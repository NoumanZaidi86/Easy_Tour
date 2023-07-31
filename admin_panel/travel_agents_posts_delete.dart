import 'package:easytour/admin_panel/admin_page.dart';
import 'package:easytour/configuration/color.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TravelPost {
  final String place;
  final String price;
  final String image;
  final String description;
  final String userId;
  final DocumentReference reference;

  TravelPost({
    required this.place,
    required this.price,
    required this.image,
    required this.description,
    required this.reference,
    required this.userId,
  });
}

class agentposts extends StatefulWidget {
  @override
  _agentpostsState createState() => _agentpostsState();
}

class _agentpostsState extends State<agentposts> {
  late Stream<List<TravelPost>> _travelPostsStream;

  @override
  void initState() {
    super.initState();
    _travelPostsStream = _fetchTravelPosts();
  }

  Stream<List<TravelPost>> _fetchTravelPosts() {
    return FirebaseFirestore.instance
        .collection('travelposts')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final place = data['place'] ?? '';
        final price = data['price'] ?? '';
        final description = data['description'] ?? '';
        final image = data['image'] ?? '';
        final userId = data['userId'] is String ? data['userId'] : '';

        return TravelPost(
          place: place,
          price: price,
          description: description,
          image: image,
          reference: doc.reference,
          userId: userId,
        );
      }).toList();
    });
  }

  Future<void> _confirmDelete(
      BuildContext context, DocumentReference reference) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) {
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
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm deletion
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel deletion
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await reference.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.myColor,
        title: Text('TravelAgents Posts'),
        leading: BackButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdminPage()),
            );
          },
        ),
      ),
      body: StreamBuilder<List<TravelPost>>(
        stream: _travelPostsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final travelPosts = snapshot.data!;

          if (travelPosts.isEmpty) {
            return Center(
              child: Text(
                'No travel posts available.',
                style: TextStyle(color: MyColors.myColor),
              ),
            );
          }

          return ListView.builder(
            itemCount: travelPosts.length,
            itemBuilder: (context, index) {
              final post = travelPosts[index];

              return Container(
                margin:
                    EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(16.0),
                child: ListTile(
                  title: Text(
                    post.place,
                    style: TextStyle(color: MyColors.myColor),
                  ),
                  subtitle: Text(
                    post.price,
                    style: TextStyle(color: MyColors.myColor),
                  ),
                  leading: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(post.image),
                      ),
                    ),
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      _confirmDelete(context, post.reference);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            'Description',
                            style: TextStyle(color: MyColors.myColor),
                          ),
                          content: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                MyTextField(
                                  icon: Icons.person,
                                  label: 'Travel agent id',
                                  hint: '',
                                  controller:
                                      TextEditingController(text: post.userId),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                MyTextField(
                                  maxLines: 20,
                                  icon: Icons.description,
                                  label: 'Description',
                                  hint: '',
                                  controller: TextEditingController(
                                      text: post.description),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
