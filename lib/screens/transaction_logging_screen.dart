
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TransactionLogging extends StatefulWidget {
  final VoidCallback onBack;

  const TransactionLogging({Key? key, required this.onBack}) : super(key: key);

  @override
  State<TransactionLogging> createState() => _TransactionLoggingState();
}

class _TransactionLoggingState extends State<TransactionLogging> {
  String transactionType = 'expense';
  String amount = '';
  String selectedCategory = '';
  String note = '';
  bool showSuccess = false;
  bool isSaving = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<Map<String, dynamic>> incomeCategories = [
    {"id": "salary", "name": "Salary", "icon": LucideIcons.briefcase, "color": Colors.blue},
    {"id": "business", "name": "Business", "icon": LucideIcons.dollarSign, "color": Colors.green},
    {"id": "ganyu", "name": "Ganyu", "icon": LucideIcons.trendingUp, "color": Colors.purple},
    {"id": "allowance", "name": "Allowance", "icon": LucideIcons.heart, "color": Colors.pink},
  ];

  final List<Map<String, dynamic>> expenseCategories = [
    {"id": "market", "name": "Market", "icon": LucideIcons.shoppingCart, "color": Colors.red},
    {"id": "transport", "name": "Transport", "icon": LucideIcons.car, "color": Colors.orange},
    {"id": "school", "name": "School Fees", "icon": LucideIcons.graduationCap, "color": Colors.blue},
    {"id": "food", "name": "Food & Drinks", "icon": LucideIcons.coffee, "color": Colors.yellow},
    {"id": "rent", "name": "Rent", "icon": LucideIcons.home, "color": Colors.grey},
    {"id": "health", "name": "Health", "icon": LucideIcons.heart, "color": Colors.green},
  ];

  final List<List<String>> keypadNumbers = [
    ["1", "2", "3"],
    ["4", "5", "6"],
    ["7", "8", "9"],
    [".", "0", "⌫"],
  ];

  String formatAmountWithCommas(String value) {
    final numericValue = value.replaceAll(",", "");
    if (numericValue.isEmpty) return "";

    final parts = numericValue.split(".");
    final integerPart = parts[0];
    final formattedInt = integerPart.replaceAllMapped(
        RegExp(r"(\d)(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]},");
    return parts.length > 1 ? "$formattedInt.${parts[1]}" : formattedInt;
  }

  void handleKeypadPress(String value) {
    setState(() {
      if (value == "⌫") {
        final clean = amount.replaceAll(",", "");
        amount = clean.isNotEmpty ? formatAmountWithCommas(clean.substring(0, clean.length - 1)) : "";
      } else if (value == "." && !amount.contains(".")) {
        amount += value;
      } else if (value != ".") {
        final currentNumeric = amount.replaceAll(",", "");
        if (currentNumeric.length < 12) {
          amount = formatAmountWithCommas(currentNumeric + value);
        }
      }
    });
  }

  Future<void> handleSave() async {
    if (amount.isEmpty || selectedCategory.isEmpty) return;

    setState(() => isSaving = true);

    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception("No user logged in. Please sign in first.");
      }

      final double parsedAmount = double.tryParse(amount.replaceAll(",", "")) ?? 0;

      await _firestore.collection("transactions").add({
        "userId": user.uid,
        "type": transactionType,
        "amount": parsedAmount,
        "category": selectedCategory,
        "note": note,
        "timestamp": FieldValue.serverTimestamp(),
      });

      setState(() {
        isSaving = false;
        showSuccess = true;
      });

      Timer(const Duration(seconds: 2), () {
        setState(() => showSuccess = false);
        widget.onBack();
      });
    } catch (e) {
      setState(() => isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving transaction: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (showSuccess) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Animate(
                effects: [ScaleEffect(begin: 0, end: 1, duration: 400.ms)],
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.check, color: Colors.white, size: 40),
                ),
              ),
              const SizedBox(height: 16),
              const Text("Transaction Saved!",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const Text("Your transaction has been recorded"),
            ],
          ),
        ),
      );
    }

    final currentCategories =
        transactionType == "income" ? incomeCategories : expenseCategories;

    return Scaffold(
      body: ListView(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.only(top: 48, left: 16, right: 16, bottom: 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.lightBlueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: widget.onBack,
                ),
                const Text("Add Transaction",
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              ],
            ),
          ),

          // Transaction Type Toggle
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => setState(() => transactionType = "expense"),
                    icon: const Icon(LucideIcons.trendingDown),
                    label: const Text("Expense"),
                    style: TextButton.styleFrom(
                      backgroundColor: transactionType == "expense"
                          ? Colors.white
                          : Colors.transparent,
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => setState(() => transactionType = "income"),
                    icon: const Icon(LucideIcons.trendingUp),
                    label: const Text("Income"),
                    style: TextButton.styleFrom(
                      backgroundColor: transactionType == "income"
                          ? Colors.white
                          : Colors.transparent,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Amount Input
          Card(
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text("Amount", style: TextStyle(color: Colors.grey)),
                  Text("MWK ${amount.isEmpty ? '0' : amount}",
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 2,
                    ),
                    itemCount: keypadNumbers.expand((e) => e).length,
                    itemBuilder: (context, index) {
                      final value = keypadNumbers.expand((e) => e).toList()[index];
                      return ElevatedButton(
                        onPressed: () => handleKeypadPress(value),
                        child: Text(value, style: const TextStyle(fontSize: 20)),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Categories
          Card(
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Select Category",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2.5,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: currentCategories.length,
                    itemBuilder: (context, index) {
                      final category = currentCategories[index];
                      return GestureDetector(
                        onTap: () => setState(() => selectedCategory = category["id"]),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: selectedCategory == category["id"]
                                  ? Colors.blue
                                  : Colors.grey,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: category["color"],
                                child: Icon(category["icon"], color: Colors.white, size: 20),
                              ),
                              const SizedBox(height: 6),
                              Text(category["name"],
                                  style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Note
          Card(
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: transactionType == "expense"
                      ? "e.g., Groceries from Limbe Market"
                      : "e.g., Monthly salary payment",
                  border: InputBorder.none,
                ),
                onChanged: (value) => setState(() => note = value),
              ),
            ),
          ),

          // Save Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: (amount.isEmpty || selectedCategory.isEmpty || isSaving)
                  ? null
                  : handleSave,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: isSaving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Save Transaction"),
            ),
          ),
        ],
      ),
    );
  }
}
