import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import 'product_provider.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String _errorMessage = '';
  String _activeUserEmail = '';

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get activeUserEmail => _activeUserEmail;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final success = await _apiService.login(email, password);

      if (!success) {
        _errorMessage = 'შესვლა ვერ მოხერხდა. შეიყვანეთ მეილი და პაროლი და სცადეთ ხელახლა.';
      } else {
        _activeUserEmail = email.trim().toLowerCase();
      }

      _isLoading = false;
      notifyListeners();
      return success;
    } catch (_) {
      _errorMessage = 'ვერ მოხერხდა კავშირის დამყარება. სცადეთ ხელახლა.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void setActiveUser(String email, BuildContext context) {
    _activeUserEmail = email.trim().toLowerCase();
    context.read<ProductProvider>().setActiveUser(_activeUserEmail);
    notifyListeners();
  }
}