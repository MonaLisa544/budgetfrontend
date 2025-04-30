import 'dart:ui';
import 'package:budgetfrontend/models/transaction.dart';
import 'package:budgetfrontend/views/budgets/subscription_info_view.dart';
import 'package:budgetfrontend/views/main_tab/main_bar_view.dart';
import 'package:budgetfrontend/views/transactions/add_transaction_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionView extends StatefulWidget {
  const TransactionView({super.key});

  @override
  State<TransactionView> createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {
  String selectedType = 'All';
  String selectedWallet = 'Private Wallet';
  DateTime? selectedDate;

  List<TransactionModel> transactions = [
    TransactionModel(
      id: 1,
      title: 'Salary',
      amount: 2500.0,
      type: 'Income',
      walletId: 1,
      categoryId: 1,
      date: DateTime(2025, 4, 10, 8, 30),
      description: 'Monthly salary',
    ),
    TransactionModel(
      id: 2,
      title: 'Groceries',
      amount: 150.0,
      type: 'Expense',
      walletId: 2,
      categoryId: 2,
      date: DateTime(2025, 4, 11, 14, 20),
      description: 'Food shopping',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    List<TransactionModel> filteredTransactions =
        transactions.where((txn) {
          if (selectedType != 'All' && txn.type != selectedType) return false;
          if (selectedWallet == 'Private Wallet' && txn.walletId != 1)
            return false;
          if (selectedWallet == 'Family Wallet' && txn.walletId != 2)
            return false;
          if (selectedDate != null && txn.date != selectedDate) return false;
          return true;
        }).toList();
    bool _isAddedTransaction = false; // Товчны төлөв
    String _buttonText = 'Add Transaction'; // Товчний текст

    final balances = calculateBalances();
    TextEditingController searchController =
        TextEditingController(); // Controller for search input
    List<String> filteredTypes = ['All', 'Income', 'Expense'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MainBarView(
        title: 'Transactions',
        onNotfPressed: () {},
        onProfilePressed: () {},
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_isAddedTransaction) {
              _buttonText = 'Add Transaction';
            } else {
              _buttonText = 'X'; // Товчийг "X" болгож өөрчилнө
            }
            _isAddedTransaction = !_isAddedTransaction;
          });

          if (_isAddedTransaction) {
            // Диалогоор сонголт хийх хэсгийг харуулна
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Гүйлгээний төрөл сонгоно уу"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text("Private transaction"),
                        onTap: () {
                          Navigator.pop(context); // Диалог хаах
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      AddTransactionPage(type: 'Private'),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text("Family transaction"),
                        onTap: () {
                          Navigator.pop(context); // Диалог хаах
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      AddTransactionPage(type: 'Family'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
        backgroundColor: Colors.blue, // Товчны өнгө
        child: Icon(
          _isAddedTransaction
              ? Icons.close
              : Icons.add, // Товчны icon (X эсвэл +)
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/background/background14.jpeg', fit: BoxFit.cover),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 99, sigmaY: 50),
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
                padding: const EdgeInsets.only(
                  top: 8,
                  left: 16,
                  right: 16,
                  bottom: 10,
                ),
                child: Column(
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
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            // decoration: BoxDecoration(
                            //   color: Colors.black.withOpacity(0.5),
                            //   border: const Border(
                            //     top: BorderSide(color: Colors.white24),
                            //   ),
                            // ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Balance:  ',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "\$${balances[selectedWallet]!.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .end, // Aligning everything to the right
                            children: [
                              // Search Button
                              // Space between the buttons
                              // Date Picker Button (Example)
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    // First Container - Нийт орлого
    Container(
      height: 60,
      width: 135,
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(221, 67, 107, 167).withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.arrow_upward,
                size: 14,
                color: Colors.white,
              ),
              SizedBox(width: 4),
              const Text(
                'Нийт орлого:',
                style: TextStyle(
                  color: Color.fromARGB(255, 236, 236, 236),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            "\$${balances[selectedWallet]!.toStringAsFixed(2)} MNT",
            style: const TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),

    const SizedBox(width: 10), // хоорондын зай

    // Second Container - Нийт зарлага
    Container(
      height: 60,
      width: 135,
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(221, 67, 107, 167).withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.arrow_downward,
                size: 14,
                color: Colors.white,
              ),
              SizedBox(width: 4),
              const Text(
                'Нийт зарлага:',
                style: TextStyle(
                  color: Color.fromARGB(255, 236, 236, 2361),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            "\$${balances[selectedWallet]!.toStringAsFixed(2)} MNT",
            style: const TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  ],
),


                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 15,
                              right: 15,
                              top: 2,
                              bottom: 2,
                            ),
                            child: Container(
                              height: 35,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color.fromARGB(
                                      255,
                                      199,
                                      199,
                                      199,
                                    ), // Shadow color
                                    blurRadius: 10.0, // Shadow blur radius
                                    offset: Offset(
                                      2,
                                      2,
                                    ), // Shadow offset (x, y)
                                  ),
                                ],
                                // Rounded corners
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .center, // Center the chips
                                children:
                                    ['All', 'Income', 'Expense'].map((type) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 0.0,
                                        ),
                                        child: ChoiceChip(
                                          label: Text(
                                            type,
                                            style: TextStyle(
                                              color:
                                                  selectedType == type
                                                      ? Colors.white
                                                      : Colors
                                                          .black, // Change text color based on selection
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          selected: selectedType == type,
                                          selectedColor: const Color.fromARGB(
                                            255,
                                            16,
                                            88,
                                            221,
                                          ).withOpacity(
                                            0.75,
                                          ), // Active chip color (green)
                                          backgroundColor:
                                              Colors
                                                  .white, // Inactive chip background
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ), // Rounded corners for chips
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 8,
                                          ), // Padding inside the chip
                                          onSelected:
                                              (_) => setState(
                                                () => selectedType = type,
                                              ), // Update selected type
                                        ),
                                      );
                                    }).toList(),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),

                          Container(
                            padding: EdgeInsets.only(top: 0, bottom: 200),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 17,
                                    vertical: 8,
                                  ), // left & right зай
                                  child: Row(
                                    children: [
                                      Text(
                                        "Transactions",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Spacer(),

                                      // Date Button
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: IconButton(
                                          onPressed: pickSingleDate,
                                          icon: Icon(
                                            Icons.calendar_month,
                                            size: 20,
                                          ),
                                          padding: EdgeInsets.zero,
                                          constraints: BoxConstraints(),
                                          color: Color.fromARGB(
                                            255,
                                            75,
                                            75,
                                            75,
                                          ),
                                        ),
                                      ),

                                      SizedBox(width: 4),

                                      // Filter Button
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                            255,
                                            205,
                                            216,
                                            243,
                                          ).withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: IconButton(
                                          onPressed: () {
                                            print("Filter button pressed");
                                          },
                                          icon: Icon(
                                            Icons.filter_alt,
                                            size: 20,
                                          ),
                                          padding: EdgeInsets.zero,
                                          constraints: BoxConstraints(),
                                          color: Color.fromARGB(
                                            255,
                                            90,
                                            90,
                                            90,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),

                                const SizedBox(height: 10),

                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: filteredTransactions.length,
                                  itemBuilder: (context, index) {
                                    final txn = filteredTransactions[index];
                                    bool isIncome = txn.type == 'Income';
                                    return Card(
                                      // Using Card instead of _BlurredCard
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          20,
                                        ), // You can keep the border radius here
                                      ),
                                      elevation:
                                          4, // Optional: Add elevation for a subtle shadow
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor:
                                              txn.walletId == 1
                                                  ? Colors.blueAccent
                                                  : Colors.orangeAccent,
                                          child: Icon(
                                            getWalletIcon(txn.walletId),
                                            color: Colors.white,
                                          ),
                                        ),
                                        title: Text(
                                          txn.title,
                                          style: const TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "${getWalletName(txn.walletId)} • ${DateFormat('yyyy-MM-dd').format(txn.date)}",
                                          style: const TextStyle(
                                            color: Color.fromARGB(179, 0, 0, 0),
                                            fontSize: 12,
                                          ),
                                        ),
                                        trailing: Text(
                                          (isIncome ? "+" : "-") +
                                              "\$${txn.amount.toStringAsFixed(2)}",
                                          style: TextStyle(
                                            color:
                                                isIncome
                                                    ? Colors.greenAccent
                                                    : Colors.redAccent,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        Colors.blueAccent, // Text color
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ), // Padding
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      ), // Rounded corners
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => SubscriptionInfoView(
                                              sObj: {
                                                "icon":
                                                    "assets/img/sample_icon.png", // Replace with your icon path
                                                "name": "Sample Subscription",
                                                "price": "10.00",
                                              },
                                            ),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Click Me!',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void pickSingleDate() async {
    final pickedDate = await showDialog<DateTime>(
      context: context,
      builder: (context) => DatePickerDialog(),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Map<String, double> calculateBalances() {
    double familyBalance = 0.0;
    double privateBalance = 0.0;

    for (var txn in transactions) {
      if (txn.walletId == 1) {
        familyBalance += txn.type == 'Income' ? txn.amount : -txn.amount;
      } else if (txn.walletId == 2) {
        privateBalance += txn.type == 'Income' ? txn.amount : -txn.amount;
      }
    }

    return {'Family Wallet': familyBalance, 'Private Wallet': privateBalance};
  }

  String getWalletName(int walletId) {
    if (walletId == 1) return 'Family Wallet';
    if (walletId == 2) return 'Private Wallet';
    return 'Unknown';
  }

  IconData getWalletIcon(int walletId) {
    if (walletId == 1) return Icons.group;
    if (walletId == 2) return Icons.person;
    return Icons.help_outline;
  }
}

class DatePickerDialog extends StatelessWidget {
  const DatePickerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Date'),
      content: CalendarDatePicker(
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2030),
        onDateChanged: (selectedDate) {
          Navigator.of(context).pop(selectedDate); // Return selected date
        },
      ),
    );
  }
}
