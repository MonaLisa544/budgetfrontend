import 'package:budgetfrontend/controllers/transaction_controller.dart';
import 'package:budgetfrontend/models/category_model.dart';
import 'package:budgetfrontend/models/transaction_model.dart';
import 'package:budgetfrontend/views/home/back_app_bar.dart';
import 'package:budgetfrontend/views/transactions/category_selecter_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:budgetfrontend/widgets/blue_field_text_theme.dart';
import 'package:get/get.dart';

import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

class AddTransactionView extends StatefulWidget {
  final String type;
  final TransactionModel? editTransaction;

  const AddTransactionView({
    super.key,
    required this.type,
    this.editTransaction,
  });

  @override
  State<AddTransactionView> createState() => _AddTransactionViewState();
}

class _AddTransactionViewState extends State<AddTransactionView> {
  bool showMoreFields = false;
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
    bool showNoteField = false; // ✅ More дээр дарсан эсэх
  final TextEditingController noteController = TextEditingController();
  String? categoryError; // 🎯


  @override
  void initState() {
    super.initState();

    if (widget.editTransaction != null) {
      // 🔥 Өмнө бөглөгдсөн утгуудыг оруулах
      amountController.text =
          widget.editTransaction!.transactionAmount.toString();
      nameController.text = widget.editTransaction!.transactionName;
      selectedDate = DateTime.parse(widget.editTransaction!.transactionDate);
      selectedCategory = widget.editTransaction!.category;
      isPaid = true; // example
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        title:
            widget.editTransaction != null
                ? 'Edit ${widget.type}'
                : 'Add ${widget.type}',
      ),
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
          categoryError = null; // ✅ Сонгочихвол алдааг арилгана
        });
      }
    },
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(
      color: categoryError != null 
          ? const Color.fromARGB(255, 175, 47, 38)              // 🎯 Алдаа байгаа үед улаан хүрээ
          : Colors.grey.shade400,    // 🎯 Алдаа байхгүй үед саарал хүрээ
    ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Icon(
                selectedCategory?.iconData ?? Icons.category,
                color: selectedCategory?.safeColor ?? Colors.grey,
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
        if (categoryError != null) // ✅ Алдаа байвал доор улаан текст
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 5),
            child: Text(
              categoryError!,
              style: const TextStyle(
                color: Color.fromARGB(255, 187, 50, 40),
                fontSize: 12,
              ),
            ),
          ),
      ],
    ),
  ),
),

                const SizedBox(height: 16),
               TextFormField(
  controller: amountController,
  keyboardType: TextInputType.number,
  decoration: InputDecoration(
    labelText: 'Amount',
    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
    labelStyle: const TextStyle(
      color: Colors.grey,
    ),
    floatingLabelStyle: const TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
    ),
    suffixIcon: Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Icon(
        Icons.currency_exchange,
        size: 24,
        color: Colors.blueGrey,
      ),
    ),
    
    // 🎯 Эдгээрийг нэмнэ:
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20), // Булангуудыг дугуйруулна
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Colors.blue, width: 1.5),
    ),
  ),
   validator: (value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter amount';
    }
    if (double.tryParse(value) == null || double.parse(value) <= 0) {
      return 'Enter a valid amount';
    }
    return null;
  },
),

                const SizedBox(height: 16),
        DropdownButtonFormField<String>(
  value: selectedAccount,
  isExpanded: true, // ✅ Field дотор item бүрэн сунана
  icon: const Icon(Icons.arrow_drop_down),
  elevation: 4,
  dropdownColor: Colors.white,
  borderRadius: BorderRadius.circular(16),
  decoration: InputDecoration(
    labelText: 'Account',
    floatingLabelStyle: const TextStyle(
      color: Colors.black38,
      fontWeight: FontWeight.bold,
    ),
    labelStyle: const TextStyle(
      color: Colors.black38,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Colors.grey),
    ),
  ),
  
  selectedItemBuilder: (BuildContext context) {
    return accounts.map<Widget>((e) {
      return Row(
        children: [
          Image.asset(
            'assets/icon/MasterCard_Logo.svg.png',
            width: 35,
            height: 30,
          ),
          const SizedBox(width: 8),
          Text(
            e,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      );
    }).toList();
  },

  items: accounts.map((e) {
    return DropdownMenuItem<String>(
      value: e,
      child: Row(
        children: [
          if (e == selectedAccount) ...[
            const Icon(
              Icons.check,
              color: Colors.grey,
              size: 18,
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              e,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }).toList(),

  onChanged: (value) {
    setState(() {
      selectedAccount = value!;
    });
  },
),


                const SizedBox(height: 10),
              FloatingLabelContainer(
  label: 'Date',
  child: InkWell(
    onTap: pickDate,
    borderRadius: BorderRadius.circular(20), // ✅ InkWell даралт бас зөөлөн болно
    child: InputDecorator(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14), // ✅ Дотор Padding
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20), // ✅ Булангийн radius
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.blue, width: 1.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat('dd MMM yyyy').format(selectedDate),
            style: const TextStyle(fontSize: 16),
          ),
          const Icon(Icons.calendar_today, size: 18),
        ],
      ),
    ),
  ),
),
                const SizedBox(height: 16),
                   TextFormField(
  controller: nameController,
  keyboardType: TextInputType.number,
  decoration: InputDecoration(
    labelText: 'Name',
    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    labelStyle: const TextStyle(
      color: Colors.grey,
    ),
    floatingLabelStyle: const TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
    ),
    
    // 🎯 Эдгээрийг нэмнэ:
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20), // Булангуудыг дугуйруулна
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Colors.blue, width: 1.5),
    ),
  ),
   validator: (value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter name';
    }
    return null;
  },
),
                const SizedBox(height: 5),
               Center(
                 child: TextButton(
                           onPressed: () {
                             setState(() {
                               showNoteField = !showNoteField; // ✅ toggle хийх
                             });
                           },
                           child: Row(
                             mainAxisSize: MainAxisSize.min,
                             children: [
                               const Text(
                  "MORE",
                  style: TextStyle(color: Colors.blue),
                               ),
                               const SizedBox(width: 4),
                               Icon(
                  showNoteField ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: Colors.blue,
                               ),
                             ],
                           ),
                         ),
               ),
         // ✅ "MORE" дээр дарахад гарч ирэх NOTE хэсэг
        if (showNoteField) ...[
          const SizedBox(height: 0),

        TextFormField(
  controller: noteController,
  minLines: 3,
  maxLines: 5,
  keyboardType: TextInputType.multiline,
  decoration: InputDecoration(
    labelText: 'Notes', // 🎯 LabelText ашиглана
    floatingLabelBehavior: FloatingLabelBehavior.auto, // 🎯 Auto дээш хөөрдөг
    labelStyle: TextStyle(
      color: Colors.grey.shade400,
    ),
    floatingLabelStyle: TextStyle(
      color: const Color.fromARGB(255, 138, 137, 137),
      fontWeight: FontWeight.bold,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    fillColor: const Color.fromARGB(255, 255, 255, 255), // 🎯 Арын фонт
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: const Color.fromARGB(255, 179, 178, 178)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: Colors.blue, width: 1.5),
    ),
  ),
  style: const TextStyle(fontSize: 16),
),
          const SizedBox(height: 16),
        ],
                const SizedBox(height: 5),
                ElevatedButton(
                onPressed: () async {
  bool isValid = _formKey.currentState!.validate();

  if (selectedCategory == null) {
    setState(() {
      categoryError = 'Please choose a category';
    });
    isValid = false;
  } else {
    setState(() {
      categoryError = null;
    });
  }

  if (isValid) {
    final walletType = selectedAccount == 'Family Wallet' ? 'family' : 'private';

    final txn = TransactionModel(
      transactionName: nameController.text.trim(),
      transactionAmount: double.tryParse(amountController.text.trim()) ?? 0.0,
      transactionDate: DateFormat('yyyy-MM-dd').format(selectedDate),
      categoryId: selectedCategory!.id!,
      walletType: walletType,
    );

    if (widget.editTransaction != null) {
      await transactionController.updateTransaction(txn); // ✅ SnackBar Controller дээр
    } else {
      await transactionController.createTransaction(txn, walletType); // ✅ SnackBar Controller дээр
    }

    Navigator.pop(context); // ✅ Save амжилттай болсон тул буцна
  } else {
    // ❗ Validation алдаатай үед зөвхөн энд Snackbar харуулна
    showTopErrorSnackBar('Please fill all required fields');
  }
},
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    backgroundColor: Colors.blue,
                  ),
                  child: Text(
                    widget.editTransaction != null ? "Update" : "Create",
                  ),
                ),
                SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Colors.blue,
                      width: 1.5,
                    ), // Хүрээний өнгө
                    minimumSize: const Size.fromHeight(48), // Өндөр
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void showTopErrorSnackBar(String message) {
  showTopSnackBar(
    Get.overlayContext! as OverlayState,
    CustomSnackBar.error(
      message: message,
      backgroundColor: Colors.red,
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
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
              shape: RoundedRectangleBorder(
                // ✅ булантай dialog
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
