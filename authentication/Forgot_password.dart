import 'package:easytour/configuration/color.dart';
import 'package:easytour/main.dart';
import 'package:easytour/authentication/reset_successfully.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({Key? key}) : super(key: key);
  final Emailcontroller = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.myColor,
        title: Text('Forgot Password'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Reset your password',
              style: TextStyle(
                color: MyColors.myColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Enter the email address associated with your account to reset your password',
              style: TextStyle(
                color: MyColors.myColor,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: Emailcontroller,
              decoration: InputDecoration(
                labelText: 'Email Address',
                labelStyle: TextStyle(
                  color: MyColors.myColor,
                ),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: MyColors.myColor,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                auth
                    .sendPasswordResetEmail(
                        email: Emailcontroller.text.toString())
                    .then((value) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => PasswordResetSuccessPage()),
                  );
                }).onError((error, stackTrace) {
                  Utils.showToast(
                      context, 'Please Enter a Correct email address');
                  print("error${error.toString()}");
                });
              },
              style: ElevatedButton.styleFrom(
                primary: MyColors.myColor,
              ),
              child: Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}

//Utils class for rest page msg
class Utils {
  static void showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: MyColors.myColor,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
