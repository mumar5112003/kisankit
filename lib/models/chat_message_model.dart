import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String query;
  final String response;
  final DateTime timestamp;
  String userUid;
  bool isPlaying;

  ChatMessage({
    required this.query,
    required this.response,
    required this.timestamp,
    required this.userUid,
    this.isPlaying = false,
  });

  // Convert a ChatMessage to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'query': query,
      'response': response,
      'userUid': userUid,
      'timestamp': timestamp,
    };
  }

  // Convert Firestore document to a ChatMessage object
  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      query: map['query'],
      response: map['response'],
      userUid: map['userUid'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
  void togglePlayState() {
    isPlaying = !isPlaying;
  }
}
