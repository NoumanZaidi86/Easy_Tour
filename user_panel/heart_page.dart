import 'package:easytour/configuration/color.dart';
import 'package:easytour/homepage.dart';
import 'package:easytour/user_panel/description.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FavoritePage extends StatefulWidget {
  static List<FavoriteTrip> favoriteTrips = [];

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
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
      body: ListView.builder(
        itemCount: FavoritePage.favoriteTrips.length,
        itemBuilder: (context, index) {
          final trip = FavoritePage.favoriteTrips[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DescriptionPage(trip: trip),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (trip.image != null) SizedBox(height: 8.0),
                  Image.network(
                    trip.image!,
                    height: 200.0,
                    width: 400.0,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    'Price: ${trip.price}',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: MyColors.myColor,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    'Place: ${trip.place}',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: MyColors.myColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
