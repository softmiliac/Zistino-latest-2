import 'package:flutter/material.dart';

class ResidueFakeModel {
  int id;
  String icon;
  String name;
  String picture;
  List<Color> colors;
  String highestPrice;
  String pricePerKg;
  String description;

  ResidueFakeModel({
    required this.id,
    required this.icon,
    required this.name,
    required this.picture,
    required this.colors,
    required this.highestPrice,
    required this.pricePerKg,
    required this.description,
  });
}
