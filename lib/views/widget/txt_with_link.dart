
import 'package:flutter/material.dart';
import '../../consts/colors.dart';

Widget txtWithLink({required String? txt, required String? linkTxt,  Color linkTxtColor= AppColors.redColor,required GestureTapCallback onTap}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        txt!,
        style: const TextStyle(color: AppColors.textColor, fontWeight: FontWeight.w300),
      ),
      const SizedBox(width: 5,),
      InkWell(
        onTap: onTap,
        child: Text(
          linkTxt!,
          style:  TextStyle(color:linkTxtColor, fontWeight: FontWeight.w300),
        ),
      ),
    ],
  );
}
