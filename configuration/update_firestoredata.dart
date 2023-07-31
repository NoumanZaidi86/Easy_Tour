import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easytour/configuration/color.dart';

import 'package:flutter/material.dart';

class UpdateCustomerDialog extends StatelessWidget {
  final TextEditingController cnicController;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final DocumentSnapshot data;
  final CollectionReference ref;
  final _formKey = GlobalKey<FormState>();

  UpdateCustomerDialog({
    required this.cnicController,
    required this.nameController,
    required this.phoneController,
    required this.data,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    nameController.text = data['name'];
    cnicController.text = data['cnic'];
    phoneController.text = data['phone'];
    return AlertDialog(
      title: Text(
        'Update ',
        style: TextStyle(color: MyColors.myColor),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyTextField(
              controller: nameController,
              icon: Icons.person,
              label: 'Name',
              hint: 'Abc',
            ),
            SizedBox(
              height: 10,
            ),
            MyTextField(
              controller: cnicController,
              icon: Icons.credit_card,
              label: 'CNIC',
              hint: 'Enter a 13 Digit Cnic Number',
              validator: MyTextField.cnicValidator,
              keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: 10,
            ),
            MyTextField(
              controller: phoneController,
              icon: Icons.phone_android_outlined,
              label: 'Phone Number',
              hint: 'Enter a 11 digit Phone Number',
              validator: MyTextField.phoneNumberValidator,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: MyColors.myColor,
          ),
          child: Text('Save'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              String newCnic = cnicController.text;
              String newName = nameController.text;
              String newPhone = phoneController.text;

              // Update the Firestore document with the new values
              ref.doc(data['uid'].toString()).update({
                'cnic': newCnic,
                'name': newName,
                'phone': newPhone,
              }).then((value) {
                Navigator.of(context).pop(); // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(' updated successfully'),
                  ),
                );
              }).catchError((error) {
                print('Failed to update : $error');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to update '),
                  ),
                );
              });
            }
          },
        ),
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
