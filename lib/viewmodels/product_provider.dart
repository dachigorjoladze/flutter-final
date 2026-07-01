import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/user.dart';

class ProductProvider extends ChangeNotifier {
  final Map<String, UserProfile> _users = {};
  UserProfile? _activeUser;

  int get monthlyIncome => _activeUser?.monthlyIncome ?? 5000;
  List<Product> get products => _activeUser?.products ?? [];

  void setActiveUser(String email) {
    final normalizedEmail = email.trim().toLowerCase();
    _activeUser = _users.putIfAbsent(
      normalizedEmail,
      () => UserProfile(email: normalizedEmail),
    );
    notifyListeners();
  }

  double get remainingLimit {
    double totalAmount = products.fold(0, (sum, product) => sum + (product.amount / 12));
    return monthlyIncome - totalAmount;
  }

  void updateIncome(int newIncome) {
    if (_activeUser == null) return;
    _activeUser = _activeUser!.copyWith(monthlyIncome: newIncome);
    _users[_activeUser!.email] = _activeUser!;
    notifyListeners();
  }

  void addProduct(Product product) {
    if (_activeUser == null) return;
    final updatedProducts = List<Product>.from(_activeUser!.products)..add(product);
    _activeUser = _activeUser!.copyWith(products: updatedProducts);
    _users[_activeUser!.email] = _activeUser!;
    notifyListeners();
  }

  void removeProduct(int id) {
    if (_activeUser == null) return;
    final updatedProducts = _activeUser!.products.where((p) => p.id != id).toList();
    _activeUser = _activeUser!.copyWith(products: updatedProducts);
    _users[_activeUser!.email] = _activeUser!;
    notifyListeners();
  }
}