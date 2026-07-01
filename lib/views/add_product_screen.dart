import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../viewmodels/product_provider.dart';

class AddProductScreen extends StatefulWidget {
  final LoansCategory category;
  const AddProductScreen({super.key, required this.category});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Credit Product')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              'Max available monthly limit: \$${productProvider.remainingLimit.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Monthly Payment', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(_amountController.text);
                if (amount == null || amount > productProvider.remainingLimit) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('არასაკმარისი ლიმიტი ან არასწორი ფორმატი')));
                  return;
                }
                
                context.read<ProductProvider>().addProduct(
                  Product(Random().nextInt(9999), amount * 12, widget.category)
                );
                
                Navigator.pop(context);
              },
              child: const Text('პროდუქტის დამატება'),
            )
          ],
        ),
      ),
    );
  }
}