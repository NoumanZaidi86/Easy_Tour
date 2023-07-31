import 'package:easytour/authentication/signup.dart';
import 'package:easytour/configuration/color.dart';
import 'package:flutter/material.dart';

class HowToSendTravelRequest extends StatelessWidget {
  const HowToSendTravelRequest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.myColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyRegister(),
              ),
            );
          },
        ),
        centerTitle: true,
        title: const Text('Send Travel Agent Request'),
      ),
      body: Container(
        margin: EdgeInsets.all(13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                child: Image.asset('images/loginscreen.jpeg'),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Please Follow these steps: ',
              style: TextStyle(
                  color: MyColors.myColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Step : 1',
              style: TextStyle(
                  color: MyColors.myColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Please Sigup First ',
              style: TextStyle(color: MyColors.myColor, fontSize: 18),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Step : 2',
              style: TextStyle(
                  color: MyColors.myColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Please Login. ',
              style: TextStyle(color: MyColors.myColor, fontSize: 18),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Step : 3',
              style: TextStyle(
                  color: MyColors.myColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'In homepage there is a Drawer on top left corner please click on it.  ',
              style: TextStyle(color: MyColors.myColor, fontSize: 18),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Step : 4',
              style: TextStyle(
                  color: MyColors.myColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'There is a Send Travel Agent Request Button Please click on it and proceed a request.',
              style: TextStyle(color: MyColors.myColor, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
