/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easytour/configuration/color.dart';
import 'package:flutter/material.dart';

class AdminBookingDetailsPage extends StatefulWidget {
  @override
  _AdminBookingDetailsPageState createState() =>
      _AdminBookingDetailsPageState();
}

class _AdminBookingDetailsPageState extends State<AdminBookingDetailsPage> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _bookings = [];

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    final bookingsSnapshot =
        await FirebaseFirestore.instance.collection('booking details').get();

    setState(() {
      _bookings = bookingsSnapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Booking Details'),
      ),
      body: _bookings.isEmpty
          ? Center(
              child: Text('No bookings found'),
            )
          : ListView.builder(
              itemCount: _bookings.length,
              itemBuilder: (context, index) {
                final booking = _bookings[index].data();
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
                        // Add more fields as needed
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easytour/admin_panel/admin_page.dart';
import 'package:easytour/configuration/color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminBookingDetailsPage extends StatefulWidget {
  @override
  _AdminBookingDetailsPageState createState() =>
      _AdminBookingDetailsPageState();
}

class _AdminBookingDetailsPageState extends State<AdminBookingDetailsPage> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _bookings = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _filteredBookings = [];

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    final bookingsSnapshot =
        await FirebaseFirestore.instance.collection('booking details').get();

    setState(() {
      _bookings = bookingsSnapshot.docs;
      _filteredBookings =
          _bookings; // Initialize filtered bookings with all bookings
    });
  }

  void filterBookings(String bookingId) {
    setState(() {
      _filteredBookings = _bookings
          .where((booking) =>
              booking.id.toLowerCase().contains(bookingId.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' Booking Details'),
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
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: filterBookings,
              style: TextStyle(
                color: MyColors.myColor,
              ),
              decoration: InputDecoration(
                labelText: 'Search',
                labelStyle: TextStyle(
                  color: MyColors.myColor, // Set the desired label text color
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
            ),
          ),
          Expanded(
            child: _filteredBookings.isEmpty
                ? Center(
                    child: Text('No bookings found'),
                  )
                : ListView.builder(
                    itemCount: _filteredBookings.length,
                    itemBuilder: (context, index) {
                      final booking = _filteredBookings[index].data();
                      Timestamp bookingTimestamp = booking['bookingDate'];
                      DateTime bookingDate = bookingTimestamp.toDate();
                      Timestamp departureTimestamp = booking['Departure'];
                      DateTime departureDate = departureTimestamp.toDate();

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
                                height: 10,
                              ),
                              Text(
                                'Departure:${DateFormat('yyyy-MM-dd').format(departureDate)}',
                                style: TextStyle(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              MyTextField(
                                label: 'Booking ID',
                                hint: '',
                                icon: Icons.book_online,
                                controller: TextEditingController(
                                  text: _filteredBookings[index].id,
                                ),
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
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              // Add more fields as needed
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
