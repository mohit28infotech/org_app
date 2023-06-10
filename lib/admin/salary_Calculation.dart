import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:org_app/models/Leaves_model.dart';
import 'package:org_app/models/user_model.dart';
import 'package:firebase_database/firebase_database.dart';

class SalaryPage extends StatefulWidget {
  SalaryPage({Key? key}) : super(key: key);

  @override
  State<SalaryPage> createState() => SalaryPageState();
}

class SalaryPageState extends State<SalaryPage> {
  final List<LeaveModel> leaveList = [];

  int? _selectedMonth = DateTime.now().month;
  int? _selectedYear = DateTime.now().year;
  var _salary;
  var employeeIdLeave;
  var salary;
  var oneDaySalary;
  var firstName;
  var totalSalary;
  var documentId;
  int? workingDays;
  int? numberOfDaysInMonth;
  bool isLoading = true;
  int? daysInMonth;
  int? numberOfWorkingDays;
  int? totalWorkingDays;
  String? monthAndYear;
  String? employeeIdUser;
  late int leavess;
  int? leavedays;
  String? SelectedMonthYear;
  String? leaveStatus;
  int? employeeLeave;
  int? totalleave;

  final List<usersDetails> UsersList = [];
  Future<List<usersDetails>> fetchUsers() async {
    final CollectionReference postsRef =
        FirebaseFirestore.instance.collection('Users');

    final List<usersDetails> UsersList = [];

    final QuerySnapshot snapshot =
        await postsRef.orderBy("employeeId", descending: false).get();
    if (snapshot.docs.isNotEmpty) {
      snapshot.docs.forEach((doc) {
        var users = usersDetails.fromDocumentSnapshot(doc);
        UsersList.add(users);
      });
    }

    return UsersList;
  }

