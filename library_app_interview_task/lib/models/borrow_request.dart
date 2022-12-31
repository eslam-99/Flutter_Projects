import 'package:library_app_interview_task/models/enums/borrow_status.dart';

class BorrowRequest {
  String? uid;
  String? bookISBN;
  String? bookName;
  String? studentUid;
  String? studentName;
  String? borrowerStaffUid;
  String? returnerStaffUid;
  String? lenderStaffName;
  String? retrieverStaffName;
  // bool? isBorrowed;
  // bool? isReturned;
  DateTime? borrowRequestTime;
  DateTime? borrowResponseTime;
  DateTime? returnRequestTime;
  DateTime? returnResponseTime;
  BorrowStatus? status;

  BorrowRequest.fromDoc(String this.uid, Map request) {
    bookISBN = request['bookISBN'];
    studentUid = request['studentUid'];
    borrowerStaffUid = request['borrowerStaffUid'];
    returnerStaffUid = request['returnerStaffUid'];
    borrowRequestTime = request['borrowRequestTime'] is String ? null : DateTime.fromMillisecondsSinceEpoch(request['borrowRequestTime']);
    borrowResponseTime = request['borrowResponseTime'] is String ? null : DateTime.fromMillisecondsSinceEpoch(request['borrowResponseTime']);
    returnRequestTime = request['returnRequestTime'] is String ? null : DateTime.fromMillisecondsSinceEpoch(request['returnRequestTime']);
    returnResponseTime = request['returnResponseTime'] is String ? null : DateTime.fromMillisecondsSinceEpoch(request['returnResponseTime']);
    status = BorrowStatus.values[request['status']];
    // isBorrowed = status == BorrowStatus.borrowApproved;
    // isReturned = status == BorrowStatus.returnApproved;
  }

  Map<String, Object?> toMap() {
    return {
      'bookISBN': bookISBN,
      'studentUid': studentUid,
      'borrowerStaffUid': borrowerStaffUid,
      'returnerStaffUid': returnerStaffUid,
      'status': status?.index ?? 0,
      'borrowRequestTime': borrowRequestTime == null ? '' : borrowRequestTime?.millisecondsSinceEpoch,
      'borrowResponseTime': borrowResponseTime == null ? '' : borrowResponseTime?.millisecondsSinceEpoch,
      'returnRequestTime': returnRequestTime == null ? '' : returnRequestTime?.millisecondsSinceEpoch,
      'returnResponseTime': returnResponseTime == null ? '' : returnResponseTime?.millisecondsSinceEpoch,
    };
  }
}