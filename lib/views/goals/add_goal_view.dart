import 'package:budgetfrontend/views/home/back_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:budgetfrontend/controllers/goal_controller.dart';
import 'package:budgetfrontend/models/goal_model.dart';
import 'package:budgetfrontend/widgets/blue_field_text_theme.dart';
import 'package:flutter/cupertino.dart';

class AddGoalView extends StatefulWidget {
  final GoalModel? editGoal;
  const AddGoalView({Key? key, this.editGoal}) : super(key: key);

  @override
  State<AddGoalView> createState() => _AddGoalViewState();
}

class _AddGoalViewState extends State<AddGoalView> {
  final _formKey = GlobalKey<FormState>();
  final goalController = Get.put(GoalController());

  final nameController = TextEditingController();
  final targetAmountController = TextEditingController();
  final descriptionController = TextEditingController();
  final startingAmountController = TextEditingController();
  final monthlyPaidAmountController = TextEditingController();

  final List<String> accounts = ['Гэр бүлийн данс', 'Хувийн данс'];
  // Mongol label + English value хослуул
final List<Map<String, String>> goalTypes = [
  {'label': 'Хадгаламж', 'value': 'saving'},
  {'label': 'Зээл', 'value': 'loan'},
];
String selectedGoalType = 'saving'; // default утга
  String selectedAccount = 'Хувийн данс';
  // String selectedGoalType = 'Хадгаламж';
  int selectedDueDay = DateTime.now().day;
  bool showField = false;
  String? selectedDateError;
  DateTime startDate = DateTime.now();
  DateTime? selectedDate;

