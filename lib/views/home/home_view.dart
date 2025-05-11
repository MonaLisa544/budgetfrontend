import 'dart:ui';
import 'package:budgetfrontend/views/home/create_family.dart';
import 'package:budgetfrontend/views/goals/goal_view.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:budgetfrontend/widgets/option_btn.dart';
import 'package:budgetfrontend/widgets/transaction_item.dart';
import 'package:budgetfrontend/widgets/line_chart.dart';
import 'package:budgetfrontend/views/home/main_bar_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool hasFamily = false;
  String? createdFamilyName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MainBarView(
        title: 'Сайна уу! Хонгороо',
        onNotfPressed: () {},
        onProfilePressed: () {},
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
          SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    buildCarousel(context),
                    const SizedBox(height: 10),
                    hasFamily
                        ? _buildFamilyMembersSection()
                        : _buildCreateFamilyPrompt(),
                    const SizedBox(height: 20),
                    _buildAnalyticsSection(),
                    const SizedBox(height: 20),
                    _buildLatestTransactions(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCarousel(BuildContext context) {
    return SizedBox(
      height: 200,
      child: CarouselSlider(
        options: CarouselOptions(
          height: 180.0,
          enlargeCenterPage: true,
          autoPlay: true,
          aspectRatio: 10 / 16,
          viewportFraction: 0.95,
        ),
        items:
            [1, 2].map((i) {
              return Builder(
                builder: (BuildContext context) {
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
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Balance:',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          const SizedBox(height: 3),
                          const Text(
                            '₮3,236,000',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              OptionButton(
                                icon: Icons.savings_outlined,
                                title: "Saving",
                                onTap:
                                    () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const GoalView(),
                                      ),
                                    ),
                              ),
                              OptionButton(
  icon: Icons.credit_card_outlined,
  title: "Loan",
  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const GoalView(),
                                      ),
                                    ),
)
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }).toList(),
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
    final familyName = await showFamilyDialog(context); // 👈 await ашиглана
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
    final members = [
      {"name": "Ээж", "avatar": "assets/img/mother.png"},
      {"name": "Аав", "avatar": "assets/img/father.png"},
      {"name": "Хүү", "avatar": "assets/img/son.png"},
    ];

    return Column(
      children: [
        Row(
          children: [
            const Text(
              "     Family Members",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: const Text(
                "View All ➔",
                style: TextStyle(
                  color: Color.fromARGB(255, 23, 130, 218),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 75,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: members.length + 1,
            itemBuilder: (context, index) {
              if (index == members.length) return _buildAddMember();
              final member = members[index];
              return _buildFamilyMember(member["name"]!, member["avatar"]!);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFamilyMember(String name, String avatarPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
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
    return Column(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: Colors.white.withOpacity(0.3),
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 4),
        const Text("Add", style: TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }

  Widget _buildAnalyticsSection() {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              "     Analytics",
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
                "View All ➔",
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

  Widget _buildLatestTransactions() {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              "  Last Transaction",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: const Text(
                "View All ➔",
                style: TextStyle(
                  color: Color.fromARGB(255, 23, 130, 218),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            return const TransactionItem(
              icon: Icons.shopping_cart,
              title: 'IODash Purchase',
              subtitle: 'Online payment',
              amount: '-₮28,000',
              time: '4 Aug 1:00 PM',
            );
          },
        ),
      ],
    );
  }
}
