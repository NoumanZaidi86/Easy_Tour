import 'package:easytour/authentication/login.dart';
import 'package:easytour/configuration/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class logoutbutton extends StatelessWidget {
  const logoutbutton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: MyColors.myColor, // Set button color here
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "LogOut",
                style: TextStyle(
                  color: MyColors.myColor,
                ),
              ),
              content: Text("Are you sure you want to Logout"),
              actions: [
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(
                    "LogOut",
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () async {
                    // Handle delete action
                    await FirebaseAuth.instance.signOut();
                    // navigate to login page
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => MyLogin(),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
      child: Text('Log out'),
    );
  }
}
