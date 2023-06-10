import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: camel_case_types, must_be_immutable
class LeaveRequest extends StatefulWidget {
  LeaveRequest({Key? key}) : super(key: key);
  DateTime dateTime = DateTime.now();

  @override
  State<LeaveRequest> createState() => LeaveRequestState();
}

// ignore: camel_case_types
enum date { oneDate, dateRange, halfLeaveR }

// ignore: camel_case_types
class LeaveRequestState extends State<LeaveRequest> {
  /// ------------------- Variables -------------------------//
  var value_half = "";
  var startDate = "";
  var endDate = "";
  var oneDate = "";
  var applyDateTime = "";
  // ignore: non_constant_identifier_names
  var firstName = "";
  var lastName = "";
  // ignore: non_constant_identifier_names
  var EmployeeId = "";
  var status = "pending";
  String _userNote = "";
  int _maxNoteLength = 100;
  date? _date;
  bool _startDate = false;
  bool _multipleDate = false;
  bool _LeaveCon = false;
  String? selectedItem;
  int oneday = 1;
  int? totalDays;
  int? daysDifference;
  int? HolidayCount;
  var HalfLeave;
  double halfday = 0.5;
  // var Duration = 0.5;
  late int leaveDays;

  int? months;
  int? years;

  final applyLeave = GlobalKey<FormState>();

  List<String> HalfLeaveList = ['First Half', 'Second Half'];

  TextEditingController startController = TextEditingController();
  TextEditingController endController = TextEditingController();

//------------------ setState-----------------------------//
  void handleSelection(date? value) {
    setState(() {
      _date = value;
      _startDate = value == date.oneDate;
      _multipleDate = value == date.dateRange;
      _LeaveCon = value == date.halfLeaveR;
    });
  }
// firebase

  final currentUser = FirebaseAuth.instance.currentUser;
  final firestoreInstance = FirebaseFirestore.instance;
  bool loading = false;
  final fireStore = FirebaseFirestore.instance.collection("Leave");
  List<DocumentSnapshot> documents = [];

  String now = DateFormat("dd-MM-yyyy h:mm a").format(DateTime.now());

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
          title: const Text(
        "Apply Leave",
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
          leaveRequest(),
        ],
      ),
    );
  }

