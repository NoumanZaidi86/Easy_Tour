import 'package:easytour/admin_panel/admin_page.dart';

import 'package:easytour/configuration/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class AdminProfilePage extends StatefulWidget {
  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  String _username = '';
  String _email = '';
  String _phone = '';
  String _cnic = '';

  @override
  void initState() {
    super.initState();
    _loadadmindata();
  }

  Future<void> _loadadmindata() async {
    final user = FirebaseAuth.instance.currentUser;
    final doc = await FirebaseFirestore.instance
        .collection('admins')
        .doc(user?.uid)
        .get();
    setState(() {
      _username = doc.get('name');
      _email = doc.get('email');
      _phone = doc.get('phone');
      _cnic = doc.get('cnic');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Profile'),
        centerTitle: true,
        backgroundColor: MyColors.myColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdminPage(),
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5,
              ),
              Center(
                child: Container(
                    height: 200,
                    width: 200,
                    child: Image.asset('images/signup.png')),
              ),
              SizedBox(
                height: 10,
              ),
              MyTextField(
                controller: TextEditingController(text: _username),
                readOnly: true,
                hint: '',
                label: 'User Name',
                icon: Icons.person,
                maxLines: 1,
              ),
              SizedBox(height: 8),
              MyTextField(
                controller: TextEditingController(text: _email),
                readOnly: true,
                hint: '',
                label: 'Email',
                icon: Icons.email,
                maxLines: 1,
              ),
              SizedBox(height: 8),
              MyTextField(
                controller: TextEditingController(text: _phone),
                readOnly: true,
                hint: '',
                label: 'Phone Number',
                icon: Icons.phone_android_outlined,
                maxLines: 1,
              ),
              SizedBox(height: 8),
              MyTextField(
                controller: TextEditingController(text: _cnic),
                readOnly: true,
                hint: '',
                label: 'CNIC',
                icon: Icons.credit_card,
                maxLines: 1,
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
