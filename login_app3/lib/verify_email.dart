import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:login_app3/home_page.dart';
import 'package:login_app3/utils.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  Timer? timer;
  bool isEmailVerified = false;
  bool canResendEmail = false;
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();
      timer = Timer(Duration(seconds: 3), () => checkEmailVerified());
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(
        Duration(seconds: 5),
      );
      setState(() {
        canResendEmail = true;
      });
    } catch (e) {
      Utils.showSnackBar(e.toString());
    }
  }

  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) {
      timer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return isEmailVerified
        ? HomePage()
        : Scaffold(
            appBar: AppBar(
              title: Text('Verify Email'),
            ),
            body: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('A verification email has been sent to this email'),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(50),
                    ),
                    onPressed: canResendEmail ? sendVerificationEmail : null,
                    icon: Icon(
                      Icons.email,
                      size: 32,
                    ),
                    label: Text(
                      'Resend Verification Email',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(50),
                    ),
                    onPressed: () => FirebaseAuth.instance.signOut(),
                    icon: Icon(
                      Icons.email,
                      size: 32,
                    ),
                    label: Text(
                      'Cancel',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
