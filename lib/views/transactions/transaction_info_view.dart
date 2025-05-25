import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:budgetfrontend/models/transaction_model.dart';
import 'package:budgetfrontend/views/transactions/add_transaction_view.dart'; // ✅ Edit хийхэд хэрэгтэй
import 'package:get/get.dart';
import 'package:budgetfrontend/controllers/transaction_controller.dart';

Future<void> showTransactionDetailDialog(
  
    BuildContext context, TransactionModel transaction) {
       print('💬 showTransactionDetailDialog called: ${transaction.transactionName}');
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => TransactionDetailContent(transaction: transaction),
  );
}

class TransactionDetailContent extends StatelessWidget {
  final TransactionModel transaction;
  const TransactionDetailContent({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.transactionType == 'income';
    final TransactionController transactionController = Get.find<TransactionController>();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.85,
      minChildSize: 0.4,
      builder: (_, controller) {
        return Stack(
          clipBehavior: Clip.none, // ⬅️ Container-аас гарч тавихыг зөвшөөрнө
          children: [
            Container(
              padding: const EdgeInsets.only(top: 70, left: 20, right: 20, bottom: 10), // 👈 Дээдээс зай авна (icon гаргаж тавих гэж)
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: ListView(
                controller: controller,
                children: [
                  Center(
                    child: Text(
                      "Гүйлгээний дэлгэрэнгүй",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  _buildDetailRow("Огноо:", DateFormat('yyyy-MM-dd').format(DateTime.parse(transaction.transactionDate))),
                  _buildDetailRow("Төрөл:", isIncome ? "Орлого" : "Зарлага"),
                  _buildDetailRow("Дүн:", "${transaction.transactionAmount.toStringAsFixed(2)}₮"),
                  _buildDetailRow("Тайлбар:", transaction.transactionName.isNotEmpty ? transaction.transactionName : "—"),
                  _buildDetailRow("Хэтэвч:", transaction.walletType == 'family' ? "Family Wallet" : "Private Wallet"),

                  const SizedBox(height: 15),

             Padding(
  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween, // ➡️ Зүүнд Delete, Баруунд Edit
    children: [
      // Устгах товч
      TextButton.icon(
        onPressed: () async {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Баталгаажуулах'),
              content: const Text('Энэ гүйлгээг устгах уу?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Үгүй'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('Тийм'),
                ),
              ],
            ),
          );
          if (confirmed == true) {
            await transactionController.deleteTransaction(transaction.id!);
            Navigator.pop(context);
            Get.snackbar(
              "Амжилттай", "Гүйлгээг устгалаа",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.greenAccent,
            );
          }
        },
        icon: const Icon(Icons.delete_sharp, color: Colors.red),
        label: const Text(
          "Устгах",
          style: TextStyle(
            color: Colors.red,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // Засах товч
      TextButton.icon(
        onPressed: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddTransactionView(
                type: transaction.transactionType ?? 'expense',
                editTransaction: transaction,
              ),
            ),
          );
        },
        icon: const Icon(Icons.edit, color: Colors.blue),
        label: const Text(
          "Засах",
          style: TextStyle(
            color: Colors.blue,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  ),
),

                  const SizedBox(height: 10),
               
                ],
              ),
            ),
   

            // ⬆️ Positioned дээр CATEGORY ICON тавина
            
           Positioned(
  top: -40,
  left: 0,
  right: 0,
  child: Center(
    child: Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // Доод талын өнгөт сүүдэртэй давхарга
        Container(
          width: 85,
          height: 85,
          decoration: BoxDecoration(
            color: transaction.category?.safeColor ?? Colors.grey,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: (transaction.category?.safeColor ?? Colors.grey).withOpacity(0.6),
                blurRadius: 10,
                offset: const Offset(0, 2.5), // доош чиглэсэн сүүдэр
              ),
            ],
          ),
        ),
        
        // Дээд талын цагаан сүүдэртэй давхарга
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: transaction.category?.safeColor ?? Colors.grey.shade300,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.9),
                blurRadius: 10,
                offset: const Offset(0, -2.5), // дээш чиглэсэн сүүдэр
              ),
            ],
          ),
          child: Center(
            child: Icon(
              transaction.category?.iconData ?? Icons.category,
              size: 40,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  ),
),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }
}

