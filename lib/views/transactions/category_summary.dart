import 'package:flutter/material.dart';
import 'package:budgetfrontend/models/category_model.dart';

class CategorySummary {
  final int id;
  final String name;
  final String? icon; // string codePoint
  final Color iconColor;
  double sum;
  double percent;
  final CategoryModel categoryModel;

  CategorySummary({
    required this.id,
    required this.name,
    required this.icon,
    required this.iconColor,
    required this.sum,
    required this.percent,
    required this.categoryModel,
  });
}
