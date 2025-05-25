import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Models/IconPack.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart' as FlutterIconPicker;
import 'package:get/get.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:budgetfrontend/controllers/category_controller.dart';
import 'package:budgetfrontend/models/category_model.dart';
import 'package:budgetfrontend/views/home/back_app_bar.dart';
import 'package:budgetfrontend/widgets/blue_field_text_theme.dart';

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
String getTypeLabel(String type) {
  switch (type) {
    case 'income':
      return 'Орлого';
    case 'expense':
      return 'Зарлага';
    default:
      return type;
  }
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
      appBar: BackAppBar(title: widget.isEdit ? 'Ангилал засах' : 'Ангилал үүсгэх'),
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
  keyboardType: TextInputType.text,
  autofocus: true, // Name учраас number биш текст болгоно
  decoration: InputDecoration(
    labelText: 'Ангиллын нэр',
    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    labelStyle: const TextStyle(
      color: Color.fromARGB(255, 131, 131, 131), fontWeight: FontWeight.w500
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
      return 'Ангиллын нэр оруулна уу!';
    }
    return null;
  },
),
                const SizedBox(height: 25),

                InkWell(
                  onTap: () async {
                    final icon = await FlutterIconPicker.showIconPicker(
                      context,
                      iconPackModes: [IconPack.material],
                      iconSize: 32,
                      iconColor: Colors.black,
                      backgroundColor: Colors.white,
                      title: const Text("Дүрс сонгох"),
                      
                      closeChild: const Text("Цуцлах", style: TextStyle(color: Colors.blue)),
                      searchHintText: "Дүрс хайх...",
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
                      labelText: 'Дүрс сонгох',
                      floatingLabelStyle: TextStyle(color: Color.fromARGB(221, 148, 148, 148),  fontWeight: FontWeight.bold), 
                      border: OutlineInputBorder(),
                    ),
                    child: Row(
                      children: [
                        Icon(selectedIcon ?? Icons.category, color: selectedIconColor),
                        const SizedBox(width: 10),
                        Text(
  selectedIcon != null ? 'Дүрс сонгосон' : 'Дүрс сонгох',
  style: TextStyle(
    color: selectedIcon != null ? Colors.black : Colors.grey, // 🎯 Өнгө сонголт
    fontSize: 14,
  ),
),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Дүрсний өнгө',
                    
                   floatingLabelStyle: TextStyle(color: Color.fromARGB(221, 148, 148, 148),  fontWeight: FontWeight.bold),
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
  child: Text(
    'Өнгө сонгох',
    style: TextStyle(color: selectedIconColor), // ✅ Сонгосон өнгө
  ),
  onPressed: () {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Дүрсний өнгө сонгох'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: selectedIconColor,
            onColorChanged: (color) =>
                setState(() => selectedIconColor = color),
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Болсон'),
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
                const SizedBox(height: 24),

              Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text("Ангиллын төрөл", style: TextStyle(fontSize: 14),),
   
    const SizedBox(height: 12),
    Wrap(
  spacing: 20,
  children: types.map((type) {
    return CustomRadioButton(
      label: getTypeLabel(type), // Одоо монголоор харагдана!
      value: type,
      groupValue: selectedType,
      onChanged: (value) {
        setState(() {
          selectedType = value!;
        });
      },
    );
  }).toList(),
),
  ],
),





                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: saveCategory,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    backgroundColor: Colors.blue,
                  ),
                  child: Text(widget.isEdit ? 'Засах' : 'Үүсгэх'),
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

class CustomRadioButton extends StatelessWidget {
  final String label;
  final String value;
  final String groupValue;
  final ValueChanged<String?> onChanged;

  const CustomRadioButton({
    super.key,
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;

    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.grey.shade400,
                width: 2,
              ),
              color: isSelected ? Colors.blue : const Color.fromARGB(255, 255, 255, 255), // 🎯
            ),
            child: isSelected
                ? const Center(
                    child: Icon(Icons.check, size: 14, color: Colors.white),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, // 🎯
              color: isSelected ? Colors.blue : Colors.grey.shade600, // 🎯
            ),
          ),
        ],
      ),
    );
  }
}

