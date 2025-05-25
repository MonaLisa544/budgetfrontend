import 'package:budgetfrontend/views/home/back_app_bar.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  // Жишээ notification list
  final List<NotificationItem> notifications = const [
    NotificationItem(
      title: "Шинэ орлого нэмэгдлээ",
      body: "₮50,000 орлого 2025-05-21 өдөр нэмэгдсэн.",
      date: "2025-05-21 10:03",
      icon: Icons.attach_money,
      color: Colors.greenAccent,
    ),
    NotificationItem(
      title: "Төлөвлөгөө дөхөж байна",
      body: "Зарлагын хязгаарт дөхөж байна!",
      date: "2025-05-20 19:12",
      icon: Icons.warning_amber_rounded,
      color: Colors.orangeAccent,
    ),
    NotificationItem(
      title: "Өрхийн гишүүн нэмж оров",
      body: "Хонгорзул шинэ гишүүнээр нэмэгдлээ.",
      date: "2025-05-19 16:25",
      icon: Icons.person_add_alt_1,
      color: Colors.blueAccent,
    ),
  ];

  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 245, 255),
      appBar: BackAppBar(
        title: 'Мэдэгдэл',
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/icon/background15.jpg', fit: BoxFit.cover),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 235, 245, 255),
                    Colors.transparent,
                  ],
                  stops: [1.0, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            child: notifications.isEmpty
                ? const Center(child: Text("Мэдэгдэл байхгүй байна"))
                : ListView.separated(
                    itemCount: notifications.length,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                    separatorBuilder: (ctx, i) =>
                        const Divider(height: 25, color: Colors.black12),
                    itemBuilder: (context, index) {
                      final notif = notifications[index];
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: notif.color.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Icon(notif.icon, color: notif.color, size: 28),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  notif.title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600, fontSize: 15),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  notif.body,
                                  style: const TextStyle(
                                      fontSize: 13, color: Colors.black87),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  notif.date,
                                  style: const TextStyle(
                                      fontSize: 11, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class NotificationItem {
  final String title;
  final String body;
  final String date;
  final IconData icon;
  final Color color;

  const NotificationItem({
    required this.title,
    required this.body,
    required this.date,
    required this.icon,
    required this.color,
  });
}
