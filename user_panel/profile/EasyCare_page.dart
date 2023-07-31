import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easytour/configuration/color.dart';
import 'package:easytour/user_panel/profile/ProfilePage.dart';
import 'package:flutter/material.dart';

class WeCarePage extends StatefulWidget {
  @override
  _WeCarePageState createState() => _WeCarePageState();
}

class _WeCarePageState extends State<WeCarePage> {
  TextEditingController suggestionController = TextEditingController();
  String userEmail = '';
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Fetch the current user's email
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userEmail = user.email ?? '';
    }
  }

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      if (userEmail.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Not Logged In',
                style: TextStyle(color: Colors.red),
              ),
              content: Text('Please log in to submit your suggestions.',
                  style: TextStyle(color: Colors.red)),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
        return;
      }

      String suggestion = suggestionController.text;

      // Save the user's input and email to Firestore
      FirebaseFirestore.instance.collection('wecare').add({
        'suggestion': suggestion,
        'email': userEmail,
      });

      // Clear the text fields after submitting
      suggestionController.clear();

      // Show a dialog or navigate to a success screen
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Submission Successful'),
            content: Text('Thank you for your feedback!'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(),
                    ),
                  );
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    suggestionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.myColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(),
              ),
            );
          },
        ),
        title: Text('We Care'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20),
                Text(
                  'We Care',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: MyColors.myColor),
                ),
                SizedBox(height: 20),
                Text(
                  'Suggestions:',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: MyColors.myColor),
                ),
                SizedBox(height: 10),
                Text(
                  "We value your feedback and suggestions! We believe that our app can continuously evolve and improve with the help of our users. If you have any ideas, features, or enhancements that you would like to see implemented, we encourage you to share them with us. Simply use the provided text field to jot down your suggestions, and we'll carefully review each one. We also understand that issues may arise from time to time, so if you come across any bugs, glitches, or have any concerns, please don't hesitate to report them through the text field as well. Your input is invaluable to us, as it helps us deliver a better experience for all our users. Together, let's make our app the best it can be!",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                MyTextField(
                  validator: MyTextField.wecarevalidator,
                  maxLines: 7,
                  controller: suggestionController,
                  hint: 'Enter Your Suggestions',
                  label: 'Suggestions / Reports',
                  icon: Icons.report,
                ),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: submitForm,
                    child: Text('Submit'),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(MyColors.myColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
