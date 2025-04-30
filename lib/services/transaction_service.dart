// import 'dart:convert';
// import 'package:budgetfrontend/models/transaction.dart';
// import 'package:http/http.dart' as http;

// class TransactionService {
//   final String baseUrl = 'http://172.16.149.76:3001/transactions'; // Replace with your API endpoint

//   // Fetch transactions from API
//   Future<List<Transaction>> fetchTransactions() async {
//     final response = await http.get(Uri.parse(baseUrl));

//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body)['data'];
//       return data.map((json) => Transaction.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to load transactions');
//     }
//   }

//   // Create a new transaction
//   Future<void> createTransaction(Map<String, dynamic> transactionData) async {
//     final response = await http.post(
//       Uri.parse(baseUrl),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode(transactionData),
//     );

//     if (response.statusCode != 201) {
//       throw Exception('Failed to create transaction');
//     }
//   }
// }