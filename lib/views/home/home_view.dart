import 'dart:ui';
import 'package:budgetfrontend/controllers/auth_controller.dart';
import 'package:budgetfrontend/controllers/family_controller.dart';
import 'package:budgetfrontend/controllers/wallet_controller.dart';
import 'package:budgetfrontend/views/home/create_family.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:budgetfrontend/widgets/line_chart.dart';
import 'package:budgetfrontend/views/home/main_bar_view.dart';
import 'package:get/get.dart';

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
  
 @override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    walletController.fetchWallets();
    familyController.fetchFamilyInfo();
    familyController.fetchFamilyMembers(); // 👈 Гэр бүлийн гишүүдийг татна
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MainBarView(
        title:
            "Сайна уу! ${Get.find<AuthController>().user.value?.firstName ?? ''} ${Get.find<AuthController>().user.value?.lastName ?? ''}",
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
        title: 'Private Balance',
        balance: myWallet?.balance ?? 0,
      ),
      _buildBalanceCard(
        title: 'Family Balance',
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
                    _buildAnalyticsSection(),
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

 Widget _buildBalanceCard({required String title, required double balance}) {
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
                          style: const TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '₮${balance.toStringAsFixed(0)}',
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
  final bool isFamilyWallet = title == 'Family Balance'; // ← энд зөв
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
                  const Icon(Icons.arrow_upward, color: Colors.white, size: 18),
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

        // 🏁 БАРУУН ДООД буланд NFC icon-г буцааж нэмнэ!
        Positioned(
          bottom: 12,
          right: 12,
          child: Image.asset(
            'assets/icon/cardd2.png', // ← энд чиний жижиг цагаан icon байрлаж байна
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
        final familyName = familyController.family.value?.familyName ?? 'Family';
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            familyName,
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
                'No family members',
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
  return _buildFamilyMember(member.firstName, member.profilePhotoUrl ?? '');
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
              color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.4),
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
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.blueAccent, width: 2), // ✅ Border нэмсэн
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 68, 127, 255).withOpacity(0.4),
                blurRadius: 6,
                offset: const Offset(3, 3),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white,
            backgroundImage: avatarUrl.isNotEmpty
                ? NetworkImage(avatarUrl)
                : const AssetImage('assets/img/default_user_profile.png') as ImageProvider,
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 70, // ✅ Нэрний уртыг хязгаарлах
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

 Future<void> _showEditBalanceDialog({required String title, required bool isFamilyWallet}) async {
  final TextEditingController balanceController = TextEditingController();
  final wallet = isFamilyWallet ? walletController.familyWallet.value : walletController.myWallet.value;
  if (wallet != null) {
    balanceController.text = wallet.balance.toStringAsFixed(0);
  }

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.4,
        maxChildSize: 0.6,
        minChildSize: 0.3,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
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
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 209, 215, 221),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Text(
                    "$title шинэчлэх",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: balanceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Шинэ баланс оруулна уу",
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.blue),
                          ),
                          child: const Text("Болих", style: TextStyle(color: Colors.blue)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () async {
                            final newBalance = double.tryParse(balanceController.text);
                            if (newBalance != null) {
                              if (isFamilyWallet) {
                                await walletController.updateFamilyWalletBalance(newBalance);
                              } else {
                                await walletController.updateMyWalletBalance(newBalance);
                              }
                              Navigator.pop(context);
                            }
                          },
                          child: const Text("Хадгалах"),
                        ),
                      ),
                    ],
                  ),
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
