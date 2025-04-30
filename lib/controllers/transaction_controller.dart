import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TransactionController extends GetxController {
  var transactions = <dynamic>[].obs; // Гүйлгээний жагсаалт
  var isLoading = true.obs; // Гүйлгээний мэдээллийг ачаалж буй байдал

  final String baseUrl = 'https://yourapiurl.com/api/v1/transactions'; // өөрийн API URL оруулна уу

  @override
  void onInit() {
    super.onInit();
    fetchTransactions(); // Гүйлгээний мэдээллийг ачаалах
  }

  // Гүйлгээний мэдээллийг ачаалах
  fetchTransactions() async {
    isLoading(true);
    try {
      var response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'];
        transactions.assignAll(data);
      } else {
        throw Exception('Failed to load transactions');
      }
    } finally {
      isLoading(false);
    }
  }

  // Шинэ гүйлгээ үүсгэх
  createTransaction(Map<String, dynamic> transactionData) async {
    var response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(transactionData),
    );

    if (response.statusCode == 201) {
      fetchTransactions(); // Гүйлгээ амжилттай үүссэн үед жагсаалтыг дахин ачаална
    } else {
      throw Exception('Failed to create transaction');
    }
  }
}