 @override
void initState() {
  super.initState();

  // 🔥 Format all currency fields
  void setupCurrencyFormatter(TextEditingController controller) {
    controller.addListener(() {
      String text = controller.text.replaceAll(RegExp(r'[^\d]'), '');
      if (text.isEmpty) {
        controller.value = TextEditingValue(
          text: '',
          selection: const TextSelection.collapsed(offset: 0),
        );
      } else {
        final formatter = NumberFormat("#,##0", "mn");
        String newText = formatter.format(int.parse(text));
        controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: newText.length),
        );
      }
    });
  }

  setupCurrencyFormatter(targetAmountController);
  setupCurrencyFormatter(startingAmountController);
  setupCurrencyFormatter(monthlyPaidAmountController);

  if (widget.editGoal != null) {
    final goal = widget.editGoal!;
    nameController.text = goal.goalName;
    targetAmountController.text = NumberFormat("#,##0", "mn").format(goal.targetAmount);
    descriptionController.text = goal.description ?? '';
    selectedGoalType = goal.goalType;
    selectedAccount = goal.walletType == 'family' ? 'Гэр бүлийн данс' : 'Хувийн данс';
    selectedDueDay = goal.monthlyDueDay;
    startDate = DateTime.tryParse(goal.startDate.toString()) ?? DateTime.now();
    selectedDate = DateTime.tryParse(goal.expectedDate.toString());
    startingAmountController.text = goal.savedAmount != null
        ? NumberFormat("#,##0", "mn").format(goal.savedAmount)
        : '';
    monthlyPaidAmountController.text = goal.monthlyDueAmount != null
        ? NumberFormat("#,##0", "mn").format(goal.monthlyDueAmount)
        : '';
  }
}

  @override
  void dispose() {
    nameController.dispose();
    targetAmountController.dispose();
    descriptionController.dispose();
    startingAmountController.dispose();
    monthlyPaidAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        title: widget.editGoal != null ? 'Зорилго засах' : 'Зорилго нэмэх',
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
                 TextFormField(
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  autofocus: true, // Name учраас number биш текст болгоно
                  decoration: InputDecoration(
                    labelText: 'Зорилгын нэр',
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    labelStyle: const TextStyle(
                      color: Color.fromARGB(255, 131, 131, 131),
                      fontWeight: FontWeight.w500,
                    ),
                    floatingLabelStyle: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Зорилгын нэр оруулна уу!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                  TextFormField(
                  controller: targetAmountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Үнийн дүн',
                    prefix: const Text('₮ ', style: TextStyle(fontWeight: FontWeight.bold)),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 20,
                    ),
                    labelStyle: const TextStyle(color: Colors.grey),
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
                      borderRadius: BorderRadius.circular(
                        20,
                      ), // Булангуудыг дугуйруулна
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 1.5,
                      ),
                    ),
                  ),
                  validator: (value) {
    if (value == null || value.trim().isEmpty) {
      return 'Үнийн дүн оруулна уу!';
    }
    final onlyDigits = value.replaceAll(RegExp(r'[^\d]'), '');
    if (onlyDigits.isEmpty || double.tryParse(onlyDigits) == null || double.parse(onlyDigits) <= 0) {
      return 'Боломжгүй үнийн дүн байна';
    }
    return null;
  },
                ),
                const SizedBox(height: 20),
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
                    labelStyle: const TextStyle(color: Colors.black38),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
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
                          Text(e, style: const TextStyle(fontSize: 14)),
                        ],
                      );
                    }).toList();
                  },

                  items:
                      accounts.map((e) {
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
                const Text('Зорилгын төрөл', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              Row(
  children: goalTypes.map((type) {
    return Expanded(
      child: Row(
        children: [
          Radio<String>(
            value: type['value']!,
            groupValue: selectedGoalType,
            onChanged: (value) {
              setState(() {
                selectedGoalType = value!;
              });
            },
            activeColor: Colors.blue,
          ),
          Text(type['label']!),
        ],
      ),
    );
  }).toList(),
),
                FloatingLabelContainer(
                  label: 'Дуусах хугацаа',
                  child: InkWell(
                    onTap: () => pickExpectedDate(context),
                    borderRadius: BorderRadius.circular(20),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        errorText: selectedDateError,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
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
                            selectedDate != null
                                ? DateFormat('dd MMM yyyy').format(selectedDate!)
                                : '---',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const Icon(Icons.calendar_today, size: 18),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        showField = !showField;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(showField ? "Нуух" : "Цааш", style: const TextStyle(color: Colors.blue)),
                        const SizedBox(width: 4),
                        Icon(showField ? Icons.arrow_drop_up : Icons.arrow_drop_down, color: Colors.blue),
                      ],
                    ),
                  ),
                ),
                if (showField) ...[
                  const Text("Сануулга", style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color.fromARGB(255, 185, 185, 185), width: 1.5),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: buildMonthlyDueDateSelector(),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: startingAmountController,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration('Эхлэх үнийн дүн', prefix: '₮ ',  suffix: Icons.currency_exchange),
                    // validator байхгүй!
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: monthlyPaidAmountController,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration('Сарын төлбөр', prefix: '₮ ',suffix: Icons.currency_exchange),
                  ),
                  const SizedBox(height: 16),
                ],
                
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: saveGoal,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    backgroundColor: Colors.blue,
                  ),
                  child: Text(widget.editGoal != null ? 'Засах' : 'Үүсгэх'),
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
                  child: const Text('Цуцлах', style: TextStyle(color: Colors.blue)),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, {String? prefix, IconData? suffix}) {
  return InputDecoration(
    labelText: label,
    prefix: prefix != null
        ? Text(prefix, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87))
        : null,
    // бусад кодууд чинь хэвээрээ
    suffixIcon: suffix != null
        ? Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(suffix, size: 24, color: Colors.blueGrey),
          )
        : null,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Colors.blue, width: 1.5),
    ),
    labelStyle: const TextStyle(color: Colors.grey),
    floatingLabelStyle: const TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
    ),
    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
  );
}

  void pickExpectedDate(BuildContext context) {
    DateTime tempPickedDate = selectedDate ?? DateTime.now();
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
                initialDateTime: selectedDate ?? DateTime.now(),
                minimumDate: DateTime(2020, 1, 1),
                maximumDate: DateTime(2035, 12, 31),
                onDateTimeChanged: (DateTime newDate) {
                  tempPickedDate = newDate;
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
                      selectedDate = tempPickedDate;
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
          'Сарын төлбөрийн хугацаа',
          style: TextStyle(fontSize: 12, color: Color.fromARGB(221, 39, 39, 39)),
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
                    selectedDueDay -= 1;
                  }
                });
              },
            ),
            Text(
              selectedDueDay.toString(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color.fromARGB(255, 102, 102, 102)),
            ),
            IconButton(
              icon: const Icon(Icons.keyboard_arrow_up_rounded, color: Colors.green, size: 24),
              onPressed: () {
                setState(() {
                  if (selectedDueDay >= 31) {
                    selectedDueDay = 31;
                  } else {
                    selectedDueDay += 1;
                  }
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  void saveGoal() async {
    bool isValid = _formKey.currentState!.validate();
    if (selectedDate == null) {
      setState(() {
        selectedDateError = 'Please select expected date';
      });
      return;
    } else {
      setState(() {
        selectedDateError = null;
      });
    }
    if (!isValid) {
      // showTopSnackBar(
      //   Get.overlayContext! as OverlayState,
      //   CustomSnackBar.error(message: 'Please fill all required fields'),
      // );
      return;
    }
    final double? targetAmount = double.tryParse(
    targetAmountController.text.trim().replaceAll(RegExp(r'[^\d]'), ''),
  );
  final double? startingAmount = startingAmountController.text.trim().isNotEmpty
      ? double.tryParse(startingAmountController.text.trim().replaceAll(RegExp(r'[^\d]'), ''))
      : 0;
  final double? monthlyPaidAmount = monthlyPaidAmountController.text.trim().isNotEmpty
      ? double.tryParse(monthlyPaidAmountController.text.trim().replaceAll(RegExp(r'[^\d]'), ''))
      : 0;

    final goal = GoalModel(
      id: widget.editGoal?.id ?? 0,
      goalName: nameController.text.trim(),
      goalType: selectedGoalType,
      status: 'active',
      targetAmount: targetAmount ?? 0,
      savedAmount: startingAmount ?? 0,
      startDate: DateFormat('yyyy-MM-dd').format(startDate),
      expectedDate: DateFormat('yyyy-MM-dd').format(selectedDate!),
      monthlyDueDay: selectedDueDay,
      monthlyDueAmount: monthlyPaidAmount ?? 0,
      description: descriptionController.text.trim(),
      remainingAmount: (targetAmount ?? 0) - (startingAmount ?? 0),
      monthsLeft: 0,
      walletType: selectedAccount == 'Family Wallet' ? 'family' : 'private',
    );

    if (widget.editGoal != null) {
      await goalController.updateGoal(goal);
    } else {
      await goalController.createGoal(goal);
    }
    Navigator.pop(context);
  }
}

/// Label-тай field-ийг бага зэрэг хөөрхөн харагдуулах wrapper
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
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

}

  
