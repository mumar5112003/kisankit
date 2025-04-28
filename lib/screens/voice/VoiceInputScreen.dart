import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kisankit/theme/app_theme.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart' as stt;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kisankit/controllers/user_controller.dart';
import 'package:kisankit/models/chat_message_model.dart';
import 'dart:async';

class VoiceInputScreen extends StatefulWidget {
  @override
  _VoiceInputScreenState createState() => _VoiceInputScreenState();
}

class _VoiceInputScreenState extends State<VoiceInputScreen> {
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  final UserController userController = Get.put(UserController());

  bool _isListening = false;
  String _lastWords = '';
  String _response = '';
  List<ChatMessage> _chatMessages = [];
  bool _isWaitingForResponse =
      false; // To track if we're waiting for a response
  Timer? _dotsTimer; // To manage the blinking dots animation

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _fetchChatMessages();
  }

  Future<void> _initSpeech() async {
    var status = await Permission.microphone.request();
    if (status == PermissionStatus.granted) {
      await _speechToText.initialize();
    }
    setState(() {});
  }

  Future<void> _startListening() async {
    String _selectedLocale =
        Get.locale?.languageCode == 'en' ? 'en_US' : 'ur_PK';
    await _speechToText.listen(
        onResult: _onSpeechResult, localeId: _selectedLocale);
    setState(() {
      _isListening = true;
    });
  }

  Future<void> _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
    });
  }

  void _onSpeechResult(stt.SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });

    if (result.finalResult) {
      _generateResponse(_lastWords);
    }
  }

  Future<void> _generateResponse(String query) async {
    setState(() {
      _isWaitingForResponse = true; // Start the waiting state (show dots)
    });

    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=AIzaSyAWO80F102FD1pBbnVWy3zsN_wet56J7kc',
    );

    final headers = {'Content-Type': 'application/json'};

    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {
              'text':
                  'Answer to following query in ${Get.locale?.languageCode == 'en' ? "english" : "Urdu"} and pretend to be crop doctor (in pakistan) also remember that your response will be played using text to speech and make sure to not use any special characters like "*" in your response, so any characters like "*" should not be in your response:' +
                      query
            }
          ]
        }
      ]
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _response = data['candidates'][0]['content']['parts'][0]['text'];
        _addMessageToChat(query, _response);
        _playResponse(_response);
      } else {
        _response = 'Error generating response';
      }
    } catch (e) {
      print('Request failed: $e');
    }

    // Stop the waiting animation after receiving the response
    setState(() {
      _isWaitingForResponse = false;
    });
  }

  Future<void> _playResponse(String response) async {
    int index = _chatMessages.indexWhere((msg) => msg.response == response);
    if (index != -1) {
      var message = _chatMessages[index];

      // Check if the message is already playing
      if (message.isPlaying) {
        await _flutterTts.stop();
        setState(() {
          message.isPlaying = false;
        });
      } else {
        await _flutterTts
            .setLanguage(Get.locale?.languageCode == 'en' ? 'en_US' : 'ur_PK');

        // Listen for the completion of speech
        await _flutterTts.speak(response);

        _flutterTts.setCompletionHandler(() {
          setState(() {
            message.isPlaying = false;
          });
        });

        setState(() {
          message.isPlaying = true;
        });
      }
    }
  }

  void _addMessageToChat(String query, String response) {
    ChatMessage chatMessage = ChatMessage(
        userUid: userController.user.value!.uid,
        query: query,
        response: response,
        timestamp: DateTime.now(),
        isPlaying: false);
    userController.saveChat(chatMessage);
    setState(() {
      _chatMessages.insert(0, chatMessage);
    });
  }

  Future<void> _fetchChatMessages() async {
    List<ChatMessage> messages = await userController.getChatHistory();
    setState(() {
      _chatMessages = messages;
    });
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _dotsTimer?.cancel(); // Stop the blinking timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('voice_chat'.tr),
      ),
      body: Column(
        children: [
          // Chat Messages Section
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _chatMessages.length,
              itemBuilder: (context, index) {
                var message = _chatMessages[index];
                return GestureDetector(
                  onTap: () => _playResponse(message.response),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.account_circle,
                          size: 40,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(message.query,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 4),
                              Text(message.response,
                                  style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            message.isPlaying
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_filled,
                            size: 30,
                            color: AppTheme.primaryColor,
                          ),
                          onPressed: () => _playResponse(message.response),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Blinking dots animation while waiting for response
          if (_isWaitingForResponse)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildBlinkingDot(),
                  _buildBlinkingDot(),
                  _buildBlinkingDot(),
                ],
              ),
            ),
          // Floating mic button at the bottom of the screen, no overlap
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Column(
                children: [
                  GestureDetector(
                    onPanUpdate: (details) {
                      if (details.localPosition.dy < 50) {
                        if (!_isListening) {
                          _startListening();
                        }
                      }
                    },
                    onPanEnd: (details) {
                      if (_isListening) {
                        _stopListening();
                      }
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: _isListening ? 70 : 60,
                      height: _isListening ? 70 : 60,
                      decoration: BoxDecoration(
                        color:
                            _isListening ? AppTheme.primaryColor : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          _isListening ? Icons.mic : Icons.mic_none,
                          color: Colors.white,
                          size: _isListening ? 40 : 35,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'hold_to_speak'.tr,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlinkingDot() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      width: 10,
      height: 10,
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            _isWaitingForResponse ? AppTheme.primaryColor : Colors.transparent,
      ),
    );
  }
}
