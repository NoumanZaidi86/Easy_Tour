import 'package:flutter/material.dart';

import '../configuration/color.dart';
import 'login.dart';

class PasswordResetSuccessPage extends StatelessWidget {
  const PasswordResetSuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 100,
              color: Colors.green,
            ),
            SizedBox(height: 20),
            Text(
              'Your password has been reset successfully!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: MyColors.myColor,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => MyLogin()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: MyColors.myColor,
              ),
              child: Text('Back to Login'),
            ),
          ],
        ),
      ),
    );
  }
}
