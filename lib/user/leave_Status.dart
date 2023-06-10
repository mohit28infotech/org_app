import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

// ignore: camel_case_types
class LeaveStatus extends StatefulWidget {
  const LeaveStatus({Key? key}) : super(key: key);

  @override
  State<LeaveStatus> createState() => LeaveStatusState();
}

// ignore: camel_case_types
class LeaveStatusState extends State<LeaveStatus> {
  /// ------------------- Variables -------------------------//

  var startDate = '';
  var endDate = '';
  var employeeId = '';
  var status = '';
  var applyDateTime = "";
  int? totalDays;
  var DurationDays;
  int? dateCount;
  String? HalfLeave;

  List<DateTime> datesToCheck = [
    DateTime(2023, 6, 05),
    DateTime(2023, 6, 10),
    DateTime(2023, 6, 03),
    DateTime(2023, 5, 15),
  ];
  DateFormat formatter = DateFormat('dd-MM-yyyy');
  final user = FirebaseAuth.instance.currentUser;

//------------------------- build------------------------------//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        "List of Leave Status",
        style: TextStyle(color: Colors.white),
      )),
      body: Stack(
        children: [
          const Image(
            image: AssetImage('assets/images/loginback.jpg'),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          leaveStatusPage(),
        ],
      ),
    );
  }

// ----------------------------ui --------------------////

  StreamBuilder leaveStatusPage() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('Leave')
          .orderBy("applyDateTime", descending: true)
          .where("email", isEqualTo: user?.email)
          .snapshots(),
      builder: (_, snapshot) {
        if (snapshot.hasError) return Text('Error = ${snapshot.error}');

        if (snapshot.hasData) {
          final docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (_, i) {
              startDate = docs[i].data()['startDate'];
              endDate = docs[i].data()['endDate'];
              HalfLeave = docs[i].data()['HalfLeave'];
              DurationDays = docs[i].data()['DurationDays'];
              return Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 10, bottom: 10),
                  child: Card(
                      elevation: 20,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Colors.cyan,
                        ),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Apply DateTime : ${docs[i].data()['applyDateTime']}",
                              style: const TextStyle(
                                  color: Colors.green, fontSize: 18),
                            ),
                          ),
                          Divider(thickness: 1, color: Colors.cyan),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: displayDate(),
                          ),
                          Divider(thickness: 1, color: Colors.cyan),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: displayDays(),
                          ),
                          Divider(thickness: 1, color: Colors.cyan),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, bottom: 8.0, left: 19, right: 19),
                            child: Text(
                              "Note : ${docs[i].data()['Note']}",
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 18),
                            ),
                          ),
                          Divider(thickness: 1, color: Colors.cyan),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              " Status  : ${docs[i].data()['status']}",
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 18),
                            ),
                          ),
                        ],
                      )));
            },
          );
        }
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.white,
          child: Container(
            color: Colors.grey,
          ),
        );
      },
    );
  }

// other method

//get days duration
  displayDays() {
    if (endDate.isEmpty) {
      if (HalfLeave == null) {
        return Text(
          "Duration :- 1 day",
          style: TextStyle(color: Colors.black, fontSize: 18),
        );
      } else {
        return Text(
          "Duration :- 1 day ($HalfLeave) ",
          style: TextStyle(color: Colors.black, fontSize: 18),
        );
      }
    }
    if (endDate.isNotEmpty) {
      if (HalfLeave == null) {
        return Text(
          "Duration :- $DurationDays days ",
          style: TextStyle(color: Colors.black, fontSize: 18),
        );
      } else {
        return Text(
          "Duration :- $HalfLeave days ",
          style: TextStyle(color: Colors.black, fontSize: 18),
        );
      }
    }
  }

// Displaydate
  displayDate() {
    // ignore: unnecessary_null_comparison
    if (endDate.isEmpty) {
      return Text("Apply For : $startDate",
          style: const TextStyle(color: Colors.black, fontSize: 18));
    } else {
      return Text("Apply For : $startDate To $endDate",
          style: const TextStyle(color: Colors.black, fontSize: 18));
    }
  }
}