  Future<List<LeaveModel>> fetchDataAndStore() async {
    final collection = FirebaseFirestore.instance.collection('Leave');

    final querySnapshot =
        await collection.where("employeeId", isEqualTo: employeeIdUser).get();

    querySnapshot.docs.forEach((documentSnapshot) {
      final data = documentSnapshot.data();

      var leaveDetailsList = (data['LeaveDetails'])
          .map<LeaveDetails>((item) => LeaveDetails.fromJson(item))
          .toList();

      final leaveModel = LeaveModel(
        DurationDays: data['DurationDays'],
        HalfLeave: data['HalfLeave'],
        Note: data['Note'],
        applyDateTime: data['applyDateTime'],
        documentId: data['documentId'],
        email: data['email'],
        employeeId: data['employeeId'],
        endDate: data['endDate'],
        firstName: data['firstName'],
        lastName: data['lastName'],
        status: data['status'],
        startDate: data['startDate'],
        leaveDetails: leaveDetailsList,
      );

      leaveList.add(leaveModel);
    });

    return leaveList;
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
    fetchDataAndStore();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Salary Calculation ",
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
            SalaryCalculation(),
          ],
        ),
      ),
    );
  }

  Column SalaryCalculation() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildMonthPicker(),
            _buildYearPicker(),
          ],
        ),
        Card(
          shape: Border(
              left: BorderSide(color: Colors.black),
              right: BorderSide(color: Colors.black),
              bottom: BorderSide(color: Colors.black),
              top: BorderSide(color: Colors.black)),
          elevation: 15,
          shadowColor: Colors.black,
          color: Colors.white,
          child: Text(
            " Employee Details ",
            style: TextStyle(color: Colors.black, fontSize: 23),
          ),
        ),
        Expanded(
          child: ListOfUser(),
        ),
      ],
    );
  }

  FutureBuilder ListOfUser() {
    return FutureBuilder<List<usersDetails>>(
        future: fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<usersDetails> UsersList = snapshot.data!;
            return ListView.builder(
                itemCount: UsersList.length,
                itemBuilder: (context, index) {
                  final Users = UsersList[index];
                  employeeIdUser = Users.employeeId;
                  salary = Users.salary;
                  return Padding(
                      padding: const EdgeInsets.all(18),
                      child: Card(
                          shadowColor: Colors.black,
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              color: Colors.greenAccent,
                            ),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: Container(
                              decoration: const BoxDecoration(),
                              child: Column(children: [
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    "Employee Id :- ${Users.employeeId}",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Divider(thickness: 1, color: Colors.cyan),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    "Name:- ${Users.firstName} ${Users.lastName} ",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Divider(thickness: 1, color: Colors.cyan),
                                Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: LeaveDays(index)),
                                Divider(thickness: 1, color: Colors.cyan),
                                Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: calculateSalary(_selectedMonth!,
                                        _selectedYear!, index)),
                              ]))));
                });
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return Center(
              child: CircularProgressIndicator(
            color: Colors.white,
          ));
        });
  }

  Text LeaveDays(index) {
    SelectedDate();

    List employeeLeaveDays = [];
    print("###$employeeLeaveDays");

    for (int i = 0; i < UsersList.length; i++) {
      employeeIdUser = UsersList[i].employeeId;
    }

    for (int i = 0; i < leaveList.length; i++) {
      employeeIdLeave = leaveList[i].employeeId;
      leaveStatus = leaveList[i].status;
      employeeLeave = leaveList[i].leaveDetails[0].leaveDays;
      monthAndYear = leaveList[i].leaveDetails[0].monthYear;

      if (employeeIdUser == employeeIdLeave) {
        if (monthAndYear == SelectedMonthYear) {
          if (leaveStatus == "Approve") {
            employeeLeaveDays.add(employeeLeave);
          }
        }
      }
    }

    int noLeave = 0;
    if (employeeLeave == null) {
      return Text(
        "Leave days :- $noLeave",
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
        ),
      );
    } else {
      return Text(
        "Leave days :- $employeeLeave ",
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
        ),
      );
    }
  }

  // LeaveDays(index) {
  //   List employeeLeaveDays = [];

  //   formatSelectedDate();

  //   for (int i = 0; i < leaveList.length; i++) {
  //     employeeIdLeave = leaveList[i].employeeId;
  //     status = leaveList[i].status;

  //     int leavelength = leaveList[i].leaveDetails.length;
  //     print("leavelistlength :- $leavelength");

  //     if (leavelength == 1) {
  //       leaveDays = leaveList[i].leaveDetails[0].leaveDays;
  //       monthYear = leaveList[i].leaveDetails[0].monthYear;
  //     } else {
  //       leaveDays = leaveList[i].leaveDetails[0].leaveDays;
  //       monthYear = leaveList[i].leaveDetails[0].monthYear;

  //       int leaveDays1 = leaveList[i].leaveDetails[1].leaveDays;
  //       String monthYear1 = leaveList[i].leaveDetails[1].monthYear;

  //       totalleave = leaveDays! + leaveDays1 + 1;

  //       print("total leave ::- $totalleave");
  //     }

  //     if (employeeIdUser == employeeIdLeave) {
  //       if (monthYear == formattedDate) {
  //         if (status == "Approve") {
  //           employeeLeaveDays.add(leaveDays!);
  //         }
  //       }
  //     }
  //   }
  //   int oneN = 0;
  //   // leavess = 0;
  //   // for (int i = 0; i < employeeLeaveDays.length; i++) {
  //   //   leavess += employeeLeaveDays.length;
  //   //   print("@#@#$leavess");
  //   // }
  //   // leavedays = employeeLeaveDays.length;

  //   if (employeeLeaveDays.isEmpty) {
  //     return Text(
  //       "Leave days :- $oneN",
  //       style: TextStyle(
  //         color: Colors.black,
  //         fontSize: 18,
  //       ),
  //     );
  //   } else {
  //     return Text(
  //       "Leave days :- $leaveDays",
  //       style: TextStyle(
  //         color: Colors.black,
  //         fontSize: 18,
  //       ),
  //     );
  //   }
  // }

  calculateSalary(int _selectedMonth, int _selectedYear, index) {
    LeaveDays(index);
    // Create a DateTime object for the first day of the selected month
    // ignore: unused_local_variable
    DateTime firstDayOfMonth = DateTime(_selectedYear, _selectedMonth, 1);

    // Get the number of days in the selected month
    int totalDaysInMonth = DateTime(_selectedYear, _selectedMonth + 1, 0).day;

    // Variables to count the number of excluded days
    int excludedSaturdays = 0;
    int excludedSundays = 0;

    // Iterate over each day in the selected month
    for (int day = 1; day <= totalDaysInMonth; day++) {
      DateTime currentDate = DateTime(_selectedYear, _selectedMonth, day);

      // Check if the current day is a Saturday
      if (currentDate.weekday == DateTime.saturday) {
        // Check if it's the 1st or 3rd Saturday
        if ((day <= 7 && day <= 31) || (day > 14 && day <= 21 && day <= 31)) {
          excludedSaturdays++;
        }
      }

      // Check if the current day is a Sunday
      if (currentDate.weekday == DateTime.sunday) {
        excludedSundays++;
      }
    }
    // Subtract the number of excluded days from the total days in the month
    int remainingDays = totalDaysInMonth - excludedSaturdays - excludedSundays;
    // print("employeeIdLeave := $employeeIdLeave");
    print("remainingDays := $remainingDays");
    print("leave Days := $employeeLeave");
    // LeaveDays();

    totalWorkingDays = remainingDays - employeeLeave!;
    // totalSalary = totalWorkingDays! * oneDaySalary;

    // print("LeaveDays :----$leaves");
    print("totalWorkingDays := $totalWorkingDays");

    //convert string to int
    int Salary = 0;
    if (salary != null) {
      Salary = int.parse(salary);
      print(" total salary := $Salary");
    }
    oneDaySalary = Salary / remainingDays;
    print(" one day := $oneDaySalary");

    // multi of working day salary and Leave days **
    totalSalary = totalWorkingDays! * oneDaySalary;
    int convertToInteger(double totalSalary) {
      return totalSalary.toInt();
    }

    int totalsalary = convertToInteger(totalSalary);

    print("salary := $totalSalary");

    print("---------------");
    if (employeeLeave == null) {
      return Text("Salary : $Salary Rs",
          style: TextStyle(
            color: Colors.green,
            fontSize: 18,
          ));
    } else {
      return Text("Salary : $totalsalary Rs",
          style: TextStyle(
            color: Colors.green,
            fontSize: 18,
          ));
    }
  }

  Widget _buildMonthPicker() {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
            shape: Border(
                left: BorderSide(color: Colors.black),
                right: BorderSide(color: Colors.black),
                bottom: BorderSide(color: Colors.black),
                top: BorderSide(color: Colors.black)),
            child: Text(" Select Month ",
                style: TextStyle(fontSize: 18, color: Colors.black)),
          ),
          SizedBox(height: 8),
          DropdownButton<int>(
            dropdownColor: Colors.blueGrey,
            borderRadius: BorderRadius.all(Radius.circular(4)),
            value: _selectedMonth,
            items: [
              DropdownMenuItem(
                  child: Text("January", style: TextStyle(color: Colors.white)),
                  value: 1),
              DropdownMenuItem(
                  child:
                      Text("February", style: TextStyle(color: Colors.white)),
                  value: 2),
              DropdownMenuItem(
                  child: Text("March", style: TextStyle(color: Colors.white)),
                  value: 3),
              DropdownMenuItem(
                  child: Text("April", style: TextStyle(color: Colors.white)),
                  value: 4),
              DropdownMenuItem(
                  child: Text("May", style: TextStyle(color: Colors.white)),
                  value: 5),
              DropdownMenuItem(
                  child: Text("June", style: TextStyle(color: Colors.white)),
                  value: 6),
              DropdownMenuItem(
                  child: Text("July", style: TextStyle(color: Colors.white)),
                  value: 7),
              DropdownMenuItem(
                  child: Text("August", style: TextStyle(color: Colors.white)),
                  value: 8),
              DropdownMenuItem(
                  child:
                      Text("September", style: TextStyle(color: Colors.white)),
                  value: 9),
              DropdownMenuItem(
                  child: Text("October", style: TextStyle(color: Colors.white)),
                  value: 10),
              DropdownMenuItem(
                  child:
                      Text("November", style: TextStyle(color: Colors.white)),
                  value: 11),
              DropdownMenuItem(
                  child:
                      Text("December", style: TextStyle(color: Colors.white)),
                  value: 12),
            ],
            onChanged: (value) {
              setState(() {
                _selectedMonth = value!;
                _salary =
                    calculateSalary(_selectedMonth!, _selectedYear!, Index);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildYearPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Card(
          shape: Border(
              left: BorderSide(color: Colors.black),
              right: BorderSide(color: Colors.black),
              bottom: BorderSide(color: Colors.black),
              top: BorderSide(color: Colors.black)),
          child: Text(" Select Year ",
              style: TextStyle(fontSize: 18, color: Colors.black)),
        ),
        SizedBox(height: 8),
        DropdownButton<int>(
          dropdownColor: Colors.blueGrey,
          borderRadius: BorderRadius.circular(5),
          value: _selectedYear,
          items: List.generate(5, (index) {
            final year = DateTime.now().year + index;
            return DropdownMenuItem(
                child: Text(year.toString(),
                    style: TextStyle(color: Colors.white)),
                value: year);
          }),
          onChanged: (value) {
            setState(() {
              _selectedYear = value!;
              _salary = calculateSalary(_selectedMonth!, _selectedYear!, Index);
            });
          },
        ),
      ],
    );
  }

  SelectedDate() {
    String monthandyear = _selectedMonth.toString() + _selectedYear.toString();
    SelectedMonthYear =
        '${monthandyear.substring(0, 1)}/${monthandyear.substring(1)}';
    SelectedMonthYear =
        '${SelectedMonthYear?.substring(0, SelectedMonthYear!.length - 2)}${SelectedMonthYear!.substring(SelectedMonthYear!.length - 2)}';
    print("Month and year $SelectedMonthYear");
    return SelectedMonthYear;
  }
}
