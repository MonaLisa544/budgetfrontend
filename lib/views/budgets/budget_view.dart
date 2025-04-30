import 'dart:ui';
import 'package:budgetfrontend/widgets/budgets_row.dart';
import 'package:budgetfrontend/widgets/option_btn.dart';
import 'package:flutter/material.dart';
import 'package:budgetfrontend/views/main_tab/main_bar_view.dart';
import 'package:budgetfrontend/widgets/common/color_extension.dart';

class FamilyView extends StatefulWidget {
  const FamilyView({super.key});

  @override
  State<FamilyView> createState() => _FamilyViewState();
}

class _FamilyViewState extends State<FamilyView> {
  List<Map<String, dynamic>> walletCards = [
    {"title": "Total Balance", "amount": "\$5,200,000"},
    {"title": "Savings", "amount": "\$1,500,000"},
    {"title": "Loans", "amount": "-\$2,000,000"},
  ];

  List<Map<String, dynamic>> familyMembers = [
    {"name": "Ээж", "avatar": "assets/img/mother.png"},
    {"name": "Аав", "avatar": "assets/img/father.png"},
    {"name": "Хүү", "avatar": "assets/img/son.png"},
    {"name": "Охин", "avatar": "assets/img/daughter.png"},
  ];

  List<Map<String, dynamic>> budgetArr = [
    {
      "name": "Auto & Transport",
      "icon": "assets/img/auto_&_transport.png",
      "spend_amount": "25.99",
      "total_budget": "400",
      "left_amount": "250.01",
      "color": TColor.secondaryG,
    },
    {
      "name": "Entertainment",
      "icon": "assets/img/entertainment.png",
      "spend_amount": "50.99",
      "total_budget": "600",
      "left_amount": "300.01",
      "color": TColor.secondary50,
    },
    {
      "name": "Security",
      "icon": "assets/img/security.png",
      "spend_amount": "5.99",
      "total_budget": "600",
      "left_amount": "250.01",
      "color": TColor.primary10,
    },
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MainBarView(
        title: 'Family Dashboard',
        onNotfPressed: () {},
        onProfilePressed: () {},
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/background/background14.jpeg', fit: BoxFit.cover),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 80, sigmaY: 50),
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
                padding: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ Top Card
                    Container(
                      alignment: Alignment.centerLeft,
                      height: 240,
                      width: media.width,
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage("assets/icon/card2.png"),
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(
                              255,
                              229,
                              242,
                              253,
                            ).withOpacity(0.2),
                            offset: const Offset(10, -5),
                            blurRadius: 0.2,
                            spreadRadius: -10,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          const Text(
                            'Total Balance:',
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          ),
                          const SizedBox(height: 3),
                          const Text(
                            '£3,236.00',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // ✅ Savings Button
                              OptionButton(
                                icon: Icons.savings_outlined,
                                title: "Saving",
                                //subtitle: "Your Savings",
                                onTap: () {
                                  // Saving дарсан үед юу хийхийг энд бич
                                },
                              ),
                              const SizedBox(width: 7),

                              // ✅ Loan Button
                              OptionButton(
                                icon: Icons.credit_card_outlined,
                                title: "Loan",
                                onTap: () {
                                  // Loan дарсан үед юу хийхийг энд бич
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // const SizedBox(height: 5),
                    // ✅ Section Title
                    Text(
                      "    Family Members",
                      style: TextStyle(
                        color: TColor.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    // ✅ Family Members Horizontal Scroll
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 8,
                        top: 5,
                        bottom: 2,
                      ), // <<< 16px өгвөл маш гоё зайтай болно
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white24, width: 2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: SizedBox(
                          height: 75,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: familyMembers.length + 1,
                            itemBuilder: (context, index) {
                              if (index == familyMembers.length) {
                                return _buildAddMember();
                              }
                              var member = familyMembers[index];
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                child: _buildFamilyMember(
                                  member["name"],
                                  member["avatar"],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // ✅ Budget Section Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "   This Month's Budget",
                          style: TextStyle(
                            color: TColor.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "View All ➔",
                            style: TextStyle(
                              color: Color.fromARGB(255, 23, 130, 218),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // ✅ (Chart хэсгийг хассан! Хоосон үлдээсэнгүй)
                    // / ✅ Budgets List
                    ListView.builder(
                      itemCount: budgetArr.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemBuilder: (context, index) {
                        var bObj = budgetArr[index];
                        return BudgetsRow(
                          bObj: bObj,
                          onPressed: () {
                            // Тухайн Budget дээр дарахад юу хийхийг энд бичнэ
                          },
                        );
                      },
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

  Widget _buildFamilyMember(String name, String avatarPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        children: [
          CircleAvatar(radius: 26, backgroundImage: AssetImage(avatarPath)),
          const SizedBox(height: 4),
          Text(name, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildAddMember() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white.withOpacity(0.3),
            child: const Icon(Icons.add, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 4),
          const Text(
            "Add",
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
