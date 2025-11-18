import 'package:flutter/cupertino.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

import '../main.dart';
import '../views/widget/buttons.dart';

class CustomDialog {
  final String msg;
  final StylishDialogType stylishDialogType;
  final bool dismissible;
  final Function? callBack;

  CustomDialog(
      {required this.stylishDialogType,
      required this.msg,
      this.dismissible = true,
      this.callBack});

  Future<void> show(BuildContext context) async {
    DialogController controller;
    StylishDialog dialog;

    controller = DialogController(
      listener: (status) {
        if (status == DialogStatus.Showing) {
          debugPrint("Dialog is showing");
        } else if (status == DialogStatus.Changed) {
          debugPrint("Dialog type changed");
        } else if (status == DialogStatus.Dismissed) {
          debugPrint("Dialog dismissed");
        }
      },
    );

    dialog = StylishDialog(
      context: context,
      alertType: stylishDialogType,
      title: Text(
        msg,
        style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600),
        textAlign: TextAlign.center,
      ),
      dismissOnTouchOutside: dismissible,
      controller: controller,
      confirmButton: AppElevatedButton(
        width: 150,
        onPressed: () {
          if (callBack == null) {
            Navigator.pop(context);
          } else {
            callBack!();
          }
          controller.dispose();
        },
        title: "Ok", //Empty
      ),
    );

    await dialog.show();
  }
}
