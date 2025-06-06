import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TransactionItem extends StatelessWidget {
  final IconData iconData;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String amount;
  final VoidCallback? onPressed;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onDetail;

  const TransactionItem({
    super.key,
    required this.iconData,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.amount,
    this.onPressed,
    this.onDelete,
    this.onEdit,
    this.onDetail,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: key,
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.4,
        children: [
          // Дэлгэрэнгүй
          CustomSlidableAction(
            onPressed: (_) => onDetail?.call(),
            backgroundColor: Colors.blueAccent.withOpacity(0.03),
            child: _actionButton(
              icon: Icons.visibility,
              label: 'Дэлгэрэнгүй',
              iconColor: Colors.blueAccent,
            ),
            borderRadius: BorderRadius.horizontal(left: Radius.circular(35)),
          ),
          // Засах
          CustomSlidableAction(
            onPressed: (_) => onEdit?.call(),
            backgroundColor: Colors.orangeAccent.withOpacity(0.035),
            child: _actionButton(
              icon: Icons.edit,
              label: 'Засах',
              iconColor: Colors.orangeAccent,
            ),
            //  borderRadius: BorderRadius.horizontal(right: Radius.circular(18)),
          ),
          // Устгах
          CustomSlidableAction(
            onPressed: (_) => onDelete?.call(),
            backgroundColor: Colors.redAccent.withOpacity(0.035),
            child: _actionButton(
              icon: Icons.delete,
              label: 'Устгах',
              iconColor: Colors.redAccent,
            ),
            borderRadius: BorderRadius.horizontal(right: Radius.circular(35)),
          ),
        ],
      ),
      child: InkWell(
        onTap: onPressed,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 23.0, vertical: 7.0),
              child: Row(
                children: [
             Container(
  width: 40,
  height: 40,
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        iconColor.withOpacity(0.5),
        iconColor.withOpacity(0.9),
      ],
    ),
    boxShadow: [
      // Доор зүүн тал буюу “гэрлийн эх” талаас цагаан сүүдэр
      BoxShadow(
        color: Colors.white.withOpacity(0.8),
        offset: Offset(-3, -3),
        blurRadius: 4,
      ),
      // Баруун доод буюу “гарахи” зурвасын сүүдэр
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        offset: Offset(3, 3),
        blurRadius: 4,
      ),
    ],
  ),
  child: Center(
  child: Icon(
    iconData,
    color: Colors.white,
    size: 26,
    shadows: [
      Shadow(
        color: Colors.black26,
        offset: Offset(0, 1),
        blurRadius: 2,
      )
    ],
  ),
)
),

                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.5,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 13.5,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    amount,
                    style: TextStyle(
                      color: amount.startsWith('-') ? Colors.red[600] : Colors.green[600],
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              color: Color.fromARGB(60, 90, 89, 89),
              height: 1,
              thickness: 0.8,
              indent: 16,
              endIndent: 16,
            ),
          ],
        ),
      ),
    );
  }

  // Custom Action Button UI
  Widget _actionButton({required IconData icon, required String label, Color? iconColor}) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Icon(icon, size: 23, color: iconColor ?? Colors.black87)),
          SizedBox(height: 2),
          // Text(
          //   label,
          //   style: TextStyle(
          //     fontSize: 10,
          //     fontWeight: FontWeight.w600,
          //     letterSpacing: -0.5,
          //     color: iconColor ?? Colors.black87,
          //   ),
          //   textAlign: TextAlign.center,
          // ),
        ],
      ),
    );
  }
}
