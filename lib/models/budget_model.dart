import 'dart:ui';

import 'package:budgetfrontend/models/category_model.dart';

class BudgetModel {
  final int id;
  final String budgetName;
  final double amount;
  final int payDueDate;
  final String description;
  final String walletType;
  final int categoryId;
  final CategoryModel? category; // ✅ category нэмсэн!
  final CurrentMonthBudget? currentMonthBudget;

  BudgetModel({
    required this.id,
    required this.budgetName,
    required this.amount,
    required this.payDueDate,
    required this.description,
    required this.walletType,
    required this.categoryId,
    this.category,
    this.currentMonthBudget,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    final attributes = json['attributes'];
    final relationships = json['relationships'];

    return BudgetModel(
      id: int.parse(json['id'].toString()),
      budgetName: attributes['budget_name'],
      amount: (attributes['amount'] as num).toDouble(),
      payDueDate: attributes['pay_due_date'],
      description: attributes['description'],
      walletType: attributes['wallet_type'],
      categoryId: relationships?['category']?['data'] != null
          ? int.parse(relationships['category']['data']['id'].toString())
          : 0,
      
      category: (attributes['category_name'] != null)
          ? CategoryModel(
              categoryName: attributes['category_name'],
              icon: attributes['category_icon'],
              transactionType: attributes['transaction_type'] ?? '',
              iconColor: attributes['category_icon_color'] != null
                  ? Color(int.parse(attributes['category_icon_color'].replaceFirst('#', '0xff')))
                  : null,
            )
          : null, // ✅ category барьж авах!

      currentMonthBudget: attributes['current_month_budget'] != null
          ? CurrentMonthBudget.fromJson(attributes['current_month_budget'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "wallet_type": walletType.toLowerCase(),
      "category_id": categoryId,
      "budget_name": budgetName,
      "amount": amount,
      "pay_due_date": payDueDate,
      "description": description,
    };
  }
}

class CurrentMonthBudget {
  final int id;
  final String month;
  final double amount;
  final double usedAmount;
  final double remainingAmount;
  final String spendingStatus;
  final String timelineStatus;

  CurrentMonthBudget({
    required this.id,
    required this.month,
    required this.amount,
    required this.usedAmount,
    required this.remainingAmount,
    required this.spendingStatus,
    required this.timelineStatus,
  });

  factory CurrentMonthBudget.fromJson(Map<String, dynamic> json) {
    return CurrentMonthBudget(
      id: json['id'],
      month: json['month'],
      amount: (json['amount'] as num).toDouble(),
      usedAmount: (json['used_amount'] as num).toDouble(),
      remainingAmount: (json['remaining_amount'] as num).toDouble(),
      spendingStatus: json['spending_status'],
      timelineStatus: json['timeline_status'],
    );
  }
}