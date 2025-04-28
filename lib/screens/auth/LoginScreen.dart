import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kisankit/controllers/auth_controller.dart';
import 'package:kisankit/theme/app_theme.dart';
import 'package:pinput/pinput.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class LoginScreen extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RxString completePhoneNumber = ''.obs;
  final RxBool isPhoneValid = false.obs;
  final RxBool isOtpValid = false.obs;

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Obx(() {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 50),
                          Image.asset(
                            'assets/icons/app-icon.png',
                            height: Get.height * .25,
                          ),
                          const SizedBox(height: 40),
                          if (!authController.otpSent.value) ...[
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: IntlPhoneField(
                                controller: phoneController,
                                decoration: InputDecoration(
                                  labelText: 'phone_number'.tr,
                                  labelStyle: TextStyle(color: Colors.black),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  prefixIcon:
                                      Icon(Icons.phone, color: Colors.black),
                                ),
                                initialCountryCode: 'PK',
                                cursorColor: Colors.black,
                                textAlign: TextAlign.left,
                                dropdownTextStyle:
                                    TextStyle(color: Colors.black),
                                invalidNumberMessage: 'invalid_phone'.tr,
                                onChanged: (phone) {
                                  if (phone.number.length >= 10) {
                                    completePhoneNumber.value =
                                        phone.completeNumber;
                                    isPhoneValid.value = true;
                                  } else {
                                    isPhoneValid.value = false;
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: () =>
                                  authController.signInWithGoogle(),
                              icon: Image.asset(
                                'assets/icons/google.png',
                                height: 24,
                              ),
                              label: Text('continue_with_google'.tr),
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                          if (authController.otpSent.value) ...[
                            Text(
                              'enter_verification_code'.tr,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${'sent_code_to'.tr}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: Text(
                                completePhoneNumber.toString(),
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: Pinput(
                                length: 6,
                                controller: otpController,
                                onChanged: (value) {
                                  isOtpValid.value = value.length == 6;
                                },
                                defaultPinTheme: PinTheme(
                                  width: 56,
                                  height: 56,
                                  textStyle: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black.withOpacity(0.5)),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                focusedPinTheme: PinTheme(
                                  width: 56,
                                  height: 56,
                                  textStyle: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextButton(
                              onPressed: () {
                                authController.otpSent.value = false;
                                otpController.clear();
                                isOtpValid.value = false;
                              },
                              child: Text(
                                'change_phone_number'.tr,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Obx(() {
                    bool isButtonEnabled = authController.otpSent.value
                        ? isOtpValid.value
                        : isPhoneValid.value;

                    return ElevatedButton(
                      onPressed: (!isButtonEnabled ||
                              authController.isLoading.value)
                          ? null
                          : () {
                              if (authController.otpSent.value) {
                                if (isOtpValid.value) {
                                  authController.verifyOTP(otpController.text);
                                }
                              } else {
                                if (isPhoneValid.value) {
                                  authController.signInWithPhoneNumber(
                                      completePhoneNumber.value);
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: AppTheme.primaryColor,
                        disabledBackgroundColor: Colors.grey.withOpacity(.5),
                      ),
                      child: authController.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              authController.otpSent.value
                                  ? 'verify'.tr
                                  : 'next'.tr,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                    );
                  }),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
