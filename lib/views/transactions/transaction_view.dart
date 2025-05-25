import 'dart:ui';
import 'package:budgetfrontend/models/category_model.dart';
import 'package:budgetfrontend/models/transaction_model.dart';
import 'package:budgetfrontend/views/home/main_bar_view.dart';
import 'package:budgetfrontend/views/transactions/add_transaction_view.dart';
import 'package:budgetfrontend/views/transactions/category_selecter_dialog.dart';
import 'package:budgetfrontend/views/transactions/transaction_info_view.dart';
import 'package:budgetfrontend/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:budgetfrontend/controllers/transaction_controller.dart';
import 'package:budgetfrontend/views/transactions/date_range_picker_dialog.dart';

class TransactionView extends StatefulWidget {
  const TransactionView({super.key});

  @override
  State<TransactionView> createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {
  String selectedType = 'Бүгд';
  String selectedWallet = 'Хувийн гүйлгээ';
  DateTime? selectedDate;
  bool _isAddedTransaction = false;
  CategoryModel? selectedCategory;

  final transactionController = Get.find<TransactionController>();

  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    startDate = DateTime.now().subtract(const Duration(days: 7));
    endDate = DateTime.now();
    transactionController.loadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: MainBarView(
            title: 'Гүйлгээ',
            onNotfPressed: () {},
            onProfilePressed: () {},
            showChartIcon: true,
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: 'main',
            onPressed: () => setState(() => _isAddedTransaction = true),
            backgroundColor: Colors.blue,
            child: const Icon(Icons.add),
          ),
          body: buildBody(),
        ),

