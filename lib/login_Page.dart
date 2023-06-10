// ignore: file_names
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:org_app/admin/admin_Home.dart';
import 'package:org_app/state/app_state.dart';
import 'package:org_app/user/employee_Home.dart';
import 'package:org_app/user/forget_password.dart';
import 'package:provider/provider.dart';

// ignore: camel_case_types
class LoginPage extends StatefulWidget {
  const LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => LoginPageState();
}

// ignore: camel_case_types
class LoginPageState extends State<LoginPage> {
  //----------------------------variable---------------------------//
  final loginKey = GlobalKey<FormState>();
  var obscureText = true;

  final passwordVisibility = AppState();
  //----------------------------Controller-------------------------//
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

//------------------------- build------------------------------//
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: loginPageForm(),
      ),
    );
  }

// login form
  Widget loginPageForm() {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    return Stack(children: [
      Container(
        child: const Image(
          image: AssetImage('assets/images/loginback.jpg'),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
      Consumer<AppState>(
        builder: (context, passwordVisibility, _) {
          return Form(
            key: loginKey,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 90),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                          radius: 120,
                          backgroundImage:
                              AssetImage("assets/images/home.jpeg")),
                      const SizedBox(height: 20),
                      const Center(
                          child: Text(
                        "Login",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 33,
                            color: Colors.white),
                      )),
                      const SizedBox(height: 30),
                      TextFormField(
                          style: const TextStyle(color: Colors.white),
                          controller: _emailController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.mail,
                                color: Colors.white,
                              ),
                              border: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(23)),
                              labelText: 'Email',
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                              hintText: 'Enter Email id ',
                              hintStyle:
                                  const TextStyle(color: Colors.white70)),
                          validator: (value) {
                            RegExp emailRegExp = RegExp(
                                r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$");
                            if (value == null || value.isEmpty) {
                              return "Please Enter Your Email";
                            } else if (!emailRegExp.hasMatch(value)) {
                              return "Please Enter a valid Email Address";
                            }
                            return null;
                          }),
                      const SizedBox(height: 30),
                      TextFormField(
                          style: const TextStyle(color: Colors.white),
                          controller: _passwordController,
                          obscuringCharacter: "*",
                          obscureText: !passwordVisibility.value,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Colors.white,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  passwordVisibility.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: passwordVisibility.toggle,
                              ),
                              border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(23),
                              ),
                              labelText: 'Password',
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                              hintText: 'Enter Password ',
                              hintStyle:
                                  const TextStyle(color: Colors.white70)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Your Password';
                            } else if (value.length < 8) {
                              return "must be 8 or greater";
                            }
                            return null;
                          }),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Text("Forget password ?",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18)),
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: ((context) => ForgetPassword())));
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 60),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: SizedBox(
                          height: 45,
                          width: 200,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (loginKey.currentState!.validate()) {
                                if ("admin@gmail.com" ==
                                        _emailController.text.toString() &&
                                    "Test@12345" ==
                                        _passwordController.text.toString()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        backgroundColor: Colors.cyan,
                                        content:
                                            Text('Admin Login successfully!')),
                                  );
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AdminHome()));
                                } else {
                                  final auth = FirebaseAuth.instance;
                                  var user = auth.currentUser;
                                  user = await loginUsingEmailPassword(
                                      email: _emailController.text.toString(),
                                      password:
                                          _passwordController.text.toString(),
                                      context: context);

                                  if (user != null) {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                const EmployeeHome())));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          backgroundColor: Colors.cyan,
                                          content: Text(
                                              'Employee Login successfully!')),
                                    );
                                  } else {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                const LoginPage())));
                                  }
                                }
                              }
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 23,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ]);
  }

//  Action Methods Button Click Methods

// login FirebaseAuthException
  static Future loginUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    final auth = FirebaseAuth.instance;
    var user = auth.currentUser;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {}
    }
    return user;
  }
}
