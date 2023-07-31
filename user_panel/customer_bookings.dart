import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easytour/configuration/color.dart';
import 'package:easytour/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:shared_preferences/shared_preferences.dart';

class BookingDetailsPage extends StatefulWidget {
  @override
  _BookingDetailsPageState createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  List<Map<String, dynamic>> _modifiedBookings = [];

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
      fetchRatings(); // Fetch ratings from shared preferences
    }
  }

  Future<void> fetchBookings() async {
    final bookingsSnapshot = await FirebaseFirestore.instance
        .collection('booking details')
        .where('uid', isEqualTo: _user!.uid)
        .get();

    setState(() {
      _bookings = bookingsSnapshot.docs;
      _modifiedBookings =
          List<Map<String, dynamic>>.from(_bookings.map((doc) => doc.data()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details'),
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
                    return Container(
                      margin: EdgeInsets.all(15),
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
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              ' ${bookingDate.toString()}',
                              style: TextStyle(fontSize: 10),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            MyTextField(
                              label: 'Booking ID',
                              hint: '',
                              icon: Icons.book_online,
                              controller: TextEditingController(
                                text: _bookings[index].id,
                              ),
                              readOnly: true,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            MyTextField(
                              label: 'Trip name',
                              hint: '',
                              icon: Icons.place,
                              controller: TextEditingController(
                                text: booking['place'].toString(),
                              ),
                              readOnly: true,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            MyTextField(
                              label: 'Username',
                              hint: '',
                              icon: Icons.person,
                              controller: TextEditingController(
                                text: booking['username'].toString(),
                              ),
                              readOnly: true,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            MyTextField(
                              label: 'TravelAgent Id',
                              hint: '',
                              icon: Icons.book_online_outlined,
                              controller: TextEditingController(
                                text: booking['tid'].toString(),
                              ),
                              readOnly: true,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            MyTextField(
                              label: 'Customer Id',
                              hint: '',
                              icon: Icons.book_online,
                              controller: TextEditingController(
                                text: booking['uid'].toString(),
                              ),
                              readOnly: true,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            MyTextField(
                              hint: '',
                              icon: Icons.email,
                              label: 'Email',
                              controller: TextEditingController(
                                text: booking['email'].toString(),
                              ),
                              readOnly: true,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            MyTextField(
                              label: 'Phone',
                              hint: '',
                              icon: Icons.phone,
                              controller: TextEditingController(
                                text: booking['phone'].toString(),
                              ),
                              readOnly: true,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            MyTextField(
                              label: 'CNIC',
                              hint: '',
                              icon: Icons.credit_card,
                              controller: TextEditingController(
                                text: booking['cnic'].toString(),
                              ),
                              readOnly: true,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            MyTextField(
                              label: 'Total Members',
                              hint: '',
                              icon: Icons.person,
                              controller: TextEditingController(
                                text: booking['totalMembers'].toString(),
                              ),
                              readOnly: true,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            MyTextField(
                              label: 'Total Payment',
                              hint: '',
                              icon: Icons.money,
                              controller: TextEditingController(
                                text: booking['totalPayment'].toString(),
                              ),
                              readOnly: true,
                            ),
                            SizedBox(
                              height: 10,
                            ),

                            RatingBar.builder(
                              initialRating: double.tryParse(
                                      _modifiedBookings[index]['rating'] ??
                                          '') ??
                                  0,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 25.0,
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) async {
                                final bookingId = _bookings[index].id;
                                final travelAgentId = _bookings[index]['tid'];

                                // Check if the customer has already rated the travel agent
                                final customerRating = await getCustomerRating(
                                    bookingId, travelAgentId);

                                if (customerRating != null) {
                                  // Update the existing rating
                                  updateRatingInFirestore(
                                      customerRating.id, rating);
                                } else {
                                  // Save a new rating
                                  saveRatingToFirestore(
                                      bookingId, travelAgentId, rating);
                                }

                                setState(() {
                                  _modifiedBookings[index]['rating'] =
                                      rating.toString();
                                });
                              },
                            ),

                            Text(
                              _modifiedBookings[index]['rating'] != null
                                  ? _modifiedBookings[index]['rating']
                                      .toString()
                                  : '',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),

                            // Add more fields as needed
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Future<QueryDocumentSnapshot<Map<String, dynamic>>?> getCustomerRating(
    String bookingId,
    String travelAgentId,
  ) async {
    final ratingsSnapshot = await FirebaseFirestore.instance
        .collection('ratings')
        .where('bookingId', isEqualTo: bookingId)
        .where('travelAgentId', isEqualTo: travelAgentId)
        .get();

    if (ratingsSnapshot.docs.isNotEmpty) {
      return ratingsSnapshot.docs.first;
    } else {
      return null;
    }
  }

  Future<void> updateRatingInFirestore(String ratingId, double rating) async {
    try {
      final ratingRef =
          FirebaseFirestore.instance.collection('ratings').doc(ratingId);
      await ratingRef.update({'rating': rating.toString()});
    } catch (e) {
      print('Error updating rating: $e');
    }
  }

  Future<void> saveRatingToFirestore(
    String bookingId,
    String travelAgentId,
    double rating,
  ) async {
    try {
      final ratingsRef = FirebaseFirestore.instance.collection('ratings');
      final ratingData = {
        'bookingId': bookingId,
        'travelAgentId': travelAgentId,
        'rating': rating.toString(),
      };
      final newRatingDoc = await ratingsRef.add(ratingData);

      // Save the rating to shared preferences
      await saveRatingToLocalDatabase(bookingId, rating);
    } catch (e) {
      print('Error saving rating: $e');
    }
  }

  Future<void> saveRatingToLocalDatabase(
      String bookingId, double rating) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble(bookingId, rating);
  }

  Future<void> fetchRatings() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _modifiedBookings.forEach((booking) {
        final bookingId = booking['bookingId'];
        final rating = prefs.getString(bookingId);
        booking['rating'] = rating;
      });
    });
  }
}
