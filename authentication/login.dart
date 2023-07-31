import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:easytour/admin_panel/admin_page.dart';
import 'package:easytour/authentication/Forgot_password.dart';

import 'package:easytour/authentication/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:easytour/homepage.dart';
import 'package:easytour/travel_agent/TravelAgentHomePage.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../configuration/color.dart';

enum UserType {
  admins,
  customers,
  travelagents,
}

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> showErrorDialog(String errorMessage) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Error',
            style: TextStyle(color: Colors.red),
          ),
          content: Text(errorMessage),
          actions: [
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFF28A3AA),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _login(BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      User? user = userCredential.user;
      if (user != null) {
        String userId = user.uid;

        // Check if the user exists in the "admins" collection
        bool isAdmin = await FirebaseFirestore.instance
            .collection("admins")
            .doc(userId)
            .get()
            .then((docSnapshot) => docSnapshot.exists);

        // Check if the user exists in the "travelagents" collection
        bool isTravelAgent = await FirebaseFirestore.instance
            .collection("travelagents")
            .doc(userId)
            .get()
            .then((docSnapshot) => docSnapshot.exists);

        // Check if the user exists in the "customers" collection
        bool isCustomer = await FirebaseFirestore.instance
            .collection("customers")
            .doc(userId)
            .get()
            .then((docSnapshot) => docSnapshot.exists);

        if (isAdmin) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminPage()),
          );
        } else if (isTravelAgent) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TravelAgentHomePage()),
          );
        } else if (isCustomer) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      }
    } catch (error) {
      showErrorDialog(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 120,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.elliptical(30, 30),
              bottomRight: Radius.elliptical(30, 30)),
        ),
        backgroundColor: MyColors.myColor,
        centerTitle: true,
        title: Text(
          'Easy Tour',
          style: TextStyle(
            fontSize: 70,
            fontStyle: FontStyle.italic,
            shadows: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 2,
                offset: Offset(2, 2),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(left: 35, right: 35),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          left: 35, right: 35, top: 20, bottom: 15),
                      child: Image.asset('images/loginscreen.jpeg'),
                      height: 200,
                      width: 200,
                    ),
                    Container(
                      child: Text(
                        '  Login Account',
                        style: TextStyle(
                          fontSize: 40,
                          fontStyle: FontStyle.italic,
                          color: MyColors.myColor,
                          shadows: [
                            BoxShadow(
                              color: MyColors.myColor,
                              blurRadius: 2,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    MyTextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      icon: Icons.email_outlined,
                      label: 'Email',
                      hint: 'abc@.com',
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    MypasswordTextField(
                      controller: passwordController,
                      icon: Icons.lock,
                      label: 'Password',
                      hint: 'abc@1/?.',
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgotPasswordPage()),
                              );
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                              ),
                            )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 310,
                          decoration: BoxDecoration(
                            color: MyColors.myColor,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: TextButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                showDialog(
                                    context: context,
                                    builder: ((context) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: MyColors.myColor,
                                        ),
                                      );
                                    }));

                                _login(context);
                              }
                            },
                            child: Text(
                              " Sign in",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style:
                              TextStyle(color: MyColors.myColor, fontSize: 18),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyRegister()),
                            );
                          },
                          child: Text(
                            " Sign up",
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.blue, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                MyColors.myColor),
                          ),
                          child: Text(
                            'Skip',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
