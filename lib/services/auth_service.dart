import 'dart:convert';
import 'dart:io';
import 'package:budgetfrontend/models/budget_model.dart';
import 'package:budgetfrontend/models/family_model.dart';
import 'package:budgetfrontend/models/user_model.dart';
import 'package:budgetfrontend/models/wallet_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'package:dio/dio.dart';

class AuthService {
  static const String _baseUrl = "http://192.168.1.4:3001";
   static Dio dio = Dio();

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

  static Future<String?> getPlayerId() async {
  final pushSubscription = await OneSignal.User.pushSubscription;
  return pushSubscription.id;
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
    await storeToken(data['token']); // эхлээд токен хадгална

    final playerId = await AuthService.getPlayerId(); // дараа нь PlayerID авна
    if (playerId != null) {
      sendPlayerIdToBackend(playerId); // токен байгаа тул server руу player_id явуулна
    }

    return true;
  }
}
    return false;
  }

 static void sendPlayerIdToBackend(String playerId) async {
  var url = Uri.parse('$_baseUrl/users/player_id'); // 🔥 Энд өөрийн backend url тавина
 final token = await AuthService.getToken();// 🔥 Хэрэглэгчийн access_token тавина

  try {
    var response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'player_id': playerId,
      }),
    );

    if (response.statusCode == 200) {
      print('✅ Player ID backend руу амжилттай илгээгдлээ!');
    } else {
      print('❌ Алдаа: ${response.statusCode} - ${response.body}');
    }
  } catch (e) {
    print('❗ Exception: $e');
  }
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
       final playerId = await getPlayerId();
      if (playerId != null) {
        sendPlayerIdToBackend(playerId);
        print('✅ Player ID сервер рүү илгээлээ!');
      } else {
        print('⚠️ Player ID олдсонгүй!');
      }
    }
    return false;
  }

 //өөрийн мэдээлэл авах 
 static Future<UserModel?> getMe() async {
  final token = await getToken();
  if (token == null) {
    print('❌ Токен олдсонгүй');
    return null;
  }

  final response = await http.get(
    Uri.parse("$_baseUrl/users/me"),
    headers: {'Authorization': 'Bearer $token'},
  );

  print('✅ /users/me API Response Code: ${response.statusCode}');
  print('✅ /users/me API Body: ${response.body}');

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    final attributes = data['data']['attributes'];
    final relationships = data['data']['relationships'];

    return UserModel(
      id: int.parse(data['data']['id']),
      firstName: attributes['firstName'] ?? '',
      lastName: attributes['lastName'] ?? '',
      email: attributes['email'] ?? '',
      role: attributes['role'] ?? '',
      profilePhotoUrl: attributes['profile_photo'] ?? '',
      familyId: relationships['family']['data'] != null
          ? int.parse(relationships['family']['data']['id'])
          : null,
    );
  } else {
    print('❌ /users/me API амжилтгүй');
    return null;
  }
}

static Future<bool> updateProfile({
  required String firstName,
  required String lastName,
  required String email,
  File? profilePhotoFile,
}) async {
  final token = await getToken();
  if (token == null) return false;

  try {
    FormData formData = FormData.fromMap({
      'user[firstName]': firstName,
      'user[lastName]': lastName,
      'user[email]': email,
      if (profilePhotoFile != null)
        'profile_photo': await MultipartFile.fromFile(profilePhotoFile.path, filename: 'profile.jpg'),
    });

    final response = await Dio().put(
      "$_baseUrl/users/edit",
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    if (response.statusCode == 200) {
      print('✅ Profile updated successfully');
      return true;
    } else {
      print('❌ Failed to update profile: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('❌ Update Profile error: $e');
    return false;
  }
}


  // Гарах
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
  

  static Future<bool> changePassword({
  required String currentPassword,
  required String newPassword,
  required String confirmPassword,
}) async {
  final token = await getToken();
  if (token == null) return false;

  try {
    final response = await dio.post(
      '$_baseUrl/users/password_change', // ✅ POST method
      data: {
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': confirmPassword,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      print('✅ Password changed successfully');
      return true;
    } else {
      print('❌ Password change failed: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('❌ Password change error: $e');
    return false;
  }
}



  // -----------------------------------------------



    //my wallet 
     static Future<WalletModel?> fetchMyWallet() async {
    try {
      final token = await AuthService.getToken();
      final response = await dio.get(
        '$_baseUrl/api/v1/wallets/me',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      print('📦 My Wallet Response: ${response.data}'); 
      return WalletModel.fromJson(response.data['data']); // ✅ зөв
    } catch (e) {
      print('❌ fetchMyWallet error: $e');
      return null;
    }
  }
  

  //family wallet 
  static Future<WalletModel?> fetchFamilyWallet() async {
    try {
      final token = await AuthService.getToken();
      final response = await dio.get(
        '$_baseUrl/api/v1/wallets/family',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      print('📦 My Wallet Response: ${response.data}'); 
      return WalletModel.fromJson(response.data['data']); // ✅ зөв
    } catch (e) {
      print('❌ fetchFamilyWallet error: $e');
      return null;
    }
  }

  static Future<bool> updateMyWalletBalance(double balance) async {
    try {
      final token = await AuthService.getToken();
      await dio.put(
        '$_baseUrl/api/v1/wallets/update_me',
        data: {'balance': balance},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return true;
    } catch (e) {
      print('❌ updateMyWalletBalance error: $e');
      return false;
    }
  }

  static Future<bool> updateFamilyWalletBalance(double balance) async {
    try {
      final token = await AuthService.getToken();
      await dio.put(
        '$_baseUrl/api/v1/wallets/update_family',
        data: {'balance': balance},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return true;
    } catch (e) {
      print('❌ updateFamilyWalletBalance error: $e');
      return false;
    }
  }


  // -------------------------------------------
  // Гэр бүлийн мэдээлэл авах
  static Future<FamilyModel?> getFamilyInfo() async {
    try {
      final token = await AuthService.getToken();
      final response = await dio.get(
        '$_baseUrl/api/v1/families/me',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      final data = response.data['data'];
      return FamilyModel.fromJson(data);
    } catch (e) {
      print('❌ Family info татахад алдаа гарлаа: $e');
      return null;
    }
  }

  // Гэр бүлийн гишүүдийн жагсаалт авах
 static Future<List<UserModel>> getFamilyMembers() async {
  try {
    final token = await AuthService.getToken();
    final response = await dio.get(
      '$_baseUrl/api/v1/families/members',
      options: Options(headers: {
        'Authorization': 'Bearer $token',
      }),
    );

    final List<dynamic> data = response.data['data'] as List<dynamic>; // 🛠️ ИНГЭЖ АШИГЛА
    return data.map((e) => UserModel.fromJson(e)).toList();
  } catch (e) {
    print('❌ Family members татахад алдаа гарлаа: $e');
    return [];
  }
}

// services/auth_service.dart дотор:
static Future<bool> joinFamily({
  required String familyName,
  required String password,
}) async {
  try {
    final token = await getToken();
    if (token == null) {
      print('❌ Токен олдсонгүй!');
      return false;
    }

    final response = await dio.post(
      '$_baseUrl/api/v1/families/join',
      data: {
        "family": {
          "family_name": familyName,
          "password": password,
        }
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );

    print('📦 Join Family Response: ${response.statusCode} - ${response.data}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      print('❌ Гэр бүлд нэгдэхэд алдаа: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('❌ joinFamily error: $e');
    return false;
  }
}


  // ---------------------------------------

   
}

