import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:squel_1/customer_model.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ?? await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentDirectory.path, 'customer.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute("""
   
  CREATE TABLE customer(
    id INTEGER PRIMARY KEY,
    first_name TEXT,
    last_name TEXT,
    email TEXT
  )
  """);
  }

  Future<int> addCustomer(CustomerModel customerModel) async {
    Database db = await instance.database;
    return await db.insert("customer", customerModel.toMap());
  }

  Future<List<CustomerModel>> getCustomer() async {
    Database db = await instance.database;
    var customer = await db.query("customer", orderBy: "id");

    List<CustomerModel> customerList = customer.isNotEmpty
        ? customer.map((data) => CustomerModel.fromMap(data)).toList()
        : [];

    return customerList;
  }

  Future<int> updateCustomer(CustomerModel customerModel) async {
    Database db = await instance.database;

    return await db.update("customer", customerModel.toMap(),
        where: "id = ?", whereArgs: [customerModel.id]);
  }

  Future<int> deleteCustomer(int? id) async {
    Database db = await instance.database;

    return await db.delete("customer", where: "id = ?", whereArgs: [id]);
  }
}
