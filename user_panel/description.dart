import 'package:easytour/authentication/login.dart';
import 'package:easytour/configuration/color.dart';
import 'package:easytour/homepage.dart';
import 'package:easytour/user_panel/heart_page.dart';
import 'package:easytour/user_panel/make_payment_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DescriptionPage extends StatefulWidget {
  final FavoriteTrip trip;

  DescriptionPage({required this.trip});

  @override
  _DescriptionPageState createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  bool isFavorite = false;

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });

    if (isFavorite) {
      FavoritePage.favoriteTrips.add(widget.trip);
    } else {
      FavoritePage.favoriteTrips.remove(widget.trip);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.myColor,
        title: Text('Description'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.trip.image != null)
                Image.network(
                  widget.trip.image!,
                  height: 150.0,
                  width: 400.0,
                  fit: BoxFit.fill,
                ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Name: ${widget.trip.place}',
                style: TextStyle(
                  color: MyColors.myColor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5.0),
              Text(
                'Price: ${widget.trip.price}',
                style: TextStyle(
                  color: MyColors.myColor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5.0),
              Text(
                'Description:',
                style: TextStyle(
                  color: MyColors.myColor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                maxLines: 21,
                readOnly: true,
                controller: TextEditingController(text: widget.trip.data),
                style: TextStyle(color: MyColors.myColor),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: MyColors.myOtherColor,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 5.0),
              Row(
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(MyColors.myColor),
                    ),
                    onPressed: () async {
                      User? user = FirebaseAuth.instance.currentUser;

                      if (user != null) {
                        // User is logged in, show booking dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            int members = 1;
                            int pricePerMember = int.parse(widget.trip.price);

                            int totalPrice = pricePerMember;

                            return StatefulBuilder(
                              builder: (context, setState) {
                                return AlertDialog(
                                  title: Text(
                                    'Book Tour',
                                    style: TextStyle(color: MyColors.myColor),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Members:',
                                            style: TextStyle(
                                                color: MyColors.myColor),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.remove),
                                                onPressed: () {
                                                  setState(() {
                                                    if (members > 1) members--;
                                                    totalPrice =
                                                        pricePerMember *
                                                            members;
                                                  });
                                                },
                                              ),
                                              Text(members.toString()),
                                              IconButton(
                                                icon: Icon(Icons.add),
                                                onPressed: () {
                                                  setState(() {
                                                    members++;
                                                    totalPrice =
                                                        pricePerMember *
                                                            members;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 16.0),
                                      Text(
                                        'Total Price: $totalPrice',
                                        style:
                                            TextStyle(color: MyColors.myColor),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PaymentPage(
                                              totalPayment: totalPrice,
                                              Members: members,
                                              tid: widget.trip.tid,
                                              place: widget.trip.place,
                                              date: widget.trip.departureDate,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'Confirm',
                                        style:
                                            TextStyle(color: MyColors.myColor),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      } else {
                        // User is not logged in, navigate to the login page
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                'Not Logged In',
                                style: TextStyle(
                                  color: MyColors.myColor,
                                ),
                              ),
                              content: Text(
                                'Please log in to proceed.',
                                style: TextStyle(
                                  color: MyColors.myColor,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    // Navigate the user to the login page
                                    // You can replace 'LoginPage' with the actual route to your login page
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => MyLogin()),
                                    );
                                  },
                                  child: Text(
                                    'Log In',
                                    style: TextStyle(
                                      color: MyColors.myColor,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Text('Book Tour'),
                  ),
                  SizedBox(
                    width: 70,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(MyColors.myColor),
                    ),
                    onPressed: toggleFavorite,
                    child: Text(isFavorite
                        ? 'Remove from Favorites'
                        : 'Add to Favorites'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
