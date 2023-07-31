import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easytour/admin_panel/admin_bookings_details.dart';

import 'package:easytour/admin_panel/admin_profile.dart';
import 'package:easytour/admin_panel/all_travelagents_pics_data.dart';
import 'package:easytour/admin_panel/approved.dart';
import 'package:easytour/admin_panel/customers_reports_sugestions.dart';

import 'package:easytour/admin_panel/make_a_admin.dart';
import 'package:easytour/admin_panel/make_a_travelagent.dart';
import 'package:easytour/admin_panel/travel_agents_details.dart';
import 'package:easytour/admin_panel/travel_agents_posts_delete.dart';
import 'package:easytour/admin_panel/travelagents_ratings.dart';

import 'package:easytour/admin_panel/user_details.dart';
import 'package:easytour/admin_panel/accept.dart';
import 'package:easytour/authentication/login.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import '../configuration/color.dart';
import 'Admins_details.dart';

class AdminPage extends StatefulWidget {
  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Admin Panel'),
        backgroundColor: MyColors.myColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  margin: EdgeInsets.all(10),
                  height: 180,
                  decoration: BoxDecoration(
                    color: MyColors.myColor,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => admindetails()));
                          },
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              color: MyColors.myOtherColor,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.person,
                                    color: MyColors.myColor, size: 50),
                                SizedBox(height: 10),
                                Text(
                                  'All Admins',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: MyColors.myColor,
                                  ),
                                ),
                                SizedBox(height: 5),
                                FutureBuilder<int>(
                                  future: getadminsCount(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      if (snapshot.hasError) {
                                        return Text("Error: ${snapshot.error}");
                                      } else {
                                        return Text(
                                          " ${snapshot.data}",
                                          style: TextStyle(
                                              color: MyColors.myColor,
                                              fontSize: 25),
                                        );
                                      }
                                    } else {
                                      return CircularProgressIndicator();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => travelagentstails()));
                          },
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.person,
                                    color: MyColors.myColor, size: 50),
                                SizedBox(height: 10),
                                Text(
                                  ' Travel Agents',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: MyColors.myColor),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                FutureBuilder<int>(
                                  future: getTravelAgentsCount(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      if (snapshot.hasError) {
                                        return Text("Error: ${snapshot.error}");
                                      } else {
                                        return Text(
                                          " ${snapshot.data}",
                                          style: TextStyle(
                                              color: MyColors.myColor,
                                              fontSize: 25),
                                        );
                                      }
                                    } else {
                                      return CircularProgressIndicator();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => customerdetails()));
                          },
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.person,
                                    color: MyColors.myColor, size: 50),
                                SizedBox(height: 10),
                                Text(
                                  'All Customers',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: MyColors.myColor),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                FutureBuilder<int>(
                                  future: getCustomersCount(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      if (snapshot.hasError) {
                                        return Text("Error: ${snapshot.error}");
                                      } else {
                                        return Text(
                                          " ${snapshot.data}",
                                          style: TextStyle(
                                              color: MyColors.myColor,
                                              fontSize: 25),
                                        );
                                      }
                                    } else {
                                      return CircularProgressIndicator();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 180,
                          width: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(2),
                color: Colors.white,
                child: Column(children: [
                  Container(
                    margin: EdgeInsets.all(7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureContainer(
                          text: 'Add Travel Agent',
                          icon: Icons.add,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MakeTravelAgent()),
                            );
                          },
                        ),
                        GestureContainer(
                          text: 'Add Admin',
                          icon: Icons.add,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Makeadmin()),
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
                          text: 'Booking Details',
                          icon: Icons.book_online,
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => AdminBookingDetailsPage(),
                              ),
                            );
                          },
                        ),
                        GestureContainer(
                          text: 'Travel Agents Pics',
                          icon: Icons.picture_in_picture,
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => alltravelagentspicsdata(),
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
                        /*
                        GestureContainer(
                          text: 'Chat Box',
                          icon: Icons.chat_bubble,
                          onTap: () {},
                        ),*/
                        GestureContainer(
                          text: 'Admin Profile',
                          icon: Icons.person,
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => AdminProfilePage(),
                              ),
                            );
                          },
                        ),
                        GestureContainer(
                          text: 'Agents Requests',
                          icon: Icons.request_page,
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => ApprovedRequests(),
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
                          text: 'Agents Posts',
                          icon: Icons.newspaper,
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => agentposts(),
                              ),
                            );
                          },
                        ),
                        GestureContainer(
                          text: 'Reports',
                          icon: Icons.report_sharp,
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => ReportsPage(),
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
                          text: 'Transfer',
                          icon: Icons.transfer_within_a_station,
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => TransferPage(),
                              ),
                            );
                          },
                        ),
                        GestureContainer(
                          text: 'All Agents Ratings',
                          icon: Icons.stars,
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => RatingsPage(),
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
            ],
          ),
        ),
      ),
    );
  }
}

//for all users details how many users are there in firestore
Future<int> getCustomersCount() async {
  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('customers').get();
  return snapshot.size;
}

Future<int> getTravelAgentsCount() async {
  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('travelagents').get();
  return snapshot.size;
}

Future<int> getadminsCount() async {
  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('admins').get();
  return snapshot.size;
}

class GestureContainer extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const GestureContainer({
    Key? key,
    required this.text,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: MyColors.myColor,
          borderRadius: BorderRadius.circular(20),
        ),
        height: 70,
        width: 180,
        child: Column(
          children: [
            SizedBox(height: 8),
            Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 8),
            Icon(
              icon,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
