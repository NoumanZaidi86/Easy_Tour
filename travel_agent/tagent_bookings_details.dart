import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easytour/configuration/color.dart';
import 'package:easytour/travel_agent/TravelAgentHomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TravelAgentBookingDetailsPage extends StatefulWidget {
  @override
  _TravelAgentBookingDetailsPageState createState() =>
      _TravelAgentBookingDetailsPageState();
}

class _TravelAgentBookingDetailsPageState
    extends State<TravelAgentBookingDetailsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user; // User object to store the logged-in user
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _bookings = [];

  @override
  void initState() {
    super.initState();
    // Check if a user is already logged in
    _user = _auth.currentUser;
    if (_user != null) {
      fetchBookings();
    }
  }

  Future<void> fetchBookings() async {
    final bookingsSnapshot = await FirebaseFirestore.instance
        .collection('booking details')
        .where('tid', isEqualTo: _user!.uid)
        .get();

    setState(() {
      _bookings = bookingsSnapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.myColor,
        title: Text('Booking Details'),
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => TravelAgentHomePage(),
              ),
            );
          },
        ),
      ),
      body: _user == null
          ? Center(
              child: Text('User not logged in'),
            )
          : _bookings.isEmpty
              ? Center(
                  child: Text('No bookings found'),
                )
              : ListView.builder(
                  itemCount: _bookings.length,
                  itemBuilder: (context, index) {
                    final booking = _bookings[index].data();
                    Timestamp bookingTimestamp = booking['bookingDate'];
                    DateTime bookingDate = bookingTimestamp.toDate();
                    Timestamp departureTimestamp = booking['Departure'];
                    DateTime departureDate = departureTimestamp.toDate();
                    return ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Card(
                            color: Colors.yellow.shade100,
                            elevation: 2.0,
                            margin: EdgeInsets.all(10.0),
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  SizedBox(height: 8),
                                  Text(
                                    ' ${bookingDate.toString()}',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    'Booking ID: ${_bookings[index].id}',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Username: ${booking['username']}',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Place: ${booking['place']}',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Departure:${DateFormat('yyyy-MM-dd').format(departureDate)}',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Email: ${booking['email']}',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Phone: ${booking['phone']}',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'CNIC: ${booking['cnic']}',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Total Members: ${booking['totalMembers']}',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Total Payment: ${booking['totalPayment']}',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
