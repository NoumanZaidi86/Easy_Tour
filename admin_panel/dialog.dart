import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easytour/admin_panel/admin_page.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatefulWidget {
  final String? name;
  final String? company;
  final String? phone;
  final String? cnic;
  final String? email;
  final String? password;

  CustomDialog({
    Key? key,
    this.name,
    this.company,
    this.phone,
    this.cnic,
    this.email,
    this.password,
  }) : super(key: key);

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  TextEditingController nameController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController cnicController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    nameController.text = widget.name ?? '';
    companyController.text = widget.company ?? '';
    phoneController.text = widget.phone ?? '';
    cnicController.text = widget.cnic ?? '';
    emailController.text = widget.email ?? '';
    passwordController.text = widget.password ?? '';
  }

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
    return AlertDialog(
      title: Text('Agent Details'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: companyController,
              decoration: InputDecoration(
                labelText: 'Company Name',
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Phone',
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: cnicController,
              decoration: InputDecoration(
                labelText: 'CNIC',
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            // Perform accept action
            FirebaseAuth.instance
                .createUserWithEmailAndPassword(
              email: emailController.text,
              password: passwordController.text,
            )
                .then((value) async {
              print("created new account");

              // Authenticate user here
              await addTravelagentToFirestore(
                nameController.text,
                phoneController.text,
                cnicController.text,
                emailController.text,
                companyController.text,
                passwordController.text,
              );

              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AdminPage()),
              );
            }).onError((error, stackTrace) {
              print("error${error.toString()}");
              showErrorDialog(error.toString());
            });
          },
          child: Text('Accept'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }

  Future<void> addTravelagentToFirestore(
    String name,
    String phone,
    String cnic,
    String email,
    String company,
    String password,
  ) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    User? user = auth.currentUser;
    if (user != null) {
      try {
        await firestore.collection('travelagents').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'name': name,
          'phone': phone,
          'cnic': cnic,
          'company': company,
          'password': password,
          // Add additional fields as desired
        });
        print('Travel Agent added to Firestore');
      } catch (e) {
        print('Error adding Travel Agent to Firestore: $e');
      }
    }
  }

  @override
  void dispose() {
    // Dispose the controllers when the widget is disposed
    nameController.dispose();
    companyController.dispose();
    phoneController.dispose();
    cnicController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
