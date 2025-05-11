import 'dart:convert';
import 'package:budgetfrontend/models/category_model.dart';
import 'package:budgetfrontend/models/transaction_model.dart';
import 'package:budgetfrontend/services/auth_service.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://172.16.150.26:3001/api/v1';

  static Future<Map<String, String>> get headers async {
    final token = await AuthService.getToken();
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  // ------------------- TRANSACTIONS -------------------

 static Future<List<TransactionModel>> getTransactions() async {
    final response = await http.get(
      Uri.parse('$baseUrl/transactions'),
      headers: await headers,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json is Map && json['data'] is List) {
        return (json['data'] as List).map((item) {
          final attributes = item['attributes'];
          attributes['id'] = int.tryParse(item['id'].toString()); // id-г attributes руу хийнэ
          return TransactionModel.fromJson(attributes);
        }).toList();
      }
      throw Exception('Unexpected JSON structure');
    } else {
      throw Exception('Failed to load transactions');
    }
  }

static Future<TransactionModel?> postTransactionWithType(TransactionModel txn, String type) async {
  final bodyData = txn.toJson();
  bodyData['type'] = type; // "type" гэж нэмэлтээр хийчихнэ
  final response = await http.post(
    Uri.parse('$baseUrl/transactions'),
    headers: await headers,
    body: jsonEncode(bodyData), // ❗️шууд transaction-ийн талбарууд явуулна
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    final attributes = jsonDecode(response.body)['data']['attributes'];
    return TransactionModel.fromJson(attributes);
  } else {
    print('❌ Гүйлгээ үүсгэхэд алдаа гарлаа: ${response.statusCode} - ${response.body}');
    return null;
  }
}


  

  static Future<TransactionModel?> getTransactionById(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/transactions/$id'),
      headers: await headers,
    );

    if (response.statusCode == 200) {
      return TransactionModel.fromJson(jsonDecode(response.body));
    } else {
      print('Гүйлгээ харахад алдаа гарлаа: ${response.statusCode} - ${response.body}');
      return null;
    }
  }

  static Future<TransactionModel?> updateTransaction(TransactionModel txn) async {
    final response = await http.put(
      Uri.parse('$baseUrl/transactions/${txn.id}'),
      headers: await headers,
      body: jsonEncode(txn.toJson()),
    );

    if (response.statusCode == 200) {
      return TransactionModel.fromJson(jsonDecode(response.body));
    } else {
      print('Гүйлгээ шинэчлэхэд алдаа гарлаа: ${response.statusCode} - ${response.body}');
      return null;
    }
  }

  static Future<bool> deleteTransaction(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/transactions/$id'),
      headers: await headers,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Гүйлгээ устгах үед алдаа гарлаа: ${response.statusCode} - ${response.body}');
      return false;
    }
  }

  // ------------------- CATEGORIES -------------------

  // static Future<List<CategoryModel>> getCategories(String type) async {
  //   final response = await http.get(
  //     Uri.parse('$baseUrl/categories?transaction_type=$type'),
  //     headers: await headers,
  //   );

  //   if (response.statusCode == 200) {
  //     final List data = jsonDecode(response.body);
  //     return data.map((e) => CategoryModel.fromJson(e)).toList();
  //   } else {
  //     throw Exception('Категори татаж чадсангүй');
  //   }
  // }

  static Future<List<CategoryModel>> getCategories(String type) async {
  final response = await http.get(
    Uri.parse('$baseUrl/categories?transaction_type=$type'),
    headers: await headers,
  );

  print('🔎 Response Status: ${response.statusCode}');
  print('📦 Body: ${response.body}');

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);

    if (json is Map && json['data'] is List) {
      return (json['data'] as List).map((e) {
        final attributes = e['attributes'];
        attributes['id'] = int.tryParse(e['id'].toString()); // 🔧 ID-г attributes руу оруулна
        return CategoryModel.fromJson(attributes);
      }).toList();
    }

    throw Exception('⚠️ Unexpected JSON structure');
  } else {
    throw Exception('Категори татаж чадсангүй');
  }
}

  static Future<CategoryModel?> createCategory(CategoryModel category) async {
  final response = await http.post(
    Uri.parse('$baseUrl/categories'),
    headers: await headers,
    body: jsonEncode(category.toJson()),
  );

  if (response.statusCode == 201 || response.statusCode == 200) {
    final body = jsonDecode(response.body);
    final attributes = body['data']['attributes']; // ✅ зөв өгөгдөл

    // ID-г attributes дотор байхгүй тул гаднаас нь нэмээд өгч болно
    attributes['id'] = int.tryParse(body['data']['id'].toString());

    return CategoryModel.fromJson(attributes);
  } else {
    print('Категори үүсгэхэд алдаа гарлаа: ${response.statusCode} - ${response.body}');
    return null;
  }
}
  static Future<CategoryModel?> getCategoryById(int id) async {
  final response = await http.get(
    Uri.parse('$baseUrl/categories/$id'),
    headers: await headers,
  );

  if (response.statusCode == 200) {
    final body = jsonDecode(response.body);
    final data = body['data'];
    final attributes = data['attributes'];
    attributes['id'] = int.tryParse(data['id'].toString()); // ✅ ID-г attributes руу нэмэх

    return CategoryModel.fromJson(attributes);
  } else {
    print('Категори харахад алдаа гарлаа: ${response.statusCode} - ${response.body}');
    return null;
  }
}

  static Future<CategoryModel?> updateCategory(CategoryModel category) async {
  final response = await http.put(
    Uri.parse('$baseUrl/categories/${category.id}'),
    headers: await headers,
    body: jsonEncode(category.toJson()),
  );

  if (response.statusCode == 200) {
    final body = jsonDecode(response.body);
    final data = body['data'];
    final attributes = data['attributes'];
    attributes['id'] = int.tryParse(data['id'].toString()); // id-г attributes руу оруулна

    return CategoryModel.fromJson(attributes);
  } else {
    print('Категори шинэчлэхэд алдаа гарлаа: ${response.statusCode} - ${response.body}');
    return null;
  }
}

  static Future<bool> deleteCategory(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/categories/$id'),
      headers: await headers,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Категори устгах үед алдаа гарлаа: ${response.statusCode} - ${response.body}');
      return false;
    }
  }
}
