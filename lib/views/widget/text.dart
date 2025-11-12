import 'package:flutter/material.dart';

import '../../consts/colors.dart';
import '../../consts/fonts.dart';

///Fontsize 28 bold heading
Text headingText1(String title, {Color color = AppColors.headingTextColor}) =>
    Text(
      title,
      style: TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.bold,
        fontFamily: FontFamily.satoshi,
        color: color,
      ),
    );

///Fontsize 24 bold
Text headline1(String title, {Color color = AppColors.textColor}) => Text(
      title,
      style: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        fontFamily: FontFamily.satoshi,
        color: color,
      ),
    );
//fontsize 30
Text headline0(String title,
        {Color color = AppColors.textColor,
        TextAlign? textAlign,
        FontWeight fontWeight = FontWeight.normal}) =>
    Text(
      title,
      textAlign: textAlign ?? TextAlign.start,
      style: TextStyle(
        fontSize: 28.0,
        fontWeight: fontWeight,
        fontFamily: FontFamily.satoshi,
        color: color,
      ),
    );

///Fontsize 24
Text headline2(String title,
        {Color color = AppColors.headingTxtColor,
        TextAlign? textAlign,
        FontWeight fontWeight = FontWeight.normal}) =>
    Text(
      title,
      textAlign: textAlign ?? TextAlign.start,
      style: TextStyle(
        fontSize: 24.0,
        fontWeight: fontWeight,
        fontFamily: FontFamily.satoshi,
        color: color,
      ),
    );

///Fontsize 22 bold
Text headline3(String title,
        {Color color = AppColors.headingTxtColor, TextAlign? textAlign}) =>
    Text(
      title,
      textAlign: textAlign ?? TextAlign.start,
      style: TextStyle(
        fontSize: 22.0,
        fontWeight: FontWeight.bold,
        fontFamily: FontFamily.satoshi,
        color: color,
      ),
    );

///Fontsize 22
Text headline4(String title, {Color color = AppColors.headingTxtColor}) => Text(
      title,
      style: TextStyle(
          fontSize: 22.0, fontFamily: FontFamily.satoshi, color: color),
    );

///Fontsize 20
Text headline5(String title,
        {TextAlign? align,
        Color? color = AppColors.headingTxtColor,
        TextDecoration? txtDecoration,
        FontWeight? fontWeight}) =>
    Text(
      title,
      textAlign: align ?? TextAlign.center,
      style: TextStyle(
          decoration: txtDecoration ?? TextDecoration.none,
          fontWeight: fontWeight ?? FontWeight.bold,
          fontSize: 16.0,
          fontFamily: FontFamily.satoshi,
          color: color),
    );
Text headline6(String title,
        {TextAlign? align,
        Color? color = AppColors.headingTxtColor,
        TextDecoration? txtDecoration,
        FontWeight? fontWeight}) =>
    Text(
      title,
      textAlign: align ?? TextAlign.center,
      style: TextStyle(
          decoration: txtDecoration ?? TextDecoration.none,
          fontWeight: fontWeight ?? FontWeight.bold,
          fontSize: 14.0,
          fontFamily: FontFamily.satoshi,
          color: color),
    );

///Fontsize 18 grey
Text subText1(
  String title, {
  TextAlign? align,
  double? fontSize,
  FontWeight? fontWeight,
  Color color = AppColors.textColor,
}) =>
    Text(
      title,
      textAlign: align ?? TextAlign.center,
      style: TextStyle(
        fontSize: fontSize ?? 16.0,
        fontFamily: FontFamily.satoshi,
        color: color,
        fontWeight: fontWeight ?? FontWeight.normal,
      ),
    );

///Fontsize 18 grey bold
Text subText2(
  String title, {
  TextAlign? align,
  Color color = AppColors.textColor,
  FontWeight? fontWeight,
}) =>
    Text(
      title,
      textAlign: align ?? TextAlign.center,
      style: TextStyle(
        fontSize: 18.0,
        fontFamily: FontFamily.satoshi,
        color: color,
        fontWeight: fontWeight ?? FontWeight.bold,
      ),
    );
//fontSize 26
Text subText5(
  String title, {
  TextAlign? align,
  Color color = AppColors.textColor,
  double? fontSize,
  TextDecoration? decoration,
  FontWeight? fontWeight,
  TextOverflow? textOverflow,
}) =>
    Text(
      title,
      textAlign: align ?? TextAlign.center,
      style: TextStyle(
        fontSize: fontSize ?? 10.0,
        fontFamily: FontFamily.satoshi,
        decoration: decoration ?? TextDecoration.none,
        color: color,
        overflow: textOverflow,
        fontWeight: fontWeight ?? FontWeight.bold,
      ),
    );
//fontSize 14
Text subText4(
  String title, {
  TextAlign? align,
  Color color = AppColors.blackColor,
  FontWeight? fontWeight,
  TextDecoration? decoration,
  Color? decorationColor,
}) =>
    Text(
      title,
      textAlign: align ?? TextAlign.center,
      style: TextStyle(
        fontSize: 14.0,
        fontFamily: FontFamily.satoshi,
        color: color,
        decoration: decoration ?? TextDecoration.none,
        decorationColor: decorationColor ?? AppColors.white,
        fontWeight: fontWeight ?? FontWeight.normal,
      ),
    );

///Fontsize 12 grey
Text subText3(
  String title, {
  TextAlign? align,
  Color color = AppColors.textColor,
  FontWeight? fontWeight,
  TextOverflow? textOverflow,
}) =>
    Text(
      title,
      textAlign: align ?? TextAlign.center,
      style: TextStyle(
        fontSize: 14.0,
        overflow: textOverflow,
        fontFamily: FontFamily.satoshi,
        color: color,
        fontWeight: fontWeight ?? FontWeight.normal,
      ),
    );
//Fontsize 8
Text subText6(
  String title, {
  TextAlign? align,
  FontWeight? fontWeight,
  Color color = Colors.black45,
}) =>
    Text(
      title,
      textAlign: align ?? TextAlign.center,
      style: TextStyle(
        fontSize: 10.0,
        fontFamily: FontFamily.satoshi,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color,
      ),
    );
