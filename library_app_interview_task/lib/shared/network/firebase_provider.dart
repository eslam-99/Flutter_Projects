import 'dart:async';
import 'dart:io';
import 'package:library_app_interview_task/models/book.dart';
import 'package:library_app_interview_task/models/borrow_request.dart';
import 'package:library_app_interview_task/models/enums/borrow_status.dart';
import 'package:library_app_interview_task/models/enums/users_role.dart';
import 'package:library_app_interview_task/models/user_admin.dart';
import 'package:library_app_interview_task/models/user_staff.dart';
import 'package:library_app_interview_task/models/user_student.dart';
import 'package:library_app_interview_task/shared/local/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';


class FirebaseProvider{
  final String bucket = 'gs://library-app-sabis.appspot.com';

  FirebaseProvider._privateConstructor();
  static final FirebaseProvider instance = FirebaseProvider._privateConstructor();

  final Auth.FirebaseAuth auth = Auth.FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<QuerySnapshot<Map<String, dynamic>>> getAllUsers() async {
    try {
      return firestore
          .collection('Users')
          .where('role', whereIn: ['1', '2'])
          .get();
    } catch (e) {throw 'Failed, Check your internet Connection';}
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllStudents() async {
    try {
      return firestore
          .collection('Users')
          .where('role', isEqualTo: '2')
          .get();
    } catch (e) {throw 'Failed, Check your internet Connection';}
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllStaff() async {
    try {
      return firestore
          .collection('Users')
          .where('role', isEqualTo: '1')
          .get();
    } catch (e) {throw 'Failed, Check your internet Connection';}
  }

  Future<String> getStudentName(String studentUid) async {
    try {
      return firestore
          .doc('Users/$studentUid')
          .get()
          .then((value) {
        return value.get('name');
      });
    } catch (e) {throw 'Failed, Check your internet Connection';}
  }

  Future<String> getStaffName(String staffUid) async {
    try {
      if (staffUid.isEmpty) {
        return '';
      }
      return firestore
          .doc('Users/$staffUid')
          .get()
          .then((value) {
        return value.get('name');
      });
    } catch (e) {throw 'Failed, Check your internet Connection';}
  }

  Future<String> getBookName(String bookISBN) async {
    try {
      return firestore
          .doc('Books/$bookISBN')
          .get()
          .then((value) {
        return value.get('name');
      });
    } catch (e) {throw 'Failed, Check your internet Connection';}
  }

  Future<List<String>> getBorrowingStatus() async {
    try {
      return firestore
          .collection('BorrowingStatus')
          .get()
          .then((value) {
        return value.docs.map<String>((e) => e.data()['status']).toList();
      });
    } catch (e) {throw 'Failed, Check your internet Connection';}
  }

  Future<bool> checkBookBorrowedStatus(String bookISBN) async {
    try {
      return firestore
          .doc('Books/$bookISBN')
          .get()
          .then((value) {
        return value.get('borrower').toString().isNotEmpty;
      });
    } catch (e) {throw 'Failed, Check your internet Connection';}
  }

  Future<List<BorrowRequest>> getBorrowingRequestsForStudent(String studentUid) async {
    try {
      return await firestore
          .collection('BorrowingBooksRequests')
          .where('studentUid', isEqualTo: studentUid)
          .get()
          .then((value) async {
            List<BorrowRequest> borrowRequests = value.docs.map((req) => BorrowRequest.fromDoc(req.id, req.data())).toList();
            List<List> data = await Future.wait(borrowRequests.map((e) async {
              var obj = await Future.wait([
                getStudentName(e.studentUid!),
                getStaffName(e.borrowerStaffUid!),
                getBookName(e.bookISBN!),
              ]);
              return obj;
            }));
            for (int i = 0; i < borrowRequests.length ; i++) {
              borrowRequests[i].studentName = data[i][0];
              borrowRequests[i].lenderStaffName = data[i][1];
              borrowRequests[i].bookName = data[i][2];
            }
            borrowRequests.sort((a,b) {
              return a.borrowRequestTime!.compareTo(b.borrowRequestTime!) * -1;
            });
            return borrowRequests;
      });
    } catch (e) {rethrow;}
  }

  Future<List<BorrowRequest>> getBindingBorrowingRequests(int status) async {
    try {
      return await firestore
          .collection('BorrowingBooksRequests')
          .where('status', isEqualTo: status)
          .get()
          .then((value) async {
        List<BorrowRequest> borrowRequests = value.docs.map((req) => BorrowRequest.fromDoc(req.id, req.data())).toList();
        List<List> data = await Future.wait(borrowRequests.map((e) async {
          var obj = await Future.wait([
            getStudentName(e.studentUid!),
            getStaffName(e.borrowerStaffUid!),
            getBookName(e.bookISBN!),
          ]);
          return obj;
        }));
        for (int i = 0; i < borrowRequests.length ; i++) {
          borrowRequests[i].studentName = data[i][0];
          borrowRequests[i].lenderStaffName = data[i][1];
          borrowRequests[i].bookName = data[i][2];
        }
        borrowRequests.sort((a,b) {
          return a.borrowRequestTime!.compareTo(b.borrowRequestTime!) * -1;
        });
        return borrowRequests;
      });
    } catch (e) {rethrow;}
  }

  Future<List<BorrowRequest>> getBindingReturningRequests() async {
    try {
      return await firestore
          .collection('BorrowingBooksRequests')
          .where('status', isEqualTo: 2)
          .get()
          .then((value) async {
        List<BorrowRequest> borrowRequests = value.docs.map((req) => BorrowRequest.fromDoc(req.id, req.data())).toList();
        List<List> data = await Future.wait(borrowRequests.map((e) async {
          var obj = await Future.wait([
            getStudentName(e.studentUid!),
            getStaffName(e.borrowerStaffUid!),
            getBookName(e.bookISBN!),
          ]);
          return obj;
        }));
        for (int i = 0; i < borrowRequests.length ; i++) {
          borrowRequests[i].studentName = data[i][0];
          borrowRequests[i].lenderStaffName = data[i][1];
          borrowRequests[i].bookName = data[i][2];
        }
        borrowRequests.sort((a,b) {
          return a.borrowRequestTime!.compareTo(b.borrowRequestTime!) * -1;
        });
        return borrowRequests;
      });
    } catch (e) {rethrow;}
  }

  Future<bool> checkDuplicateBorrowBookRequest(String studentUid, String bookISBN) async {
    try {
      List<BorrowRequest> requests = await firestore
          .collection('BorrowingBooksRequests')
          .where('bookISBN', isEqualTo: bookISBN)
          .where('studentUid', isEqualTo: studentUid)
          .get()
          .then((value) {
            return value.docs.map((req) => BorrowRequest.fromDoc(req.id, req.data())).toList();
      });
      for (var req in requests) {
        if (req.status == BorrowStatus.borrowRequested || req.status == BorrowStatus.borrowApproved || req.status == BorrowStatus.returnRequested) {
          return true; // To prevent the student from requesting the same book again
        }
      }
      return false;
    } catch (e) {rethrow;}
  }

  Future addBorrowRequest(String studentUid, String bookISBN) async {
    try {
      await checkDuplicateBorrowBookRequest(studentUid, bookISBN).then((borrowResult) async {
        if (borrowResult) {
          throw 'Failed, you have already requested this book';
        }
        await checkBookBorrowedStatus(bookISBN).then((isBorrowed) async {
          if(isBorrowed) {
            throw 'Another student already borrowed this book';
          }
          // await firestore.doc('UsersActivities/$uid').update({
          await firestore.collection('BorrowingBooksRequests').add({
            'bookISBN': bookISBN,
            'studentUid': studentUid,
            'status': 0,
            'borrowerStaffUid': '',
            'returnerStaffUid': '',
            'borrowRequestTime': DateTime.now().millisecondsSinceEpoch,
            'borrowResponseTime': '',
            'returnRequestTime': '',
            'returnResponseTime': '',
          });
          // await firestore.doc('Books/$bookISBN').update({
          //   'borrower': ,
          // });
        });
      });
    } catch (e) {rethrow;}
  }

  Future addReturnRequest(String studentUid, String bookISBN) async {
    try {
      await firestore.collection('BorrowingBooksRequests')
      .where('bookISBN', isEqualTo: bookISBN)
      .where('studentUid', isEqualTo: studentUid)
      .where('status', isEqualTo: 1)
      .get()
      .then((requests) async {
        if (requests.docs.isEmpty) throw 'You don\'t have the book to return it';
        Map<String, dynamic> req = requests.docs[0].data()..['id'] = requests.docs[0].id;
        req['status'] = BorrowStatus.returnRequested.index;
        req['returnRequestTime'] = DateTime.now().millisecondsSinceEpoch;
        await firestore.doc('BorrowingBooksRequests/${req['id']}').set(req);
      });
    } catch (e) {rethrow;}
  }

  Future deleteBorrowRequest(String reqUid) async {
    try {
      await firestore.doc('BorrowingBooksRequests/$reqUid').delete();
    } catch (e) {rethrow;}
  }

  // Future responseBorrowBookRequest(BorrowRequest req) async {
  //   try {
  //     if (req.status == BorrowStatus.borrowApproved) {
  //       acceptBorrowBookRequest(req);
  //     }
  //     else if (req.status == BorrowStatus.borrowRequested){
  //       rejectBorrowBookRequest(req);
  //     }
  //   } catch (e) {rethrow;}
  // }

  Future acceptBorrowBookRequest(BorrowRequest req) async {
    try {
      await firestore.doc('Books/${req.bookISBN!}').set(
          {'borrower': req.studentUid!}, SetOptions(merge: true));
      await firestore.doc('BorrowingBooksRequests/${req.uid}').set(
          req.toMap(), SetOptions(merge: true));
    } catch (e) {rethrow;}
  }

  Future rejectBorrowBookRequest(BorrowRequest req) async {
    try {
      await firestore.doc('BorrowingBooksRequests/${req.uid}').set(
          req.toMap(), SetOptions(merge: true));
    } catch (e) {rethrow;}
  }

  Future acceptReturnBookRequest(BorrowRequest req) async {
    try {
      await firestore.doc('Books/${req.bookISBN!}').set(
          {'borrower': ''}, SetOptions(merge: true));
      await firestore.doc('BorrowingBooksRequests/${req.uid}').set(
          req.toMap(), SetOptions(merge: true));
    } catch (e) {rethrow;}
  }

  Future rejectReturnBookRequest(BorrowRequest req) async {
    try {
      await firestore.doc('BorrowingBooksRequests/${req.uid}').set(
          req.toMap(), SetOptions(merge: true));
    } catch (e) {rethrow;}
  }

  Future<void> addBook(Book book) async {
    try {
      await firestore.doc('Books/${book.isbn}').set(book.toMap());
    } catch (e) {
      //
    }
  }

  Future<void> deleteBook(String bookISBN, String bookCoverURL) async {
    try {
      await firestore.doc('Books/$bookISBN').get().then((book) async{
        if (book.data()!['borrower'] == '') {
          await firestore.doc('Books/$bookISBN').delete();
          await firestore.collection('BorrowingBooksRequests').where(
              'bookISBN', isEqualTo: bookISBN).get().then((value) async {
            if (value.size != 0) {
              Future.wait(value.docs.map((e) =>
                  firestore.doc('BorrowingBooksRequests/${e.id}').delete()));
            }
          });
          try {
            if (bookCoverURL.isNotEmpty) {
              deleteProfPic(bookISBN);
            }
          } catch (e) {
            //
          }
        } else {
          throw 'There is a student has the book, return it first';
        }
      });
    } catch (e) {rethrow;}
  }

  Future<List<Book>> getAllBooks() async {
    try {
      return await firestore.collection('Books').get().then((value) {
        return value.docs.map((e) => Book.fromDoc(e.id, e.data())).toList();
      });
    } catch (e) {rethrow;}
  }

  Future<String> uploadProfPic(var image, String uid) async {
    try {
      if(image.isEmpty) return '';
      FirebaseStorage storage = FirebaseStorage.instanceFor(
        bucket: bucket,
      );
      Reference? ref = storage.ref('profPic/$uid');
      UploadTask storageUploadTask = kIsWeb ? ref.putData(image) : ref.putFile(File(image));
      TaskSnapshot storageTaskSnapshot =
      await storageUploadTask.whenComplete(() => null);
      String url = await storageTaskSnapshot.ref.getDownloadURL();
      return url;
    } catch (e) {
      throw 'Failed, Check your internet Connection';
    }
  }

  Future deleteProfPic(String uid) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instanceFor(
        bucket: bucket,
      );
      Reference? ref = storage.ref('profPic/$uid');
      ref.delete();
    } catch (e) {
      throw 'Failed, Check your internet Connection';
    }
  }

