import 'package:cloud_firestore/cloud_firestore.dart';

class usersDetails {
  final String email;
  final String employeeId;
  final String firstName;
  final String lastName;
  final String password;
  final String salary;

  usersDetails(
      {required this.email,
      required this.employeeId,
      required this.firstName,
      required this.lastName,
      required this.password,
      required this.salary});

  factory usersDetails.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return usersDetails(
      email: data['email'],
      employeeId: data["employeeId"],
      firstName: data['firstName'],
      lastName: data['lastName'],
      password: data['password'],
      salary: data['salary'],
    );
  }
}
