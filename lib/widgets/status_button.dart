import 'package:flutter/material.dart';

import 'common/color_extension.dart';

class StatusButton extends StatelessWidget {
  final String title;
  final String value;
  final Color statusColor;

  final VoidCallback onPressed;
  const StatusButton(
      {super.key,
      required this.title,
      required this.value,
      required this.statusColor,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            padding: EdgeInsets.all(3),
            //height: 300,
            // decoration: BoxDecoration(
            //   border: Border.all(
            //     color: TColor.border.withOpacity(0.15),
            //   ),
            //   color: TColor.gray50.withOpacity(0.2),
            //   borderRadius: BorderRadius.circular(10),
            // ),
            alignment: Alignment.center,
            child: Column(
              //mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      color: TColor.white.withOpacity(0.9),
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  value,
                  style: TextStyle(
                      color: TColor.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          // Positioned(
          //    left: 0, // Зүүн талд байрлуулах
          //   top: 0,  // Дээд талд байрлах
          //   bottom: 0,  // Төмөр дээгүүр харагдах
          //   child: Container(
          //     width: 2,
          //     height: 5,
          //     color: statusColor,
          //   ),
          // ),
        ],
      ),
    );
  }
}
