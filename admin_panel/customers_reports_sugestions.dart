import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easytour/admin_panel/admin_page.dart';
import 'package:easytour/configuration/color.dart';
import 'package:flutter/material.dart';

class ReportsPage extends StatefulWidget {
  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  List<Map<String, dynamic>> reportList = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromFirestore();
  }

  void fetchDataFromFirestore() async {
    // Fetch data from Firestore
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('wecare').get();

    List<Map<String, dynamic>> reports = [];

    // Process each document in the snapshot
    for (DocumentSnapshot document in snapshot.docs) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;

      reports.add(data);
    }

    // Update the reportList with the retrieved data
    setState(() {
      reportList = reports;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.myColor,
        title: Text('We Care'),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Suggestions And Reports',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: MyColors.myColor,
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 12,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: reportList.length,
                itemBuilder: (context, index) {
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
                      title: Column(
                        children: [
                          SizedBox(height: 12),
                          MyTextField(
                            controller: TextEditingController(
                              text: reportList[index]['email'],
                            ),
                            label: 'Email',
                            hint: '',
                            icon: Icons.email,
                          ),
                          SizedBox(height: 12),
                          MyTextField(
                            controller: TextEditingController(
                              text: reportList[index]['suggestion'],
                            ),
                            hint: '',
                            label: 'Suggestion / Report',
                            icon: Icons.report,
                          ),
                          SizedBox(height: 5),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
