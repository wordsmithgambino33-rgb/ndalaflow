import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'firestore_service.dart';
import 'local_db.dart';
import '../models/transaction.dart';

class BackendService {
  BackendService._private();
  static final BackendService instance = BackendService._private();

  // Returns true if device is online (any network)
  Future<bool> get isOnline async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  // Add or update a transaction
  Future<void> upsertTransaction(Transaction tx) async {
    if (await isOnline) {
      await FirestoreService.instance.addTransaction(tx);
    } else {
      await LocalDatabase.instance.upsertTransaction(tx);
    }
  }

  // Delete a transaction by id
  Future<void> deleteTransaction(String id) async {
    if (await isOnline) {
      await FirestoreService.instance.deleteTransaction(id);
    } else {
      await LocalDatabase.instance.deleteTransaction(id);
    }
  }

  // Get all transactions (once)
  Future<List<Transaction>> getAllTransactions() async {
    if (await isOnline) {
      return await FirestoreService.instance.fetchTransactionsOnce();
    } else {
      return await LocalDatabase.instance.getAllTransactions();
    }
  }

  // Get transactions by category (once)
  Future<List<Transaction>> getTransactionsByCategory(String category) async {
    if (await isOnline) {
      final all = await FirestoreService.instance.fetchTransactionsOnce();
      return all.where((tx) => tx.category == category).toList();
    } else {
      return await LocalDatabase.instance.getTransactionsByCategory(category);
    }
  }

  // Stream transactions (live updates if online, fallback to local snapshot if offline)
  Stream<List<Transaction>> transactionsStream({String? category}) async* {
    if (await isOnline) {
      yield* FirestoreService.instance.transactionsStream(category: category);
    } else {
      final local = await LocalDatabase.instance.getAllTransactions();
      yield local;
    }
  }

  // Utility: clear all transactions (for testing)
  Future<void> clearAll() async {
    if (await isOnline) {
      // Not recommended to clear all cloud data in production!
      // You can implement batch delete if needed.
    }
    await LocalDatabase.instance.clearAll();
  }
}
