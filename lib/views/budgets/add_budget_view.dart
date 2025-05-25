import 'package:budgetfrontend/controllers/budget_controller.dart';
import 'package:budgetfrontend/models/budget_model.dart';
import 'package:budgetfrontend/models/category_model.dart';
import 'package:budgetfrontend/views/home/back_app_bar.dart';
import 'package:budgetfrontend/views/transactions/category_selecter_dialog.dart';
import 'package:budgetfrontend/widgets/blue_field_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class AddBudgetView extends StatefulWidget {
  final BudgetModel? editBudget;

  const AddBudgetView({Key? key, this.editBudget}) : super(key: key);

  @override
  State<AddBudgetView> createState() => _AddBudgetViewState();
}

class _AddBudgetViewState extends State<AddBudgetView> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.find<BudgetController>();

  final nameController = TextEditingController();
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  final List<String> accounts = ['Гэр бүлийн данс', 'Хувийн данс'];
  String selectedAccount = 'Хувийн данс';
  CategoryModel? selectedCategory;
  DateTime? startDate;
  DateTime? dueDate;
 int selectedDueDay = DateTime.now().day; // 🎯 Сонгогдсон сарын өдөр


  String? categoryError;
  bool showField = false;

  @override
void initState() {
  super.initState();
  // Add listener for formatting currency in ALL cases (not just edit)
  amountController.addListener(() {
    final text = amountController.text.replaceAll(RegExp(r'[^\d]'), '');
    if (text.isEmpty) {
      amountController.value = TextEditingValue(
        text: '',
        selection: const TextSelection.collapsed(offset: 0),
      );
    } else {
      final formatter = NumberFormat("#,##0", "mn");
      final newText = formatter.format(int.parse(text));
      amountController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    }
  });

  if (widget.editBudget != null) {
    final budget = widget.editBudget!;
    nameController.text = budget.budgetName;
    // amountController.text = budget.amount.toString(); // Үүнийг автоматаар форматлаж үзүүлнэ!
    amountController.text = NumberFormat("#,##0", "mn").format(budget.amount);
    descriptionController.text = budget.description;
    selectedAccount =
        budget.walletType == 'Family' ? 'Гэр бүлийн данс' : 'Хувийн данс';
    selectedDueDay = budget.payDueDate;
    selectedCategory = budget.category;
  } else {
    startDate = DateTime.now();
    dueDate = DateTime.now().add(const Duration(days: 30));
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        title: widget.editBudget != null ? 'Төсөв засах' : 'Төсөв нэмэх',
      ),
      backgroundColor: Colors.white,
      body: BlueTextFieldTheme(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FloatingLabelContainer(
                  label: 'Ангилал (Зарлага)',
                  child: InkWell(
                    onTap: () async {
                      final selected = await showCategorySelectorDialogByType(
                        context: context,
                        type: 'expense',
                        selectedCategory: selectedCategory,
                      );
                      if (selected != null) {
                        setState(() {
                          selectedCategory = selected;
                          categoryError = null;
                        });
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: categoryError != null
                                  ? Color.fromARGB(255, 175, 47, 38)
                                  : Colors.grey.shade400,
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
                                  selectedCategory?.categoryName ?? 'Ангилал сонгох',
                                  style: TextStyle(
                                    color: selectedCategory == null ? Colors.grey : Colors.black,
                                  ),
                                ),
                              ),
                              const Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                        if (categoryError != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 12, top: 5),
                            child: Text(
                              categoryError!,
                              style: const TextStyle(color: Color.fromARGB(255, 175, 47, 38), fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
  controller: nameController,
  keyboardType: TextInputType.text,
  decoration: InputDecoration(
    labelText: 'Төсвийн нэр',
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
      return 'Төсвийн нэр оруулна уу!';
    }
    return null;
  },
),
                const SizedBox(height: 16),
                   TextFormField(
  controller: amountController,
  keyboardType: TextInputType.number,
  decoration: InputDecoration(
    labelText: 'Үнийн дүн',
    prefix: const Text('₮ ', style: TextStyle(fontWeight: FontWeight.bold)),
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
    return 'Үнийн дүн оруулна уу!';
  }
  final onlyDigits = value.replaceAll(RegExp(r'[^\d]'), '');
  if (onlyDigits.isEmpty || double.tryParse(onlyDigits) == null || double.parse(onlyDigits) <= 0) {
    return 'Боломжгүй үнийн дүн байна ';
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
    labelText: 'Данс',
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
 const SizedBox(height: 16),
 Center(
  child: TextButton(
    onPressed: () {
      setState(() {
        showField = !showField; // ✅ toggle хийх
      });
    },
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          showField ? "Нуух" : "Цааш",
          style: const TextStyle(color: Colors.blue),
        ),
        const SizedBox(width: 4),
        Icon(
          showField ? Icons.arrow_drop_up : Icons.arrow_drop_down,
          color: Colors.blue,
        ),
      ],
    ),
  ),
),
                const SizedBox(height: 16),
               if (showField) ...[
                TextFormField(
    controller: descriptionController,
    minLines: 3,
    maxLines: 5,
    keyboardType: TextInputType.multiline,
    decoration: InputDecoration(
      labelText: 'Тайлбар',
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelStyle: TextStyle(
        color: Colors.grey.shade400,
      ),
      floatingLabelStyle: TextStyle(
        color: const Color.fromARGB(255, 138, 137, 137),
        fontWeight: FontWeight.bold,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      fillColor: Colors.white,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Color.fromARGB(255, 179, 178, 178)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.blue, width: 1.5),
      ),
    ),
    style: const TextStyle(fontSize: 16),
  ),
  const SizedBox(height: 16),
  Text("Сануулга", style: TextStyle(fontWeight: FontWeight.w500)),
  SizedBox(height: 5),
  Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
    decoration: BoxDecoration(
      border: Border.all(
        color: const Color.fromARGB(255, 185, 185, 185),
        width: 1.5,
      ),
      borderRadius: BorderRadius.circular(20),
      color: Colors.white,
    ),
    child: buildMonthlyDueDateSelector(),
  ),
  const SizedBox(height: 16),
  
],
                // const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: saveBudget,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    backgroundColor: Colors.blue,
                  ),
                  child: Text(
                    widget.editBudget != null ? 'Засах' : 'Үүсгэх',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.blue, width: 1.5),
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  child: const Text(
                    'Цуцлах',
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

  InputDecoration _inputDecoration(String label) => InputDecoration(
        labelText: label.isNotEmpty ? label : null,
        floatingLabelStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Colors.grey)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Colors.blue, width: 1.5)),
      );

  void saveBudget() async {
  if (_formKey.currentState!.validate() && selectedCategory != null) {
    final walletType = selectedAccount == 'Гэр бүлийн данс' ? 'family' : 'private';

    // 🔥 Тоон утгыг зөв авч байгаа эсэх
    final onlyDigits = amountController.text.replaceAll(RegExp(r'[^\d]'), '');
    final amount = onlyDigits.isEmpty ? 0.0 : double.parse(onlyDigits);

    final budget = BudgetModel(
      id: widget.editBudget?.id ?? 0,
      budgetName: nameController.text.trim(),
      amount: amount, // <-- Форматлагдсан утга биш, зөвхөн тоон утга!
      payDueDate: selectedDueDay,
      description: descriptionController.text.trim(),
      walletType: walletType == 'family' ? 'Family' : 'Private',
      categoryId: selectedCategory!.id!,
      category: selectedCategory,
    );

    if (widget.editBudget != null) {
      await controller.updateBudget(widget.editBudget!.id, budget);
    } else {
      await controller.createBudget(budget);
    }
    Navigator.pop(context);
  } else {
    setState(() {
      if (selectedCategory == null) categoryError = 'Ангилал сонгоно уу!';
    });
  }
}

