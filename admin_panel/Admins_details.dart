import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easytour/admin_panel/admin_page.dart';
import 'package:easytour/configuration/update_firestoredata.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import '../configuration/color.dart';

class admindetails extends StatefulWidget {
  @override
  _admindetailsState createState() => _admindetailsState();
}

class _admindetailsState extends State<admindetails> {
  final cnicController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  String name = "name loading...";
  String email = "email loading...";
  String searchQuery = '';
  List<DocumentSnapshot> filteredCustomers = [];

  void getData() async {
    User? user = await FirebaseAuth.instance.currentUser;
    var vari = await FirebaseFirestore.instance
        .collection("admins")
        .doc(user?.uid)
        .get();

    setState(() {
      name = vari.data()!['name'];
      email = vari.data()!['email'];
    });
  }

  CollectionReference ref = FirebaseFirestore.instance.collection("admins");

  @override
  void initState() {
    getData();
    super.initState();
  }

  void searchCustomers(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
    });

    if (query.isNotEmpty) {
      FirebaseFirestore.instance
          .collection("admins")
          .where('email', isGreaterThanOrEqualTo: query.toLowerCase())
          .get()
          .then((snapshot) {
        setState(() {
          filteredCustomers = snapshot.docs;
        });
      }).catchError((error) {
        print("Failed to search admin: $error");
      });
    } else {
      setState(() {
        filteredCustomers = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Admins Data "),
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
            padding: EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                searchCustomers(value);
              },
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
            child: StreamBuilder<QuerySnapshot>(
              stream: searchQuery.isEmpty
                  ? FirebaseFirestore.instance.collection("admins").snapshots()
                  : null,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                List<DocumentSnapshot> customers = snapshot.data!.docs;

                if (searchQuery.isNotEmpty) {
                  customers = filteredCustomers;
                }

                return ListView.builder(
                  itemCount: customers.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot data = customers[index];

                    return Container(
                      margin: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: MyColors.myColor),
                        boxShadow: [
                          BoxShadow(
                            color: MyColors.myColor.withOpacity(0.5),
                            spreadRadius: 4,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.supervised_user_circle,
                          size: 30,
                          color: MyColors.myColor,
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 8,
                            ),
                            MyTextField(
                              controller:
                                  TextEditingController(text: data['name']),
                              hint: '',
                              icon: Icons.person,
                              label: 'Name',
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            MyTextField(
                              controller:
                                  TextEditingController(text: data['cnic']),
                              hint: '',
                              icon: Icons.credit_card,
                              label: 'Cnic',
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            MyTextField(
                              controller:
                                  TextEditingController(text: data['email']),
                              hint: '',
                              icon: Icons.email_outlined,
                              label: 'Email',
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            MyTextField(
                              controller:
                                  TextEditingController(text: data['phone']),
                              hint: '',
                              icon: Icons.phone_android,
                              label: 'Phone',
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            MyTextField(
                              controller:
                                  TextEditingController(text: data['uid']),
                              hint: '',
                              icon: Icons.vpn_key,
                              label: 'Uid',
                            ),
                            SizedBox(height: 10),
                            ElevatedButton.icon(
                              icon: Icon(Icons.save),
                              label: Text('Edit'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: MyColors.myColor,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return UpdateCustomerDialog(
                                      cnicController: cnicController,
                                      nameController: nameController,
                                      phoneController: phoneController,
                                      data: data,
                                      ref: ref,
                                    );
                                  },
                                );
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
          ),
        ],
      ),
    );
  }
}

TextStyle myTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 15,
  fontWeight: FontWeight.bold,
);
