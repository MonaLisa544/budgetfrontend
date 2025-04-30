// class Transaction {
//   int id;
//   String transactionName;
//   double transactionAmount;
//   String transactionDate;
//   String description;

//   Transaction({
//     required this.id,
//     required this.transactionName,
//     required this.transactionAmount,
//     required this.transactionDate,
//     required this.description,
//   });

//   // Factory method to create a Transaction from JSON
//   factory Transaction.fromJson(Map<String, dynamic> json) {
//     return Transaction(
//       id: json['id'],
//       transactionName: json['attributes']['transaction_name'],
//       transactionAmount: json['attributes']['transaction_amount'].toDouble(),
//       transactionDate: json['attributes']['transaction_date'],
//       description: json['attributes']['description'],
//     );
//   }

//   // Convert a Transaction object to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'transaction_name': transactionName,
//       'transaction_amount': transactionAmount,
//       'transaction_date': transactionDate,
//       'description': description,
//     };
//   }
// }

class TransactionModel {
  final int id;
  final String title;
  final double amount;
  final String type;
  final int walletId;
  final int categoryId;
  final DateTime date;
  final String? description;

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.walletId,
    required this.categoryId,
    required this.date,
    this.description,
  });
}
