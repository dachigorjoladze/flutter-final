import 'product.dart';

class UserProfile {
  UserProfile({
    required this.email,
    this.monthlyIncome = 5000,
    List<Product>? products,
  }) : products = products ?? [
          Product(1, 1000, LoansCategory.consumer),
          Product(2, 2000, LoansCategory.mortgage),
        ];

  final String email;
  int monthlyIncome;
  final List<Product> products;

  UserProfile copyWith({
    String? email,
    int? monthlyIncome,
    List<Product>? products,
  }) {
    return UserProfile(
      email: email ?? this.email,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      products: products ?? List<Product>.from(this.products),
    );
  }
}
