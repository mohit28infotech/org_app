import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:org_app/login_Page.dart';

class ForgetPassword extends StatefulWidget {
  ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final resetPassword = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Reset Password ",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Stack(
          children: [
            const Image(
              image: AssetImage('assets/images/loginback.jpg'),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            changePassword(),
          ],
        ));
  }

  Widget changePassword() => Form(
        key: resetPassword,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Enter your email address to reset your password',
                  style: TextStyle(fontSize: 18, color: Colors.white)),
              TextFormField(
                style: TextStyle(color: Colors.white),
                controller: _emailController,
                decoration: InputDecoration(
                    labelText: 'Email id',
                    labelStyle: TextStyle(color: Colors.white)),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                child: Text(
                  'Reset Password',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (resetPassword.currentState!.validate()) {
                    try {
                      await _auth.sendPasswordResetEmail(
                        email: _emailController.text,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            backgroundColor: Colors.cyan,
                            content: Text('Password Reset Email sent !')),
                      );
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: ((context) => ForgetPassword())));
                    } on FirebaseAuthException catch (e) {
                      // Handle password reset errors
                    }
                  }
                },
              ),
            ],
          ),
        ),
      );
}
