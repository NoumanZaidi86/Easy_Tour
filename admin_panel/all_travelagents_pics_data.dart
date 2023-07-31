import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easytour/admin_panel/admin_page.dart';
import 'package:easytour/configuration/color.dart';

class alltravelagentspicsdata extends StatefulWidget {
  @override
  _alltravelagentspicsdataState createState() =>
      _alltravelagentspicsdataState();
}

class _alltravelagentspicsdataState extends State<alltravelagentspicsdata> {
  final CollectionReference requestsCollection =
      FirebaseFirestore.instance.collection('alltravelagentsdata');
  final TextEditingController searchController = TextEditingController();
  String searchUid = '';

  void performSearch() {
    setState(() {
      searchUid = searchController.text.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Travel Agents Data'),
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
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: TextStyle(
                      color: MyColors.myColor,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Search',
                      labelStyle: TextStyle(
                        color: MyColors
                            .myColor, // Set the desired label text color
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: MyColors.myColor,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: MyColors.myColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(
                          color: MyColors.myColor,
                        ),
                      ),
                    ),
                    controller: searchController,
                    onChanged: (value) {
                      setState(() {
                        searchUid = value.trim();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ImageData>>(
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
                              controller:
                                  TextEditingController(text: imageData.uid),
                            ),
                            SizedBox(height: 8.0),
                            GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
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
                            SizedBox(
                              height: 10,
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
          ),
        ],
      ),
    );
  }

  Future<List<ImageData>> getImageData() async {
    final snapshot = await requestsCollection.get();
    final imageDataList = <ImageData>[];

    for (final doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final uid = data['uid']; // Use the 'uid' field from the document data
      final List<dynamic>? imageUrls = data['imageUrls'];

      if (imageUrls != null && (searchUid.isEmpty || uid.contains(searchUid))) {
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
