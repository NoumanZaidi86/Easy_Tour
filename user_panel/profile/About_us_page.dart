import 'package:easytour/configuration/color.dart';
import 'package:easytour/user_panel/profile/ProfilePage.dart';
import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => ProfilePage(),
              ),
            );
          },
        ),
        backgroundColor: MyColors.myColor,
        title: Text('About Us'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            Text(
              'Welcome to Easy Tour!',
              style: TextStyle(
                color: MyColors.myColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'About Easy Tour:',
              style: TextStyle(
                color: MyColors.myColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Easy Tour is a comprehensive tourism app that aims to make your travel experience smooth, enjoyable, and hassle-free. Whether you are a seasoned traveler or a first-time explorer, Easy Tour is here to assist you at every step of your journey.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Features:',
              style: TextStyle(
                color: MyColors.myColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '1. Explore Destinations: Discover amazing travel destinations around the world and get detailed information about attractions, landmarks, accommodations, and more.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '2. Plan Your Itinerary: Create personalized itineraries for your trips, including activities, sightseeing, and dining options. Save and share your plans with friends and family.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '3. Book Tours and Accommodations: Find the best deals on tours and accommodations directly through our app. Enjoy a seamless booking experience.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '4. Travel Recommendations: Get personalized recommendations based on your preferences and interests. Discover hidden gems and popular tourist spots.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '5. Travel Guides and Tips: Access travel guides, safety tips, local customs, and essential information for your chosen destination.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
