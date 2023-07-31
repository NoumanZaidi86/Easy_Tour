import 'package:easytour/configuration/color.dart';
import 'package:easytour/user_panel/profile/ProfilePage.dart';
import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
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
        title: Text('Terms and Conditions'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              Text(
                'Terms and Conditions',
                style: TextStyle(
                  color: MyColors.myColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'By using the Easy Tour app, you agree to the following terms and conditions:',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '1. Content Usage:',
                style: TextStyle(
                  color: MyColors.myColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'The Easy Tour app provides information about various travel destinations, attractions, and accommodations. This information is for personal use and reference only. You must not use the content for commercial purposes without obtaining permission from Easy Tour.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '2. Booking and Payments:',
                style: TextStyle(
                  color: MyColors.myColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'When booking tours or accommodations through the Easy Tour app, you agree to the terms and conditions set by the respective service providers. Easy Tour acts as an intermediary and is not responsible for any issues arising from bookings, including cancellations, refunds, or changes in itinerary. Payments made through the app are securely processed, and any disputes regarding payments should be resolved directly with the service provider.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '3. User Responsibilities:',
                style: TextStyle(
                  color: MyColors.myColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'As a user of the Easy Tour app, you are responsible for providing accurate information during registration and booking processes. You should also adhere to the rules and regulations of the travel destinations,  health and safety guidelines, and local customs. Easy Tour is not liable for any consequences resulting from your failure to comply with these responsibilities.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '4. App Usage and Privacy:',
                style: TextStyle(
                  color: MyColors.myColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Easy Tour collects and processes personal data as described in the Privacy Policy. By using the app, you consent to the collection, storage, and use of your information in accordance with the Privacy Policy.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Please read the complete Terms and Conditions and Privacy Policy on our website for detailed information.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
