
// lib/models/transaction.dart
class Transaction {
  final String id;
  final String type; // 'income' or 'expense'
  final String category;
  final double amount;
  final String? note;
  final DateTime date;

  Transaction({
    required this.id,
    required this.type,
    required this.category,
    required this.amount,
    this.note,
    required this.date,
  });
}
