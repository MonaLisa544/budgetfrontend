class TransactionModel {
  final int? id;
  final String transactionName;
  final double transactionAmount;
  final String transactionDate;
  final String? description;
  final int categoryId;
  final String? walletType;
  final String? transactionType;

  TransactionModel({
    this.id,
    required this.transactionName,
    required this.transactionAmount,
    required this.transactionDate,
    this.description,
    required this.categoryId,
    this.walletType,
    this.transactionType,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      transactionName: json['transaction_name'],
      transactionAmount: (json['transaction_amount'] as num).toDouble(),
      transactionDate: json['transaction_date'],
      description: json['description'],
      categoryId: json['category_id'],
      walletType: json['wallet_type'],
      transactionType: json['transaction_type'],
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
