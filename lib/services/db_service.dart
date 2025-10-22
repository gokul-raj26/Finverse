import 'dart:async';
import 'package:finverse/models/asset_model.dart';
import 'package:finverse/models/debt_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBService {
  DBService._privateConstructor();
  static final DBService instance = DBService._privateConstructor();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    await init();
    return _db!;
  }

  Future<void> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'finverse.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE assets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        value REAL NOT NULL,
        quantity REAL DEFAULT 0,
        notes TEXT,
        createdAt TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE debts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        principal REAL NOT NULL,
        emi REAL NOT NULL,
        interestRate REAL NOT NULL,
        startDate TEXT NOT NULL,
        endDate TEXT,
        notes TEXT
      );
    ''');
  }

  // Asset CRUD
  Future<int> insertAsset(AssetModel asset) async {
    final db = await database;
    return await db.insert('assets', asset.toMap());
  }

  Future<List<AssetModel>> getAllAssets() async {
    final db = await database;
    final res = await db.query('assets', orderBy: 'id DESC');
    return res.map((m) => AssetModel.fromMap(m)).toList();
  }

  Future<AssetModel?> getAssetById(int id) async {
    final db = await database;
    final res = await db.query('assets', where: 'id = ?', whereArgs: [id]);
    if (res.isNotEmpty) return AssetModel.fromMap(res.first);
    return null;
  }

  Future<int> updateAsset(AssetModel asset) async {
    final db = await database;
    return await db.update('assets', asset.toMap(), where: 'id = ?', whereArgs: [asset.id]);
  }

  Future<int> deleteAsset(int id) async {
    final db = await database;
    return await db.delete('assets', where: 'id = ?', whereArgs: [id]);
  }

  // Debt CRUD
  Future<int> insertDebt(DebtModel debt) async {
    final db = await database;
    return await db.insert('debts', debt.toMap());
  }

  Future<List<DebtModel>> getAllDebts() async {
    final db = await database;
    final res = await db.query('debts', orderBy: 'id DESC');
    return res.map((m) => DebtModel.fromMap(m)).toList();
  }

  Future<int> updateDebt(DebtModel debt) async {
    final db = await database;
    return await db.update('debts', debt.toMap(), where: 'id = ?', whereArgs: [debt.id]);
  }

  Future<int> deleteDebt(int id) async {
    final db = await database;
    return await db.delete('debts', where: 'id = ?', whereArgs: [id]);
  }
}
