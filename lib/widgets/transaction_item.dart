import 'package:flutter/material.dart';

class TransactionItem extends StatelessWidget {
  final IconData iconData;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String amount;
  // final String time;
  final VoidCallback? onPressed;

  const TransactionItem({
    super.key,
    required this.iconData,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.amount,
    // required this.time,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Row(
              children: [
                Container(
  width: 40,
  height: 40,
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    color: const Color.fromARGB(255, 246, 251, 255),
    boxShadow: [
      BoxShadow(
        color: iconColor.withOpacity(0.4), // Иконы өнгөтэй glow
        blurRadius: 8,
        spreadRadius: 2,
        offset: const Offset(0, 3),
      ),
    ],
  ),
  child: Center(
    child: Icon(iconData, color: iconColor, size: 22),
  ),
),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white, // ⬅️ Бүх текстүүд цагаан
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Colors.white70, // ⬅️ Subtitle цайвар цагаан
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      amount,
                      style: const TextStyle(
                        color: Colors.white, // ⬅️ Amount цагаан
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Text(
                    //   time,
                    //   style: const TextStyle(
                    //     color: Colors.white70, // ⬅️ Time цайвар цагаан
                    //     fontSize: 12,
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.white24, // ⬅️ Divider-г цагаандуу болгоно
            height: 1,
            thickness: 0.8,
            indent: 16,
            endIndent: 16,
          ),
        ],
      ),
    );
  }
}
