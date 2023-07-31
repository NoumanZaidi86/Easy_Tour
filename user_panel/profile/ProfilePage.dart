import 'dart:io';

import 'package:easytour/authentication/login.dart';
import 'package:easytour/configuration/color.dart';
import 'package:easytour/homepage.dart';

import 'package:easytour/user_panel/profile/About_us_page.dart';
import 'package:easytour/user_panel/profile/EasyCare_page.dart';
import 'package:easytour/user_panel/profile/Terms&condition.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _username = '';
  String _email = '';
  String _phone = '';
  String _cnic = '';
  File? _profileImage;
  String? _downloadUrl;

  @override
  void initState() {
    super.initState();
    _loaduserdata();
  }

  Future<void> _loaduserdata() async {
    final user = FirebaseAuth.instance.currentUser;
    final doc = await FirebaseFirestore.instance
        .collection('customers')
        .doc(user?.uid)
        .get();
    setState(() {
      _username = doc.get('name');
      _email = doc.get('email');
      _phone = doc.get('phone');
      _cnic = doc.get('cnic');
      final profileImage = doc.get('userprofile');
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
          FirebaseStorage.instance.ref().child('userpicture/${user.uid}');
      final uploadTask = storageRef.putFile(_profileImage!);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('customers')
          .doc(user.uid)
          .update({'userprofile': downloadUrl});
      setState(() {
        _downloadUrl = downloadUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        backgroundColor: MyColors.myColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 15,
            ),

            Container(
              margin: EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Column(children: [
                Container(
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
                IconButton(
                    onPressed: () async {
                      await _pickImage();
                    },
                    icon: Icon(Icons.camera)),
                SizedBox(height: 8),
                MyProfileTextField(
                  controller: TextEditingController(text: _username),
                  readOnly: true,
                  icon: Icons.person,
                  maxLines: 1,
                ),
                SizedBox(height: 8),
                MyProfileTextField(
                  controller: TextEditingController(text: _email),
                  readOnly: true,
                  icon: Icons.email,
                  maxLines: 1,
                ),
                SizedBox(height: 8),
                MyProfileTextField(
                  controller: TextEditingController(text: _phone),
                  readOnly: true,
                  icon: Icons.phone_android_outlined,
                  maxLines: 1,
                ),
                SizedBox(height: 8),
                MyProfileTextField(
                  controller: TextEditingController(text: _cnic),
                  readOnly: true,
                  icon: Icons.credit_card,
                  maxLines: 1,
                ),
              ]),
            ),
            SizedBox(height: 5),

            Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => WeCarePage(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(
                            20), // Set the border radius value
                      ),
                      height: 80,
                      width: 180,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 15,
                                ),
                                Icon(
                                  Icons.favorite_outline,
                                  color: MyColors.myColor,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 15,
                                ),
                                Text('Easy Care')
                              ],
                            ),
                          ]),
                    )),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => TermsAndConditionsPage(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(
                            20), // Set the border radius value
                      ),
                      height: 80,
                      width: 180,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 15,
                                ),
                                Icon(
                                  Icons.description,
                                  color: Colors.greenAccent,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 15,
                                ),
                                Text('Terms&Conditions')
                              ],
                            ),
                          ]),
                    )),
              ],
            ),
//for line 2
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => AboutUsPage(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(
                            20), // Set the border radius value
                      ),
                      height: 80,
                      width: 180,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 15,
                                ),
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.deepPurple,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 15,
                                ),
                                Text('About Us')
                              ],
                            ),
                          ]),
                    )),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                    onTap: (() {
                      launch('tel:03456475591');
                    }),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(
                            20), // Set the border radius value
                      ),
                      height: 80,
                      width: 180,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 15,
                                ),
                                Icon(
                                  Icons.phone_android,
                                  color: Colors.indigoAccent,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 15,
                                ),
                                Text('Contact Us')
                              ],
                            ),
                          ]),
                    )),
              ],
            ),
            //for line 3
            SizedBox(
              height: 10,
            ),

            Center(
              child: GestureDetector(
                  onTap: () {
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
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(
                          20), // Set the border radius value
                    ),
                    height: 80,
                    width: 180,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.logout, color: Colors.red),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text('Logout')],
                          ),
                        ]),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
