import 'package:flutter/material.dart';
import 'package:budgetfrontend/models/category_model.dart';
import 'package:budgetfrontend/services/api_service.dart';
import 'package:budgetfrontend/views/transactions/category_view.dart';

Future<CategoryModel?> showCategorySelectorDialogByType({
  required BuildContext context,
  required String type,
  CategoryModel? selectedCategory,
}) async {
  return await showDialog<CategoryModel>(
    context: context,
    builder: (context) {
      CategoryModel? tempSelected = selectedCategory;
      late Future<List<CategoryModel>> futureCategories;

      futureCategories = ApiService.getCategories(type);

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Category', style: TextStyle(fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CategoryManagePage()),
                    );
                    setState(() {
                      futureCategories = ApiService.getCategories(type);
                    });
                  },
                  child: const Text('Edit', style: TextStyle(color: Colors.blue),),
                ),
              ],
            ),
            content: FutureBuilder<List<CategoryModel>>(
              future: futureCategories,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Text('Алдаа гарлаа: ${snapshot.error}');
                }

                final allCategories = snapshot.data ?? [];

                final filteredCategories = allCategories
                    .where((cat) => cat.transactionType.toLowerCase() == type.toLowerCase())
                    .toList();

                if (filteredCategories.isEmpty) {
                  return const Center(child: Text("No categories"));
                }

                return SizedBox(
                  width: double.maxFinite,
                  height: 300,
                  child: ListView.builder(
                    itemCount: filteredCategories.length,
                    itemBuilder: (context, index) {
                      final cat = filteredCategories[index];
                      final isSelected = tempSelected?.id == cat.id;
                      return ListTile(
                        leading: Icon(cat.iconData, color: cat.safeColor),
                        title: Text(cat.categoryName),
                        tileColor: isSelected ? Colors.pink.shade200 : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        onTap: () {
                          setState(() {
                            tempSelected = cat; // ✅ зөвхөн сонгоно
                          });
                        },
                      );
                    },
                  ),
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, tempSelected), // ✅ OK дарахад буцна
                child: const Text("OK", style: TextStyle(color: Colors.blue),),
              ),
            ],
          );
        },
      );
    },
  );
}
