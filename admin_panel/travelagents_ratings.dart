import 'package:easytour/admin_panel/admin_page.dart';
import 'package:easytour/configuration/color.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RatingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Travel Agent Ratings'),
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('ratings').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text(
              'Error: ${snapshot.error}',
              style: TextStyle(color: Colors.red),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          final ratingsDocs = snapshot.data!.docs;
          if (ratingsDocs.isEmpty) {
            return Text(
              'No Ratings',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            );
          }

          // Calculate average rating for each unique travel agent ID
          Map<String, List<double>> ratingsMap = {};

          for (var ratingDoc in ratingsDocs) {
            final travelAgentId = ratingDoc['travelAgentId'];
            final ratingStr = ratingDoc['rating'];
            final rating = double.tryParse(ratingStr) ?? 0.0;

            if (ratingsMap.containsKey(travelAgentId)) {
              ratingsMap[travelAgentId]!.add(rating);
            } else {
              ratingsMap[travelAgentId] = [rating];
            }
          }

          return ListView.builder(
            itemCount: ratingsMap.length,
            itemBuilder: (BuildContext context, int index) {
              final travelAgentId = ratingsMap.keys.elementAt(index);
              final ratingsList = ratingsMap[travelAgentId]!;
              final numberOfRatings = ratingsList.length;
              final totalRating = ratingsList.reduce((a, b) => a + b);
              final averageRating = totalRating / numberOfRatings;

              return ListTile(
                title: Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: MyColors.myColor),
                    boxShadow: [
                      BoxShadow(
                        color: MyColors.myColor.withOpacity(0.5),
                        spreadRadius: 4,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        MyTextField(
                          controller:
                              TextEditingController(text: travelAgentId),
                          hint: '',
                          label: 'Travel Agent Id',
                          icon: Icons.travel_explore,
                        ),
                        Text('Number of Ratings: $numberOfRatings'),
                        Row(
                          children: List.generate(5, (index) {
                            if (index < averageRating.floor()) {
                              return Icon(
                                Icons.star,
                                color: Colors.yellow,
                              );
                            } else if (index < averageRating) {
                              return Icon(
                                Icons.star_half,
                                color: Colors.yellow,
                              );
                            } else {
                              return Icon(
                                Icons.star_border,
                                color: Colors.yellow,
                              );
                            }
                          }),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Average Rating: ${averageRating.toStringAsFixed(1)}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
