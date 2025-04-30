import 'dart:ui';
import 'package:budgetfrontend/widgets/common/color_extension.dart';
import 'package:budgetfrontend/views/main_tab/main_bar_view.dart';
import 'package:budgetfrontend/widgets/line_chart.dart';
import 'package:budgetfrontend/widgets/option_btn.dart';
import 'package:budgetfrontend/widgets/transaction_item.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    Container(
                      alignment: Alignment.centerLeft,
                      height: 240,
                      width: 420,
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        image: DecorationImage(
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
                            ).withOpacity(0.3),
                            offset: Offset(15, -8),
                            blurRadius: 0.5,
                            spreadRadius: -5,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          const Text(
                            'Total Balance:',
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 22,
                            ),
                          ),
                          const SizedBox(height: 3),
                          const Text(
                            '£3,236.00',
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
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
                              SizedBox(width: 7),

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

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "   Analytics",
                          style: TextStyle(
                            color: TColor.white,
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
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 200, child: TransactionLineChart()),
                    // Latest transactions section
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
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
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 0,
                      ),
                      physics:
                          const NeverScrollableScrollPhysics(), // Disable scroll in this ListView
                      shrinkWrap:
                          true, // Makes ListView take only as much space as it needs
                      itemCount: 3, // Use the length of your list here
                      itemBuilder: (context, index) {
                        return TransactionItem(
                          icon: Icons.shopping_cart,
                          title: 'IODash Purchase',
                          subtitle: 'Online payment',
                          amount: '-\$28.00',
                          time: '4 Aug 1:00 PM',
                        );
                      },
                    ),
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
}

// Avatar with Name
class _AvatarWithName extends StatelessWidget {
  final String imagePath;
  final String name;

  const _AvatarWithName({required this.imagePath, required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(backgroundImage: AssetImage(imagePath), radius: 25),
        const SizedBox(height: 4),
        Text(name, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}


