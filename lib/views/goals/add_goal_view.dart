import 'package:budgetfrontend/views/home/back_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:budgetfrontend/controllers/goal_controller.dart';
import 'package:budgetfrontend/models/goal_model.dart';
import 'package:budgetfrontend/widgets/blue_field_text_theme.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
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
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  final List<String> accounts = ['Family Wallet', 'Private Wallet'];
  DateTime? selectedDate;
  final TextEditingController noteController = TextEditingController();

  String selectedAccount = 'Private Wallet';
  String selectedGoalType = 'saving';
  DateTime startDate = DateTime.now();
  DateTime expectedDate = DateTime.now().add(const Duration(days: 365));
  final List<String> goalTypes = ['saving', 'loan']; // 🎯 Goal Type жагсаалт
  bool isAutoCalculate = true;
  final TextEditingController monthsLeftController = TextEditingController();
  final TextEditingController monthlyPaymentController =
      TextEditingController();

 late int selectedDueDay; // 🎯 Сонгогдсон сарын өдөр
 String? selectedDateError; // 🎯 Expected Date-д зориулсан error хадгалах хувьсагч


  @override
  void initState() {
    super.initState();
    selectedDueDay = DateTime.now().day;
    if (widget.editGoal != null) {
      final goal = widget.editGoal!;
      nameController.text = goal.goalName;
      amountController.text = goal.targetAmount.toString();
      descriptionController.text = goal.description;
      startDate = goal.startDate;
      expectedDate = goal.expectedDate;
      selectedAccount =
          goal.ownerType == 'Family' ? 'Family Wallet' : 'Private Wallet';
      selectedGoalType = goal.goalType;
    }
     
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        title: widget.editGoal != null ? 'Edit Goal' : 'Add Goal',
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
                // const SizedBox(height: 10),
                TextFormField(
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  autofocus: true, // Name учраас number биш текст болгоно
                  decoration: InputDecoration(
                    labelText: 'Goal Name',
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
                      return 'Please enter amount';
                    }
                    if (double.tryParse(value) == null ||
                        double.parse(value) <= 0) {
                      return 'Enter a valid amount';
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
                    labelText: 'Account',
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

                const Text(
                  'Goal Type',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),

                // const SizedBox(height: 5),
                Row(
                  children:
                      goalTypes.map((type) {
                        return Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Radio<String>(
                                value: type,
                                groupValue: selectedGoalType,
                                onChanged: (value) {
                                  setState(() {
                                    selectedGoalType = value!;
                                  });
                                },
                                activeColor: Colors.blue,
                              ),
                              Text(
                                type.capitalizeFirst ?? type,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                ),

                // const SizedBox(height: 16),
            FloatingLabelContainer(
  label: 'Expected Date',
  child: InkWell(
    onTap: () => pickExpectedDate(context),
    borderRadius: BorderRadius.circular(20),
    child: InputDecorator(
      decoration: InputDecoration(
        errorText: selectedDateError, // 🎯 selectedDateError-г харуулна
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

                SizedBox(height: 16),
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

              
                
                const SizedBox(height: 16),
                TextFormField(
                  controller: noteController,
                  minLines: 3,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    labelText: 'Notes', // 🎯 LabelText ашиглана
                    floatingLabelBehavior:
                        FloatingLabelBehavior.auto, // 🎯 Auto дээш хөөрдөг
                    labelStyle: TextStyle(color: Colors.grey.shade400),
                    floatingLabelStyle: TextStyle(
                      color: const Color.fromARGB(255, 138, 137, 137),
                      fontWeight: FontWeight.bold,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    fillColor: const Color.fromARGB(
                      255,
                      255,
                      255,
                      255,
                    ), // 🎯 Арын фонт
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 179, 178, 178),
                      ),
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
                  onPressed: saveGoal,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    backgroundColor: Colors.blue,
                  ),
                  child: Text(widget.editGoal != null ? 'Update' : 'Create'),
                ),

                const SizedBox(height: 10),
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
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
 void pickExpectedDate(BuildContext context) {
  DateTime tempPickedDate = selectedDate ?? DateTime.now();  // 🎯 selectedDate-ийг түр хадгална

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

void saveGoal() async {
  bool isValid = _formKey.currentState!.validate();

  // 🎯 Энд selectedDate шалгах
  if (selectedDate == null) {
    setState(() {
      selectedDateError = 'Please select expected date';
    });
    return;
  } else {
    setState(() {
      selectedDateError = null; // ✅ Зөв сонгогдсон бол алдааг арилгана
    });
  }

  if (!isValid) {
    showTopSnackBar(
      Get.overlayContext! as OverlayState,
      CustomSnackBar.error(message: 'Please fill all required fields'),
    );
    return;
  }

  final goal = GoalModel(
    id: 0,
    goalName: nameController.text.trim(),
    goalType: selectedGoalType,
    status: 'active',
    targetAmount: double.parse(amountController.text.trim()),
    paidAmount: 0,
    remainingAmount: double.parse(amountController.text.trim()),
    startDate: startDate,
    expectedDate: selectedDate!,
    monthlyDueDay: selectedDueDay,
    description: descriptionController.text.trim(),
    progressPercentage: 0,
    monthsLeft: 0,
    ownerType: selectedAccount == 'Family Wallet' ? 'family' : 'private',
    walletId: 0,
  );

  if (widget.editGoal != null) {
    await goalController.updateGoal(goal);
  } else {
    await goalController.createGoal(goal);
  }

  Navigator.pop(context);
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
