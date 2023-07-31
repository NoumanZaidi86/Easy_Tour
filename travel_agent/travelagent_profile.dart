import 'dart:io';

import 'package:easytour/configuration/color.dart';
import 'package:easytour/travel_agent/TravelAgentHomePage.dart';
import 'package:easytour/user_panel/profile/About_us_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class TravelagentProfilePage extends StatefulWidget {
  @override
  State<TravelagentProfilePage> createState() => _TravelagentProfilePageState();
}

class _TravelagentProfilePageState extends State<TravelagentProfilePage> {
  String _username = '';
  String _email = '';
  String _phone = '';
  String _cnic = '';
  File? _profileImage;
  String? _downloadUrl;

  @override
  void initState() {
    super.initState();
    _loadtravelagentdata();
  }

  Future<void> _loadtravelagentdata() async {
    final user = FirebaseAuth.instance.currentUser;
    final doc = await FirebaseFirestore.instance
        .collection('travelagents')
        .doc(user?.uid)
        .get();
    setState(() {
      _username = doc.get('name');
      _email = doc.get('email');
      _phone = doc.get('phone');
      _cnic = doc.get('cnic');
      final profileImage = doc.get('tagentprofile');
      _downloadUrl = profileImage != null ? profileImage.toString() : null;
    });
  }

  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _profileImage = File(pickedImage.path);
      });
      await _uploadProfileImage();
    }
  }

  Future<void> _uploadProfileImage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && _profileImage != null) {
      final storageRef =
          FirebaseStorage.instance.ref().child('tagentpicture/${user.uid}');
      final uploadTask = storageRef.putFile(_profileImage!);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('travelagents')
          .doc(user.uid)
          .update({'tagentprofile': downloadUrl});
      setState(() {
        _downloadUrl = downloadUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$_username Profile'),
        centerTitle: true,
        backgroundColor: MyColors.myColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TravelAgentHomePage(),
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
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: _downloadUrl != null
                      ? Image.network(
                          _downloadUrl!,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.person, size: 50),
                        ),
                ),
              ),
              Center(
                child: IconButton(
                    onPressed: () async {
                      await _pickImage();
                    },
                    icon: Icon(Icons.camera)),
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
