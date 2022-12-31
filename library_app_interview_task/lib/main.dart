import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:library_app_interview_task/layout/authentication/login_screen.dart';
import 'package:library_app_interview_task/layout/home_screen/home_screen.dart';
import 'package:library_app_interview_task/models/book.dart';
import 'package:library_app_interview_task/shared/local/constants.dart';
import 'package:library_app_interview_task/shared/network/firebase_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //     options: const FirebaseOptions(
  //         apiKey: "AIzaSyA8HrW8DKD2d27hTrQyrZCvoRbLqwuiRkA",
  //         authDomain: "library-app-sabis.firebaseapp.com",
  //         projectId: "library-app-sabis",
  //         storageBucket: "library-app-sabis.appspot.com",
  //         messagingSenderId: "179003758886",
  //         appId: "1:179003758886:web:f00f1718db7d104a7f49e7",
  //         measurementId: "G-H6S3LMHY97"
  //     )
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Library App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getStartPage(context),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.hasData) {
            return snapshot.data;
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  getStartPage(context) async {
    // await FirebaseProvider.instance.fixRegistered();
    // await FirebaseProvider.instance.resetActivitiesStudents();
    // await FirebaseProvider.instance.relocateActivitiesForStudents();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? pass = prefs.getString('pass');
    var auth = FirebaseAuth.instance;
    if(email != null && pass != null) {
      try {
        await FirebaseFirestore.instance.clearPersistence();
      } catch (e) {
        //
      }
      try {
        await auth.signInWithEmailAndPassword(email: email, password: pass);
        await FirebaseProvider.instance.getLoggedUserInfo();
        AppConstants.borrowingStatus = await FirebaseProvider.instance.getBorrowingStatus();
        return const HomePage();
      } catch(e) {
        //
      }
    }
    else {
      return const LoginScreen();
    }
    //return SignInScreen();
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: future(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if(snapshot.hasData) {
              return const StartScreen();
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Future<String> future() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyA8HrW8DKD2d27hTrQyrZCvoRbLqwuiRkA",
            authDomain: "library-app-sabis.firebaseapp.com",
            projectId: "library-app-sabis",
            storageBucket: "library-app-sabis.appspot.com",
            messagingSenderId: "179003758886",
            appId: "1:179003758886:web:f00f1718db7d104a7f49e7",
            measurementId: "G-H6S3LMHY97"
        )
    );

    // for (int i = 1; i < 10 ; i++) {
    //   await FirebaseProvider.instance.addBook(Book(
    //     name: 'Book 0$i',
    //     isbn: '11110$i',
    //     author: 'Author 0$i',
    //     borrower: '',
    //     publishedIn: 'Location 0$i',
    //     numPages: 100,
    //   ));
    // }
    // for (int i = 10; i < 21 ; i++) {
    //   await FirebaseProvider.instance.addBook(Book(
    //     name: 'Book $i',
    //     isbn: '1111$i',
    //     author: 'Author $i',
    //     borrower: '',
    //     publishedIn: 'Location $i',
    //     numPages: 100,
    //   ));
    // }
    return '';
  }
}
