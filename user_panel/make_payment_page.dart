import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easytour/configuration/color.dart';
import 'package:easytour/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentPage extends StatefulWidget {
  final int totalPayment;
  final int Members;
  final String tid;
  final String place;
  final DateTime date;

  PaymentPage(
      {required this.totalPayment,
      required this.Members,
      required this.tid,
      required this.place,
      required this.date});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _username = '';
  String _email = '';
  String _phone = '';
  String _cnic = '';

  @override
  void initState() {
    // Check if a user is already logged in
    _user = _auth.currentUser;
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    final doc = await FirebaseFirestore.instance
        .collection('customers')
        .doc(user?.uid)
        .get();
    setState(() {
      _username = doc.get('name');
      _email = doc.get('email');
      _phone = doc.get('phone');
      _cnic = doc.get('cnic');
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user; // User object to store the logged-in user

  // Function to retrieve the user's UID
  String getUid() {
    if (_user != null) {
      return _user!.uid;
    } else {
      return 'Not logged in';
    }
  }

  void saveBookingDetails() {
    DateTime currentDate = DateTime.now();
    // Create a new document in the "booking details" collection
    FirebaseFirestore.instance.collection('booking details').add({
      'username': _username,
      'email': _email,
      'phone': _phone,
      'cnic': _cnic,
      'uid': getUid(),
      'tid': widget.tid,
      'place': widget.place,
      'totalMembers': widget.Members,
      'totalPayment': widget.totalPayment,
      'bookingDate': currentDate,
      'Departure': widget.date,
    }).then((value) {
      // Data successfully saved in Firestore
      print('Booking details saved!');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    }).catchError((error) {
      // An error occurred while saving data
      print('Error saving booking details: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        backgroundColor: MyColors.myColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                color: Colors.yellow.shade100,
                elevation: 2.0,
                margin: EdgeInsets.all(10.0),
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Review',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Username: $_username',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Email: $_email',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Phone: $_phone',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'CNIC: $_cnic',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      /*Text(
                        'User ID: ${getUid()}',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tid ${widget.tid}',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),*/
                      Text(
                        'Departure: ${DateFormat('yyyy-MM-dd').format(widget.date)}',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Place Name is ${widget.place}',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Your Total Members is ${widget.Members}',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Your Total Payment is ${widget.totalPayment}',
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
          SizedBox(height: 8),
          Center(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(MyColors.myColor),
              ),
              onPressed: saveBookingDetails,
              child: Text('Physical Payment'),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select a payment method',
                  style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: MyColors.myColor),
                ),
                SizedBox(height: 16.0),
                PaymentCard(
                  icon: Icons.credit_card,
                  title: 'Credit Card',
                  subtitle: 'Add a credit card for payment',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => CreditCardDialog(),
                    );
                  },
                ),
                SizedBox(height: 16.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onPressed;

  PaymentCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: Offset(0, 2),
              blurRadius: 4.0,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 32.0,
              color: MyColors.myColor,
            ),
            SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: MyColors.myColor),
                ),
                SizedBox(height: 4.0),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 16.0, color: MyColors.myColor),
                ),
              ],
            ),
            Spacer(),
            Icon(
              Icons.chevron_right,
              color: MyColors.myColor,
            ),
          ],
        ),
      ),
    );
  }
}

class CreditCardDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Enter Credit Card Details',
        style: TextStyle(fontWeight: FontWeight.bold, color: MyColors.myColor),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Card Number',
              labelStyle: TextStyle(color: MyColors.myColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Expiry Date',
                    labelStyle: TextStyle(color: MyColors.myColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'CVV',
                    labelStyle: TextStyle(color: MyColors.myColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(MyColors.myColor),
          ),
          onPressed: () {},
          child: Text(
            'Purchase',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
