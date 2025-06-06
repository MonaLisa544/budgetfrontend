import 'dart:io';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ExportDataScreen extends StatefulWidget {
  const ExportDataScreen({super.key});

  @override
  State<ExportDataScreen> createState() => _ExportDataScreenState();
}

class _ExportDataScreenState extends State<ExportDataScreen> {
  int selectedFormat = 0; // 0: CSV, 1: PDF

  // ГАРААР БУТСАН ДАТА
  final List<List<dynamic>> exportData = [
    ['Огноо', 'Төрөл', 'Дүн', 'Тайлбар'],
    ['2024-06-02', 'Орлого', 15000, 'Цалин'],
    ['2024-06-05', 'Зарлага', 8000, 'Хоол'],
    ['2024-06-07', 'Орлого', 3000, 'Хүссэн орлого'],
  ];

  Future<void> exportCSV() async {
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission олгогдоогүй!')),
      );
      return;
    }
    String csv = const ListToCsvConverter().convert(exportData);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/report.csv');
    await file.writeAsString(csv);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('CSV файл хадгаллаа: ${file.path.split('/').last}')),
    );
  }

  Future<void> exportPDF() async {
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission олгогдоогүй!')),
      );
      return;
    }
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Table.fromTextArray(data: exportData),
      ),
    );
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/report.pdf');
    await file.writeAsBytes(await pdf.save());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF файл хадгаллаа: ${file.path.split('/').last}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Экспорт (Жишээ дата)')),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Формат сонгох', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                ChoiceChip(
                  label: Text('CSV', style: TextStyle(
                    color: selectedFormat == 0 ? Colors.white : Colors.blue,
                    fontWeight: selectedFormat == 0 ? FontWeight.bold : FontWeight.normal,
                  )),
                  selected: selectedFormat == 0,
                  onSelected: (_) => setState(() => selectedFormat = 0),
                  backgroundColor: Colors.grey.shade100,
                  selectedColor: Colors.blue,
                ),
                const SizedBox(width: 14),
                ChoiceChip(
                  label: Text('PDF', style: TextStyle(
                    color: selectedFormat == 1 ? Colors.white : Colors.blue,
                    fontWeight: selectedFormat == 1 ? FontWeight.bold : FontWeight.normal,
                  )),
                  selected: selectedFormat == 1,
                  onSelected: (_) => setState(() => selectedFormat = 1),
                  backgroundColor: Colors.grey.shade100,
                  selectedColor: Colors.blue,
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (selectedFormat == 0) {
                    await exportCSV();
                  } else {
                    await exportPDF();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Хэвлэх',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
