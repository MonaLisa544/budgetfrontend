import 'dart:io';

import 'package:budgetfrontend/widgets/blue_field_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class AddLoanView extends StatefulWidget {
  const AddLoanView({super.key});

  @override
  State<AddLoanView> createState() => _AddLoanViewState();
}

class _AddLoanViewState extends State<AddLoanView> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final amountController = TextEditingController();
  final interestRateController = TextEditingController();
  final descriptionController = TextEditingController();

  DateTime loanDate = DateTime.now();
  DateTime dueDate = DateTime.now().add(const Duration(days: 30));
  String selectedAccount = 'Private Wallet';
  File? loanDocument;

  final List<String> accounts = ['Family Wallet', 'Private Wallet'];

  Future<void> pickDate({required bool isLoanDate}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isLoanDate ? loanDate : dueDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2040),
    );
    if (picked != null) {
      setState(() {
        if (isLoanDate) {
          loanDate = picked;
        } else {
          dueDate = picked;
        }
      });
    }
  }

  Future<void> pickDocument() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => loanDocument = File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Loan")),
      backgroundColor: Colors.white,
      body: BlueTextFieldTheme(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                FloatingLabelContainer(
                  label: 'Loan Name',
                  child: TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(),
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                ),
                const SizedBox(height: 16),
                FloatingLabelContainer(
                  label: 'Amount',
                  child: TextFormField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(),
                  ),
                ),
                const SizedBox(height: 16),
                FloatingLabelContainer(
                  label: 'Interest Rate (%)',
                  child: TextFormField(
                    controller: interestRateController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(),
                  ),
                ),
                const SizedBox(height: 16),
                FloatingLabelContainer(
                  label: 'Wallet Type',
                  child: DropdownButtonFormField<String>(
                    value: selectedAccount,
                    decoration: const InputDecoration(),
                    isExpanded: true,
                    items: accounts.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (value) => setState(() => selectedAccount = value!),
                  ),
                ),
                const SizedBox(height: 16),
                FloatingLabelContainer(
                  label: 'Loan Date',
                  child: InkWell(
                    onTap: () => pickDate(isLoanDate: true),
                    child: InputDecorator(
                      decoration: const InputDecoration(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(DateFormat('yyyy-MM-dd').format(loanDate)),
                          const Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                FloatingLabelContainer(
                  label: 'Due Date',
                  child: InkWell(
                    onTap: () => pickDate(isLoanDate: false),
                    child: InputDecorator(
                      decoration: const InputDecoration(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(DateFormat('yyyy-MM-dd').format(dueDate)),
                          const Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                FloatingLabelContainer(
                  label: 'Description',
                  child: TextFormField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(),
                  ),
                ),
                const SizedBox(height: 16),
                FloatingLabelContainer(
                  label: 'Upload Document',
                  child: InkWell(
                    onTap: pickDocument,
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: loanDocument != null
                          ? Image.file(loanDocument!, fit: BoxFit.cover)
                          : const Text('Tap to upload document'),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // TODO: Submit loan API
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: const Text("Submit Loan"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FloatingLabelContainer extends StatelessWidget {
  final String label;
  final Widget child;

  const FloatingLabelContainer({
    super.key,
    required this.label,
    required this.child,
  });

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
