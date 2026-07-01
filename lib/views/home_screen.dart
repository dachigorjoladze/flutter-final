import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../viewmodels/product_provider.dart';
import 'add_product_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final String title;
  const HomeScreen({super.key, required this.title});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final TextEditingController amountController = TextEditingController();
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animController);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final productProvider = context.watch<ProductProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
            }
          )
        ],
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ListView(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
            children: [
              Card(
                color: cs.primaryContainer,
                child: Padding(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          bool isSmall = constraints.maxWidth < 400;
                          return isSmall
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Income: \$${productProvider.monthlyIncome}'),
                                    const SizedBox(height: 8),
                                    Text('Spent limit: \$${(productProvider.monthlyIncome - productProvider.remainingLimit).toStringAsFixed(0)}'),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Income: \$${productProvider.monthlyIncome}'),
                                    Text('Spent limit: \$${(productProvider.monthlyIncome - productProvider.remainingLimit).toStringAsFixed(0)}'),
                                  ],
                                );
                        },
                      ),
                      const SizedBox(height: 16),
                      LinearProgressIndicator(
                        value: productProvider.monthlyIncome == 0 ? 0 : (productProvider.monthlyIncome - productProvider.remainingLimit) / productProvider.monthlyIncome,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 8),
                      Text('\$${productProvider.remainingLimit.toStringAsFixed(2)} credit limit remaining'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'New Income', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final amount = int.tryParse(amountController.text.trim());
                  if (amount != null && amount > (productProvider.monthlyIncome - productProvider.remainingLimit)) {
                    context.read<ProductProvider>().updateIncome(amount);
                    amountController.clear();
                  }
                },
                child: const Text('Change income'),
              ),
              const SizedBox(height: 30),
              Text('Activated Products', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              if (productProvider.products.isEmpty)
                const Text('არ არის აქტივირებული პროდუქტი')
              else
                Column(
                  children: productProvider.products.map((product) {
                    return Card(
                      child: ListTile(
                        leading: Icon(
                          product.category.icon,
                          color: product.category.color,
                        ),
                        title: Text(product.category.label),
                        subtitle: Text('მოცულობა: \$${product.amount.toStringAsFixed(0)}'),
                      ),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 30),
              Text('Available Categories', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = constraints.maxWidth > 800 ? 4 : constraints.maxWidth > 600 ? 3 : constraints.maxWidth > 400 ? 2 : 1;
                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.0,
                    children: LoansCategory.values.map((category) => Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(category.icon, color: category.color, size: 30),
                            const SizedBox(height: 8),
                            Text(category.label, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => AddProductScreen(category: category))
                                );
                              },
                              child: const Text('აქტივაცია'),
                            ),
                          ],
                        ),
                      ),
                    )).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}