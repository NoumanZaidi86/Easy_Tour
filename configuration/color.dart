import 'package:flutter/material.dart';

//for colors
class MyColors {
  static const Color myColor = Color(0xFF28A3AA);
  static const Color myOtherColor = Colors.white;
  static const Color myblackColor = Colors.black;
}

//for borders
class MyInputBorder extends OutlineInputBorder {
  MyInputBorder()
      : super(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Color(0xFF28A3AA),
          ),
        );
}
//for textfields

class MyTextField extends StatelessWidget {
  final TextEditingController? controller;
  final IconData icon;
  final String label;

  final String hint;

  final int? maxLines;
  final int? maxLength;
  final bool readOnly;

  final Color? fillColor;

  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;

  MyTextField({
    this.controller,
    required this.icon,
    this.maxLength,
    required this.label,
    required this.hint,
    this.maxLines,
    this.readOnly = false,
    this.fillColor,
    this.validator,
    this.keyboardType,
  });
  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }

    if (validator != null) {
      final customValidationResult = validator!(value);
      if (customValidationResult != null) {
        return customValidationResult;
      }
    }

    return null;
  }

  static String? cnicValidator(String? value) {
    if (value != null && value.isNotEmpty) {
      if (value.length != 13 || int.tryParse(value) == null) {
        return 'CNIC must be 13 Digits';
      }
    }
    return null;
  }

  static String? alphabeticValidator(String? value) {
    if (value != null && value.isNotEmpty) {
      if (!value.trim().contains(RegExp(r'^[a-zA-Z ]+$'))) {
        return 'Only alphabetic characters allowed';
      }
    }
    return null;
  }

  static String? phoneNumberValidator(String? value) {
    if (value != null && value.isNotEmpty) {
      if (value.length != 11 || int.tryParse(value) == null) {
        return 'Phone number must be 11 Digits';
      }
    }
    return null;
  }

  static String? wordCountValidator(String? value) {
    if (value != null && value.isNotEmpty) {
      // Split the value into words by whitespace
      List<String> words = value.split(' ');

      // Count the number of words
      int wordCount = words.length;

      if (wordCount < 200) {
        return 'Minimum 200 words required';
      }
    }
    return null;
  }

  static String? wecarevalidator(String? value) {
    if (value != null && value.isNotEmpty) {
      // Split the value into words by whitespace
      List<String> words = value.split(' ');

      // Count the number of words
      int wordCount = words.length;

      if (wordCount < 20) {
        return 'Minimum 20 words required';
      }
    }
    return null;
  }

  static String? numericValidator(String? value) {
    if (value != null && value.isNotEmpty) {
      if (int.tryParse(value) == null) {
        return 'Only numeric values allowed';
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: _validateInput,
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      enabled: !readOnly,
      style: TextStyle(
        color: MyColors.myColor,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
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
        labelText: label,
        labelStyle: TextStyle(
          color: MyColors.myColor,
        ),
        hintText: hint,
        hintStyle: TextStyle(
          color: MyColors.myColor,
        ),
        filled: true,
        fillColor: fillColor ?? Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      keyboardType: keyboardType,
    );
  }
}

class MypasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String label;
  final String hint;
  final TextInputType? keyboardType;

  MypasswordTextField(
      {required this.controller,
      required this.icon,
      required this.label,
      required this.hint,
      this.keyboardType});

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    // Validate if password contains at least one capital letter
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one capital letter';
    }

    // Validate if password contains at least one symbol
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one symbol';
    }

    // Validate if password contains at least one number
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
      controller: controller,
      style: TextStyle(
        color: MyColors.myColor,
      ),
      validator: _validatePassword,
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
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
        labelText: label,
        labelStyle: TextStyle(
          color: MyColors.myColor,
        ),
        hintText: hint,
        hintStyle: TextStyle(
          color: MyColors.myColor,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

//profile page fields

class MyProfileTextField extends StatelessWidget {
  final TextEditingController? controller;
  final IconData icon;

  final int? maxLines;
  final bool readOnly;
  final Color? fillColor;

  MyProfileTextField({
    this.controller,
    required this.icon,
    this.maxLines,
    this.readOnly = false,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      enabled: !readOnly,
      style: TextStyle(
        color: MyColors.myblackColor,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: MyColors.myColor,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
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
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
