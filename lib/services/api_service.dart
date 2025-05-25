import 'dart:convert';
import 'package:budgetfrontend/controllers/budget_controller.dart';
import 'package:budgetfrontend/controllers/wallet_controller.dart';
import 'package:budgetfrontend/models/budget_model.dart';
import 'package:budgetfrontend/models/category_model.dart';
import 'package:budgetfrontend/models/goal_model.dart';
import 'package:budgetfrontend/models/transaction_model.dart';
import 'package:budgetfrontend/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.1.4:3001/api/v1';

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

        // ✅ Тухайн transaction-ий category_id-г relationships-с гаргаж авна
        final relationships = item['relationships'] as Map<String, dynamic>?;
        if (relationships != null && relationships['category'] != null) {
          attributes['category_id'] = int.tryParse(
            relationships['category']['data']['id'].toString(),
          );
        }

        return TransactionModel.fromJson(attributes);
      }).toList();
    }
    throw Exception('Unexpected JSON structure');
  } else {
    throw Exception('Failed to load transactions');
  }
}

static Future<TransactionModel?> postTransactionWithType(TransactionModel txn, String type) async {
  final bodyData = {
    'transaction': txn.toJson(),
    'type': type,
  };

  final response = await http.post(
    Uri.parse('$baseUrl/transactions'),
    headers: await headers,
    body: jsonEncode(bodyData),
  );

  print('SERVER RESPONSE: ${response.body}'); // Шалгалтын тулд хадгал!

 if (response.statusCode == 200 || response.statusCode == 201) {
    Get.find<WalletController>().fetchWallets();
    Get.find<BudgetController>().fetchBudgets();
  final decoded = jsonDecode(response.body);
  final data = decoded['data'];
  final attributes = data['attributes'] ?? {};
  attributes['id'] = data['id'];

  if (attributes['category_id'] == null &&
      data['relationships'] != null &&
      data['relationships']['category'] != null) {
    attributes['category_id'] =
        int.tryParse(data['relationships']['category']['data']['id'].toString());
  }

  print('ATTRIBUTES: $attributes');
  try {
    return TransactionModel.fromJson(attributes);
  } catch (e) {
    print('FROM JSON ERROR: $e');
    return null;
  }
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

  // -----------------------------------------

  static Future<List<BudgetModel>> fetchBudgets({String? yearMonth}) async {
  final token = await AuthService.getToken();

  final query = yearMonth != null ? "?year=${yearMonth.split('-')[0]}&month=${int.parse(yearMonth.split('-')[1])}" : "";
  final response = await http.get(
    Uri.parse('$baseUrl/budgets$query'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final jsonBody = jsonDecode(response.body);
    if (jsonBody['data'] is List) {
      return (jsonBody['data'] as List)
          .map((item) => BudgetModel.fromJson(item))
          .toList();
    } else {
      throw Exception('Invalid budget data structure');
    }
  } else {
    throw Exception('Failed to fetch budgets');
  }
}

 static Future<void> createBudget(BudgetModel budget) async {
  final token = await AuthService.getToken();
  final body = {
    "budget": budget.toJson(), // ➡️ шууд toJson() ашиглана
  };

  final response = await http.post(
    Uri.parse('$baseUrl/budgets'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(body),
  );

  if (response.statusCode != 201) {
    throw Exception('Failed to create budget');
  }
}

static Future<void> updateBudget(int id, BudgetModel budget) async {
  final token = await AuthService.getToken();
  final body = {
    "budget": budget.toJson(), // ➡️ шууд toJson() ашиглана
  };

  final response = await http.put(
    Uri.parse('$baseUrl/budgets/$id'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(body),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to update budget');
  }
}
  static Future<void> deleteBudget(int id) async {
  final token = await AuthService.getToken();

  final response = await http.delete(
    Uri.parse('$baseUrl/budgets/$id'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode != 204) {
    throw Exception('Failed to delete budget');
  }
}


//------------------------------
static Future<List<GoalModel>> fetchGoals() async {
  final token = await AuthService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/goals'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List<dynamic> data = decoded['data'];
      return data.map((goal) => GoalModel.fromJson(goal)).toList();
    } else {
      throw Exception('Failed to load goals');
    }
  }

   static Future<GoalModel?> createGoal(GoalModel goal) async {
  final token = await AuthService.getToken();
  final response = await http.post(
    Uri.parse('$baseUrl/goals'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({"goal": goal.toJson()}),
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    final decoded = jsonDecode(response.body);
    return GoalModel.fromJson(decoded['data']);
  } else {
    return null;
  }
}

// Goal шинэчлэх API
static Future<GoalModel?> updateGoal(GoalModel goal) async {
  final token = await AuthService.getToken();
  final response = await http.put(
    Uri.parse('$baseUrl/goals/${goal.id}'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({"goal": goal.toJson()}),
  );

  if (response.statusCode == 200) {
    final decoded = jsonDecode(response.body);
    return GoalModel.fromJson(decoded['data']);
  } else {
    return null;
  }
}


}
