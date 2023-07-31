import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easytour/admin_panel/admin_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../configuration/color.dart';

class Makeadmin extends StatefulWidget {
  @override
  _MakeadminState createState() => _MakeadminState();
}

class _MakeadminState extends State<Makeadmin> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: MyColors.myColor,
        centerTitle: true,
        title: Text('Admin Panel'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    margin: EdgeInsets.all(15),
                    child: Text(
                      '  Create Admin  ',
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
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                Container(
                                  margin: EdgeInsets.only(left: 100),
                                  decoration: BoxDecoration(
                                    color: MyColors.myColor,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        showDialog(
                                            context: context,
                                            builder: ((context) {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: MyColors.myColor,
                                                ),
                                              );
                                            }));
                                        FirebaseAuth.instance
                                            .createUserWithEmailAndPassword(
                                                email: emailController.text,
                                                password:
                                                    passwordController.text)
                                            .then((value) async {
                                          print("created new account");

                                          // Authenticate user here
                                          await addadminToFirestore(
                                              nameController,
                                              phoneController,
                                              cnicController);

                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AdminPage()),
                                          );
                                        }).onError((error, stackTrace) {
                                          print("error${error.toString()}");
                                          showErrorDialog(error.toString());
                                        });
                                      }
                                    },
                                    child: Text(
                                      'Add Admin',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> addadminToFirestore(
      TextEditingController nameController,
      TextEditingController phoneController,
      TextEditingController cnicController) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    User? user = auth.currentUser;
    if (user != null) {
      String name = nameController.text;
      String phoneNumber = phoneController.text;
      String cnicNumber = cnicController.text;
      try {
        await firestore.collection('admins').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'name': name,
          'phone': phoneNumber,
          'cnic': cnicNumber,

          // Add additional fields as desired
        });
        print('Admin  added to Firestore');
      } catch (e) {
        print('Error adding Travel Agent to Firestore: $e');
      }
    }
  }
}