  Future<String> uploadBookCover(var image, String bookISBN) async {
    try {
      if(image.isEmpty) return '';
      FirebaseStorage storage = FirebaseStorage.instanceFor(
        bucket: bucket,
      );
      Reference? ref = storage.ref('BooksCovers/$bookISBN');
      UploadTask storageUploadTask = kIsWeb ? ref.putData(image) : ref.putFile(File(image));
      TaskSnapshot storageTaskSnapshot =
        await storageUploadTask.whenComplete(() => null);
      String url = await storageTaskSnapshot.ref.getDownloadURL();
      return url;
    } catch (e) {
      throw 'Failed, Check your internet Connection';
    }
  }

  Future deleteBookCover(String bookISBN) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instanceFor(
        bucket: bucket,
      );
      Reference? ref = storage.ref('BooksCovers/$bookISBN');
      ref.delete();
    } catch (e) {
      throw 'Failed, Check your internet Connection';
    }
  }

  logout() async {
    try{
      auth.signOut();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('email');
      await prefs.remove('pass');
    } catch(e) {
      // print(e);
    }
  }

  // getUserInfoByID(String uid) async {
  //   try {
  //     var value = await firestore
  //         .doc('Users/$uid')
  //         .get()
  //     .then((user) {
  //       if (user.exists) {
  //         if(user.get('role') == UserRole.student.index.toString()) {
  //           return Student.fromDoc(user.get('uid'), user);
  //         } else if(user.get('role') == UserRole.staff.index.toString()) {
  //           return Teacher.fromDoc(user.get('uid'), user);
  //         }
  //       }
  //       else {
  //         throw 'User with uid : $uid isn\'t found';
  //       }
  //     });
  //   } catch (e) {rethrow;}
  // }

  getLoggedUserInfo() async {
    try {
      var user = await firestore
          .collection("Users")
          .doc(auth.currentUser!.uid)
          .get();
      if (user.get('role') == UserRole.student.index.toString()) {
        UserProvider.instance.currentUser =
            StudentUser.fromDoc(auth.currentUser!.uid, user.data()!);
      } else if (user.get('role') == UserRole.staff.index.toString()) {
        UserProvider.instance.currentUser =
            StaffUser.fromDoc(auth.currentUser!.uid, user.data()!);
      } else if (user.get('role') == UserRole.admin.index.toString()) {
        UserProvider.instance.currentUser =
            AdminUser.fromDoc(auth.currentUser!.uid, user.data()!);
      }
    } catch (e) {rethrow;}
  }
}