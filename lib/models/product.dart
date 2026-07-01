import 'package:flutter/material.dart';

enum LoansCategory {
  consumer(label: 'სამომხმარებლო', icon: Icons.people, color: Colors.orange),
  mortgage(label: 'იპოთეკური', icon: Icons.house, color: Colors.blue),
  creditcard(label: 'საკრედიტო ბარათი', icon: Icons.credit_card, color: Colors.red),
  overdraft(label: 'ოვერდრაფტი', icon: Icons.light_mode, color: Colors.green);

  final String label;
  final IconData icon;
  final Color color;

  const LoansCategory({
    required this.label,
    required this.icon,
    required this.color,
  });
}

class Product {
  final int id;
  final double amount;
  final LoansCategory category;

  Product(this.id, this.amount, this.category);
}