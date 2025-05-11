import 'package:budgetfrontend/controllers/transaction_controller.dart';
import 'package:budgetfrontend/models/category_model.dart';
import 'package:budgetfrontend/models/transaction_model.dart';
import 'package:budgetfrontend/services/api_service.dart';
import 'package:budgetfrontend/views/home/back_app_bar.dart';
import 'package:budgetfrontend/views/transactions/category_selecter_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:budgetfrontend/widgets/blue_field_text_theme.dart';
import 'package:get/get.dart';

class AddTransactionView extends StatefulWidget {
  final String type;
  const AddTransactionView({super.key, required this.type});

  @override
  State<AddTransactionView> createState() => _AddTransactionViewState();
}

class _AddTransactionViewState extends State<AddTransactionView> {
  final transactionController = Get.put(TransactionController());
  List<CategoryModel> categoryList = [];
  CategoryModel? selectedCategory;
  final _formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final nameController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  bool isPaid = true;
  final List<String> accounts = ['Family Wallet', 'Private Wallet'];
  String selectedAccount = 'Private Wallet';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(title: 'Add ${widget.type}'),
      backgroundColor: Colors.white,
      body: BlueTextFieldTheme(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               FloatingLabelContainer(
  label: 'Category (${widget.type})',
  child: InkWell(
    onTap: () async {
      final selected = await showCategorySelectorDialogByType(
        context: context,
        type: widget.type,
        selectedCategory: selectedCategory,
      );
      if (selected != null) {
        setState(() {
          selectedCategory = selected;
        });
      }
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            selectedCategory?.iconData ?? Icons.category, // ✅ Сонгосон icon
            color: selectedCategory?.safeColor ?? Colors.grey, // ✅ Сонгосон өнгө
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              selectedCategory?.categoryName ?? "Choose category",
              style: TextStyle(
                color: selectedCategory == null ? Colors.grey : Colors.black,
              ),
            ),
          ),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
    ),
  ),
),

                const SizedBox(height: 16),
                TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
  value: selectedAccount,
  isExpanded: true, // ✅ input width-тэй таарна
  icon: const Icon(Icons.keyboard_arrow_down_rounded),
  elevation: 4,
  dropdownColor: Colors.white,
  borderRadius: BorderRadius.circular(16), // ✅ popup dropdown булан

  decoration: InputDecoration(
    labelText: 'Account',
    floatingLabelStyle: const TextStyle(color: Color.fromARGB(221, 134, 134, 134), fontWeight: FontWeight.bold,),
    labelStyle: const TextStyle(color: Colors.black87),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.blue, width: 1.5),
    ),
  ),

  items: accounts.map((e) {
    return DropdownMenuItem<String>(
      value: e,
      child: Text(
        e,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }).toList(),

  onChanged: (value) => setState(() => selectedAccount = value!),
),

                const SizedBox(height: 16),
                FloatingLabelContainer(
                  label: 'Date',
                  child: InkWell(
                    onTap: pickDate,
                    child: InputDecorator(
                      decoration: const InputDecoration(),
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
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {},
                    child: const Text("MORE", style: TextStyle(color: Colors.blue)),
                  ),
                ),
                const SizedBox(height: 24),
              ElevatedButton(
  onPressed: () async {
    if (_formKey.currentState!.validate() && selectedCategory != null) {
      final walletType = selectedAccount == 'Family Wallet' ? 'family' : 'private'; // ✅ түрүүлж сонгоно

      final txn = TransactionModel(
        transactionName: nameController.text.trim(),
        transactionAmount: double.tryParse(amountController.text.trim()) ?? 0.0,
        transactionDate: DateFormat('yyyy-MM-dd').format(selectedDate),
        categoryId: selectedCategory!.id!,
        walletType: walletType, // ✅ энд walletType-г оруулна
      );

      // ✅ Зөвхөн txn дамжуулна
       await transactionController.createTransaction(txn, walletType);

      // ✅ Амжилттай нэмэгдсэн Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction added successfully')),
      );

      // ✅ Буцаад transactions дэлгэц рүү шилжинэ
      Navigator.pop(context);

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
    }
  },
  style: ElevatedButton.styleFrom(
    minimumSize: const Size.fromHeight(48),
    backgroundColor: Colors.blue,
  ),
  child: const Text("Create"),
),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
              ],
            ),
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

    // ✅ Гоёчилсон сэдэв
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          dialogBackgroundColor: Colors.white,
          colorScheme: const ColorScheme.light(
            primary: Colors.blue, // ✅ header background, OK/Cancel
            onPrimary: Colors.white, // ✅ header text color
            onSurface: Colors.black, // ✅ body text color
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue, // ✅ button text color
            ),
          ),
          datePickerTheme: const DatePickerThemeData(
            
            shape: RoundedRectangleBorder( // ✅ булантай dialog
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          ),
        ),
        child: child!,
      );
    },
  );

  if (picked != null) {
    setState(() => selectedDate = picked);
  }
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
