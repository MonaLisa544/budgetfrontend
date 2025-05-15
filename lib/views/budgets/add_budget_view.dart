import 'package:budgetfrontend/controllers/budget_controller.dart';
import 'package:budgetfrontend/models/budget_model.dart';
import 'package:budgetfrontend/models/category_model.dart';
import 'package:budgetfrontend/views/home/back_app_bar.dart';
import 'package:budgetfrontend/views/transactions/category_selecter_dialog.dart';
import 'package:budgetfrontend/widgets/blue_field_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

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
  DateTime selectedDate = DateTime.now();
  final List<String> accounts = ['Family Wallet', 'Private Wallet'];
  String selectedAccount = 'Family Wallet';
  CategoryModel? selectedCategory;
  DateTime? startDate;
  DateTime? dueDate;
 late int selectedDueDay; // 🎯 Сонгогдсон сарын өдөр


  String? categoryError;
  bool showField = false;

  @override
  void initState() {
    super.initState();
    if (widget.editBudget != null) {
      final budget = widget.editBudget!;
      nameController.text = budget.budgetName;
      amountController.text = budget.amount.toString();
      descriptionController.text = budget.description;
      selectedAccount =
          budget.ownerType == 'Family' ? 'Family Wallet' : 'Private Wallet';
      startDate = DateTime.parse(budget.startDate);
      dueDate = DateTime.parse(budget.dueDate);
      selectedDate = DateTime.parse(budget.payDueDate);
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
        title: widget.editBudget != null ? 'Edit Budget' : 'Add Budget',
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
                  label: 'Category (Expense)',
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
                                  selectedCategory?.categoryName ?? 'Choose category',
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
                               const Text(
                  "MORE",
                  style: TextStyle(color: Colors.blue),
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
                Text("Reminder", style: TextStyle(fontWeight: FontWeight.w500)),
                SizedBox(height: 5),
            Container(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
  decoration: BoxDecoration(
    border: Border.all(
      color: const Color.fromARGB(255, 185, 185, 185), // 🎯 Хүрээний өнгө
      width: 1.5,         // 🎯 Хүрээний зузаан
    ),
    borderRadius: BorderRadius.circular(20), // 🎯 Буланг дугуйруулна
    color: Colors.white, // 🎯 Дотор фонт цагаан
  ),
  child: buildMonthlyDueDateSelector(),
),
                FloatingLabelContainer(
                  label: 'Pay Due Date',
                  child: InkWell(
                    onTap: () => pickExpectedDate(context),
                    child: InputDecorator(
                      decoration: _inputDecoration(''),
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
  controller: descriptionController,
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
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: saveBudget,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    backgroundColor: Colors.blue,
                  ),
                  child: Text(
                    widget.editBudget != null ? 'Update' : 'Create',
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
      final walletType = selectedAccount == 'Family Wallet' ? 'family' : 'private';

      final budget = BudgetModel(
        id: widget.editBudget?.id ?? 0,
        budgetName: nameController.text.trim(),
        amount: double.tryParse(amountController.text.trim()) ?? 0.0,
        usedAmount: widget.editBudget?.usedAmount ?? 0.0,
        startDate: DateFormat('yyyy-MM-dd').format(startDate!),
        dueDate: DateFormat('yyyy-MM-dd').format(dueDate!),
        payDueDate: DateFormat('yyyy-MM-dd').format(selectedDate),
        status: 'active',
        description: descriptionController.text.trim(),
        statusLabel: 'Active',
        ownerType: walletType == 'family' ? 'Family' : 'Private',
        ownerId: 0,
        walletId: 0,
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
        if (selectedCategory == null) categoryError = 'Please choose a category';
      });
    }
  }

   void pickExpectedDate(BuildContext context) {
  DateTime tempPickedDate = selectedDate; // 🎯 selectedDate-ийг түр хадгална

  showCupertinoModalPopup(
    context: context,
    useRootNavigator: true,
    builder: (popupContext) => Container(
      height: 300,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: selectedDate, // 🎯 selectedDate эхлэх
              minimumDate: DateTime(2020, 1, 1),
              maximumDate: DateTime(2035, 12, 31),
              onDateTimeChanged: (DateTime newDate) {
                tempPickedDate = newDate; // 🎯 Түр хадгална
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CupertinoButton(
                child: const Text('OK', style: TextStyle(color: Colors.blue)),
                onPressed: () {
                  setState(() {
                    selectedDate = tempPickedDate; // 🎯 OK дархад selectedDate-г онооно
                  });
                  Navigator.of(popupContext).pop();
                },
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
Widget buildMonthlyDueDateSelector() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const Text(
        'Monthly Due Date',
        style: TextStyle(
          fontSize: 14,
          // fontWeight: FontWeight.w600,
          color: Color.fromARGB(221, 39, 39, 39),
        ),
      ),
      SizedBox(width: 30),
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
