// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:org_app/login_Page.dart';
import 'leave_Request.dart';
import 'leave_Status.dart';

// ignore: camel_case_types
class EmployeeHome extends StatefulWidget {
  const EmployeeHome({Key? key}) : super(key: key);

  @override
  State<EmployeeHome> createState() => EmployeeHomeState();
}

// ignore: camel_case_types
class EmployeeHomeState extends State<EmployeeHome> {
  /// ------------------- Variables -------------------------//

  var currentUser = FirebaseAuth.instance.currentUser;
  final auth = FirebaseAuth.instance;
  var firstName = '';
  var lastName = '';

// initState

  @override
  void initState() {
    super.initState();
    getUserData(currentUser?.email ?? '');
  }

//------------------------- build------------------------------//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
                child: Text(
              "Welcome $firstName $lastName",
              style: TextStyle(color: Colors.white),
            )),
            IconButton(
                color: Colors.white,
                icon: const Icon(Icons.logout),
                onPressed: () {
                  auth.signOut().then((value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    ).onError((error, stackTrace) => null);
                  });
                })
          ],
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
          employeeHomePage(),
        ],
      ),
    );
  }

//------- ui ---------
  Padding employeeHomePage() {
    return Padding(
      padding: const EdgeInsets.only(top: 50, left: 45, right: 45),
      child: Column(
        children: [
          Image(
            image: AssetImage('assets/images/employee.png'),
            height: 200,
            width: 200,
          ),
          SizedBox(
            height: 80,
          ),
          SizedBox(
            height: 45,
            width: 300,
            child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LeaveRequest()));
                },
                child: const Text(
                  "Apply Leave",
                  style: TextStyle(color: Colors.white),
                )),
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 45,
            width: 300,
            child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LeaveStatus()));
                },
                child: const Text(
                  "Show Status",
                  style: TextStyle(color: Colors.white),
                )),
          )
        ],
      ),
    );
  }

// get user Data
  Future<Map<String, dynamic>?> getUserData(String email) async {
    final userQuerySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: email)
        .get();

    if (userQuerySnapshot.docs.length == 1) {
      final userData = userQuerySnapshot.docs.first.data();
      firstName = userData['firstName'];
      lastName = userData['lastName'];
      setState(() {});
      return userData;
    } else {
      return null;
    }
  }
}

//other methods
class User {
  final String name;

  User(this.name);
}

class AuthService {
  User? _currentUser;

  void setCurrentUser(User user) {
    _currentUser = user;
  }

  User? getCurrentUser() {
    return _currentUser;
  }
}