Widget buildMonthlyDueDateSelector() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const Text(
        'Сарын төлбөрийн хугацаа',
        style: TextStyle(
          fontSize: 12,
          // fontWeight: FontWeight.w600,
          color: Color.fromARGB(221, 39, 39, 39),
        ),
      ),
      SizedBox(width: 0),
      Row(
        children: [
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.orange, size: 24),
            onPressed: () {
              setState(() {
                if (selectedDueDay <= 1) {
                  selectedDueDay = 1;
                } else {
                  selectedDueDay = selectedDueDay - 1;
                }
              });
            },
          ),
          // const SizedBox(width: 2),
          Text(
           selectedDueDay.toString(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 102, 102, 102),
            ),
          ),
          // const SizedBox(width: 2),
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_up_rounded, color: Colors.green, size: 24),
            onPressed: () {
              setState(() {
                if (selectedDueDay == null || selectedDueDay! >= 31) {
                  selectedDueDay = 31;
                } else {
                  selectedDueDay = selectedDueDay! + 1;
                }
              });
            },
          ),
        ],
      ),
    ],
  );
}
}

class FloatingLabelContainer extends StatelessWidget {
  final String label;
  final Widget child;

  const FloatingLabelContainer({Key? key, required this.label, required this.child}) : super(key: key);

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
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}

String formatCurrency(String value) {
  if (value.isEmpty) return "₮ 0";
  final onlyDigits = value.replaceAll(RegExp(r'[^\d]'), '');
  if (onlyDigits.isEmpty) return "₮ 0";
  final number = int.parse(onlyDigits);
  final formatter = NumberFormat("#,##0", "mn");
  return "₮ ${formatter.format(number)}";
}

