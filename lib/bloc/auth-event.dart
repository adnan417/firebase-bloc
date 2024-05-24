import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthEvent {}

class AuthPhoneNumberSubmitEvent extends AuthEvent {
  final String phoneNumber;
  AuthPhoneNumberSubmitEvent(this.phoneNumber);
}

class AuthOtpSubmitEvent extends AuthEvent {
  final String otp;
  AuthOtpSubmitEvent(this.otp);
}

class AuthSignInEvent extends AuthEvent {
  PhoneAuthCredential credential;
  AuthSignInEvent(this.credential);
}
