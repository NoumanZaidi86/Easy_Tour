import 'package:easytour/admin_panel/admin_page.dart';
import 'package:easytour/authentication/login.dart';
import 'package:easytour/configuration/color.dart';
import 'package:easytour/travel_agent/edit_posts.dart';
import 'package:easytour/travel_agent/tagent_bookings_details.dart';
import 'package:easytour/travel_agent/terms_and_conditions_travelagents.dart';

import 'package:easytour/travel_agent/travelagent_add_post.dart';
import 'package:easytour/travel_agent/travelagent_profile.dart';
import 'package:easytour/travel_agent/we_care_travelagents.dart';
import 'package:easytour/user_panel/profile/About_us_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../configuration/logout_button.dart';

class TravelAgentHomePage extends StatefulWidget {
  const TravelAgentHomePage({Key? key}) : super(key: key);

  @override
  _TravelAgentHomePageState createState() => _TravelAgentHomePageState();
}

class _TravelAgentHomePageState extends State<TravelAgentHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Home',
          style: TextStyle(fontSize: 25),
        ),
        backgroundColor: MyColors.myColor,
      ),
      body: Container(
        child: Column(children: [
          Container(
            margin: EdgeInsets.all(7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureContainer(
                  text: 'Add trip',
                  icon: Icons.add,
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => AddPostPage(),
                      ),
                    );
                  },
                ),
                GestureContainer(
                  text: 'Booking Details',
                  icon: Icons.book_online,
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => TravelAgentBookingDetailsPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureContainer(
                  text: 'Profile',
                  icon: Icons.person,
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => TravelagentProfilePage(),
                      ),
                    );
                  },
                ),
                GestureContainer(
                  text: 'Edit Posts',
                  icon: Icons.edit,
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => TravelPostPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureContainer(
                  text: 'Contact Us',
                  icon: Icons.contact_phone,
                  onTap: () {
                    launch('tel:03456475591');
                  },
                ),
                GestureContainer(
                  text: 'About Us',
                  icon: Icons.book_online,
                  onTap: () {
                    /*Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => AboutUsPage(),
                      ),
                    );*/
                  },
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureContainer(
                  text: 'Easy Care',
                  icon: Icons.report,
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => TagentWeCarePage(),
                      ),
                    );
                  },
                ),
                GestureContainer(
                  text: 'Terms and Conditions',
                  icon: Icons.book_online,
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => AgentTermsAndConditionsPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          GestureContainer(
            text: 'Logout',
            icon: Icons.logout,
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      "LogOut",
                      style: TextStyle(
                        color: MyColors.myColor,
                      ),
                    ),
                    content: Text("Are you sure you want to Logout"),
                    actions: [
                      TextButton(
                        child: Text("Cancel"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text(
                          "LogOut",
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () async {
                          // Handle delete action
                          await FirebaseAuth.instance.signOut();
                          // navigate to login page
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => MyLogin(),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ]),
      ),
    );
  }
}
