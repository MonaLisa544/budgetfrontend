import 'dart:ui';
import 'package:budgetfrontend/controllers/auth_controller.dart';
import 'package:budgetfrontend/controllers/family_controller.dart';
import 'package:budgetfrontend/controllers/transaction_controller.dart';
import 'package:budgetfrontend/controllers/wallet_controller.dart';
import 'package:budgetfrontend/models/transaction_model.dart';
import 'package:budgetfrontend/views/home/create_family.dart';
import 'package:budgetfrontend/views/report/buble_chart.dart';
import 'package:budgetfrontend/widgets/donat_expense.dart';
import 'package:budgetfrontend/widgets/line_chart1.dart';
import 'package:budgetfrontend/widgets/monthly_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:budgetfrontend/widgets/line_chart.dart';
import 'package:budgetfrontend/views/home/main_bar_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool hasFamily = false;
  String? createdFamilyName;

  final AuthController authController =
      Get.find(); // GetX-с AuthController авах

  final WalletController walletController = Get.find<WalletController>();
  final FamilyController familyController = Get.put(FamilyController());
   final transactionController = Get.find<TransactionController>();

    DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      walletController.fetchWallets();
      familyController.fetchFamilyInfo();
      familyController.fetchFamilyMembers(); // 👈 Гэр бүлийн гишүүдийг татна
    });
    final now = DateTime.now();
    startDate = DateTime(now.year, now.month, 1);
    endDate = DateTime(now.year, now.month + 1, 0);
    transactionController.loadTransactions();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MainBarView(
        title:
            "Сайна уу! ${Get.find<AuthController>().user.value?.firstName ?? ''}",
        onNotfPressed: () {},
        onProfilePressed: () {},
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/background/background77.jpeg', fit: BoxFit.cover),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 30),
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
          SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    Obx(() {
                      final myWallet = walletController.myWallet.value;
                      final familyWallet = walletController.familyWallet.value;

                      return CarouselSlider(
                        options: CarouselOptions(
                          height: 180.0,
                          enlargeCenterPage: true,
                          autoPlay: true,
                          aspectRatio: 10 / 16,
                          viewportFraction: 0.95,
                        ),
                        items: [
                          _buildBalanceCard(
                            title: 'Хувийн данс',
                            balance: myWallet?.balance ?? 0,
                          ),
                          _buildBalanceCard(
                            title: 'Гэр бүлийн данс',
                            balance: familyWallet?.balance ?? 0,
                          ),
                        ],
                      );
                    }),

                    const SizedBox(height: 10),
                    
                    Obx(() {
                      return authController.hasFamily.value
                          ? _buildFamilyMembersSection()
                          : _buildCreateFamilyPrompt();
                    }),
                    const SizedBox(height: 10),
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
                                       
                                      });
                                    },
                                  ),
            //          Obx(() {
            //   // Динамик өгөгдлөө харуулна
            //   final months = transactionController.months;
            //   final incomes = transactionController.incomes;
            //   final expenses = transactionController.expenses;

            //   // Хоосон өгөгдөл шалгах
            //   if (months.isEmpty) {
            //     return const Center(child: CircularProgressIndicator());
            //   }

            //   return _buildAnalyticsSection(
            //     months: months,
            //     incomes: incomes,
            //     expenses: expenses,
            //   );
            // }),
                    const SizedBox(height: 20),
                    _buildAnalyticsSection(),
                    // FancyBubbleChart(),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard({required String title, required double balance}) {
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'mn_MN',
      symbol: '₮',
      decimalDigits: 0,
      customPattern: "#,##0 ¤",
    );
    String formattedBalance = currencyFormat.format(balance);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(15),
        image: const DecorationImage(
          image: AssetImage("assets/icon/card3.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(23.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            formattedBalance,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        final bool isFamilyWallet = title == 'Гэр бүлийн данс';
                        _showEditBalanceDialog(
                          title: title,
                          isFamilyWallet: isFamilyWallet,
                        );
                      },
                      child: const Icon(
                        Icons.tune_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    const Icon(
                      Icons.arrow_upward,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      "+3.5% from last month",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 12,
            right: 12,
            child: Image.asset(
              'assets/icon/cardd2.png',
              width: 70,
              height: 60,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateFamilyPrompt() {
    return Center(
      child: Column(
        children: [
          const Text(
            "Та одоогоор гэр бүл үүсгээгүй байна.",
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () async {
              final familyName = await showFamilyDialog(
                context,
              ); // 👈 await ашиглана
              if (familyName != null) {
                setState(() {
                  hasFamily = true;
                  createdFamilyName = familyName;
                });
              }
            },
            icon: const Icon(Icons.group_add),
            label: const Text("Гэр бүлтэй болох"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyMembersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // ✅ Зүүн тийш төвлөрүүлнэ
      children: [
        const SizedBox(height: 10),
        Obx(() {
          final familyName =
              familyController.family.value?.familyName ?? 'Family';
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              "${familyName} гишүүд",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          );
        }),
        const SizedBox(height: 12),
        SizedBox(
          height: 85, // ✅ Бага зэрэг өндөр болгож өглөө
          child: Obx(() {
            if (familyController.isLoadingMembers.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final members = familyController.familyMembers;
            if (members.isEmpty) {
              return const Center(
                child: Text(
                  'Гэр бүлийн гишүүн байхгүй байна ',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              );
            }

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: members.length + 1,
              itemBuilder: (context, index) {
                if (index == members.length) {
                  // ✅ Сүүлд Add товч оруулна
                  return _buildAddMemberButton();
                }

                final member = members[index];
                return _buildFamilyMember(
                  member.firstName,
                  member.profilePhotoUrl ?? '',
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildAddMemberButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: () {
          // TODO: Гишүүн нэмэх үйлдэл хийх
          print("➕ Add Member clicked!");
        },
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // border: Border.all(color: Colors.white54, width: 2),
                color: const Color.fromARGB(
                  255,
                  255,
                  255,
                  255,
                ).withOpacity(0.4),
              ),
              child: const CircleAvatar(
                radius: 29,
                backgroundColor: Colors.transparent,
                child: Icon(Icons.add, color: Colors.white, size: 30),
              ),
            ),
            const SizedBox(height: 6),
            const SizedBox(
              width: 60,
              child: Text(
                "Нэмэх",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFamilyMember(String name, String avatarUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color.fromARGB(255, 220, 219, 219),
                width: 2,
              ), // ✅ Border нэмсэн
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(
                    255,
                    255,
                    255,
                    255,
                  ).withOpacity(0.4),
                  blurRadius: 6,
                  offset: const Offset(3, 3),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 28,
              backgroundColor: Colors.white,
              backgroundImage:
                  avatarUrl.isNotEmpty
                      ? NetworkImage(avatarUrl)
                      : const AssetImage('assets/img/default_user_profile.png')
                          as ImageProvider,
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 50, // ✅ Нэрний уртыг хязгаарлах
            child: Text(
              name,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsSection() {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              "     Тайлан",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: const Text(
                "харах ➔",
                style: TextStyle(
                  color: Color.fromARGB(255, 23, 130, 218),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          height: 200,
          child: const TransactionLineChart(),
        ),
      ],
    );
  }

  Future<void> _showEditBalanceDialog({
    required String title,
    required bool isFamilyWallet,
  }) async {
    final NumberFormat formatter = NumberFormat("#,##0", "en_US");
    final TextEditingController balanceController = TextEditingController();

    final wallet =
        isFamilyWallet
            ? walletController.familyWallet.value
            : walletController.myWallet.value;
    if (wallet != null) {
      balanceController.text = formatter.format(wallet.balance);
    }

    // Real-time формат
    balanceController.addListener(() {
      String text = balanceController.text
          .replaceAll(',', '')
          .replaceAll('₮', '');
      if (text.isEmpty) return;
      double? value = double.tryParse(text);
      if (value != null) {
        String newText = formatter.format(value);
        if (balanceController.text != newText) {
          balanceController.value = TextEditingValue(
            text: newText,
            selection: TextSelection.collapsed(offset: newText.length),
          );
        }
      }
    });

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.43,
          maxChildSize: 0.65,
          minChildSize: 0.35,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.09),
                    blurRadius: 24,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 18),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    // Title + icon
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.blue.shade100,
                          child: Icon(
                            isFamilyWallet ? Icons.groups : Icons.person,
                            color: Colors.blueAccent,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "$title шинэчлэх",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff333546),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Шинэ мөнгөн дүнгээ оруулна уу",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    // Input
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.grey.shade100,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.shade50,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: balanceController,
                        keyboardType: TextInputType.number,
                        // cursorColor: Colors.blue,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 18, right: 6),
                            child: Text(
                              "₮",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                                color: Color(0xff0076e8),
                              ),
                            ),
                          ),
                          prefixIconConstraints: const BoxConstraints(
                            minWidth: 0,
                            minHeight: 0,
                          ),
                          hintText: "0",
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                            color: Colors.grey.shade400,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xff0076e8)),
                              foregroundColor: const Color(0xff0076e8),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text("Болих"),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff0076e8),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () async {
                              String text = balanceController.text.replaceAll(
                                ',',
                                '',
                              );
                              final newBalance = double.tryParse(text);
                              if (newBalance != null) {
                                if (isFamilyWallet) {
                                  await walletController
                                      .updateFamilyWalletBalance(newBalance);
                                } else {
                                  await walletController.updateMyWalletBalance(
                                    newBalance,
                                  );
                                }
                                Navigator.pop(context);
                              }
                            },
                            child: const Text("Хадгалах"),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
 




