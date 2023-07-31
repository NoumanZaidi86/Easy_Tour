import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easytour/configuration/color.dart';
import 'package:easytour/configuration/logout_button.dart';
import 'package:easytour/user_panel/customer_bookings.dart';
import 'package:easytour/user_panel/request.dart';

import 'package:easytour/user_panel/description.dart';
import 'package:easytour/user_panel/heart_page.dart';
import 'package:easytour/user_panel/image_slider.dart';

import 'package:easytour/user_panel/profile/ProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _searchController;
  Set<String> availablePlaces = {};
  Set<String> selectedPlaces = {};

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    fetchAvailablePlaces();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchAvailablePlaces() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('travelposts').get();

    final List<String> places = [];
    snapshot.docs.forEach((doc) {
      final data = doc.data() as Map<String, dynamic>;

      final place = data['place'] as String?;

      if (place != null && place.isNotEmpty) {
        places.add(place);
      }
    });

    setState(() {
      availablePlaces = places.toSet();
    });
  }

  void searchPlaces() {
    setState(() {});
  }

  bool isPlaceSelected(String place) {
    return selectedPlaces.contains(place.toLowerCase());
  }

  void togglePlaceSelection(String place) {
    setState(() {
      if (isPlaceSelected(place)) {
        selectedPlaces.remove(place.toLowerCase());
      } else {
        selectedPlaces.add(place.toLowerCase());
      }
    });
  }

  void showSelectedPlacesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Selected Places',
            style: TextStyle(color: MyColors.myColor),
          ),
          content: SingleChildScrollView(
            child: DataTable(
              columns: [
                DataColumn(
                    label: Text(
                  'Place',
                  style: TextStyle(color: MyColors.myColor),
                )),
              ],
              rows: selectedPlaces.map((place) {
                return DataRow(cells: [
                  DataCell(Text(
                    place,
                    style: TextStyle(color: MyColors.myColor),
                  )),
                ]);
              }).toList(),
            ),
          ),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(MyColors.myColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentDate = DateTime.now();
    DateTime dateTime = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
    print(formattedDate);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        backgroundColor: MyColors.myColor,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: MyColors.myColor,
              ),
              child: Center(
                child: Text(
                  'Home',
                  style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontSize: 50,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.book_online,
                color: MyColors.myColor,
              ),
              title: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.myColor,
                ),
                child: Text('Booking Details'),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => BookingDetailsPage(),
                    ),
                  );
                },
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.favorite,
                color: MyColors.myColor,
              ),
              title: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.myColor,
                ),
                child: Text('Favourite'),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => FavoritePage(),
                    ),
                  );
                },
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.person,
                color: MyColors.myColor,
              ),
              title: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.myColor,
                ),
                child: Text('Profile'),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(),
                    ),
                  );
                },
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.handshake,
                color: MyColors.myColor,
              ),
              title: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.myColor,
                ),
                child: Text('Request for travel agent'),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => RequestPage(),
                    ),
                  );
                },
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: MyColors.myColor,
              ),
              title: logoutbutton(),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: ImageSlider(),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Explore The Beauty Of Pakistan',
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: MyColors.myColor),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 8,
                right: 8,
                top: 8,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (_) => searchPlaces(),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: MyColors.myColor,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color: MyColors.myOtherColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color: MyColors.myOtherColor,
                          ),
                        ),
                        hintText: 'Search here',
                        hintStyle: TextStyle(
                          color: MyColors.myColor,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.filter_list,
                      color: MyColors.myColor,
                      size: 35,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter setState) {
                              return AlertDialog(
                                title: Text(
                                  'Filter Places',
                                  style: TextStyle(color: MyColors.myColor),
                                ),
                                content: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: ListView.builder(
                                    itemCount: availablePlaces.length,
                                    itemBuilder: (context, index) {
                                      final place =
                                          availablePlaces.elementAt(index);
                                      final isSelected = isPlaceSelected(place);
                                      return ListTile(
                                        title: Text(place),
                                        trailing: Checkbox(
                                          value: isSelected,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              togglePlaceSelection(place);
                                            });
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              MyColors.myColor),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      showSelectedPlacesDialog();
                                      searchPlaces();
                                    },
                                    child: Text('Done'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('travelposts')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(color: Colors.red),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final List<Map<String, dynamic>> filteredTrips = [];
                snapshot.data!.docs.forEach((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  String place = data['place'] ?? '';

                  if (selectedPlaces.isEmpty ||
                      selectedPlaces.contains(place.toLowerCase())) {
                    if (_searchController.text.isEmpty ||
                        place
                            .toLowerCase()
                            .contains(_searchController.text.toLowerCase())) {
                      filteredTrips.add(data);
                    }
                  }
                });

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: filteredTrips.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> data = filteredTrips[index];

                    FavoriteTrip trip = FavoriteTrip(
                      data: data['description'] ?? '',
                      price: data['price'].toString(),
                      place: data['place'].toString(),
                      image: data['image'] ?? '',
                      tid: data['userId'].toString(),
                      departureDate:
                          (data['departureDate'] as Timestamp).toDate(),
                      arrivalDate: (data['arrivalDate'] as Timestamp).toDate(),
                    );

                    return GestureDetector(
                      onTap: () {
                        if (trip.departureDate.isBefore(DateTime.now())) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  'No Bookings Available',
                                  style: TextStyle(
                                    color: MyColors.myColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: Text(
                                  'There are no bookings available for this date.',
                                  style: TextStyle(
                                    color: MyColors.myColor,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DescriptionPage(trip: trip),
                            ),
                          );
                        }
                        /* Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DescriptionPage(trip: trip),
                          ),
                        );*/
                      },
                      child: Container(
                        margin:
                            EdgeInsets.only(bottom: 10, left: 10, right: 10),
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
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  ' ${trip.formattedDepartureDate}',
                                  style: TextStyle(
                                    color: MyColors.myColor,
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  '- ${trip.formattedArrivalDate}',
                                  style: TextStyle(
                                    color: MyColors.myColor,
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.0),
                            if (trip.image != null)
                              Image.network(
                                trip.image!,
                                height: 150,
                                width: 400,
                                fit: BoxFit.fill,
                              ),
                            SizedBox(height: 8.0),
                            Text(
                              'Price: ${trip.price}',
                              style: TextStyle(
                                color: MyColors.myColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Place: ${trip.place}',
                              style: TextStyle(
                                color: MyColors.myColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('ratings')
                                  .where('travelAgentId', isEqualTo: trip.tid)
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot>
                                      ratingsSnapshot) {
                                if (ratingsSnapshot.hasError) {
                                  return Text(
                                    'Error: ${ratingsSnapshot.error}',
                                    style: TextStyle(color: Colors.red),
                                  );
                                }

                                if (ratingsSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                }

                                int numberOfRatings =
                                    ratingsSnapshot.data!.docs.length;
                                double totalRating = 0;

                                if (numberOfRatings > 0) {
                                  for (var doc in ratingsSnapshot.data!.docs) {
                                    String ratingStr = doc['rating'];
                                    double rating =
                                        double.tryParse(ratingStr) ?? 0.0;
                                    totalRating += rating;
                                  }
                                  // Calculate average rating
                                  double averageRating =
                                      totalRating / numberOfRatings;

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Number of Ratings: $numberOfRatings',
                                        style: TextStyle(
                                          color: MyColors.myColor,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Row(
                                        children: List.generate(5, (index) {
                                          if (index < averageRating.floor()) {
                                            return Icon(
                                              Icons.star,
                                              color: Colors.yellow,
                                            );
                                          } else if (index < averageRating) {
                                            return Icon(
                                              Icons.star_half,
                                              color: Colors.yellow,
                                            );
                                          } else {
                                            return Icon(
                                              Icons.star_border,
                                              color: Colors.yellow,
                                            );
                                          }
                                        }),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        'Average Rating: ${averageRating.toStringAsFixed(1)}',
                                        style: TextStyle(
                                          color: MyColors.myColor,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Text(
                                    'No Ratings',
                                    style: TextStyle(
                                      color: MyColors.myColor,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FavoriteTrip {
  final String data;
  final String price;
  final String place;
  final String? image;
  final String tid;
  final DateTime departureDate;
  final DateTime arrivalDate;

  FavoriteTrip({
    required this.data,
    required this.price,
    required this.place,
    this.image,
    required this.tid,
    required this.departureDate,
    required this.arrivalDate,
  });

  String get formattedDepartureDate {
    return DateFormat('yyyy-MM-dd').format(departureDate);
  }

  String get formattedArrivalDate {
    return DateFormat('yyyy-MM-dd').format(arrivalDate);
  }
}
