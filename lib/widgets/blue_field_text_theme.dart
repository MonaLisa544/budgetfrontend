import 'package:flutter/material.dart';

class BlueTextFieldTheme extends StatelessWidget {
  final Widget child;

  const BlueTextFieldTheme({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.blue,
          selectionColor: Color(0x882196F3),
          selectionHandleColor: Colors.blue,
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            
            borderSide: BorderSide(color:  Colors.blue, width: 1.5),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: const Color.fromARGB(255, 150, 151, 153), width: 1.2),
            borderRadius: BorderRadius.circular(10),
          ),
          labelStyle: const TextStyle(color: Colors.black87),
          hintStyle: const TextStyle(color: Colors.black54),
          floatingLabelStyle: TextStyle(color: Colors.blue), 
          
        ),
      ),
      child: child,
    );
  }
}
