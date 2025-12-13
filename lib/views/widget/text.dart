import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../consts/colors.dart';
import '../../utils/percentage_size_ext.dart';

///Fontsize 28 bold heading
Text headingText1(
  String title, {
  Color color = AppColors.headingTextColor,
  double fontSize = 28.0,
  FontWeight fontWeight = FontWeight.bold,
  BuildContext? context,
}) =>
    Text(
      title,
      style: GoogleFonts.manrope(
        fontSize: context != null ? context.percentWidth * 7 : fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );

///Fontsize 24 bold
Text headline1(
  String title, {
  Color color = AppColors.textColor,
  double fontSize = 24.0,
  FontWeight fontWeight = FontWeight.bold,
  BuildContext? context,
}) =>
    Text(
      title,
      style: GoogleFonts.manrope(
        fontSize: context != null ? context.percentWidth * 6 : fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
//fontsize 30
Text headline0(
  String title, {
  Color color = AppColors.textColor,
  TextAlign? textAlign,
  FontWeight fontWeight = FontWeight.normal,
  double fontSize = 28.0,
  BuildContext? context,
}) =>
    Text(
      title,
      textAlign: textAlign ?? TextAlign.start,
      style: GoogleFonts.manrope(
        fontSize: context != null ? context.percentWidth * 7 : fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );

///Fontsize 24
Text headline2(
  String title, {
  Color color = AppColors.headingTxtColor,
  TextAlign? textAlign,
  FontWeight fontWeight = FontWeight.normal,
  double fontSize = 24.0,
  BuildContext? context,
}) =>
    Text(
      title,
      textAlign: textAlign ?? TextAlign.start,
      style: GoogleFonts.manrope(
        fontSize: context != null ? context.percentWidth * 6 : fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );

///Fontsize 22 bold
Text headline3(
  String title, {
  Color color = AppColors.headingTxtColor,
  TextAlign? textAlign,
  double fontSize = 22.0,
  FontWeight fontWeight = FontWeight.bold,
  BuildContext? context,
}) =>
    Text(
      title,
      textAlign: textAlign ?? TextAlign.start,
      style: GoogleFonts.manrope(
        fontSize: context != null ? context.percentWidth * 5.5 : fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );

///Fontsize 22
Text headline4(
  String title, {
  Color color = AppColors.headingTxtColor,
  double fontSize = 22.0,
  FontWeight fontWeight = FontWeight.normal,
  BuildContext? context,
}) =>
    Text(
      title,
      style: GoogleFonts.manrope(
        fontSize: context != null ? context.percentWidth * 5.5 : fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );

///Fontsize 20
Text headline5(
  String title, {
  TextAlign? align,
  Color? color = AppColors.headingTxtColor,
  TextDecoration? txtDecoration,
  FontWeight? fontWeight,
  double fontSize = 16.0,
  BuildContext? context,
}) =>
    Text(
      title,
      textAlign: align ?? TextAlign.center,
      style: GoogleFonts.manrope(
        decoration: txtDecoration ?? TextDecoration.none,
        fontWeight: fontWeight ?? FontWeight.bold,
        fontSize: context != null ? context.percentWidth * 4 : fontSize,
        color: color,
      ),
    );
Text headline6(
  String title, {
  TextAlign? align,
  Color? color = AppColors.headingTxtColor,
  TextDecoration? txtDecoration,
  FontWeight? fontWeight,
  double fontSize = 15.0,
  BuildContext? context,
}) =>
    Text(
      title,
      textAlign: align ?? TextAlign.center,
      style: GoogleFonts.manrope(
        decoration: txtDecoration ?? TextDecoration.none,
        fontWeight: fontWeight ?? FontWeight.bold,
        fontSize: context != null ? context.percentWidth * 3.75 : fontSize,
        color: color,
      ),
    );

///Fontsize 18 grey
Text subText1(
  String title, {
  TextAlign? align,
  double? fontSize,
  FontWeight? fontWeight,
  Color color = AppColors.textColor,
  BuildContext? context,
}) =>
    Text(
      title,
      textAlign: align ?? TextAlign.center,
      style: GoogleFonts.manrope(
        fontSize: context != null ? context.percentWidth * 4 : (fontSize ?? 16.0),
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
  double fontSize = 18.0,
  BuildContext? context,
}) =>
    Text(
      title,
      textAlign: align ?? TextAlign.center,
      style: GoogleFonts.manrope(
        fontSize: context != null ? context.percentWidth * 4.5 : fontSize,
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
  BuildContext? context,
}) =>
    Text(
      title,
      textAlign: align ?? TextAlign.center,
      style: GoogleFonts.manrope(
        fontSize: context != null ? context.percentWidth * 3 : (fontSize ?? 12.0),
        decoration: decoration ?? TextDecoration.none,
        color: color,
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
  double fontSize = 14.0,
  BuildContext? context,
}) =>
    Text(
      title,
      textAlign: align ?? TextAlign.center,
      style: GoogleFonts.manrope(
        fontSize: context != null ? context.percentWidth * 3.5 : fontSize,
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
  double fontSize = 14.0,
  BuildContext? context,
}) =>
    Text(
      title,
      textAlign: align ?? TextAlign.center,
      overflow: textOverflow ?? TextOverflow.ellipsis,
      style: GoogleFonts.manrope(
        fontSize: context != null ? context.percentWidth * 3.5 : fontSize,
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
  double fontSize = 10.0,
  BuildContext? context,
}) =>
    Text(
      title,
      textAlign: align ?? TextAlign.center,
      style: GoogleFonts.manrope(
        fontSize: context != null ? context.percentWidth * 2.5 : fontSize,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color,
      ),
    );
