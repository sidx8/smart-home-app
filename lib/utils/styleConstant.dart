import 'package:flutter/material.dart';

class StyleConstant {
  static OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: Colors.black),
      borderRadius: BorderRadius.circular(12),
      gapPadding: 4);

  static TextStyle textStyle = TextStyle(
    color: Colors.black.withOpacity(.7),
    fontWeight: FontWeight.w500,
    fontSize: 20,
  );
}
