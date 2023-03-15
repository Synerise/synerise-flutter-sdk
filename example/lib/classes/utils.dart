import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class Utils {
  static Future<void> displaySimpleAlert(String text, BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(text, textAlign: TextAlign.center),
        );
      },
    );
  }

  static String handlePlatformException(PlatformException error) {
    String? eMsg = error.message;
    String? eDetails = error.details;
    String eCode = error.code;
    if (eDetails != null && eMsg != null) {
      String errorMessage = "$eCode : $eMsg : $eDetails";
      return errorMessage;
    } else {
      String errorMessage = eCode;
      return errorMessage;
    }
  }

  static String handleException(TypeError error) {
    String? eMsg = error as String;
  
    // ignore: unnecessary_null_comparison
    if (eMsg != null) {
      String errorMessage = eMsg;
      return errorMessage;
    } else {
      String errorMessage = "main exception";
      return errorMessage;
    }
  }
} 
