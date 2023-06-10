// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

// ignore: camel_case_types
class LeaveApplications extends StatefulWidget {
  const LeaveApplications({Key? key}) : super(key: key);

  @override
  State<LeaveApplications> createState() => _LeaveApplicationsState();
}

// ignore: camel_case_types
class _LeaveApplicationsState extends State<LeaveApplications> {
  /// ------------------- Variables -------------------------//

  var startDate = '';
  var endDate = '';
  var employeeId = '';
  var documentId = "";
  var status = "";
  var applyDateTime = "";
  var HalfLeave;
  int? totalDays;
  int? daysDifference;
  int? dateCount;
  DateFormat formatter = DateFormat('dd-MM-yyyy');

  List<DateTime> datesToCheck = [
    DateTime(2023, 6, 05),
    DateTime(2023, 6, 10),
    DateTime(2023, 6, 03),
    DateTime(2023, 5, 15),
  ];
  bool _isApprovevisible = true;
  bool _isRejectvisible = true;
  bool showWidget = false;
  // ignore: non_constant_identifier_names
  var firstName = '';
  var lastName = '';

  final databaseReference = FirebaseFirestore.instance;
//------------------------- build------------------------------//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        "Show Leave Applications",
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
          leaveApplications(),
        ],
      ),
    );
  }

//---Ui
  StreamBuilder leaveApplications() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('Leave')
          .orderBy("applyDateTime", descending: true)
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
              status = docs[i].data()['status'];
              documentId = docs[i].data()['documentId'];
              HalfLeave = docs[i].data()['HalfLeave'];
              return Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 10, bottom: 10),
                child: Card(
                    shadowColor: Colors.black,
                    elevation: 20,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Colors.greenAccent,
                      ),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Container(
                        decoration: const BoxDecoration(),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                "Employee Id  : ${docs[i].data()['employeeId']}",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            Divider(thickness: 1, color: Colors.cyan),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Name  : ${docs[i].data()['firstName']} ${docs[i].data()['lastName']} ",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            Divider(thickness: 1, color: Colors.cyan),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Apply DateTime : ${docs[i].data()['applyDateTime']}",
                                style: const TextStyle(
                                    color: Colors.amber, fontSize: 18),
                              ),
                            ),
                            Divider(thickness: 1, color: Colors.cyan),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Displaydate(),
                            ),
                            Divider(thickness: 1, color: Colors.cyan),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: displayDays(),
                            ),
                            Divider(thickness: 1, color: Colors.cyan),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Note  : ${docs[i].data()['Note']} ",
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                            ),
                            Divider(thickness: 1, color: Colors.cyan),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (status == "Approve")
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Approved",
                                      style: TextStyle(
                                          color: Colors.green, fontSize: 18),
                                    ),
                                  ),
                                if (status == "Reject")
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Rejected",
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 18),
                                    ),
                                  ),
                                if (status == "Approve" || status == "Reject")
                                  TextButton.icon(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (_) {
                                            return AlertDialog(
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  22.0))),
                                              shadowColor: Colors.black,
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      top: 20.0),
                                              icon: InkWell(
                                                child: const CircleAvatar(
                                                  backgroundColor: Colors.amber,
                                                  child: Icon(
                                                    Icons.cancel,
                                                  ),
                                                ),
                                                onTap: () =>
                                                    Navigator.pop(context),
                                              ),
                                              title: const Text(
                                                  'You want to change status ?'),
                                              actions: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    final updateData =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection("Leave")
                                                            .doc(
                                                                '${docs[i].data()['documentId']}');
                                                    updateData.update({
                                                      'status': 'Approve',
                                                    });
                                                    if (status == "Approve") {
                                                      Navigator.pop(context);
                                                    } else {
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.green,
                                                  ),
                                                  child: const Text(
                                                    "Approve",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    final updateData =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection("Leave")
                                                            .doc(
                                                                '${docs[i].data()['documentId']}');
                                                    updateData.update({
                                                      'status': 'Reject',
                                                    });
                                                    if (status == "Reject") {
                                                      Navigator.pop(context);
                                                    } else {
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                  ),
                                                  child: const Text(
                                                    "Reject",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }).then((exit) {
                                        if (status == "Approve") {
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              "Approved",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18),
                                            ),
                                          );
                                        } else if (status == "Reject") {
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              "Rejected",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18),
                                            ),
                                          );
                                        }
                                      });
                                    },
                                    icon: const Icon(Icons.edit),
                                    label: const Text("...."),
                                  ),
                              ],
                            ),
                            if (status == "pending")
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 30),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        final updateData = FirebaseFirestore
                                            .instance
                                            .collection("Leave")
                                            .doc(
                                                '${docs[i].data()['documentId']}');
                                        updateData.update({
                                          'status': 'Approve',
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                      ),
                                      child: const Text(
                                        "Approve",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 30),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        final updateData = FirebaseFirestore
                                            .instance
                                            .collection("Leave")
                                            .doc(
                                                '${docs[i].data()['documentId']}');
                                        updateData.update({
                                          'status': 'Reject',
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                      child: const Text(
                                        "Reject",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 30),
                                ],
                              ),
                            const SizedBox(height: 10),
                          ],
                        ))),
              );
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

// others method
  displayDays() {
    DateTime fromDate = formatter.parse(startDate);
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

    DateTime toDate = formatter.parse(endDate);
    daysDifference = toDate.difference(fromDate).inDays + 1;
    List<DateTime> availableDates = [];

    for (DateTime date in datesToCheck) {
      if (date.isAfter(fromDate) && date.isBefore(toDate)) {
        availableDates.add(date);
        dateCount = availableDates.length;
        totalDays = daysDifference! - dateCount!;
      }
    }

    if (endDate.isNotEmpty) {
      if (availableDates.isEmpty) {
        return Text(
          "Duration :- $daysDifference days ",
          style: TextStyle(color: Colors.black, fontSize: 18),
        );
      } else {
        return Text(
          "Duration :- $totalDays days ",
          style: TextStyle(color: Colors.black, fontSize: 18),
        );
      }
    }
  }

  // Displaydate start and end
  Displaydate() {
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
