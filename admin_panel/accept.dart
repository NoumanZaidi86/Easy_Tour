/*
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:easytour/admin_panel/admin_page.dart';
import 'package:easytour/configuration/color.dart';

class FirestorePage extends StatelessWidget {
  final TextEditingController uidController = TextEditingController();
  final CollectionReference sourceCollection =
      FirebaseFirestore.instance.collection('customers');
  final CollectionReference destinationCollection =
      FirebaseFirestore.instance.collection('travelagents');

  Future<void> processCollections(BuildContext context, String uid) async {
    QuerySnapshot snapshot =
        await sourceCollection.where('uid', isEqualTo: uid).get();

    if (snapshot.docs.isNotEmpty) {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      snapshot.docs.forEach((doc) {
        batch.set(destinationCollection.doc(doc.id), doc.data());
        batch.delete(sourceCollection.doc(doc.id));
      });

      try {
        await batch.commit();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Collections transferred successfully!')),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error transferring collections: $error')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No collections found for the provided UID.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Gallery'),
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
      body: FutureBuilder<List<ImageData>>(
        future: getImageData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final imageDataList = snapshot.data!;
            return ListView.builder(
              itemCount: imageDataList.length,
              itemBuilder: (context, index) {
                final imageData = imageDataList[index];
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'UID',
                        ),
                        controller: TextEditingController(text: imageData.uid),
                      ),
                      TextField(
                        controller: uidController,
                        decoration: InputDecoration(
                          labelText: 'UID',
                        ),
                      ),
                      SizedBox(height: 8.0),
                      GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: imageData.imageUrls.length,
                        itemBuilder: (context, index) {
                          final imageUrl = imageData.imageUrls[index];
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage(imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () =>
                            processCollections(context, uidController.text),
                        child: Text('Approve and Transfer'),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text('No data found.'),
            );
          }
        },
      ),
    );
  }

  Future<List<ImageData>> getImageData() async {
    final storage = FirebaseStorage.instance;
    final collectionRef =
        FirebaseFirestore.instance.collection('travelrequests');
    final snapshot = await collectionRef.get();
    final imageDataList = <ImageData>[];

    for (final doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final uid = data['uid']; // Use the 'uid' field from the document data
      final List<dynamic>? imageUrls = data['imageUrls'];

      if (imageUrls != null) {
        imageDataList
            .add(ImageData(uid: uid, imageUrls: List<String>.from(imageUrls)));
      }
    }

    return imageDataList;
  }
}

class ImageData {
  final String uid;
  final List<String> imageUrls;

  ImageData({required this.uid, required this.imageUrls});
}
*/
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:easytour/admin_panel/admin_page.dart';
import 'package:easytour/configuration/color.dart';

class ApprovedRequests extends StatelessWidget {
  final TextEditingController uidController = TextEditingController();
  final CollectionReference sourceCollection =
      FirebaseFirestore.instance.collection('customers');
  final CollectionReference destinationCollection =
      FirebaseFirestore.instance.collection('travelagents');
  final CollectionReference requestsCollection =
      FirebaseFirestore.instance.collection('travelrequests');

  Future<void> processCollections(BuildContext context, String uid) async {
    QuerySnapshot snapshot =
        await sourceCollection.where('uid', isEqualTo: uid).get();

    if (snapshot.docs.isNotEmpty) {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      snapshot.docs.forEach((doc) {
        batch.set(destinationCollection.doc(doc.id), doc.data());
        batch.delete(sourceCollection.doc(doc.id));
      });

      try {
        await batch.commit();

        // Delete the request from the travel requests collection
        await requestsCollection.doc(uid).delete();
        await snapshot.docs.first.reference.delete();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Collections transferred successfully!')),
        );

        // Navigate to the AdminPage
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdminPage()),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error transferring collections: $error')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No collections found for the provided UID.')),
      );
    }
  }

  Future<void> rejectRequest(BuildContext context, String uid) async {
    try {
      QuerySnapshot snapshot =
          await requestsCollection.where('uid', isEqualTo: uid).get();
      if (snapshot.docs.isNotEmpty) {
        // Delete the request document from the travel requests collection
        await snapshot.docs.first.reference.delete();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Request rejected and deleted successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No request found with the provided UID.')),
        );
      }
      // Navigate to the AdminPage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdminPage()),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error rejecting request: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Approved Requests'),
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
      body: FutureBuilder<List<ImageData>>(
        future: getImageData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final imageDataList = snapshot.data!;
            return ListView.builder(
              itemCount: imageDataList.length,
              itemBuilder: (context, index) {
                final imageData = imageDataList[index];
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      MyTextField(
                        icon: Icons.track_changes,
                        label: 'UID',
                        hint: '',
                        controller: TextEditingController(text: imageData.uid),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      MyTextField(
                        controller: uidController,
                        label: 'UID',
                        hint: '',
                        icon: Icons.track_changes_outlined,
                      ),
                      SizedBox(height: 8.0),
                      GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: imageData.imageUrls.length,
                        itemBuilder: (context, index) {
                          final imageUrl = imageData.imageUrls[index];
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage(imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  MyColors.myColor),
                            ),
                            onPressed: () =>
                                processCollections(context, uidController.text),
                            child: Text('Approved'),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.red),
                            ),
                            onPressed: () =>
                                rejectRequest(context, uidController.text),
                            child: Text('Reject'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text('No data found.'),
            );
          }
        },
      ),
    );
  }

  Future<List<ImageData>> getImageData() async {
    final storage = FirebaseStorage.instance;
    final collectionRef =
        FirebaseFirestore.instance.collection('travelrequests');
    final snapshot = await collectionRef.get();
    final imageDataList = <ImageData>[];

    for (final doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final uid = data['uid']; // Use the 'uid' field from the document data
      final List<dynamic>? imageUrls = data['imageUrls'];

      if (imageUrls != null) {
        imageDataList
            .add(ImageData(uid: uid, imageUrls: List<String>.from(imageUrls)));
      }
    }

    return imageDataList;
  }
}

class ImageData {
  final String uid;
  final List<String> imageUrls;

  ImageData({required this.uid, required this.imageUrls});
}
