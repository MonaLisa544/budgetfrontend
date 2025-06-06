import 'package:budgetfrontend/models/transaction_model.dart';
import 'package:budgetfrontend/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Та TransactionModel, TransactionItem зэрэг классуудаа импортлоорой

class TransactionListWithScroll extends StatelessWidget {
  final List<TransactionModel> transactions;
  final ScrollController scrollController;
  final String Function(double) formatCurrency;
  final void Function(BuildContext, TransactionModel) showTransactionDetailDialog;

  const TransactionListWithScroll({
    super.key,
    required this.transactions,
    required this.scrollController,
    required this.formatCurrency,
    required this.showTransactionDetailDialog,
  });

  Map<String, List<TransactionModel>> groupTransactionsByDate(
    List<TransactionModel> transactions,
  ) {
    Map<String, List<TransactionModel>> grouped = {};

    for (var txn in transactions) {
      final date = DateFormat('yyyy-MM-dd').format(DateTime.parse(txn.transactionDate));
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(txn);
    }

    return grouped;
  }

 @override
Widget build(BuildContext context) {
  final grouped = groupTransactionsByDate(transactions);

  return ListView(
    controller: scrollController,
    physics: const AlwaysScrollableScrollPhysics(), // scrollable хэвээр
    padding: const EdgeInsets.only(bottom: 30),
    children: transactions.isEmpty
        ? [
            SizedBox(height: 60),
            Center(
              child: Text(
                'Гүйлгээ олдсонгүй.',
                style: TextStyle(color: Colors.black54, fontSize: 16),
              ),
            ),
            SizedBox(height: 250), // Sheet-ээ сунгаж багасгаж болохоор хангалттай хоосон зай
          ]
        : grouped.entries.map((entry) {
            final date = entry.key;
            final txnList = entry.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 3, top: 15, left: 25),
                  child: Text(
                    date,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 185, 185, 185),
                    ),
                  ),
                ),
                ...txnList.map((txn) {
                  final isIncome = txn.transactionType == 'income';
                  final amountText =
                      (isIncome ? '+ ' : '- ') +
                      formatCurrency(txn.transactionAmount);

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 1.0,
                      horizontal: 0.0,
                    ),
                    child: TransactionItem(
                      iconData: txn.category?.iconData ?? Icons.category,
                      iconColor: txn.category?.safeColor ?? Colors.grey,
                      title: txn.transactionName,
                      subtitle: txn.category?.categoryName ?? txn.transactionName,
                      amount: amountText,
                      onPressed: () {
                        showTransactionDetailDialog(context, txn);
                      },
                    ),
                  );
                }).toList(),
              ],
            );
          }).toList(),
  );
} }
