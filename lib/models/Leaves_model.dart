class LeaveModel {
  int? DurationDays;
  String? HalfLeave;
  String Note;
  String applyDateTime;
  String documentId;
  String email;
  String employeeId;
  String endDate;
  String firstName;
  String lastName;
  String status;
  String startDate;
  List<LeaveDetails> leaveDetails;

  LeaveModel(
      {required this.DurationDays,
      required this.HalfLeave,
      required this.Note,
      required this.applyDateTime,
      required this.documentId,
      required this.email,
      required this.employeeId,
      required this.endDate,
      required this.firstName,
      required this.lastName,
      required this.leaveDetails,
      required this.status,
      required this.startDate});

  factory LeaveModel.fromJson(Map<String, dynamic> json) {
    return LeaveModel(
      DurationDays: json['DurationDays'],
      HalfLeave: json['HalfLeave'],
      Note: json['Note'],
      applyDateTime: json['applyDateTime'],
      documentId: json['documentId'],
      email: json['email'],
      employeeId: json['employeeId'],
      endDate: json['endDate'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      status: json['status'],
      startDate: json['startDate'],
      leaveDetails: (json['LeaveDetails'] as List<dynamic>)
          .map((item) => LeaveDetails.fromJson(item))
          .toList(),
    );
  }
}

class LeaveDetails {
  int leaveDays;
  String monthYear;

  LeaveDetails({
    required this.leaveDays,
    required this.monthYear,
  });

  factory LeaveDetails.fromJson(Map<String, dynamic> json) {
    return LeaveDetails(
      leaveDays: json['leaveDays'],
      monthYear: json['monthYear'],
    );
  }
}
