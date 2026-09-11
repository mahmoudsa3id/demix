import 'package:flutter/material.dart';

class CategoryModel {
  final String image;
  final String title;
  final Color color;
  final String id;
  final String? titleEn;

  CategoryModel({
    required this.image,
    required this.title,
    required this.color,
    required this.id,
    this.titleEn,
  });

  String displayTitle(bool isArabic) => isArabic ? title : (titleEn ?? title);
}
