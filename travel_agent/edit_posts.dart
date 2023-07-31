import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easytour/travel_agent/TravelAgentHomePage.dart';
import 'package:easytour/configuration/color.dart';
import 'package:intl/intl.dart';

class TravelPostPage extends StatefulWidget {
  @override
  _TravelPostPageState createState() => _TravelPostPageState();
}

class _TravelPostPageState extends State<TravelPostPage> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> deletePost(String postId) async {
    try {
      await FirebaseFirestore.instance
          .collection('travelposts')
          .doc(postId)
          .delete();
    } catch (e) {
      print('Error deleting post: $e');
      // Display an error message or handle the error as needed
    }
  }

  Future<void> editDescription(String postId, String currentDescription) async {
    _descriptionController.text = currentDescription;
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Edit Description',
            style: TextStyle(color: MyColors.myColor),
          ),
          content: Form(
            key: _formKey,
            child: MyTextField(
              controller: _descriptionController,
              validator: MyTextField.wordCountValidator,
              maxLines: 20,
              label: "Edit Description",
              hint: '',
              icon: Icons.description,
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Save',
                style: TextStyle(color: MyColors.myColor),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  String newDescription = _descriptionController.text;
                  saveDescription(postId, newDescription);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> saveDescription(String postId, String newDescription) async {
    try {
      await FirebaseFirestore.instance
          .collection('travelposts')
          .doc(postId)
          .update({'description': newDescription});
    } catch (e) {
      print('Error updating description: $e');
      // Display an error message or handle the error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.myColor,
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => TravelAgentHomePage(),
              ),
            );
          },
        ),
        title: Text('Your Travel Posts'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('travelposts')
            .where('userId', isEqualTo: currentUser?.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Text('No travel posts found.');
          }

          return ListView(
            padding: EdgeInsets.all(16.0),
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              String postId = document.id;
              String description = data['description'];
              Timestamp departureTimestamp = data['departureDate'];
              Timestamp arrivalTimestamp = data['arrivalDate'];
              DateTime departureDate = departureTimestamp.toDate();
              DateTime arrivalDate = arrivalTimestamp.toDate();

              // Format the dates
              final DateFormat formatter = DateFormat('dd MMM yyyy');
              final formattedDepartureDate = formatter.format(departureDate);
              final formattedArrivalDate = formatter.format(arrivalDate);

              return Container(
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Departure: $formattedDepartureDate',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' -Arrival $formattedArrivalDate',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Image.network(data['image']),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  MyColors.myColor),
                            ),
                            onPressed: () {
                              editDescription(postId, description);
                            },
                            label: Text('Edit'),
                            icon: Icon(
                              Icons.edit,
                            ),
                          ),
                          ElevatedButton.icon(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.red),
                            ),
                            label: Text('Delete'),
                            icon: Icon(
                              Icons.delete,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Confirmation',
                                      style: TextStyle(color: MyColors.myColor),
                                    ),
                                    content: Text(
                                      'Are you sure you want to delete this post?',
                                      style: TextStyle(color: MyColors.myColor),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text(
                                          'Delete',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onPressed: () {
                                          deletePost(postId);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      MyTextField(
                        readOnly: true,
                        icon: Icons.money,
                        hint: '',
                        label: 'Price',
                        controller: TextEditingController(text: data['price']),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      MyTextField(
                        readOnly: true,
                        icon: Icons.place,
                        hint: '',
                        label: 'Place',
                        controller: TextEditingController(text: data['place']),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      MyTextField(
                        readOnly: true,
                        icon: Icons.description,
                        hint: '',
                        label: 'Description',
                        controller:
                            TextEditingController(text: data['description']),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
