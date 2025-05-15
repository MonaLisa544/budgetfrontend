import 'package:flutter/material.dart';
import 'category_model.dart'; // Таны CategoryModel байгаа гэж үзье

class BudgetModel {
  final int id;
  final String budgetName;
  final double amount;
  final double usedAmount;
  final String startDate;
  final String dueDate;
  final String payDueDate;
  final String status;
  final String description;
  final String statusLabel;
  final String ownerType;
  final int ownerId;
  final int walletId;
  final int categoryId;
  final CategoryModel? category;

  BudgetModel({
    required this.id,
    required this.budgetName,
    required this.amount,
    required this.usedAmount,
    required this.startDate,
    required this.dueDate,
    required this.payDueDate,
    required this.status,
    required this.description,
    required this.statusLabel,
    required this.ownerType,
    required this.ownerId,
    required this.walletId,
    required this.categoryId,
    this.category,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    final attributes = json['attributes'] ?? {};
    final relationships = json['relationships'] ?? {};

    return BudgetModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      budgetName: attributes['budget_name'] ?? '',
      amount: double.tryParse(attributes['amount'].toString()) ?? 0.0,
      usedAmount: double.tryParse(attributes['used_amount'].toString()) ?? 0.0,
      startDate: attributes['start_date'] ?? '',
      dueDate: attributes['due_date'] ?? '',
      payDueDate: attributes['pay_due_date'] ?? '',
      status: attributes['status'] ?? '',
      description: attributes['description'] ?? '',
      statusLabel: attributes['status_label'] ?? '',
      ownerType: attributes['owner_type'] ?? '',
      ownerId: int.tryParse(attributes['owner_id'].toString()) ?? 0,
      walletId: relationships['wallet'] != null
          ? int.tryParse(relationships['wallet']['data']['id'].toString()) ?? 0
          : 0,
      categoryId: relationships['category'] != null
          ? int.tryParse(relationships['category']['data']['id'].toString()) ?? 0
          : 0,
      category: attributes['category_name'] != null
          ? CategoryModel(
              categoryName: attributes['category_name'],
              icon: attributes['category_icon'],
              transactionType: attributes['transaction_type'] ?? 'expense',
              iconColor: attributes['category_icon_color'] != null
                  ? Color(
                      int.tryParse(
                            attributes['category_icon_color']
                                .toString()
                                .replaceFirst('#', '0xff'),
                          ) ??
                          0xff9e9e9e, // сафети код
                    )
                  : null,
            )
          : null,
    );
  }
}
