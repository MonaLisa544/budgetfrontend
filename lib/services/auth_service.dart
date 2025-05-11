import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _baseUrl = "http://172.16.150.26:3001";

  // Токен хадгалах
  static Future<void> storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }
 
  // Токен авах
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Нэвтрэх
  static Future<bool> login(String email, String password) async {
    final url = Uri.parse("$_baseUrl/users/sign_in");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user': {'email': email, 'password': password}}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      if (data.containsKey('token')) {
        await storeToken(data['token']);
        return true;
      }
    }
    return false;
  }

  // Бүртгүүлэх
  static Future<bool> signup(String lastName, String firstName, String email, String password, String confirmPassword) async {
    final url = Uri.parse("$_baseUrl/users");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user': {
          'lastName': lastName,
          'firstName': firstName,
          'email': email,
          'password': password,
          'password_confirmation': confirmPassword,
        }
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      if (data.containsKey('token')) {
        await storeToken(data['token']);
        return true;
      }
    }
    return false;
  }

  // Гарах
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Хэрэглэгчийн мэдээлэл авах
  static Future<void> getUserInfo() async {
    final token = await getToken();
    if (token == null) return;

    final response = await http.get(
      Uri.parse("$_baseUrl/users/me"),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      print("User Info: ${response.body}");
    } else {
      print("Хэрэглэгчийн мэдээлэл татаж чадсангүй");
    }
  }
}
