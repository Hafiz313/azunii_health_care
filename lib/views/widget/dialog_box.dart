import 'package:flutter/material.dart';

class DynamicDialogButton extends StatelessWidget {
 final  String title;
 final  String message;
final   String buttonText;
  const DynamicDialogButton({super.key, required this.title, required this.message, required this.buttonText});

@override
Widget build(BuildContext context) {


  return  ElevatedButton(
    onPressed: () {
      // Show the dynamic dialog
      // _showDynamicDialog(
      //   context,
      //   title: 'Your leave request has been Approved',
      //   message: 'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
      //   buttonText: 'OK',
      // );
    },
    child: Text('Show Dialog'),
  );
}

// This function triggers the dialog from a StatelessWidget

}