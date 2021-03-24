import 'package:flutter/material.dart';

class Helpers {
  static Color colorParseIntToColor(int colorValue) {
    List<int> listColor = parseColorIntToListOfRgb(colorValue);
    print('color value : $listColor');
    String r, g, b;

    r = listColor[0].toRadixString(16);
    g = listColor[1].toRadixString(16);
    b = listColor[2].toRadixString(16);
    var finalColorString = '0xff$r$g$b';
    print('final color: $finalColorString');
    return Color(int.parse(finalColorString));
  }

  static int colorParseColorToInt(Color color) {
    var colorString = color.toString().replaceAll("Color(0xff", "");
    var value = colorString.replaceAll(")", "");
    int r, g, b;
    String rs, gs, bs;
    r = int.parse(value.substring(0, 2), radix: 16);
    g = int.parse(value.substring(2, 4), radix: 16);
    b = int.parse(value.substring(4, 6), radix: 16);

    rs = r < 100 ? "0$r" : "$r";
    gs = g < 100 ? "0$g" : "$g";
    bs = b < 100 ? "0$b" : "$b";
    var finalValue = int.parse(rs + gs + bs);
    print('R: $r G: $g B: $b  => $finalValue ');
    return finalValue;
  }

  static List parseColorIntToListOfRgb(int colorInt) {
    String colorString = colorInt.toString();
    List<int> intList = [];
    if (colorString.length < 9) {
      intList.addAll([
        int.parse(colorString.substring(0, 2)),
        int.parse(colorString.substring(2, 5)),
        int.parse(colorString.substring(5, 8)),
      ]);
    } else {
      intList.addAll([
        int.parse(colorString.substring(0, 3)),
        int.parse(colorString.substring(3, 6)),
        int.parse(colorString.substring(6, 9)),
      ]);
    }
    return intList;
  }

  static int parseUnorderedStringToOrderedInt(String unordered) {
    try {
      String r = makeLength3(unordered.substring(
          unordered.indexOf("R") + 1, unordered.indexOf("G")));
      String g = makeLength3(unordered.substring(
          unordered.indexOf("G") + 1, unordered.indexOf("B")));
      String b = makeLength3(unordered.substring(unordered.indexOf("B") + 1));

      int orderedInt = int.parse("$r$g$b");
      return orderedInt;
    } catch (err) {
      print('error while parsing : $err');
      return 0;
    }
  }

  static String makeLength3(String value) {
    if (value.length < 3) {
      if (value.length < 2) {
        return "00" + value;
      }
      return "0" + value;
    }
    return value;
  }
}
