import 'dart:io';

import 'package:budgetfrontend/widgets/blue_field_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class AddSavingView extends StatefulWidget {
  const AddSavingView({super.key});

  @override
  State<AddSavingView> createState() => _AddSavingViewState();
}

class _AddSavingViewState extends State<AddSavingView> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String selectedAccount = 'Private Wallet';
  File? imageFile;

  final List<String> accounts = ['Family Wallet', 'Private Wallet'];

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          dialogBackgroundColor: Colors.white,
          colorScheme: const ColorScheme.light(
            primary: Colors.blue,
            onPrimary: Colors.white,
            onSurface: Colors.black,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => imageFile = File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Saving')),
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
                  label: 'Name',
                  child: TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(),
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
                FloatingLabelContainer(
                  label: 'Account',
                  child: DropdownButtonFormField<String>(
                    value: selectedAccount,
                    isExpanded: true,
                    decoration: const InputDecoration(),
                    items: accounts.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (value) => setState(() => selectedAccount = value!),
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
                  label: 'Image',
                  child: InkWell(
                    onTap: pickImage,
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: imageFile != null
                          ? Image.file(imageFile!, fit: BoxFit.cover)
                          : const Text('Tap to select image'),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // TODO: Submit API
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text("Create Saving"),
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
