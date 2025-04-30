import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("http://172.16.150.142:3001/users/sign_in"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user': {'email': email, 'password': password},
      }),
    );

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      // If the response is successful, extract the token from the body
      var responseData = jsonDecode(response.body);
      String token =
          responseData['token']; // assuming the token is returned as 'token'
      await storeToken(token); // Store the token
      return true;
    }
    return false;
  }

  static Future<bool> signup(
    String lastName,
    String firstName,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    final response = await http.post(
      Uri.parse('http://172.16.149.76:3001/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user': {
          'lastName': lastName,
          'firstName': firstName,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      }),
    );

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      String token = responseData['token']; // Assuming token is returned here
      await storeToken(token);
      return true;
    }
    return false;
  }

  // Store token in SharedPreferences
  static Future<void> storeToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Retrieve token from SharedPreferences
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }



  //API руу хүсэлт илгээх үед токен ашиглах
  Future<void> fetchData() async {
    String? token = await getToken();
    final response = await http.get(
      Uri.parse("http://172.16.149.76:3001/your-protected-endpoint"),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      // Дата боловсруулалт
    } else {
      // Алдаа
    }
  }



  //Logout
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    //Get.offAll(() => SignInView());
  }

  //Хэрэглэгчийн мэдээлэл авах:
  Future<void> getUserInfo() async {
  String? token = await getToken();
  final response = await http.get(
    Uri.parse("http://172.16.149.76:3001/users/me"), // Хэрэглэгчийн мэдээлэл авах endpoint
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    // Хариу боловсруулалт
    print("User Info: ${response.body}");
  } else {
    // Алдаа
    print("Failed to fetch user info");
  }
}
  //error handling 
//   if (response.statusCode == 401) {
//   // Unauthorized бол хэрэглэгчийг logout хийж, нэвтрэх хуудас руу шилжүүлнэ
//   await logout();
// }

}
