import 'package:flutter/material.dart';

class AddTransactionView extends StatelessWidget {
  const AddTransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dialog Example"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Popup (Dialog) гаргаж ирэх код
            showDialog(
              context: context,
              barrierDismissible: true, // Popup-ыг дэлгэцийн гадна дарж хаах боломжтой болгох
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Давхарлаж гарч ирэх popup-ийн булангийн радиус
                  ),
                  title: const Text("Confirmation"),
                  content: const Text("Are you sure you want to continue?"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Popup хаах
                      },
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Popup хаах
                      },
                      child: const Text("Continue"),
                    ),
                  ],
                );
              },
            );
          },
          child: const Text('Show Dialog'),
        ),
      ),
    );
  }
}