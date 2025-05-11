import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Models/IconPack.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart' as FlutterIconPicker;
import 'package:get/get.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:budgetfrontend/controllers/category_controller.dart';
import 'package:budgetfrontend/models/category_model.dart';
import 'package:budgetfrontend/views/home/back_app_bar.dart';
import 'package:budgetfrontend/widgets/blue_field_text_theme.dart';
import 'package:get/get_connect/http/src/utils/utils.dart'; // BlueTextFieldTheme import

class AddCategoryView extends StatefulWidget {
  final bool isEdit;
  final CategoryModel? category;

  const AddCategoryView({
    this.isEdit = false,
    this.category,
    Key? key,
  }) : super(key: key);

  @override
  State<AddCategoryView> createState() => _AddCategoryViewState();
}

class _AddCategoryViewState extends State<AddCategoryView> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final controller = Get.find<CategoryController>();

  final List<String> types = ['expense', 'income'];
  String selectedType = 'expense';
  IconData? selectedIcon;
  String? selectedIconCode;
  Color selectedIconColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.category != null) {
      nameController.text = widget.category!.categoryName;
      selectedType = widget.category!.transactionType;
      selectedIconCode = widget.category!.icon;
      selectedIcon = IconData(
        int.tryParse(widget.category!.icon ?? '') ?? Icons.category.codePoint,
        fontFamily: 'MaterialIcons',
      );
      selectedIconColor = widget.category!.iconColor ?? Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(title: widget.isEdit ? 'Edit Category' : 'Add Category'),
      backgroundColor: Colors.white,
      body: BlueTextFieldTheme( // ✅ Theme wrap here
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                InkWell(
                  onTap: () async {
                    final icon = await FlutterIconPicker.showIconPicker(
                      context,
                      iconPackModes: [IconPack.material],
                      iconSize: 32,
                      iconColor: Colors.black,
                      backgroundColor: Colors.white,
                      title: const Text("Select Icon"),
                      
                      closeChild: const Text("Cancel", style: TextStyle(color: Colors.blue)),
                      searchHintText: "Search icons...",
                    );
                    if (icon != null) {
                      setState(() {
                        selectedIcon = icon;
                        selectedIconCode = icon.codePoint.toString(); // ✅ store as string
                      });
                    }
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Pick Icon',
                      floatingLabelStyle: TextStyle(color: Colors.black87), 
                      border: OutlineInputBorder(),
                    ),
                    child: Row(
                      children: [
                        Icon(selectedIcon ?? Icons.category, color: selectedIconColor),
                        const SizedBox(width: 10),
                        Text(selectedIcon != null ? 'Icon Selected' : 'Choose an icon'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Icon Color',
                    
                    floatingLabelStyle: TextStyle(color: Colors.black87),
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: selectedIconColor,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.black12),
                        ),
                      ),
                      const SizedBox(width: 10),
                      TextButton(
                        child: const Text('Pick Color', style: TextStyle(color: Colors.blue),),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Select Icon Color'),
                              content: SingleChildScrollView(
                                child: ColorPicker(
                                  pickerColor: selectedIconColor,
                                  onColorChanged: (color) =>
                                      setState(() => selectedIconColor = color),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('Done'),
                                  onPressed: () => Navigator.of(context).pop(),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

               DropdownButtonFormField<String>(
  value: selectedType,
  decoration: InputDecoration(
    labelText: 'Type',
    floatingLabelStyle: TextStyle(color: Colors.black87),
    labelStyle: const TextStyle(color: Colors.black87),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  ),
  icon: const Icon(Icons.keyboard_arrow_down_rounded),
  borderRadius: BorderRadius.circular(16),
  dropdownColor: Colors.white,
  isExpanded: true, // ✅ өргөн TextField-тэй тэнцүү болно
  elevation: 4,
  items: types.map((e) {
    return DropdownMenuItem<String>(
      value: e,
      child: Text(e.toUpperCase(), style: const TextStyle(fontSize: 16)),
    );
  }).toList(),
  onChanged: (value) => setState(() => selectedType = value!),
),



                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: saveCategory,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    backgroundColor: Colors.blue,
                  ),
                  child: Text(widget.isEdit ? 'Save' : 'Create'),
                ),
                SizedBox(height: 10),
                OutlinedButton(
  onPressed: () => Navigator.pop(context),
  style: OutlinedButton.styleFrom(
    side: const BorderSide(color: Colors.blue, width: 1.5), // Хүрээний өнгө
    minimumSize: const Size.fromHeight(48),     // Өндөр
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

  void saveCategory() async {
    if (_formKey.currentState!.validate()) {
      final category = CategoryModel(
        id: widget.isEdit ? widget.category!.id : null,
        categoryName: nameController.text.trim(),
        icon: selectedIconCode,
        transactionType: selectedType,
        iconColor: selectedIconColor,
      );

      if (widget.isEdit) {
        await controller.updateCategory(category);
      } else {
        await controller.createCategory(category);
      }

      Navigator.pop(context, true); // ✅ success result
    }
  }
}
