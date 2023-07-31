import 'package:easytour/admin_panel/admin_page.dart';
import 'package:easytour/configuration/color.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransferPage extends StatefulWidget {
  @override
  _TransferPageState createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController uidController = TextEditingController();
  final CollectionReference sourceCollection =
      FirebaseFirestore.instance.collection('customers');
  final CollectionReference destinationCollection =
      FirebaseFirestore.instance.collection('travelagents');

  void transferCollections() async {
    if (_formKey.currentState!.validate()) {
      String uid = uidController.text;
      QuerySnapshot snapshot =
          await sourceCollection.where('uid', isEqualTo: uid).get();

      if (snapshot.docs.isNotEmpty) {
        WriteBatch batch = FirebaseFirestore.instance.batch();
        snapshot.docs.forEach((doc) {
          batch.set(destinationCollection.doc(doc.id), doc.data());
          batch.delete(sourceCollection.doc(doc.id));
        });

        try {
          await batch.commit();
          print('Collections transferred successfully!');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminPage()),
          );
        } catch (error) {
          print('Error transferring collections: $error');
        }
      } else {
        print('No collections found for the provided UID.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transfer Collections'),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    height: 300,
                  ),
                  Text(
                    'Transfer The Customers To Travel Agents',
                    style: TextStyle(color: MyColors.myColor),
                  ),
                  SizedBox(height: 10.0),
                  MyTextField(
                    controller: uidController,
                    label: 'UID',
                    hint: 'Enter the User Uid ',
                    icon: Icons.track_changes,
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(MyColors.myColor),
                    ),
                    onPressed: transferCollections,
                    child: Text('Approve'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
