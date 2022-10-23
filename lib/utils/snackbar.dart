import 'package:flutter/material.dart';

void getOkSnackbar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(message),
    action: SnackBarAction(
      label: 'OK', 
      onPressed: () { },
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}