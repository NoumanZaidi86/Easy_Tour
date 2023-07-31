/*import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easytour/authentication/email_verification.dart';
import 'package:easytour/authentication/how_to%20_send_travel_request.dart';

import 'package:easytour/homepage.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import '../configuration/color.dart';
import 'login.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({Key? key}) : super(key: key);

  @override
  _MyRegisterState createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController cnicController = TextEditingController();
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

  Future<String?> checkDuplicatePhoneOrEmail(
      String phoneNumber, String cnic) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Query for customers collection
    CollectionReference customers = firestore.collection('customers');
    QuerySnapshot customerPhoneSnapshot =
        await customers.where('phone', isEqualTo: phoneNumber).limit(1).get();
    if (customerPhoneSnapshot.docs.isNotEmpty) {
      return 'Phone number ';
    }

    QuerySnapshot customerCnicSnapshot =
        await customers.where('cnic', isEqualTo: cnic).limit(1).get();
    if (customerCnicSnapshot.docs.isNotEmpty) {
      return 'CNIC  ';
    }

    // Query for admins collection
    CollectionReference admins = firestore.collection('admins');
    QuerySnapshot adminPhoneSnapshot =
        await admins.where('phone', isEqualTo: phoneNumber).limit(1).get();
    if (adminPhoneSnapshot.docs.isNotEmpty) {
      return 'Phone number ';
    }

    QuerySnapshot adminCnicSnapshot =
        await admins.where('cnic', isEqualTo: cnic).limit(1).get();
    if (adminCnicSnapshot.docs.isNotEmpty) {
      return 'CNIC ';
    }

    // Query for travelagents collection
    CollectionReference travelagents = firestore.collection('travelagents');
    QuerySnapshot travelagentPhoneSnapshot = await travelagents
        .where('phone', isEqualTo: phoneNumber)
        .limit(1)
        .get();
    if (travelagentPhoneSnapshot.docs.isNotEmpty) {
      return 'Phone number ';
    }

    QuerySnapshot travelagentCnicSnapshot =
        await travelagents.where('cnic', isEqualTo: cnic).limit(1).get();
    if (travelagentCnicSnapshot.docs.isNotEmpty) {
      return 'CNIC ';
    }

    return null;
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
          style: const TextStyle(
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
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Text(
                      '  Create Account',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 40,
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
                  Container(
                    margin: EdgeInsets.only(left: 35, right: 35),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          MyTextField(
                            validator: MyTextField.alphabeticValidator,
                            controller: nameController,
                            icon: Icons.person,
                            label: 'Name',
                            hint: 'Abc',
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          MyTextField(
                            controller: cnicController,
                            icon: Icons.credit_card,
                            label: 'CNIC',
                            hint: 'Enter a 13 Digit Cnic Number',
                            validator: MyTextField.cnicValidator,
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          MyTextField(
                            controller: phoneController,
                            icon: Icons.phone_android_outlined,
                            label: 'Phone Number',
                            hint: 'Enter a 11 digit Phone Number',
                            validator: MyTextField.phoneNumberValidator,
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          MyTextField(
                            controller: emailController,
                            icon: Icons.email_outlined,
                            label: 'Email',
                            hint: 'abc@.com',
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          MypasswordTextField(
                            controller: passwordController,
                            icon: Icons.lock,
                            label: 'Password',
                            hint: 'abc@1/?.',
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: MyColors.myColor,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: TextButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  final String name = nameController.text;
                                  final String phoneNumber =
                                      phoneController.text;
                                  final String cnicNumber = cnicController.text;
                                  final String email = emailController.text;

                                  String? duplicateField =
                                      await checkDuplicatePhoneOrEmail(
                                    phoneNumber,
                                    cnicNumber,
                                  );
                                  if (duplicateField != null) {
                                    showErrorDialog(
                                        '$duplicateField already exists.');
                                  } else {
                                    try {
                                      UserCredential userCredential =
                                          await FirebaseAuth.instance
                                              .createUserWithEmailAndPassword(
                                        email: email,
                                        password: passwordController.text,
                                      );

                                      if (!userCredential.user!.emailVerified) {
                                        // Email is not verified, do not proceed to Firestore or authentication
                                        await userCredential.user!
                                            .sendEmailVerification();
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EmailVerificationScreen()),
                                        );
                                      } else {
                                        // Email is verified, proceed to Firestore and authentication
                                        print("Created new account");

                                        // Additional logic after creating the user
                                        await addCustomerToFirestore(
                                          userCredential.user!.uid,
                                          email,
                                          name,
                                          phoneNumber,
                                          cnicNumber,
                                        );

                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => MyLogin()),
                                        );
                                      }
                                    } catch (error) {
                                      print("Error: ${error.toString()}");
                                      showErrorDialog(error.toString());
                                    }

                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                    );
                                  }
                                }
                              },
                              child: Text(
                                'Sign up',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an Account',
                                style: TextStyle(
                                  color: MyColors.myColor,
                                  fontSize: 17,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyLogin()),
                                  );
                                },
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        HowToSendTravelRequest()),
                              );
                            },
                            child: Text(
                              'Send Travel Agent Request',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> addCustomerToFirestore(String uid, String email, String name,
      String phoneNumber, String cnicNumber) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      await firestore.collection('customers').doc(uid).set({
        'uid': uid,
        'email': email,
        'name': name,
        'phone': phoneNumber,
        'cnic': cnicNumber,
        // Add additional fields as desired
      });
      print('User added to Firestore');
    } catch (e) {
      print('Error adding user to Firestore: $e');
    }
  }
}*/
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easytour/authentication/email_verification.dart';
import 'package:easytour/authentication/how_to%20_send_travel_request.dart';