        if (_isAddedTransaction) ...[
          Positioned.fill(
            child: GestureDetector(
              onTap: () => setState(() => _isAddedTransaction = false),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                child: Container(
                  color: const Color.fromARGB(255, 19, 46, 95).withOpacity(0.3),
                ),
              ),
            ),
          ),
          Positioned(
            right: 18,
            bottom: 70,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: FloatingActionButton.extended(
                    heroTag: 'income',
                    onPressed: () {
                      setState(() => _isAddedTransaction = false);
                      Get.to(() => AddTransactionView(type: 'income'));
                    },
                    backgroundColor: Colors.lightBlue.shade100,
                    icon: Icon(Icons.trending_up, color: Colors.green),
                    label: const Text(
                      'Орлого',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: FloatingActionButton.extended(
                    heroTag: 'expense',
                    onPressed: () {
                      setState(() => _isAddedTransaction = false);
                      Get.to(() => AddTransactionView(type: 'expense'));
                    },
                    backgroundColor: Colors.lightBlue.shade100,
                    icon: Icon(Icons.trending_down, color: Colors.red),
                    label: const Text(
                      'Зарлага',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                FloatingActionButton(
                  heroTag: 'close',
                  onPressed: () => setState(() => _isAddedTransaction = false),
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.close),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget buildBody() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/background/background77.jpeg', fit: BoxFit.cover),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 20),
            child: Container(color: Colors.transparent),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Color.fromARGB(255, 57, 186, 196),
                ],
                stops: [0.5, 1.0],
              ),
            ),
          ),
        ),
        SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 10.0,
              ),
              child: Obx(() {
                final transactions =
                    transactionController.transactions.where((txn) {
                  // ✅ Wallet filter
                  if (selectedWallet == 'Хувийн гүйлгээ' &&
                      txn.walletType != 'private') return false;
                  if (selectedWallet == 'Гэр бүлийн гүйлгээ' &&
                      txn.walletType != 'family') return false;

                  // ✅ Date filter
                  if (selectedDate != null &&
                      DateFormat(
                        'yyyy-MM-dd',
                      ).format(DateTime.parse(txn.transactionDate)) !=
                          DateFormat('yyyy-MM-dd').format(selectedDate!)) {
                    return false;
                  }

                  // ✅ Income / Expense / All filter
                  if (selectedType == 'Орлого' && txn.transactionType != 'income') {
                    return false;
                  }
                  if (selectedType == 'Зарлага' && txn.transactionType != 'expense') {
                    return false;
                  }
                  // selectedType == 'Бүгд' бол шалгахгүй
                  return true;
                }).toList();

                final balances = calculateBalances(
                  transactionController.transactions,
                );

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          TabBar(
                            indicatorColor: Colors.white,
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.white60,
                            tabs: const [
                              Tab(text: "Хувийн гүйлгээ"),
                              Tab(text: "Гэр бүлийн гүйлгээ"),
                            ],
                            onTap: (index) {
                              setState(() {
                                selectedWallet =
                                    ['Хувийн гүйлгээ', 'Гэр бүлийн гүйлгээ'][index];
                              });
                            },
                          ),
                          SizedBox(height: 12),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(width: 30),
                                            TextButton.icon(
                                              style: TextButton.styleFrom(
                                                padding: EdgeInsets.symmetric(vertical: 6),
                                                minimumSize: Size.zero,
                                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                              ),
                                              icon: const Icon(
                                                Icons.calendar_today,
                                                color: Color.fromARGB(255, 38, 217, 230),
                                                size: 18,
                                              ),
                                              label: Text(
                                                startDate != null && endDate != null
                                                    ? "${DateFormat('yyyy-MM-dd').format(startDate!)} → ${DateFormat('yyyy-MM-dd').format(endDate!)}"
                                                    : "🗓️ Хугацаа сонгох",
                                                style: TextStyle(
                                                  color: Color.fromARGB(255, 38, 217, 230),
                                                  fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              onPressed: () async {
                                                final picked = await showDialog<List<DateTime>>(
                                                  context: context,
                                                  builder: (context) =>
                                                      TimelineDateRangeDialog(
                                                        initialStart: startDate,
                                                        initialEnd: endDate,
                                                      ),
                                                );
                                                if (picked != null && picked.length == 2) {
                                                  setState(() {
                                                    startDate = picked[0];
                                                    endDate = picked[1];
                                                  });
                                                }
                                              },
                                            ),
                                            SizedBox(width: 30),

                                             IconButton(
      icon: Icon(Icons.download_rounded, color: Colors.white),
      onPressed: () {
        // downloadTransaction(txn);
      },
    ),
                                          ],
                                        ),
                                        // Row(
                                        //   mainAxisAlignment: MainAxisAlignment.start,
                                        //   children: [
                                        //     SizedBox(width: 10),
                                        //     TextButton.icon(
                                        //       style: TextButton.styleFrom(
                                        //         padding: EdgeInsets.symmetric(vertical: 3),
                                        //         minimumSize: Size.zero,
                                        //         tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        //       ),
                                        //       icon: const Icon(
                                        //         Icons.category,
                                        //         color: Color.fromARGB(255, 255, 255, 255),
                                        //       ),
                                        //       label: Text(
                                        //         selectedCategory?.categoryName ?? 'Ангилал сонгох',
                                        //         style: const TextStyle(
                                        //           color: Color.fromARGB(255, 255, 255, 255),
                                        //         ),
                                        //       ),
                                        //       onPressed: () async {
                                        //         final selected = await showCategorySelectorDialogByType(
                                        //           context: context,
                                        //           type: selectedType.toLowerCase(),
                                        //           selectedCategory: selectedCategory,
                                        //         );
                                        //         if (selected != null) {
                                        //           setState(() => selectedCategory = selected);
                                        //         }
                                        //       },
                                        //     ),
                                        //   ],
                                        // ),
                        //                  Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     _buildKpiCard("Орлого", "₮ 3,000,000", Colors.greenAccent),
                        //     SizedBox(width: 15),
                        //     _buildKpiCard("Зарлага", "₮ 2,500,000", Colors.redAccent)
                        //   ],
                        // ),
                        walletSummary(balances),

                                        SizedBox(height: 4),
                                        filterChips(),
                                        SizedBox(height: 8),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          transactionList(transactions),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  // Widget balanceDisplay(Map<String, double> balances) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  //     child: Row(
  //       children: [
  //         Text(
  //           'Үлдэгдэл:  ',
  //           style: TextStyle(
  //             color: Color.fromARGB(255, 158, 162, 177),
  //             fontSize: 18,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         Text(
  //           "\$${balances[selectedWallet]!.toStringAsFixed(2)}",
  //           style: TextStyle(
  //             color: Color.fromARGB(255, 158, 162, 177),
  //             fontSize: 20,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget walletSummary(Map<String, double> balances) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      walletCard(
        "Нийт орлого:",
        Icons.arrow_upward,
        balances[selectedWallet] ?? 0.0,
      ),
      SizedBox(width: 5),
      walletCard(
        "Нийт зарлага:",
        Icons.arrow_downward,
        balances[selectedWallet] ?? 0.0,
      ),
    ],
  );
}

