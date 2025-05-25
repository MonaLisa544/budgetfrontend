import 'package:budgetfrontend/controllers/auth_controller.dart';
import 'package:budgetfrontend/views/report/report_view.dart';
import 'package:budgetfrontend/views/user/notification_view.dart';
import 'package:budgetfrontend/views/user/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainBarView extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onNotfPressed;
  final VoidCallback onProfilePressed;
  final bool showChartIcon; // ШИНЭ параметр

  const MainBarView({
    super.key,
    required this.title,
    required this.onNotfPressed,
    required this.onProfilePressed,
    this.showChartIcon = false, // default нь false
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
             
             
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        color: const Color.fromARGB(255, 42, 42, 42),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
               if (showChartIcon) // зөвхөн true үед гаргана
                IconCircleButton(
                  iconData: Icons.show_chart,
                  onPressed: () {Get.to(() => ReportView());},
                ),
              const SizedBox(width: 8),
              IconCircleButton(
                iconData: Icons.notifications_none,
                onPressed: () {Get.to(() => NotificationPage());},
              ),
              const SizedBox(width: 6),
              IconButton(
  onPressed: () {
    Get.to(() => ProfileView());
  },
  icon: Obx(() {
    final user = Get.find<AuthController>().user.value;
    return CircleAvatar(
      radius: 22,
      backgroundImage: user?.profilePhotoUrl != null
          ? NetworkImage(user!.profilePhotoUrl!)
          : const AssetImage("assets/img/default_profile.png") as ImageProvider,
    );
  }),
),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class IconCircleButton extends StatelessWidget {
  final IconData iconData;
  final VoidCallback onPressed;
  final Gradient? backgroundColor;
  final Color? color;
  final double? size;

  const IconCircleButton({
    super.key,
    required this.iconData,
    required this.onPressed,
    this.backgroundColor,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 10,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(iconData, color: const Color.fromARGB(255, 124, 123, 123)),
        onPressed: onPressed,
        iconSize: size ?? 22,
      ),
    );
  }
}
