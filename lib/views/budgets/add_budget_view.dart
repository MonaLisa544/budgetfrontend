import 'package:budgetfrontend/models/category_model.dart';
import 'package:budgetfrontend/models/transaction_model.dart';
import 'package:budgetfrontend/services/api_service.dart';
import 'package:budgetfrontend/views/home/back_app_bar.dart';
import 'package:budgetfrontend/views/transactions/category_selecter_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddBudgetView extends StatefulWidget {
  //final String type;
  const AddBudgetView({super.key});

  @override
  State<AddBudgetView> createState() => _AddBudgetViewState();
}

class _AddBudgetViewState extends State<AddBudgetView> {
  List<CategoryModel> categoryList = [];
  CategoryModel? selectedCategory;
  final _formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final nameController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  bool isPaid = true;
  final List<String> accounts = ['None', 'Family Wallet', 'Private Wallet'];
  String selectedAccount = 'None';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(title: 'Add New Budget'),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            
              const SizedBox(height: 16),
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              FloatingLabelContainer(
                label: 'Account',
                child: DropdownButtonFormField<String>(
                  value: selectedAccount,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                  ),
                  items: accounts.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (value) => setState(() => selectedAccount = value!),
                ),
              ),
              const SizedBox(height: 16),
              FloatingLabelContainer(
                label: 'Date',
                child: InkWell(
                  onTap: pickDate,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(DateFormat('dd MMM yyyy').format(selectedDate)),
                        const Icon(Icons.calendar_today, size: 18),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "MORE",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // ElevatedButton(
              //   onPressed: () {}
              //   async {
              //     if (_formKey.currentState!.validate() && selectedCategory != null) {
              //       final txn = TransactionModel(
              //         transactionName: nameController.text.trim(),
              //         transactionAmount: double.tryParse(amountController.text.trim()) ?? 0.0,
              //         //transactionType: widget.type,
              //         // transactionDate: selectedDate,
              //         categoryId: selectedCategory!.id!,
              //         // walletId: selectedAccount == 'Family Wallet' ? 1 : 2,
              //       );

              //       await ApiService.postTransaction(txn);
              //       Navigator.pop(context, true);
              //     } else {
              //       ScaffoldMessenger.of(context).showSnackBar(
              //         const SnackBar(content: Text('Please fill all required fields')),
              //       );
              //     }
              //   },
              //   style: ElevatedButton.styleFrom(
              //     minimumSize: const Size.fromHeight(48),
              //     backgroundColor: Colors.blue,
              //   ),
              //   child: const Text("Create"),
              // ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }
}

class FloatingLabelContainer extends StatelessWidget {
  final String label;
  final Widget child;

  const FloatingLabelContainer({
    Key? key,
    required this.label,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(margin: const EdgeInsets.only(top: 12), child: child),
        Positioned(
          left: 13,
          top: 3,
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
