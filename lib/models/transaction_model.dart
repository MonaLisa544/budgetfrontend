import 'dart:ui';

import 'package:budgetfrontend/models/category_model.dart';

class TransactionModel {
  final int? id;
  final String transactionName;
  final double transactionAmount;
  final String transactionDate;
  final String? description;
  final int categoryId;
  final String? walletType;
  final String? transactionType;

  final CategoryModel? category; // 🔥 нэмэгдсэн хэсэг!

  TransactionModel({
    this.id,
    required this.transactionName,
    required this.transactionAmount,
    required this.transactionDate,
    this.description,
    required this.categoryId,
    this.walletType,
    this.transactionType,
    this.category,
  });
factory TransactionModel.fromJson(Map<String, dynamic> json) {
  return TransactionModel(
    id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
    transactionName: json['transaction_name'],
    transactionAmount: (json['transaction_amount'] as num).toDouble(),
    transactionDate: json['transaction_date'],
    description: json['description'],
    categoryId: json['category_id'] ??
        (json['relationships'] != null && json['relationships']['category'] != null
            ? int.tryParse(json['relationships']['category']['data']['id'].toString())
            : null),
    walletType: json['wallet_type'],
    transactionType: json['transaction_type'],
    category: (json['category_name'] != null)
        ? CategoryModel(
            categoryName: json['category_name'],
            icon: json['category_icon'],
            transactionType: json['transaction_type'] ?? '',
            iconColor: json['category_icon_color'] != null
                ? Color(int.parse(json['category_icon_color'].replaceFirst('#', '0xff')))
                : null,
          )
        : null,
  );
}


  Map<String, dynamic> toJson() {
    return {
      'transaction_name': transactionName,
      'transaction_amount': transactionAmount,
      'transaction_date': transactionDate,
      'description': description,
      'category_id': categoryId,
      'wallet_type': walletType,
    };
  }
}
