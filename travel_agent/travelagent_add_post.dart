import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easytour/configuration/color.dart';
import 'package:easytour/travel_agent/TravelAgentHomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:flutter/material.dart';

class AddPostPage extends StatefulWidget {
  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final TextEditingController priceController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? selectedImage;
  DateTime? selectedDate;
  DateTime? arrivalDate;

  Future<void> selectImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<String> uploadImageToFirebase() async {
    if (selectedImage == null) return '';

    final storage = FirebaseStorage.instance;
    final reference = storage.ref().child('profileimage/${DateTime.now()}.png');
    final uploadTask = reference.putFile(selectedImage!);
    final snapshot = await uploadTask.whenComplete(() {});

    if (snapshot.state == TaskState.success) {
      final downloadURL = await snapshot.ref.getDownloadURL();
      return downloadURL;
    }

    return '';
  }

  void savePost() async {
    if (selectedImage == null || selectedDate == null || arrivalDate == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Validation Error',
              style: TextStyle(
                color: MyColors.myColor,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Please select an image, departure date, and arrival date.',
              style: TextStyle(
                color: MyColors.myColor,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
      return;
    }
    // Check if an image is selected

    final imageUrl = await uploadImageToFirebase();
    // Get the current user's UID
    final String? userId = FirebaseAuth.instance.currentUser?.uid;
    FirebaseFirestore.instance.collection('travelposts').add({
      'userId': userId,
      'price': priceController.text,
      'place': placeController.text,
      'description': descriptionController.text,
      'image': imageUrl,
      'departureDate': selectedDate,
      'arrivalDate': arrivalDate,
    });
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: MyColors.myColor, // Change the primary color
            accentColor: MyColors.myColor, // Change the accent color
            colorScheme: ColorScheme.light(
              primary: MyColors.myColor, // Change the primary color
              onPrimary:
                  Colors.white, // Change the text color on the primary color
            ),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> selectArrivalDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: MyColors.myColor, // Change the primary color
            accentColor: MyColors.myColor, // Change the accent color
            colorScheme: ColorScheme.light(
              primary: MyColors.myColor, // Change the primary color
              onPrimary:
                  Colors.white, // Change the text color on the primary color
            ),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != arrivalDate) {
      setState(() {
        arrivalDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => TravelAgentHomePage(),
              ),
            );
          },
        ),
        title: Text('Create Post'),
        backgroundColor: MyColors.myColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyTextField(
                  controller: placeController,
                  icon: Icons.place,
                  label: 'Place',
                  hint: 'Place',
                ),
                SizedBox(
                  height: 10,
                ),
                MyTextField(
                  validator: MyTextField.numericValidator,
                  controller: priceController,
                  icon: Icons.money,
                  label: 'Price',
                  hint: 'price',
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '   Write pickup point in a description',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                MyTextField(
                  validator: MyTextField.wordCountValidator,
                  maxLines: 15,
                  controller: descriptionController,
                  icon: Icons.description,
                  label: 'Description',
                  hint: 'Description',
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(MyColors.myColor),
                  ),
                  onPressed: selectImage,
                  child: Text('Upload Image'),
                ),
                SizedBox(height: 10.0),
                selectedImage != null
                    ? Image.file(
                        selectedImage!,
                        height: 200.0,
                      )
                    : SizedBox(),
                SizedBox(height: 5.0),
                TextButton(
                  onPressed: () =>
                      selectDate(context), // Call selectDate function
                  child: Text(
                    ' Departure Date',
                    style: TextStyle(fontSize: 16, color: MyColors.myColor),
                  ),
                ),
                selectedDate != null
                    ? Text(
                        'Departure Date: ${selectedDate!.toString().substring(0, 10)}', // Display selected departure date
                        style: TextStyle(fontSize: 16, color: MyColors.myColor),
                      )
                    : SizedBox(),
                TextButton(
                  onPressed: () =>
                      selectArrivalDate(context), // Call selectDate function
                  child: Text(
                    ' Arrival Date',
                    style: TextStyle(fontSize: 16, color: MyColors.myColor),
                  ),
                ),
                SizedBox(height: 5.0),
                arrivalDate != null
                    ? Text(
                        'Arrival Date: ${arrivalDate!.toString().substring(0, 10)}', // Display selected arrival date
                        style: TextStyle(fontSize: 16, color: MyColors.myColor),
                      )
                    : SizedBox(),
                SizedBox(height: 5.0),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(MyColors.myColor),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (selectedImage == null ||
                          selectedDate == null ||
                          arrivalDate == null) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                'Validation Error',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: Text(
                                'Please select an image, departure date, and arrival date.',
                                style: TextStyle(
                                  color: MyColors.myColor,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                'Confirmation',
                                style: TextStyle(
                                  color: MyColors.myColor,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: Text(
                                'Are you sure you want to post?',
                                style: TextStyle(
                                  color: MyColors.myColor,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                ),
                                TextButton(
                                  child: Text(
                                    'Post',
                                    style: TextStyle(
                                      color: MyColors.myColor,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () {
                                    savePost();
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TravelAgentHomePage(),
                                      ),
                                    ); // Close the dialog
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                  },
                  child: Text('Save Post'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
