/*

String validator
All string related validation function will be written here for global use
 
*/

// Check if first character is capital
bool isFirstCharCapital(String string) {
  if (string.codeUnitAt(0) >= 65 && string.codeUnitAt(0) <= 90) {
    return true;
  }
  return false;
}

// Check if alphabet is included in string
bool isAlphabetIncluded(String string) {
  string = string.toUpperCase();
  for (int i = 0; i < string.length; i++) {
    if (string.codeUnitAt(i) >= 65 && string.codeUnitAt(i) <= 90) {
      return true;
    }
  }
  return false;
}

// Check if digit is included in string
bool isDigitIncluded(String string) {
  return RegExp(r'\d').hasMatch(string);
}

// Check if special character is included in string
bool isSpecialCharacterIncluded(String string) {
  String ch = "~`!@#\$%^&*.?_";

  for (int i = 0; i < string.length; i++) {
    if (ch.contains(string[i])) {
      return true;
    }
  }
  return false;
}

// Check if required characters are present in string
bool isIncludedCharactersPresent(
  String string,
  List<String>? includeCharacters,
) {
  if (includeCharacters == null) {
    return false;
  }

  for (int i = 0; i < string.length; i++) {
    if (includeCharacters.contains(string[i])) {
      return true;
    }
  }
  return false;
}

// Check if ignore characters are present in string
bool isIgnoreCharactersPresent(String string, List<String>? ignoreCharacters) {
  if (ignoreCharacters == null) {
    return false;
  }

  for (int i = 0; i < string.length; i++) {
    if (ignoreCharacters.contains(string[i])) {
      return true;
    }
  }
  return false;
}

// Check alphabet in string exceed max limit
bool checkMaxAlphabet(String string, int maxAlphabet) {
  int counter = 0;
  string = string.toUpperCase();
  for (int i = 0; i < string.length; i++) {
    if (string.codeUnitAt(i) >= 65 && string.codeUnitAt(i) <= 90) {
      counter++;
    }
  }
  if (counter <= maxAlphabet) {
    return true;
  }
  return false;
}

// Check digit in string exceed max limit
bool checkMaxDigit(String string, int maxDigit) {
  int counter = 0;

  for (int i = 0; i < string.length; i++) {
    if (string.codeUnitAt(i) >= 0 && string.codeUnitAt(i) <= 9) {
      counter++;
    }
  }
  if (counter <= maxDigit) {
    return true;
  }
  return false;
}

// Check alphabet in string exceed min limit
bool checkMinAlphabet(String string, int minAlphabet) {
  int counter = 0;
  string = string.toUpperCase();
  for (int i = 0; i < string.length; i++) {
    if (string.codeUnitAt(i) >= 65 && string.codeUnitAt(i) <= 90) {
      counter++;
    }
  }
  if (counter >= minAlphabet) {
    return true;
  }
  return false;
}

// Check digit in string exceed min limit
bool checkMinDigit(String string, int minDigit) {
  int counter = 0;
  for (int i = 0; i < string.length; i++) {
    if (string.codeUnitAt(i) >= 0 && string.codeUnitAt(i) <= 9) {
      counter++;
    }
  }
  if (counter >= minDigit) {
    return true;
  }
  return false;
}

// Global function to use all function
bool validateString(
  String string, {
  int minLength = 8,
  int maxLength = 20,
  bool firstCapital = false,
  bool firstDigit = false,
  bool includeDigit = false,
  bool includeAlphabet = false,
  bool includeSpecialCharacter = false,
  List<String>? includeCharacters,
  List<String>? ignoreCharacters,
  int minAlphabet = 5,
  int maxAlphabet = 20,
  int minDigit = 0,
  int maxDigit = 20,
}) {
  if (string.length < minLength) {
    return false;
  }

  if (string.length > maxLength) {
    return false;
  }

  if (firstCapital && !isFirstCharCapital(string)) {
    return false;
  }

  if (firstDigit && !isFirstCharCapital(string)) {
    return false;
  }

  if (includeAlphabet && !isAlphabetIncluded(string)) {
    return false;
  }

  if (includeDigit && !isDigitIncluded(string)) {
    return false;
  }

  if (includeSpecialCharacter && !isSpecialCharacterIncluded(string)) {
    return false;
  }

  if (!isIncludedCharactersPresent(string, includeCharacters)) {
    return false;
  }

  if (isIgnoreCharactersPresent(string, ignoreCharacters)) {
    return false;
  }

  if (!checkMaxAlphabet(string, maxAlphabet)) {
    return false;
  }

  if (!checkMinAlphabet(string, minAlphabet)) {
    return false;
  }

  if (!checkMaxDigit(string, maxAlphabet)) {
    return false;
  }

  if (!checkMinDigit(string, minAlphabet)) {
    return false;
  }

  return true;
}

// Check if string is email address
bool isStringEmailAddress(String email) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{1,}))$';
  RegExp regex = RegExp(pattern as String);
  return (regex.hasMatch(email));
}

// Check if string is in specific min and max limit
bool validateStringRange({
  required String text,
  int minLength = 8,
  int maxLength = 20,
}) {
  return text.length >= minLength && text.length <= maxLength;
}

/*
  Check for empty string
  Return true if string is empty
*/
bool validateEmptyString(dynamic text) {
  return text == null || text.toString().trim().isEmpty;
}

/*
  Compare two string
  Return true if same string
  Parameters:
    - firstString: first string for compare
    - secondString: second string for compare
*/
bool equalString({String? firstString, String? secondString}) {
  if (validateEmptyString(firstString) || validateEmptyString(secondString)) {
    return false;
  } else if (firstString != secondString) {
    return false;
  }
  return true;
}