//---------------------------- ui--------------------------------//
  Form leaveRequest() {
    return Form(
      key: applyLeave,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              RadioListTile(
                activeColor: Colors.cyan,
                title: const Text(
                  "Half day",
                  style: TextStyle(color: Colors.white),
                ),
                value: date.halfLeaveR,
                groupValue: _date,
                onChanged: handleSelection,
              ),
              if (_LeaveCon)
                Column(
                  children: [
                    TextFormField(
                        style: const TextStyle(color: Colors.white),
                        controller: startController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(23)),
                            labelStyle: TextStyle(color: Colors.white),
                            labelText: 'Select Date',
                            hintStyle: TextStyle(color: Colors.white),
                            hintText: 'Select  Date '),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2025));
                          if (pickedDate != null) {
                            startDate =
                                DateFormat('dd-MM-yyyy').format(pickedDate);
                            startController.text = startDate;
                          }
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: DropdownButtonFormField(
                        iconSize: 30,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(23))),
                        borderRadius: BorderRadius.circular(20),
                        value: selectedItem,
                        items: HalfLeaveList.map((item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(item, style: TextStyle(fontSize: 15)),
                          );
                        }).toList(),
                        hint: Text(
                          "Select Half ",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        onChanged: (newValue) {
                          setState(() {
                            selectedItem = newValue!;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Please Select Half Day ' : null,
                      ),
                    )
                  ],
                ),
              const SizedBox(height: 5),
              RadioListTile(
                activeColor: Colors.cyan,
                title: const Text(
                  "Single Day",
                  style: TextStyle(color: Colors.white),
                ),
                value: date.oneDate,
                groupValue: _date,
                onChanged: handleSelection,
              ),
              const SizedBox(height: 5),
              if (_startDate)
                TextFormField(
                    style: const TextStyle(color: Colors.white),
                    controller: startController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(23)),
                        labelStyle: TextStyle(color: Colors.white),
                        labelText: 'Single Date',
                        hintStyle: TextStyle(color: Colors.white),
                        hintText: 'Single Date '),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2025));
                      if (pickedDate != null) {
                        startDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                        startController.text = startDate;
                      }
                    }),
              const SizedBox(height: 5),
              RadioListTile(
                title: const Text(
                  "Multiple Days ",
                  style: TextStyle(color: Colors.white),
                ),
                value: date.dateRange,
                groupValue: _date,
                onChanged: handleSelection,
              ),
              if (_multipleDate)
                Column(
                  children: [
                    TextFormField(
                        style: const TextStyle(color: Colors.white),
                        controller: startController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(23)),
                            labelText: 'From',
                            labelStyle: const TextStyle(color: Colors.white),
                            hintText: 'Select Date '),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedStartDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2025));
                          if (pickedStartDate != null) {
                            startDate = DateFormat('dd-MM-yyyy')
                                .format(pickedStartDate);
                            startController.text = startDate;
                          }
                        }),
                    const SizedBox(height: 20),
                    TextFormField(
                        style: const TextStyle(color: Colors.white),
                        controller: endController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(23)),
                            labelText: 'To',
                            labelStyle: const TextStyle(color: Colors.white),
                            hintText: 'Select Date '),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedEndDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2025));

                          if (pickedEndDate != null) {
                            endDate =
                                DateFormat('dd-MM-yyyy').format(pickedEndDate);
                            endController.text = endDate;
                          }
                        }),
                  ],
                ),
              const SizedBox(height: 20),
              TextFormField(
                style: TextStyle(color: Colors.white),
                maxLength: _maxNoteLength,
                maxLines: null,
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.white),
                  labelText: 'Enter your note',
                  counterText: '$_maxNoteLength characters',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.multiline,
                onChanged: (value) {
                  setState(() {
                    _userNote = value;
                  });
                },
                initialValue: _userNote,
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Please enter a note';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                  height: 45,
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (applyLeave.currentState!.validate()) {
                        DocumentReference documentReference =
                            firestoreInstance.collection("Leave").doc();

                        Map<String, dynamic> data = {
                          'documentId': documentReference.id,
                          'employeeId': EmployeeId,
                          'firstName': firstName,
                          'lastName': lastName,
                          'email': currentUser?.email,
                          'startDate': startDate,
                          'endDate': endDate,
                          'status': status,
                          'applyDateTime': now,
                          'Note': _userNote,
                          "DurationDays": AddDuration(),
                          'leave_data': {
                            "MonthAndYear-leaves": countLeaveDays(),
                            "half_leave": selectedItem,
                          },
                        };

                        documentReference.set(data).then((value) async {
                          const snackbar = SnackBar(
                            content: Text('Apply successfully.....'),
                            backgroundColor: Colors.cyan,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
                        }).then((value) => Navigator.of(context)
                            .pushReplacement(MaterialPageRoute(
                                builder: (context) => LeaveRequest())));
                      }
                    },
                    child: const Text(
                      "Apply Leave ",
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

//
  Map<String, int> countLeaveDays() {
    DateFormat formatter = DateFormat('dd-MM-yyyy');

    DateTime fromDate = formatter.parse(startDate);

    DateTime toDate = formatter.parse(endDate);
    final Map<String, int> result = {};
    DateTime currentDate = DateTime(fromDate.year, fromDate.month);
    while (currentDate.isBefore(toDate) || currentDate == toDate) {
      final int daysInMonth =
          DateTime(currentDate.year, currentDate.month + 1, 0).day;
      final int daysLeft = toDate.difference(currentDate).inDays + 1;
      final int days = daysInMonth < daysLeft ? daysInMonth : daysLeft;

      result.putIfAbsent(
          "${currentDate.month}/${currentDate.year}", () => displayDays());
      currentDate = DateTime(currentDate.year, currentDate.month + 1);
    }
    return result;
  }

  //
  AddDuration() {
    DateFormat formatter = DateFormat('dd-MM-yyyy');

    DateTime fromDate = formatter.parse(startDate);
    if (endDate.isEmpty) {
      if (selectedItem != null) {
        return halfday;
      } else {
        return oneday;
      }
    }
    DateTime toDate = formatter.parse(endDate);

    daysDifference = toDate.difference(fromDate).inDays + 1;

    if (endDate.isNotEmpty) {
      return daysDifference;
    }
  }

// display Duration and Leave days
  displayDays() {
    DateFormat formatter = DateFormat('dd-MM-yyyy');

    DateTime fromDate = formatter.parse(startDate);
    DateTime toDate = formatter.parse(endDate);

    if (endDate.isEmpty) {
      if (selectedItem == null) {
        return oneday;
      } else {
        return halfday;
      }
    }

    List<DateTime> datesToCheck = [
      DateTime(2023, 5, 05),
      DateTime(2023, 5, 18),
      DateTime(2023, 6, 03),
      DateTime(2023, 6, 15),
    ];

    daysDifference = toDate.difference(fromDate).inDays + 1;
    //sat & sunday Subtract
    int satSundayCount = calculateDaysToSubtract(fromDate, toDate);
    print('Number of days to subtract: $satSundayCount');

    List<DateTime> availableDates = [];

    if (endDate.isNotEmpty) {
      for (DateTime date in datesToCheck) {
        if (date.isAfter(fromDate) && date.isBefore(toDate)) {
          availableDates.add(date);
        }
      }
      if (availableDates.isEmpty) {
        totalDays = daysDifference! - satSundayCount;
      } else {
        HolidayCount = availableDates.length;
        totalDays = daysDifference! - satSundayCount;
        leaveDays = totalDays! - HolidayCount!;
      }
    }

    if (availableDates.isEmpty &&
        satSundayCount == null &&
        HolidayCount == null) {
      return daysDifference;
    }
    if (availableDates.isEmpty) {
      return totalDays;
    } else {
      return leaveDays;
    }
  }

  // get user data
  Future<Map<String, dynamic>?> getUserData(String email) async {
    final userQuerySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: email)
        .get();
    final userData = userQuerySnapshot.docs.first.data();
    EmployeeId = userData['employeeId'];
    email = userData['email'];
    firstName = userData['firstName'];
    lastName = userData['lastName'];
    return null;
  }

  // subtract sat & sun
  int calculateDaysToSubtract(DateTime fromDate, DateTime toDate) {
    int count = 0;
    DateTime currentDate = fromDate;

    while (
        currentDate.isBefore(toDate) || currentDate.isAtSameMomentAs(toDate)) {
      if (currentDate.weekday == DateTime.saturday &&
          (currentDate.day <= 7 || currentDate.day > 14)) {
        count++;
      } else if (currentDate.weekday == DateTime.sunday) {
        count++;
      }
      currentDate = currentDate.add(Duration(days: 1));
    }

    return count;
  }
}
