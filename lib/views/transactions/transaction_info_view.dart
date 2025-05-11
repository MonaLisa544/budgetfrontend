import 'package:flutter/material.dart';

Future<void> showTransactionDetailDialog(
    BuildContext context, Map<String, dynamic> transaction) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => TransactionDetailContent(transaction: transaction),
  );
}

class TransactionDetailContent extends StatelessWidget {
  final Map<String, dynamic> transaction;
  const TransactionDetailContent({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.55,
      maxChildSize: 0.8,
      minChildSize: 0.4,
      builder: (_, controller) {
        return Container(
          padding: const EdgeInsets.all(20),
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
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
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
              const SizedBox(height: 20),
              CircleAvatar(
                        radius: 45,
                        backgroundImage: NetworkImage(
                          'https://i.pravatar.cc/150?img=10',
                        ),
                      ),
              _buildDetailRow("Огноо:", transaction['date']),
              _buildDetailRow("Төрөл:", transaction['type']), // income/expense
              _buildDetailRow("Дүн:", "${transaction['amount']}₮"),
              _buildDetailRow("Категори:", transaction['category_name']),
              _buildDetailRow("Тайлбар:", transaction['note'] ?? "—"),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
                label: const Text("Хаах"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size.fromHeight(45),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(value ?? "—", style: const TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }
}
