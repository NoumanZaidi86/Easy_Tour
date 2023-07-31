import 'package:easytour/configuration/color.dart';
import 'package:easytour/travel_agent/TravelAgentHomePage.dart';
import 'package:flutter/material.dart';

class AgentTermsAndConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms and Conditions'),
        backgroundColor: MyColors.myColor,
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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Travel Agents Terms and Conditions',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: MyColors.myColor,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'By using our services as a travel agent, you agree to the following terms and conditions:',
              style: TextStyle(
                fontSize: 16.0,
                color: MyColors.myColor,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              '1. Providing Correct Credentials:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: MyColors.myColor,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Travel agents are required to provide accurate and up-to-date information about their companies and themselves. This includes providing valid contact details, business licenses, and any other necessary credentials.',
              style: TextStyle(
                fontSize: 16.0,
                color: MyColors.myColor,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              '2. Prohibited Activities:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: MyColors.myColor,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Travel agents are strictly prohibited from engaging in any kind of criminal or fraudulent activities. If any travel agent is found involved in such activities, they will be immediately banned from using our services, and legal action may be taken against them.',
              style: TextStyle(
                fontSize: 16.0,
                color: MyColors.myColor,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              '3. Compliance with Laws:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: MyColors.myColor,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Travel agents must comply with all applicable laws and regulations related to their business operations. This includes but is not limited to local, regional, and national laws governing travel, tourism, and business practices.',
              style: TextStyle(
                fontSize: 16.0,
                color: MyColors.myColor,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              '4. Modifications to Terms and Conditions:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: MyColors.myColor,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'We reserve the right to modify these terms and conditions at any time without prior notice. It is the responsibility of travel agents to regularly review and comply with the most up-to-date version of the terms and conditions.',
              style: TextStyle(
                fontSize: 16.0,
                color: MyColors.myColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
