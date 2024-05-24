import 'package:firebase_bloc/bloc/auth-bloc.dart';
import 'package:firebase_bloc/bloc/auth-event.dart';
import 'package:firebase_bloc/bloc/auth-state.dart';
import 'package:firebase_bloc/screens/verify-otp-screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLength: 10,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Phone Number",
              ),
            ),
            SizedBox(
              height: 16,
            ),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthCodeSentState) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VerifyOtpScreen(),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is AuthLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ElevatedButton(
                    onPressed: () {
                      final String phoneNumber =
                          "+91" + _controller.text.trim();
                      BlocProvider.of<AuthBloc>(context)
                          .add(AuthPhoneNumberSubmitEvent(phoneNumber));
                    },
                    child: const Text('Sign In'),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
