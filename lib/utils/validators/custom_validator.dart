import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'string_validator.dart';

// Variables
const int _maxImageSize = 20000000; // 20MB
const int _maxVideoSize = 200000000; // 50MB

/*
  Validate email
  Return true if email is valid
*/
bool validateEmailAddress(String? email) {
  // Check if email is empty
  if (validateEmptyString(email) || !isStringEmailAddress(email!)) {
    return false;
  }

  return true;
}

/*
  Validate Password & Reset Password
  Return error code if invalid.
  0 - Valid
  -1 - Empty field
  -2 - Must include at least one alphabet, number and special character
  -3 - Password length must between 8 and 20
  -4 - Password does not match with confirm password
*/
int validatePasswords({
  String? password,
  String? confirmPassword,
  bool isSetNewPassword = true,
}) {
  // Check if password is empty
  if (validateEmptyString(password)) {
    return -1;
  }
  // Check if password has alphabet
  else if (!isAlphabetIncluded(password!) ||
      !isSpecialCharacterIncluded(password) ||
      !isDigitIncluded(password)) {
    return -2;
  }
  // Check if password is between 8 and 20 characters
  else if (!validateStringRange(text: password, minLength: 8, maxLength: 20)) {
    return -3;
  }
  // Check if password is same as confirm password
  else if (isSetNewPassword &&
      !equalString(firstString: password, secondString: confirmPassword)) {
    return -4;
  }

  return 0;
}

/*
  Check if default dropdown value
  Return true if not default value
*/
bool validateEmptyDropDownValue(String? dropDownValue) {
  return !(dropDownValue == "0" || validateEmptyString(dropDownValue));
}

/*
  Check for image only
  Return true if is one of the image type
  */
bool validateIsImageFormat(XFile file) {
  final List<String> imageExtension = [
    "jpg",
    "jpeg",
    "png",
  ];

  return imageExtension.contains(file.path.split('.').last.toLowerCase());
}

/*
  Check if variable is "integer" datatype
  */
bool validateIsIntOnly(dynamic variable) {
  RegExp integerRegExp = RegExp(r'^[0-9]+$');

  return integerRegExp.hasMatch(variable.toString());
}

/*
  Check if have decimal
  */
bool validateIsDecimal(dynamic variable) {
  RegExp decimalRegExp = RegExp(r'^[0-9]+\.[0-9]+$');

  return decimalRegExp.hasMatch(variable.toString());
}

/*
  Verify image and video size.
  - Image cannot more than 20MB
  - Video cannot more than 50MB
  */
bool validateFileSize({required dynamic file, isImage = true}) {
  // Get file size
  final int fileSize = File(file.path).lengthSync();

  return (isImage) ? fileSize < _maxImageSize : fileSize < _maxVideoSize;
}

//
// Compare
//

/*
  Compare date. 
  Cannot be used to compare same day
  Return true if date1 is later than date2
  */
bool compareDateTime(DateTime date1, {DateTime? date2}) {
  return date1.isAfter(date2 ?? DateTime.now());
}

/*
  Compare same day.
  Return true if same
  */
bool compareSameDay(DateTime date1, {DateTime? date2}) {
  return date1.day == (date2 ?? DateTime.now()).day;
}

/*
  Compare time
  Return true if time1 is later than time2
  */
bool compareTime(TimeOfDay time1, {TimeOfDay? time2}) {
  return time1.hour > (time2 ?? TimeOfDay.now()).hour ||
      (time1.hour == (time2 ?? TimeOfDay.now()).hour &&
          time1.minute > (time2 ?? TimeOfDay.now()).minute);
}
