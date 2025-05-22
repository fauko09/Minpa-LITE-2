import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ColorConstans {
  static Color primary = HexColor("#009C63");
  static Color second = HexColor("#4CD964");
  static LinearGradient primaryGradient =
      LinearGradient(colors: [HexColor("#4CD964"), HexColor("#009C63")]);
  static Color grey = HexColor("#CACACA");
  static Color redLips = HexColor("#B53A3A");
  static Color youngGreens = HexColor("#009C631A");
//   String colorToHex(Color color) {
//   String hex = color.value.toRadixString(16).padLeft(8, '0');
//   return "#${hex.substring(2, 8)}";
// }
}
