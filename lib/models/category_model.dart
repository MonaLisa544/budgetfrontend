import 'package:flutter/material.dart';

class CategoryModel {
  final int? id;
  final String categoryName;
  final String? icon; // string codePoint
  final String transactionType;
  final Color? iconColor;

  CategoryModel({
    this.id,
    required this.categoryName,
    this.icon,
    required this.transactionType,
    this.iconColor,
  });

  /// Icon string → IconData (fallback-той)
  IconData get iconData {
    final parsed = int.tryParse(icon ?? '');
    return IconData(
      parsed ?? Icons.category.codePoint,
      fontFamily: 'MaterialIcons',
    );
  }

  /// iconColor fallback (nullable байвал default)
  Color get safeColor => iconColor ?? Colors.grey;

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      categoryName: json['category_name'],
      icon: json['icon'],
      transactionType: json['transaction_type'],
      iconColor: json['icon_color'] != null
          ? Color(int.parse(json['icon_color'].replaceFirst('#', '0xff')))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_name': categoryName,
      'icon': icon,
      'transaction_type': transactionType,
      'icon_color': iconColor != null
          ? '#${iconColor!.value.toRadixString(16).substring(2)}'
          : null,
    };
  }

  CategoryModel copyWith({
    int? id,
    String? categoryName,
    String? icon,
    String? transactionType,
    Color? iconColor,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      categoryName: categoryName ?? this.categoryName,
      icon: icon ?? this.icon,
      transactionType: transactionType ?? this.transactionType,
      iconColor: iconColor ?? this.iconColor,
    );
  }
}
