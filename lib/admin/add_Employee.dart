// ignore: file_names
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'admin_Home.dart';

// ignore: camel_case_types
class AddEmployee extends StatefulWidget {
  const AddEmployee({Key? key}) : super(key: key);

  @override
  State<AddEmployee> createState() => AddEmployeeState();
}

// ignore: camel_case_types
class AddEmployeeState extends State<AddEmployee> {
  // Variables
  // initState
  // build
  // dispose
  // UI Methods
  // Action Methods Button Click Methods
  // API Methods
  // Other Methods

  /// ------------------- Variables -------------------------//
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final mobileNoController = TextEditingController();
  var employeeIdController = TextEditingController();
  var salaryController = TextEditingController();
  final addEmployeeKey = GlobalKey<FormState>();

  bool userValid = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // --------------------------------build----------------------------------------///
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Register Now",
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
            addEmployeeForm(),
          ],
        ),
      ),
    );
  }

//------------Action Methods Button Click Methods
  void _createUserWithEmailAndPassword() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      User? user = userCredential.user;
      await FirebaseFirestore.instance.collection('Users').doc(user?.uid).set({
        'employeeId': employeeIdController.text.toString(),
        'firstName': firstNameController.text.toString(),
        'lastName': lastNameController.text.toString(),
        'email': emailController.text.toString(),
        'phone no': mobileNoController.text.toString(),
        'password': encryptPassword(passwordController.text),
        "salary": salaryController.text.toString(),
      }).then((value) => {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Employee created successfully!')),
            ),
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const AdminHome()))
          });
    } on FirebaseAuthException {
      //
    } catch (e) {
      //
    }
  }

//---------------------UI Methods--------------------------//
  Form addEmployeeForm() {
    return Form(
      key: addEmployeeKey,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: employeeIdController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(23)),
                      labelText: ' Employee Id',
                      labelStyle: const TextStyle(color: Colors.white70),
                      hintText: 'Enter Employee Id '),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Employee Id';
                    } else if (value.length != 5) {
                      return ("Employee Id must be of 5 digit");
                    }
                    return null;
                  }),
              const SizedBox(height: 20),
              TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: firstNameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(23)),
                      labelText: 'Employee First Name',
                      labelStyle: const TextStyle(color: Colors.white70),
                      hintText: 'Enter Employee First Name '),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Your First Name';
                    }
                    return null;
                  }),
              const SizedBox(height: 20),
              TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: lastNameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(23)),
                      labelText: 'Employee last Name',
                      labelStyle: const TextStyle(color: Colors.white70),
                      hintText: 'Enter Employee last Name '),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Your last Name';
                    }
                    return null;
                  }),
              const SizedBox(height: 20),
              TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: emailController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(23)),
                      labelText: 'Employee Email id',
                      labelStyle: const TextStyle(color: Colors.white70),
                      hintText: 'Enter valid email id '),
                  validator: (value) {
                    RegExp emailRegExp = RegExp(
                        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$");
                    if (value == null || value.isEmpty) {
                      return "Please Enter Your Email";
                    } else if (!emailRegExp.hasMatch(value)) {
                      return "Plz Enter a valid Email Address";
                    }
                    return null;
                  }),
              const SizedBox(height: 20),
              TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: mobileNoController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(23)),
                      labelText: ' Employee Mobile No',
                      labelStyle: const TextStyle(color: Colors.white70),
                      hintText: 'Enter Mobile No '),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Mobile No';
                    } else if (value.length != 10) {
                      return ("Mobile No must be of 10 digit");
                    }
                    return null;
                  }),
              const SizedBox(height: 20),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                controller: passwordController,
                obscuringCharacter: "*",
                obscureText: true,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(23)),
                    labelText: 'Employee Password',
                    labelStyle: const TextStyle(color: Colors.white70),
                    hintText: 'Enter valid Password  '),
                validator: (value) {
                  RegExp regex = RegExp(
                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                  var passNonNullValue = value ?? "";
                  if (passNonNullValue.isEmpty) {
                    return ("Password is required");
                  } else if (passNonNullValue.length < 6) {
                    return ("Password Must be more than 5 characters");
                  } else if (!regex.hasMatch(passNonNullValue)) {
                    return ("Password should contain upper,lower,digit and Special character ");
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: salaryController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(23)),
                      labelText: ' Employee salary',
                      labelStyle: const TextStyle(color: Colors.white70),
                      hintText: 'Enter salary '),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter salary';
                    }
                    return null;
                  }),
              const SizedBox(height: 40),
              SizedBox(
                  height: 45,
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (addEmployeeKey.currentState!.validate()) {
                        _createUserWithEmailAndPassword();
                      }
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

// other methods
String encryptPassword(String password) {
  var bytes = utf8.encode(password);
  var digest = md5.convert(bytes);
  var encryptedPassword = digest.toString();

  return encryptedPassword;
}
