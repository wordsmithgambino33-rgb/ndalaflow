import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction.dart' as model;

/// FirestoreService - simple wrapper for Cloud Firestore operations.
/// Requires Firebase initialization (Firebase.initializeApp) before use.
class FirestoreService {
  FirestoreService._private();
  static final FirestoreService instance = FirestoreService._private();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'transactions';

  /// Optional: enable persistence if supported
  void enablePersistence() {
    try {
      _db.settings = const Settings(persistenceEnabled: true);
    } catch (_) {
      // Some platforms or versions may not support toggling settings at runtime.
    }
  }

  /// Add or replace a transaction document
  Future<void> addTransaction(model.Transaction tx) async {
    final data = {
      'type': tx.type,
      'category': tx.category,
      'amount': tx.amount,
      'note': tx.note,
      'date': Timestamp.fromDate(tx.date),
    };
    await _db.collection(_collection).doc(tx.id).set(data, SetOptions(merge: true));
  }

  /// Update an existing transaction (partial)
  Future<void> updateTransaction(model.Transaction tx) async {
    final data = {
      'type': tx.type,
      'category': tx.category,
      'amount': tx.amount,
      'note': tx.note,
      'date': Timestamp.fromDate(tx.date),
    };
    await _db.collection(_collection).doc(tx.id).update(data);
  }

  /// Delete by id
  Future<void> deleteTransaction(String id) async {
    await _db.collection(_collection).doc(id).delete();
  }

  /// Get a single transaction document
  Future<model.Transaction?> getTransactionById(String id) async {
    final doc = await _db.collection(_collection).doc(id).get();
    if (!doc.exists) return null;
    return _docToModel(doc);
  }

  /// Fetch all transactions once, ordered by date desc
  Future<List<model.Transaction>> fetchTransactionsOnce({int limit = 100}) async {
    final snap = await _db.collection(_collection).orderBy('date', descending: true).limit(limit).get();
    return snap.docs.map(_docToModel).whereType<model.Transaction>().toList();
  }

  /// Stream transactions (live updates). Optional category filter.
  Stream<List<model.Transaction>> transactionsStream({String? category}) {
    Query q = _db.collection(_collection).orderBy('date', descending: true);
    if (category != null && category.isNotEmpty) {
      q = q.where('category', isEqualTo: category);
    }
    return q.snapshots().map((snap) => snap.docs.map(_docToModel).whereType<model.Transaction>().toList());
  }

  // Helper: convert DocumentSnapshot to model.Transaction
  model.Transaction? _docToModel(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?; 
    if (data == null) return null;

    final dynamic rawDate = data['date'];
    DateTime date;
    if (rawDate is Timestamp) {
      date = rawDate.toDate();
    } else if (rawDate is int) {
      date = DateTime.fromMillisecondsSinceEpoch(rawDate);
    } else if (rawDate is String) {
      date = DateTime.tryParse(rawDate) ?? DateTime.now();
    } else {
      date = DateTime.now();
    }

    final amountRaw = data['amount'];
    final double amount = amountRaw is num ? amountRaw.toDouble() : double.tryParse(amountRaw?.toString() ?? '') ?? 0.0;

    return model.Transaction(
      id: doc.id,
      type: data['type'] as String? ?? 'expense',
      category: data['category'] as String? ?? 'other',
      amount: amount,
      note: data['note'] as String?,
      date: date,
    );
  }
}
