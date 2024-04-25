import 'package:flutter/material.dart';

CircleAvatar profileAvatar(String name, double radius, double fontSize) {
  String getInitials(String name) {
    final List<String> nameList = name.split(' ');
    return '${nameList[0][0]}${nameList[1][0]}';
  }

  Color getColor(String name) {
    return Colors.primaries[name.length % Colors.primaries.length];
  }

  return CircleAvatar(
    backgroundColor: getColor(name),
    radius: radius,
    child: Text(
      getInitials(name),
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize,
      ),
    ),
  );
}