import 'package:easytour/homepage.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import '../configuration/color.dart';
import 'login.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({Key? key}) : super(key: key);

  @override
  _MyRegisterState createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController cnicController = TextEditingController();
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

  Future<String?> checkDuplicatePhoneOrEmail(
      String phoneNumber, String cnic) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Query for customers collection
    CollectionReference customers = firestore.collection('customers');
    QuerySnapshot customerPhoneSnapshot =
        await customers.where('phone', isEqualTo: phoneNumber).limit(1).get();
    if (customerPhoneSnapshot.docs.isNotEmpty) {
      return 'Phone number ';
    }

    QuerySnapshot customerCnicSnapshot =
        await customers.where('cnic', isEqualTo: cnic).limit(1).get();
    if (customerCnicSnapshot.docs.isNotEmpty) {
      return 'CNIC  ';
    }

    // Query for admins collection
    CollectionReference admins = firestore.collection('admins');
    QuerySnapshot adminPhoneSnapshot =
        await admins.where('phone', isEqualTo: phoneNumber).limit(1).get();
    if (adminPhoneSnapshot.docs.isNotEmpty) {
      return 'Phone number ';
    }

    QuerySnapshot adminCnicSnapshot =
        await admins.where('cnic', isEqualTo: cnic).limit(1).get();
    if (adminCnicSnapshot.docs.isNotEmpty) {
      return 'CNIC ';
    }

    // Query for travelagents collection
    CollectionReference travelagents = firestore.collection('travelagents');
    QuerySnapshot travelagentPhoneSnapshot = await travelagents
        .where('phone', isEqualTo: phoneNumber)
        .limit(1)
        .get();
    if (travelagentPhoneSnapshot.docs.isNotEmpty) {
      return 'Phone number ';
    }

    QuerySnapshot travelagentCnicSnapshot =
        await travelagents.where('cnic', isEqualTo: cnic).limit(1).get();
    if (travelagentCnicSnapshot.docs.isNotEmpty) {
      return 'CNIC ';
    }

    return null;
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
          style: const TextStyle(
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
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Text(
                      '  Create Account',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 40,
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
                  Container(
                    margin: EdgeInsets.only(left: 35, right: 35),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          MyTextField(
                            validator: MyTextField.alphabeticValidator,
                            controller: nameController,
                            icon: Icons.person,
                            label: 'Name',
                            hint: 'Abc',
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          MyTextField(
                            controller: cnicController,
                            icon: Icons.credit_card,
                            label: 'CNIC',
                            hint: 'Enter a 13 Digit Cnic Number',
                            validator: MyTextField.cnicValidator,
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          MyTextField(
                            controller: phoneController,
                            icon: Icons.phone_android_outlined,
                            label: 'Phone Number',
                            hint: 'Enter a 11 digit Phone Number',
                            validator: MyTextField.phoneNumberValidator,
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          MyTextField(
                            controller: emailController,
                            icon: Icons.email_outlined,
                            label: 'Email',
                            hint: 'abc@.com',
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          MypasswordTextField(
                            controller: passwordController,
                            icon: Icons.lock,
                            label: 'Password',
                            hint: 'abc@1/?.',
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: MyColors.myColor,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: TextButton(
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: ((context) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }),
                                );

                                if (_formKey.currentState!.validate()) {
                                  final String name = nameController.text;
                                  final String phoneNumber =
                                      phoneController.text;
                                  final String cnicNumber = cnicController.text;
                                  final String email = emailController.text;

                                  String? duplicateField =
                                      await checkDuplicatePhoneOrEmail(
                                    phoneNumber,
                                    cnicNumber,
                                  );

                                  if (duplicateField != null) {
                                    Navigator.pop(context); // Close the dialog
                                    showErrorDialog(
                                        '$duplicateField already exists.');
                                  } else {
                                    FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                      email: email,
                                      password: passwordController.text,
                                    )
                                        .then((value) async {
                                      print("Created new account");

                                      // Additional logic after creating the user
                                      await addCustomerToFirestore(
                                        value.user!.uid,
                                        email,
                                        name,
                                        phoneNumber,
                                        cnicNumber,
                                      );

                                      Navigator.pop(
                                          context); // Close the dialog
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => MyLogin()),
                                      );
                                    }).catchError((error) {
                                      print("Error: ${error.toString()}");
                                      Navigator.pop(
                                          context); // Close the dialog
                                      showErrorDialog(error.toString());
                                    });
                                  }
                                }
                              },
                              child: Text(
                                'Sign up',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an Account',
                                style: TextStyle(
                                  color: MyColors.myColor,
                                  fontSize: 17,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyLogin()),
                                  );
                                },
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        HowToSendTravelRequest()),
                              );
                            },
                            child: Text(
                              'Send Travel Agent Request',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> addCustomerToFirestore(String uid, String email, String name,
      String phoneNumber, String cnicNumber) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      await firestore.collection('customers').doc(uid).set({
        'uid': uid,
        'email': email,
        'name': name,
        'phone': phoneNumber,
        'cnic': cnicNumber,
        // Add additional fields as desired
      });
      print('User added to Firestore');
    } catch (e) {
      print('Error adding user to Firestore: $e');
    }
  }
}
