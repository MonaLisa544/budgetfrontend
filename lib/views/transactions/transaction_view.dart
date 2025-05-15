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
  String selectedType = 'All';
  String selectedWallet = 'Private Wallet';
  DateTime? selectedDate;
  bool _isAddedTransaction = false;
  CategoryModel? selectedCategory;

  final transactionController = Get.put(TransactionController());
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
            title: 'Transactions',
            onNotfPressed: () {},
            onProfilePressed: () {},
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
                      'Income',
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
                      'Expense',
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
                      if (selectedWallet == 'Private Wallet' &&
                          txn.walletType != 'private')
                        return false;
                      if (selectedWallet == 'Family Wallet' &&
                          txn.walletType != 'family')
                        return false;

                      // ✅ Date filter
                      if (selectedDate != null &&
                          DateFormat(
                                'yyyy-MM-dd',
                              ).format(DateTime.parse(txn.transactionDate)) !=
                              DateFormat('yyyy-MM-dd').format(selectedDate!))
                        return false;

                      // ✅ Income / Expense / All filter
                      if (selectedType == 'Income' &&
                          txn.transactionType != 'income')
                        return false;
                      if (selectedType == 'Expense' &&
                          txn.transactionType != 'expense')
                        return false;

                      // selectedType == 'All' бол шалгахгүй
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
                              Tab(text: "Private Wallet"),
                              Tab(text: "Family Wallet"),
                            ],
                            onTap: (index) {
                              setState(() {
                                selectedWallet =
                                    ['Private Wallet', 'Family Wallet'][index];
                              });
                            },
                          ),
                          SizedBox(height: 12),
                          //balanceDisplay(balances),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(
                                255,
                                174,
                                192,
                                226,
                              ).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(
                                    255,
                                    255,
                                    255,
                                    255,
                                  ).withOpacity(0.9),
                                  blurRadius: 1,
                                  offset: Offset(0, 0),
                                ),
                              ],
                              // border: Border.all(
                              //   color: Colors.white.withOpacity(0.2),
                              // ),
                            ),
                            child: Column(
                              children: [
                                TextButton.icon(
                                  icon: const Icon(
                                    Icons.calendar_month,
                                    color: Color.fromARGB(255, 158, 162, 177),
                                  ),
                                  label: Text(
                                    startDate != null && endDate != null
                                        ? "${DateFormat('yyyy-MM-dd').format(startDate!)} → ${DateFormat('yyyy-MM-dd').format(endDate!)}"
                                        : "🗓️ Хугацаа сонгох",
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 158, 162, 177),
                                    ),
                                  ),
                                  onPressed: () async {
                                    final picked =
                                        await showDialog<List<DateTime>>(
                                          context: context,
                                          builder:
                                              (context) =>
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 10),
                                    TextButton.icon(
                                      icon: const Icon(
                                        Icons.category,
                                        color: Color.fromARGB(
                                          255,
                                          158,
                                          162,
                                          177,
                                        ),
                                      ),
                                      label: Text(
                                        selectedCategory?.categoryName ??
                                            'Ангилал сонгох',
                                        style: const TextStyle(
                                          color: Color.fromARGB(
                                            255,
                                            158,
                                            162,
                                            177,
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        final selected =
                                            await showCategorySelectorDialogByType(
                                              context: context,
                                              type: selectedType.toLowerCase(),
                                              selectedCategory:
                                                  selectedCategory,
                                            );
                                        if (selected != null) {
                                          setState(
                                            () => selectedCategory = selected,
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                walletSummary(balances),
                                SizedBox(height: 10),
                                filterChips(),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),

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

  Widget balanceDisplay(Map<String, double> balances) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Text(
            'Balance:  ',
            style: TextStyle(
              color: Color.fromARGB(255, 158, 162, 177),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "\$${balances[selectedWallet]!.toStringAsFixed(2)}",
            style: TextStyle(
              color: Color.fromARGB(255, 158, 162, 177),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget walletSummary(Map<String, double> balances) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        walletCard(
          "Нийт орлого:",
          Icons.arrow_upward,
          balances[selectedWallet]!,
        ),
        SizedBox(width: 5),
        walletCard(
          "Нийт зарлага:",
          Icons.arrow_downward,
          balances[selectedWallet]!,
        ),
      ],
    );
  }

  Widget walletCard(String label, IconData icon, double value) {
    return Container(
      height: 60,
      width: 160,
      padding: EdgeInsets.symmetric(horizontal: 7, vertical: 10),
      // decoration: BoxDecoration(
      //   color: Color.fromARGB(221, 67, 107, 167).withOpacity(0.2),
      //   borderRadius: BorderRadius.circular(10),
      //   border: Border.all(color: Colors.white24),
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: Color.fromARGB(255, 158, 162, 177)),
              SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: Color.fromARGB(255, 158, 162, 177),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Text(
            "\$${value.toStringAsFixed(2)} MNT",
            style: TextStyle(
              color: Color.fromARGB(255, 158, 162, 177),
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
          // border: Border.all(
          //   color: const Color.fromARGB(
          //     255,
          //     197,
          //     197,
          //     197,
          //   ).withOpacity(0.5), // хүрээний өнгө
          //   width: 1.5, // хүрээний зузаан
          // ),
          color: const Color.fromARGB(255, 158, 162, 177).withOpacity(0.8),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 184, 196, 206),
              blurRadius: 5,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              ['All', 'Income', 'Expense'].map((type) {
                return ChoiceChip(
                  label: Text(
                    type,
                    style: TextStyle(
                      color: selectedType == type ? Colors.white : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  selected: selectedType == type,
                  selectedColor: Colors.blue,
                  backgroundColor: const Color.fromARGB(
                    255,
                    139,
                    144,
                    160,
                  ).withOpacity(0.8),
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
        'No transactions available.',
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
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16,
              ),
              child: Text(
                date,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
            ),

            // 💳 Тухайн өдрийн гүйлгээнүүд
            ...txnList.map((txn) {
              final isIncome = txn.transactionType == 'income';
              final amountText = (isIncome ? '+' : '-') +
                  "\$${txn.transactionAmount.toStringAsFixed(2)}";

              final dateStr = txn.transactionDate;

              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 1.0,
                  horizontal: 0.0,
                ),
                child: TransactionItem(
                  iconData: txn.category?.iconData ?? Icons.category,
                  iconColor: txn.category?.safeColor ?? Colors.grey,
                  title: txn.category?.categoryName ?? txn.transactionName,
                  subtitle: txn.transactionName,
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
      ).format(DateTime.parse(txn.transactionDate)); // ✅ parse хийж байна
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
    return {'Family Wallet': familyBalance, 'Private Wallet': privateBalance};
  }

  String getWalletName(String? walletType) {
    if (walletType == 'family') return 'Family Wallet';
    if (walletType == 'private') return 'Private Wallet';
    return 'Unknown';
  }

  IconData getWalletIcon(String? walletType) {
    if (walletType == 'family') return Icons.family_restroom;
    if (walletType == 'private') return Icons.account_circle;
    return Icons.question_mark;
  }
}
