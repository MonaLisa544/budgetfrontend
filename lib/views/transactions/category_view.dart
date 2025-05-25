import 'package:budgetfrontend/views/home/back_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/category_controller.dart';
import '../../models/category_model.dart';
import 'add_category_view.dart';

class CategoryManagePage extends StatefulWidget {
  @override
  _CategoryManagePageState createState() => _CategoryManagePageState();
}

class _CategoryManagePageState extends State<CategoryManagePage>
    with SingleTickerProviderStateMixin {
  final CategoryController controller = Get.put(CategoryController());
  late TabController _tabController;
  String selectedType = 'expense';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    controller.loadCategories(selectedType);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      setState(() {
        selectedType = _tabController.index == 0 ? 'expense' : 'income';
      });
      controller.loadCategories(selectedType);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(title: 'Ангилал'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 245, 245, 245),
                borderRadius: BorderRadius.circular(32),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: selectedType == 'expense'
                      ?  Colors.pink
                      : Colors.green,
                  borderRadius: BorderRadius.circular(32),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                tabs: const [
                  Tab(text: 'ЗАРЛАГА'),
                  Tab(text: 'ОРЛОГО'),
                ],
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Obx(() {
                  final categories = controller.categories
                      .where((cat) => cat.transactionType == selectedType)
                      .toList();
                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 100),
                    itemCount: categories.length,
                    itemBuilder: (_, index) {
                      final cat = categories[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 245, 245, 245),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            leading: Icon(cat.iconData, color: cat.safeColor),
                            title: Text(
                              cat.categoryName,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing: Padding(
  padding: const EdgeInsets.only(right: 4), // 👈 Баруун зайг ойртуулна
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      IconButton(
        icon: const Icon(Icons.edit),
        padding: const EdgeInsets.all(4), // 👈 icon хоорондын зай багасгана
        constraints: const BoxConstraints(), // 👈 icon button-ийг compact болгоно
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddCategoryView(
                isEdit: true,
                category: cat,
              ),
            ),
          );
          if (result == true) {
            controller.loadCategories(selectedType);
          }
        },
      ),
      IconButton(
        icon: const Icon(Icons.delete),
        padding: const EdgeInsets.all(4),
        constraints: const BoxConstraints(),
        onPressed: () async {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text("Confirm Delete"),
              content: const Text("Are you sure you want to delete this category?"),
              actions: [
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () => Navigator.pop(ctx, false),
                ),
                ElevatedButton(
                  child: const Text("Delete"),
                  onPressed: () => Navigator.pop(ctx, true),
                ),
              ],
            ),
          );
          if (confirm == true) {
            await controller.deleteCategory(cat.id!);
            controller.loadCategories(selectedType);
          }
        },
      ),
    ],
  ),
),

                          ),
                        ),
                      );
                    },
                  );
                }),

                // Floating Add Button
                Positioned(
                  right: 16,
                  bottom: 18,
                  child: FloatingActionButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddCategoryView(
                            isEdit: false,
                            category: null,
                          ),
                        ),
                      );
                      if (result == true) {
                        controller.loadCategories(selectedType);
                      }
                    },
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
          ),

          // Bottom OK Button
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('OK'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
