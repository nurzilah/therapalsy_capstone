import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:therapalsy_capstone/app/modules/models/user_model.dart';

class AuthServices extends GetxService {
  static const String baseUrl = 'https://evidently-moved-marmoset.ngrok-free.app'; // Ganti dengan URL backend kamu

  // Register user
  Future<Map<String, dynamic>> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return {'success': true, 'message': 'Registration successful'};
    } else {
      final data = json.decode(response.body);
      return {'success': false, 'message': data['message'] ?? 'Registration failed'};
    }
  }

  // Login user
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {'success': true, 'access_token': data['access_token']};
    } else {
      final data = json.decode(response.body);
      return {'success': false, 'message': data['message'] ?? 'Login failed'};
    }
  }

  // Login with Google
  static Future<UserModel> googleLogin(String idToken) async {
    final url = Uri.parse('$baseUrl/api/google-login');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id_token': idToken,
      }),
    );

    print("Google Login Status: ${response.statusCode}");
    print("Google Login Body: ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return UserModel.fromJson(data);
    } else {
      return UserModel.error(data['message'] ?? 'Login Google gagal');
    }
  }

  // Forgot password - kirim kode reset
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email}),
    );

    if (response.statusCode == 200) {
      return {'success': true, 'message': 'Reset code sent'};
    } else {
      final data = json.decode(response.body);
      return {'success': false, 'message': data['message'] ?? 'Failed to send reset code'};
    }
  }

  // Reset password dengan kode reset
  Future<Map<String, dynamic>> resetPassword(String email, String resetCode, String newPassword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'reset_code': resetCode,
        'new_password': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      return {'success': true, 'message': 'Password reset successful'};
    } else {
      final data = json.decode(response.body);
      return {'success': false, 'message': data['message'] ?? 'Password reset failed'};
    }
  }

  // Verify email dengan kode verifikasi
  Future<Map<String, dynamic>> verifyEmail(String email, String verificationCode) async {
    final response = await http.post(
      Uri.parse('$baseUrl/verify-email'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'verification_code': verificationCode,
      }),
    );

    if (response.statusCode == 200) {
      return {'success': true, 'message': 'Email verified successfully'};
    } else {
      final data = json.decode(response.body);
      return {'success': false, 'message': data['message'] ?? 'Email verification failed'};
    }
  }
}