import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/transaction.dart' as model;

class LocalDatabase {
  LocalDatabase._privateConstructor();
  static final LocalDatabase instance = LocalDatabase._privateConstructor();

  Database? _db;
  static const _dbName = 'ndalaflow.db';
  static const _dbVersion = 1;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = '${documentsDirectory.path}/$_dbName';
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions (
        id TEXT PRIMARY KEY,
        type TEXT NOT NULL,
        category TEXT NOT NULL,
        amount REAL NOT NULL,
        note TEXT,
        date INTEGER NOT NULL
      )
    ''');
  }

  // Insert or replace a transaction
  Future<int> upsertTransaction(model.Transaction tx) async {
    final db = await database;
    return db.insert(
      'transactions',
      {
        'id': tx.id,
        'type': tx.type,
        'category': tx.category,
        'amount': tx.amount,
        'note': tx.note,
        'date': tx.date.millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all transactions ordered by date desc
  Future<List<model.Transaction>> getAllTransactions() async {
    final db = await database;
    final maps = await db.query('transactions', orderBy: 'date DESC');
    return maps.map((m) {
      return model.Transaction(
        id: m['id'] as String,
        type: m['type'] as String,
        category: m['category'] as String,
        amount: (m['amount'] as num).toDouble(),
        note: m['note'] as String?,
        date: DateTime.fromMillisecondsSinceEpoch(m['date'] as int),
      );
    }).toList();
  }

  // Delete by id
  Future<int> deleteTransaction(String id) async {
    final db = await database;
    return db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  // Simple query by category
  Future<List<model.Transaction>> getTransactionsByCategory(String category) async {
    final db = await database;
    final maps = await db.query('transactions', where: 'category = ?', whereArgs: [category], orderBy: 'date DESC');
    return maps.map((m) {
      return model.Transaction(
        id: m['id'] as String,
        type: m['type'] as String,
        category: m['category'] as String,
        amount: (m['amount'] as num).toDouble(),
        note: m['note'] as String?,
        date: DateTime.fromMillisecondsSinceEpoch(m['date'] as int),
      );
    }).toList();
  }

  Future<void> close() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
    }
  }

  // Optional: clear all data (useful for testing)
  Future<void> clearAll() async {
    final db = await database;
    await db.delete('transactions');
  }
}
