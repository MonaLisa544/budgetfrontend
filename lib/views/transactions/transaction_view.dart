import 'dart:ui';
import 'package:budgetfrontend/controllers/wallet_controller.dart';
import 'package:budgetfrontend/models/category_model.dart';
import 'package:budgetfrontend/models/transaction_model.dart';
import 'package:budgetfrontend/views/home/main_bar_view.dart';
import 'package:budgetfrontend/views/transactions/add_transaction_view.dart';
import 'package:budgetfrontend/views/transactions/transaction_info_view.dart';
import 'package:budgetfrontend/widgets/monthly_picker.dart';
import 'package:budgetfrontend/widgets/transaction_list.dart';
import 'package:budgetfrontend/widgets/wallet_summary.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:budgetfrontend/controllers/transaction_controller.dart';

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
  final walletController = Get.find<WalletController>();

  final ScrollController _scrollController = ScrollController();

@override
void dispose() {
  _scrollController.dispose();
  super.dispose();
}

  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    startDate = DateTime(now.year, now.month, 1);
    endDate = DateTime(now.year, now.month + 1, 0);
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
        // Background
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
                colors: [Colors.transparent, Color.fromARGB(255, 57, 186, 196)],
                stops: [0.5, 1.0],
              ),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 0.0,
              vertical: 10.0,
            ),
            child: Obx(() {
              final allTransactions = transactionController.transactions;
              final filteredTransactions = filterTransactions(allTransactions);

  final incomeExpense = calculateIncomeExpense(filteredTransactions);


              final balances = calculateBalances(allTransactions);

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
                                  [
                                    'Хувийн гүйлгээ',
                                    'Гэр бүлийн гүйлгээ',
                                  ][index];
                              // Ангилалын сонголт цуцална
                              selectedCategory = null;
                            });
                          },
                        ),
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
                                  SizedBox(height: 15),
                                  MonthYearPickerButton(
                                    initialDate: DateTime.now(),
                                    onChanged: (date) {
                                      setState(() {
                                        startDate = DateTime(
                                          date.year,
                                          date.month,
                                          1,
                                        );
                                        endDate = DateTime(
                                          date.year,
                                          date.month + 1,
                                          0,
                                        );
                                        selectedCategory =
                                            null; // Сонголтыг цуцална
                                      });
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  Obx(() {
                                    double balance = 0.0;
                                    if (selectedWallet == "Хувийн гүйлгээ") {
                                      balance =
                                          walletController
                                              .myWallet
                                              .value
                                              ?.balance ??
                                          0.0;
                                    } else if (selectedWallet ==
                                        "Гэр бүлийн гүйлгээ") {
                                      balance =
                                          walletController
                                              .familyWallet
                                              .value
                                              ?.balance ??
                                          0.0;
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 18,
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            " ${formatCurrency(balance)}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            "дансны үлдэгдэл",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: const Color.fromARGB(
                                                255,
                                                223,
                                                223,
                                                223,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                  
                                 WalletSummary(
                                  
  income: incomeExpense[selectedWallet]?['income'] ?? 0.0,
  expense: incomeExpense[selectedWallet]?['expense'] ?? 0.0,
  formatCurrency: formatCurrency,
),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
        // Доод DraggableScrollableSheet
        Obx(() {
          final allTransactions = transactionController.transactions;
          final filteredTransactions = filterTransactions(allTransactions);

          return DraggableScrollableSheet(
            initialChildSize: 0.55,
            minChildSize: 0.5,
            maxChildSize: 0.9,
            builder:
                (context, scrollController) => Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(36.0),
                      topRight: Radius.circular(36.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(
                          255,
                          255,
                          255,
                          255,
                        ).withOpacity(0.08),
                        spreadRadius: 2,
                        blurRadius: 24,
                        offset: Offset(0, -8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 8),
                      Container(
                        width: 50,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 25),
                          Text(
                            "Ангилал",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromARGB(255, 136, 136, 136),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      spendAnalysis(transactionController.transactions),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Нийт гүйлгээ",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 168, 168, 168),
                            ),
                          ),
                        ],
                      ),
                      Flexible(
      child: TransactionListWithScroll(
        transactions: filteredTransactions,
        scrollController: scrollController,
        formatCurrency: formatCurrency,
        showTransactionDetailDialog: showTransactionDetailDialog,
      ),),
      SizedBox(height: 30),
                    ],
                  ),
                ),
          );
        }),
      ],
    );
  }

  // Ангилал дээр дарсан үед filter хийгдэх функц
  List<TransactionModel> filterTransactions(
    List<TransactionModel> allTransactions,
  ) {
    return allTransactions.where((txn) {
      if (selectedWallet == 'Хувийн гүйлгээ' && txn.walletType != 'private')
        return false;
      if (selectedWallet == 'Гэр бүлийн гүйлгээ' && txn.walletType != 'family')
        return false;
      if (startDate != null && endDate != null) {
        final txnDate = DateTime.parse(txn.transactionDate);
        if (txnDate.isBefore(startDate!) || txnDate.isAfter(endDate!))
          return false;
      }
      if (selectedType == 'Орлого' && txn.transactionType != 'income')
        return false;
      if (selectedType == 'Зарлага' && txn.transactionType != 'expense')
        return false;
      // Category filter
      if (selectedCategory != null &&
          txn.category?.categoryName != selectedCategory!.categoryName)
        return false;
      return true;
    }).toList();
  }

  // Spend Analysis Widget
 Widget spendAnalysis(List<TransactionModel> transactions) {
  Map<int, double> categoryExpenseTotals = {};
  Map<int, double> categoryIncomeTotals = {};
  double totalExpense = 0.0;
  double totalIncome = 0.0;

  for (var txn in transactions) {
    if (txn.transactionType == 'expense') {
      totalExpense += txn.transactionAmount;
      categoryExpenseTotals[txn.categoryId] =
          (categoryExpenseTotals[txn.categoryId] ?? 0) + txn.transactionAmount;
    } else if (txn.transactionType == 'income') {
      totalIncome += txn.transactionAmount;
      categoryIncomeTotals[txn.categoryId] =
          (categoryIncomeTotals[txn.categoryId] ?? 0) + txn.transactionAmount;
    }
  }

  final categoryIds = <int>{
    ...categoryExpenseTotals.keys,
    ...categoryIncomeTotals.keys,
  }.toList();

  return SizedBox(
    height: 110,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      
      itemCount: categoryIds.length,
      itemBuilder: (context, index) {
        final catId = categoryIds[index];
        final expense = categoryExpenseTotals[catId] ?? 0;
        final income = categoryIncomeTotals[catId] ?? 0;
        final expensePercent = totalExpense == 0 ? 0 : (expense / totalExpense * 100).round();
        final incomePercent = totalIncome == 0 ? 0 : (income / totalIncome * 100).round();

        final catTxn = transactions.firstWhere(
          (txn) => txn.categoryId == catId && txn.category != null,
          orElse: () => transactions.firstWhere((txn) => txn.categoryId == catId),
        ).category!;

        final isSelected = selectedCategory?.categoryName == catTxn.categoryName;

        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                selectedCategory = null;
              } else {
                selectedCategory = catTxn;
              }
            });
          },
          child: Container(
            width: 100,
            margin: EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: isSelected ? catTxn.iconColor!.withOpacity(0.1) : Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Container(
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    boxShadow: [
      BoxShadow(
        color: catTxn.iconColor!.withOpacity(0.30), // илүү glow мэдрэмжтэй болгоё
        blurRadius: 14,
        spreadRadius: 2,
        offset: Offset(0, 3),
      ),
    ],
  ),
  child: CircleAvatar(
    radius: 23, // жаахан томруулж илүү "glow"
    backgroundColor: Colors.white,
    child: Icon(
      catTxn.iconData,
      color: catTxn.iconColor,
      size: 25,
      shadows: [
        Shadow(
          color: catTxn.iconColor!.withOpacity(0.21),
          blurRadius: 6,
        ),
      ],
    ),
  ),
),

                SizedBox(height: 4),
                Text(
                  catTxn.categoryName,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                // Хоёр хувь зэрэг харуулна
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (income > 0)
                      Text(
                        "+$incomePercent%",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    if (expense > 0)
                      Text(
                        "-$expensePercent%",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
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
    return {
      'Гэр бүлийн гүйлгээ': familyBalance,
      'Хувийн гүйлгээ': privateBalance,
    };
  }

  String formatCurrency(double value, {bool symbolFirst = true}) {
    final formatter = NumberFormat("#,##0", "mn");
    return symbolFirst
        ? "${formatter.format(value)} ₮"
        : "₮ ${formatter.format(value)}";
  }

  void showTransactionDetailDialog(BuildContext context, TransactionModel txn) {
    // Transaction info-г үзүүлэх өөрийнхөө dialog эсвэл дэлгэцийг дуудаарай.
    // Get.to(() => TransactionInfoView(transaction: txn));
  }
  Map<String, Map<String, double>> calculateIncomeExpense(List<TransactionModel> transactions) {
  // {walletType: {income: ..., expense: ...}}
  double familyIncome = 0.0, familyExpense = 0.0;
  double privateIncome = 0.0, privateExpense = 0.0;

  for (var txn in transactions) {
    if (txn.walletType == 'family') {
      if (txn.transactionType == 'income') familyIncome += txn.transactionAmount;
      if (txn.transactionType == 'expense') familyExpense += txn.transactionAmount;
    }
    if (txn.walletType == 'private') {
      if (txn.transactionType == 'income') privateIncome += txn.transactionAmount;
      if (txn.transactionType == 'expense') privateExpense += txn.transactionAmount;
    }
  }

  return {
    'Гэр бүлийн гүйлгээ': {
      'income': familyIncome,
      'expense': familyExpense,
    },
    'Хувийн гүйлгээ': {
      'income': privateIncome,
      'expense': privateExpense,
    },
  };
}
}
