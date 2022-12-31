import 'package:flutter/material.dart';
import 'package:library_app_interview_task/layout/home_screen/home_screen.dart';
import 'package:library_app_interview_task/shared/local/components/custom_text_field.dart';
import 'package:library_app_interview_task/shared/local/components/loading_widget.dart';
import 'package:library_app_interview_task/shared/network/firebase_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            margin:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
            constraints: const BoxConstraints(
                // minWidth: 200.0,
                maxWidth: 600.0,
                // minHeight: 400,
                maxHeight: 800),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50.0),
                bottomRight: Radius.circular(50.0),
              ),
              color: Colors.white,
              border: Border.all(
                color: Theme.of(context).primaryColor,
              ),
            ),
            child: Form(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Login',
                      style: Theme.of(context).textTheme.headline2,
                    ),
                    const SizedBox(height: 30.0),
                    buildTextField(
                      controller: emailController,
                      hintText: 'email',
                    ),
                    const SizedBox(height: 20.0),
                    buildTextField(
                      controller: passController,
                      hintText: 'Password',
                      isObscured: true,
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () async {
                        await login();
                      },
                      child: const Text('Login'),
                    ),
                    const SizedBox(height: 20.0),
                    TextButton(
                      child: const Text('Forgot Password ?'),
                      onPressed: () {},
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  login() async {
    LoadingWidget().loading(context);
    try {
      // await Firebase.initializeApp();
      await FirebaseProvider.instance.auth
          .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passController.text.trim(),
          )
          .timeout(const Duration(seconds: 5),
              onTimeout: () => throw 'Failed, Check your internet Connection');
      try {
        await FirebaseProvider.instance.getLoggedUserInfo();
        await saveCredentials();
        Navigator.of(context).pop();
        if (Navigator.of(context).canPop()) Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      } catch (e) {
        try {
          await FirebaseProvider.instance.logout();
        } catch (e) {
          //
        }
        throw Auth.FirebaseAuthException(code: 'user-not-found');
      }
    } on Auth.FirebaseAuthException catch (e) {
      Navigator.of(context).pop();
      String message = 'error Occurred';
      if (e.code == 'user-not-found') {
        message = 'User not found';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password';
      } else if (e.code == 'ERROR_INVALID_EMAIL') {
        message = 'Your email address appears to be malformed';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        backgroundColor: Theme.of(context).errorColor,
      ));
    } catch (e) {
      Navigator.of(context).pop();
      try {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
          // 'Check your internet Connection'),
          duration: const Duration(seconds: 3),
          backgroundColor: Theme.of(context).errorColor,
        ));
      } catch (e) {
        //
      }
    }
  }

  saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', emailController.text.trim());
    await prefs.setString('pass', passController.text.trim());
  }
}
