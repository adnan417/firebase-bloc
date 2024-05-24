import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_bloc/bloc/auth-event.dart';
import 'package:firebase_bloc/bloc/auth-state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;
  AuthBloc() : super(AuthInitialState()) {
    on<AuthPhoneNumberSubmitEvent>((event, emit) async {
      //verify otp

      emit(AuthLoadingState());

      try {
        await _auth.verifyPhoneNumber(
          phoneNumber: event.phoneNumber,
          codeSent: (verificationId, forceResendingToken) {
            _verificationId = verificationId;
            emit(AuthCodeSentState());
          },
          verificationCompleted: (phoneAuthCredential) {
            emit(AuthCodeVerifiedState(phoneAuthCredential));
          },
          verificationFailed: (error) {
            emit(AuthErrorState(error.message!));
          },
          codeAutoRetrievalTimeout: (verificationId) {
            _verificationId = verificationId;
          },
        );
        print('object');
      } on FirebaseAuthException catch (error) {
        print(error.message);
        emit(AuthErrorState(error.message!));
      }
    });

    on<AuthOtpSubmitEvent>((event, emit) {
      emit(AuthLoadingState());
      PhoneAuthCredential _credential = PhoneAuthProvider.credential(
          smsCode: event.otp, verificationId: _verificationId!);
      emit(AuthCodeVerifiedState(_credential));
    });

    on<AuthSignInEvent>(
      (event, emit) async {
        try {
          UserCredential userCredential =
              await _auth.signInWithCredential(event.credential);
          if (userCredential.user != null) {
            emit(AuthLoggedInState(userCredential.user!));
          }
        } on FirebaseAuthException catch (error) {
          emit(AuthErrorState(error.message!));
        }
      },
    );
  }
}
