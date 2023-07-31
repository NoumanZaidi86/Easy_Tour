/*import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easytour/configuration/color.dart';
import 'package:easytour/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RequestPage extends StatefulWidget {
  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  File? frontSideImage;
  File? backSideImage;
  File? nocImage;
  File? tagentImage;

  Future<void> selectImage(ImageSource source, Function(File) setImage) async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: source);

    if (pickedImage != null) {
      setState(() {
        setImage(File(pickedImage.path));
      });
    }
  }

  Future<List<String>> uploadImagesToFirebase() async {
    List<String> downloadURLs = [];

    if (frontSideImage != null) {
      final storage = FirebaseStorage.instance;
      final frontSideReference =
          storage.ref().child('requestpics/${DateTime.now()}_front.png');
      final frontSideUploadTask = frontSideReference.putFile(frontSideImage!);
      final frontSideSnapshot = await frontSideUploadTask.whenComplete(() {});

      if (frontSideSnapshot.state == TaskState.success) {
        final frontSideDownloadURL =
            await frontSideSnapshot.ref.getDownloadURL();
        downloadURLs.add(frontSideDownloadURL);
      }
    }

    if (backSideImage != null) {
      final storage = FirebaseStorage.instance;
      final backSideReference =
          storage.ref().child('requestpics/${DateTime.now()}_back.png');
      final backSideUploadTask = backSideReference.putFile(backSideImage!);
      final backSideSnapshot = await backSideUploadTask.whenComplete(() {});

      if (backSideSnapshot.state == TaskState.success) {
        final backSideDownloadURL = await backSideSnapshot.ref.getDownloadURL();
        downloadURLs.add(backSideDownloadURL);
      }
    }

    if (nocImage != null) {
      final storage = FirebaseStorage.instance;
      final nocReference =
          storage.ref().child('requestpics/${DateTime.now()}_noc.png');
      final nocUploadTask = nocReference.putFile(nocImage!);
      final nocSnapshot = await nocUploadTask.whenComplete(() {});

      if (nocSnapshot.state == TaskState.success) {
        final nocDownloadURL = await nocSnapshot.ref.getDownloadURL();
        downloadURLs.add(nocDownloadURL);
      }
    }

    if (tagentImage != null) {
      final storage = FirebaseStorage.instance;
      final tagentReference =
          storage.ref().child('requestpics/${DateTime.now()}_tagent.png');
      final tagentUploadTask = tagentReference.putFile(tagentImage!);
      final tagentSnapshot = await tagentUploadTask.whenComplete(() {});

      if (tagentSnapshot.state == TaskState.success) {
        final tagentDownloadURL = await tagentSnapshot.ref.getDownloadURL();
        downloadURLs.add(tagentDownloadURL);
      }
    }

    return downloadURLs;
  }

/*
  Future<void> handleSendRequest() async {
    if (frontSideImage == null ||
        backSideImage == null ||
        nocImage == null ||
        tagentImage == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Error',
              style: TextStyle(color: Colors.red),
            ),
            content: Text(
              'Please select all the images.',
              style: TextStyle(color: MyColors.myColor),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return UploadProgressDialog(
            uploadTask: uploadImagesToFirebase(),
            onSavePost: savePost,
          );
        },
      );
    }
  }*/
  void handleSendRequest() async {
    if (frontSideImage == null ||
        backSideImage == null ||
        nocImage == null ||
        tagentImage == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Error',
              style: TextStyle(color: Colors.red),
            ),
            content: Text(
              'Please select all the images.',
              style: TextStyle(color: MyColors.myColor),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return UploadProgressDialog(
            uploadTask: uploadImagesToFirebase(),
            onSavePost: savePost,
          );
        },
      ).then((_) {
        Future.delayed(Duration(milliseconds: 100), () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false,
          );
        });
      });
    }
  }

  /*void savePost(List<String> imageUrls) async {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;
    FirebaseFirestore.instance.collection('travelrequests').add({
      'uid': userId,
      'imageUrls': imageUrls,
    });
  }*/
  void savePost(List<String> imageUrls) async {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;

    // Save to 'travelrequests' collection
    FirebaseFirestore.instance.collection('travelrequests').add({
      'uid': userId,
      'imageUrls': imageUrls,
    });

    // Save to 'alltravelagentsdata' collection
    FirebaseFirestore.instance.collection('alltravelagentsdata').add({
      'uid': userId,
      'imageUrls': imageUrls,
    });
  }

  Widget buildSelectedImage(File? image) {
    return image != null
        ? Image.file(
            image,
            height: 100,
            width: 200,
          )
        : SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Request'),
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
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(MyColors.myColor),
                ),
                onPressed: () => selectImage(
                  ImageSource.camera,
                  (image) => frontSideImage = image,
                ),
                child: Text('Upload Front Side of CNIC'),
              ),
              SizedBox(height: 8.0),
              buildSelectedImage(frontSideImage), // Display selected image

              SizedBox(height: 8.0),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(MyColors.myColor),
                ),
                onPressed: () => selectImage(
                  ImageSource.camera,
                  (image) => backSideImage = image,
                ),
                child: Text('Upload Back Side of CNIC'),
              ),
              SizedBox(height: 8.0),
              buildSelectedImage(backSideImage),
              SizedBox(height: 8.0),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(MyColors.myColor),
                ),
                onPressed: () => selectImage(
                  ImageSource.camera,
                  (image) => nocImage = image,
                ),
                child: Text('Upload NOC Picture'),
              ),
              SizedBox(height: 8.0),
              buildSelectedImage(nocImage),
              SizedBox(height: 8.0),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(MyColors.myColor),
                ),
                onPressed: () => selectImage(
                  ImageSource.camera,
                  (image) => tagentImage = image,
                ),
                child: Text('Upload Travel Agent Picture'),
              ),
              SizedBox(height: 8.0),
              buildSelectedImage(tagentImage),
              SizedBox(height: 16.0),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(MyColors.myColor),
                ),
                onPressed: handleSendRequest,
                child: Text('Submit Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UploadProgressDialog extends StatelessWidget {
  final Future<List<String>> uploadTask;
  final Function(List<String>) onSavePost; // Callback function

  const UploadProgressDialog({
    required this.uploadTask,
    required this.onSavePost,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Uploading',
        style: TextStyle(
          color: MyColors.myColor,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: FutureBuilder<List<String>>(
        future: uploadTask,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16.0),
                Text(
                  'Uploading images...',
                  style: TextStyle(color: MyColors.myColor),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            // Save the post to Firestore with the image URLs
            onSavePost(snapshot.data!);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );

            return Text(
              'Upload completed!',
              style: TextStyle(color: MyColors.myColor),
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}*/
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easytour/configuration/color.dart';
import 'package:easytour/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RequestPage extends StatefulWidget {
  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  File? frontSideImage;
  File? backSideImage;
  File? nocImage;
  File? tagentImage;

  Future<void> selectImage(ImageSource source, Function(File) setImage) async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: source);

    if (pickedImage != null) {
      setState(() {
        setImage(File(pickedImage.path));
      });
    }
  }

  Future<List<String>> uploadImagesToFirebase() async {
    List<String> downloadURLs = [];

    if (frontSideImage != null) {
      final storage = FirebaseStorage.instance;
      final frontSideReference =
          storage.ref().child('requestpics/${DateTime.now()}_front.png');
      final frontSideUploadTask = frontSideReference.putFile(frontSideImage!);
      final frontSideSnapshot = await frontSideUploadTask;

      if (frontSideSnapshot.state == TaskState.success) {
        final frontSideDownloadURL =
            await frontSideSnapshot.ref.getDownloadURL();
        downloadURLs.add(frontSideDownloadURL);
      }
    }

    if (backSideImage != null) {
      final storage = FirebaseStorage.instance;
      final backSideReference =
          storage.ref().child('requestpics/${DateTime.now()}_back.png');
      final backSideUploadTask = backSideReference.putFile(backSideImage!);
      final backSideSnapshot = await backSideUploadTask;

      if (backSideSnapshot.state == TaskState.success) {
        final backSideDownloadURL = await backSideSnapshot.ref.getDownloadURL();
        downloadURLs.add(backSideDownloadURL);
      }
    }

    if (nocImage != null) {
      final storage = FirebaseStorage.instance;
      final nocReference =
          storage.ref().child('requestpics/${DateTime.now()}_noc.png');
      final nocUploadTask = nocReference.putFile(nocImage!);
      final nocSnapshot = await nocUploadTask;

      if (nocSnapshot.state == TaskState.success) {
        final nocDownloadURL = await nocSnapshot.ref.getDownloadURL();
        downloadURLs.add(nocDownloadURL);
      }
    }

    if (tagentImage != null) {
      final storage = FirebaseStorage.instance;
      final tagentReference =
          storage.ref().child('requestpics/${DateTime.now()}_tagent.png');
      final tagentUploadTask = tagentReference.putFile(tagentImage!);
      final tagentSnapshot = await tagentUploadTask;

      if (tagentSnapshot.state == TaskState.success) {
        final tagentDownloadURL = await tagentSnapshot.ref.getDownloadURL();
        downloadURLs.add(tagentDownloadURL);
      }
    }

    return downloadURLs;
  }

  Future<void> handleSendRequest() async {
    if (frontSideImage == null ||
        backSideImage == null ||
        nocImage == null ||
        tagentImage == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Error',
              style: TextStyle(color: Colors.red),
            ),
            content: Text(
              'Please select all the images.',
              style: TextStyle(color: MyColors.myColor),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return UploadProgressDialog(
            uploadTask: uploadImagesToFirebase(),
            onSavePost: savePost,
          );
        },
      );
    }
  }

  void savePost(List<String> imageUrls) async {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;

    // Save to 'travelrequests' collection
    await FirebaseFirestore.instance.collection('travelrequests').add({
      'uid': userId,
      'imageUrls': imageUrls,
    });

    // Save to 'alltravelagentsdata' collection
    await FirebaseFirestore.instance.collection('alltravelagentsdata').add({
      'uid': userId,
      'imageUrls': imageUrls,
    });

    // Navigate back to the home page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
  }

  Widget buildSelectedImage(File? image) {
    return image != null
        ? Image.file(
            image,
            height: 100,
            width: 200,
          )
        : SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Request'),
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
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(MyColors.myColor),
                ),
                onPressed: () => selectImage(
                  ImageSource.camera,
                  (image) => frontSideImage = image,
                ),
                child: Text('Upload Front Side of CNIC'),
              ),
              SizedBox(height: 8.0),
              buildSelectedImage(frontSideImage), // Display selected image

              SizedBox(height: 8.0),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(MyColors.myColor),
                ),
                onPressed: () => selectImage(
                  ImageSource.camera,
                  (image) => backSideImage = image,
                ),
                child: Text('Upload Back Side of CNIC'),
              ),
              SizedBox(height: 8.0),
              buildSelectedImage(backSideImage),
              SizedBox(height: 8.0),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(MyColors.myColor),
                ),
                onPressed: () => selectImage(
                  ImageSource.camera,
                  (image) => nocImage = image,
                ),
                child: Text('Upload NOC Picture'),
              ),
              SizedBox(height: 8.0),
              buildSelectedImage(nocImage),
              SizedBox(height: 8.0),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(MyColors.myColor),
                ),
                onPressed: () => selectImage(
                  ImageSource.camera,
                  (image) => tagentImage = image,
                ),
                child: Text('Upload Travel Agent Picture'),
              ),
              SizedBox(height: 8.0),
              buildSelectedImage(tagentImage),
              SizedBox(height: 16.0),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(MyColors.myColor),
                ),
                onPressed: handleSendRequest,
                child: Text('Submit Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UploadProgressDialog extends StatelessWidget {
  final Future<List<String>> uploadTask;
  final Function(List<String>) onSavePost; // Callback function

  const UploadProgressDialog({
    required this.uploadTask,
    required this.onSavePost,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Uploading',
        style: TextStyle(
          color: MyColors.myColor,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: FutureBuilder<List<String>>(
        future: uploadTask,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16.0),
                Text(
                  'Uploading images...',
                  style: TextStyle(color: MyColors.myColor),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            // Save the post to Firestore with the image URLs
            onSavePost(snapshot.data!);
            return Text(
              'Upload completed!',
              style: TextStyle(color: MyColors.myColor),
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}
