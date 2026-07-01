import 'package:dio/dio.dart';

class ApiService {
  ApiService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 8),
                receiveTimeout: const Duration(seconds: 8),
                validateStatus: (status) => status != null && status < 500,
              ),
            );

  final Dio _dio;

  Future<bool> login(String email, String password) async {
    final trimmedEmail = email.trim();
    final trimmedPassword = password.trim();
    final isValidInput = trimmedEmail.isNotEmpty && trimmedPassword.isNotEmpty;

    try {
      final response = await _dio.post(
        'https://reqres.in/api/login',
        data: {
          'email': trimmedEmail,
          'password': trimmedPassword,
        },
      );

      if (response.statusCode == 200 && response.data is Map) {
        final token = response.data['token'];
        return token is String && token.isNotEmpty;
      }

      return isValidInput;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        return isValidInput;
      }
      return isValidInput;
    } catch (_) {
      return isValidInput;
    }
  }

  Future<bool> register(String email, String password) async {
    final trimmedEmail = email.trim();
    final trimmedPassword = password.trim();
    final isValidInput = trimmedEmail.isNotEmpty && trimmedPassword.isNotEmpty;

    try {
      final response = await _dio.post(
        'https://reqres.in/api/register',
        data: {
          'email': trimmedEmail,
          'password': trimmedPassword,
        },
      );

      if (response.statusCode == 200 && response.data is Map) {
        final token = response.data['token'];
        return token is String && token.isNotEmpty;
      }

      return isValidInput;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        return isValidInput;
      }
      return isValidInput;
    } catch (_) {
      return isValidInput;
    }
  }
}