Widget walletCard(String label, IconData icon, double value) {
  return Container(
    height: 60,
    width: 160,
    padding: EdgeInsets.symmetric(horizontal: 7, vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: Color.fromARGB(255, 255, 255, 255)),
            SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: Color.fromARGB(255, 237, 236, 236),
                fontSize: 12,
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
        Text(
          formatCurrency(value), // <<<<<<<<<<<<<<<<<<
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}



  Widget filterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      child: Container(
        height: 37,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 3, 12, 31).withOpacity(0.8),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 2, 19, 53).withOpacity(0.8),
              blurRadius: 5,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: ['Бүгд', 'Орлого', 'Зарлага'].map((type) {
            return ChoiceChip(
              label: Text(
                type,
                style: TextStyle(
                  color: selectedType == type
                      ? const Color.fromARGB(255, 0, 0, 0)
                      : const Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.bold,
                ),
              ),
              selected: selectedType == type,
              selectedColor: const Color.fromARGB(255, 255, 255, 255),
              backgroundColor:
                  const Color.fromARGB(255, 3, 12, 31),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              onSelected: (_) => setState(() => selectedType = type),
            );
          }).toList(),
        ),
      ),
    );
  }
  Widget transactionList(List<TransactionModel> transactions) {
    final grouped = groupTransactionsByDate(transactions);

    if (transactions.isEmpty) {
      return Center(
        child: Text(
          'Гүйлгээ олдсонгүй.',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 200),
      child: Column(
        children: grouped.entries.map((entry) {
          final date = entry.key;
          final txnList = entry.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🗓️ Огнооны гарчиг
             Padding(
               padding: const EdgeInsets.all(5.0),
               child: Container(
                 width: double.infinity, // 🔥 Бүхэлдээ дэлгэцийн өргөний хэмжээгээр тэлнэ!
                 decoration: BoxDecoration(
                   color: Colors.white.withOpacity(0.1),
                 ),
                 child: Padding(
                   padding: const EdgeInsets.symmetric(
                     vertical: 7.0,
                     horizontal: 16,
                   ),
                   child: Text(
                     date,
                     style: const TextStyle(
                       fontSize: 13.5,
                       fontWeight: FontWeight.bold,
                       color: Color.fromARGB(255, 30, 183, 194),
                     ),
                   ),
                 ),
               ),
             ),

              // 💳 Тухайн өдрийн гүйлгээнүүд
              ...txnList.map((txn) {
               final isIncome = txn.transactionType == 'income';
final amountText = (isIncome ? '+ ' : '- ') +
    formatCurrency(txn.transactionAmount); // <<<<<<<<<<<<

                final dateStr = txn.transactionDate;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 1.0,
                    horizontal: 0.0,
                  ),
                  child: TransactionItem(
                    iconData: txn.category?.iconData ?? Icons.category,
                    iconColor: txn.category?.safeColor ?? Colors.grey,
                    title: txn.transactionName,
                    subtitle:  txn.category?.categoryName ?? txn.transactionName,
                    amount: amountText,
                    // time: dateStr,
                    onPressed: () {
                      showTransactionDetailDialog(context, txn);
                      print('Item clicked: ${txn.transactionName}');
                    },
                  ),
                );
              }).toList(),
            ],
          );
        }).toList(),
      ),
    );
  }

  Map<String, List<TransactionModel>> groupTransactionsByDate(
    List<TransactionModel> transactions,
  ) {
    Map<String, List<TransactionModel>> grouped = {};

    for (var txn in transactions) {
      final date = DateFormat(
        'yyyy-MM-dd',
      ).format(DateTime.parse(txn.transactionDate));
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(txn);
    }

    return grouped;
  }

  Map<String, double> calculateBalances(List<TransactionModel> transactions) {
    double familyBalance = 0.0;
    double privateBalance = 0.0;
    for (var txn in transactions) {
      final isIncome = txn.transactionType == 'income';
      final amount = isIncome ? txn.transactionAmount : -txn.transactionAmount;

      if (txn.walletType == 'family') {
        familyBalance += amount;
      } else if (txn.walletType == 'private') {
        privateBalance += amount;
      }
    }
    return {'Гэр бүлийн гүйлгээ': familyBalance, 'Хувийн гүйлгээ': privateBalance};
  }

  String getWalletName(String? walletType) {
    if (walletType == 'family') return 'Гэр бүлийн гүйлгээ';
    if (walletType == 'private') return 'Хувийн гүйлгээ';
    return 'Тодорхойгүй';
  }

  IconData getWalletIcon(String? walletType) {
    if (walletType == 'family') return Icons.family_restroom;
    if (walletType == 'private') return Icons.account_circle;
    return Icons.question_mark;
  }


  
  String formatCurrency(double value, {bool symbolFirst = true}) {
  final formatter = NumberFormat("#,##0", "mn");
  return symbolFirst
      ? "${formatter.format(value)} ₮"
      : "₮ ${formatter.format(value)}";
}

}

