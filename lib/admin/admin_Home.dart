// ignore: file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:org_app/admin/leave_Applications.dart';
import 'package:org_app/admin/salary_Calculation.dart';
import 'package:org_app/login_Page.dart';
import 'add_Employee.dart';

// ignore: camel_case_types
class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => AdminHomeState();
}

// ignore: camel_case_types
class AdminHomeState extends State<AdminHome> {
  /// ------------------- Variables -------------------------//
//------------------------- build------------------------------//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Expanded(
                child: Text(
              "Welcome Admin",
              style: TextStyle(color: Colors.white),
            )),
            IconButton(
                highlightColor: Colors.white,
                color: Colors.white,
                iconSize: 28,
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
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
          adminHomepage(),
        ],
      ),
    );
  }

// ------------------------ UI Methods---------------------//
  Padding adminHomepage() {
    return Padding(
      padding: const EdgeInsets.all(50),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Image(
              image: AssetImage('assets/images/admin2.png'),
              height: 200,
              width: 200,
            ),
            SizedBox(
              height: 70,
            ),
            SizedBox(
              height: 45,
              width: 300,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddEmployee()),
                    );
                  },
                  child: const Text(
                    "ADD Employee",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 45,
              width: 300,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LeaveApplications()),
                    );
                  },
                  child: const Text(
                    "Show Leave Applications",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 45,
              width: 300,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SalaryPage()),
                    );
                  },
                  child: const Text(
                    "Salary Calculation ",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
