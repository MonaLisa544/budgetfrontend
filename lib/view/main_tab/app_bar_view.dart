import 'package:budgetfrontend/common/color_extension.dart';
import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onNotfPressed;
  final VoidCallback onProfilePressed;

  const MainAppBar({
    super.key,
    required this.title,
    required this.onNotfPressed,
    required this.onProfilePressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: TColor.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 27, 27, 27),
        ),
      ),
      title: Row(
        children: [
          IconCircleButton(
            iconData: Icons.person,
            onPressed: onProfilePressed,
          ),
          const SizedBox(width: 10,),
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Row(
            children: [
              IconCircleButton(
                iconData: Icons.notifications_none,
                onPressed: onNotfPressed,
              ),
            ],
          ),
        ),
      ],
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
    Key? key,
    required this.iconData,
    required this.onPressed,
    this.backgroundColor,
    this.color,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 10,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 90, 90, 87),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(iconData, color: Colors.white,),
        onPressed: onPressed,
        iconSize: size ?? 19,
      ),
    );
  }
}

