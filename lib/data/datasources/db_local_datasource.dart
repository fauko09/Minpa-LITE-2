import 'dart:developer';


import 'package:minpa_lite/data/models/responses/category_response_model.dart';
import 'package:minpa_lite/data/models/responses/product_response_model.dart';
import 'package:minpa_lite/data/models/responses/user_model.dart';
import 'package:sqflite/sqflite.dart';

import '../models/responses/tax_discount_model.dart';
import '../models/responses/transaction_response_model.dart';

class DBLocalDatasource {
  DBLocalDatasource._init();

  static final DBLocalDatasource instance = DBLocalDatasource._init();

  final String tableProducts = 'products';
  final String tableCategories = 'categories';
  final String tableTransactions = 'transactions';
  final String tableTransactionItems = 'transaction_items';
  final String tableTaxDiscount = 'tax_discounts';
  final String tableUsers = 'users';
  static Database? _database;

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = dbPath + filePath;

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableCategories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        categoryId TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE $tableProducts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        productId TEXT,
        categoryId INTEGER,
        description TEXT,
        image TEXT,
        color TEXT,
        price TEXT,
        cost TEXT,
        stock INTEGER,
        barcode TEXT,
        sku TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableTransactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        transactionId TEXT,
        orderNumber TEXT,
        subTotal TEXT,
        totalPrice TEXT,
        totalItems INTEGER,
        tax TEXT,
        discount TEXT,
        paymentMethod TEXT,
        status TEXT,
        cashierId INTEGER,
        createdAt TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableTransactionItems (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        transactionItemId TEXT,
        orderId TEXT,
        productId INTEGER,
        quantity INTEGER,
        price TEXT,
        total TEXT,
        createdAt TEXT
      )
    ''');

    await db.execute('''
    CREATE TABLE $tableTaxDiscount (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        type TEXT,
        status TEXT,
        value INTEGER,
        chargeType TEXT
      )
    ''');

    await db.execute('''
    CREATE TABLE $tableUsers (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      userId TEXT,
      name TEXT,
      phone TEXT,
      email TEXT,
      password TEXT,
      bank TEXT,
      account TEXT,
      role TEXT
    )
    ''');
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('jagoposf.db');
    return _database!;
  }

  // save category
  Future<int> saveCategory(CategoryModel category) async {
    final db = await instance.database;
    log("Save category: ${category.toMap()}");
    return await db.insert(tableCategories, category.toMap());
  }

  // get all category
  Future<List<CategoryModel>> getAllCategory() async {
    final db = await instance.database;
    final result = await db.query(tableCategories);

    return result.map((e) => CategoryModel.fromMap(e)).toList();
  }

  // get category by id
  Future<CategoryModel> getCategoryById(String categoryId) async {
    final db = await instance.database;
    final result = await db.query(tableCategories,
        where: 'categoryId = ?', whereArgs: [categoryId]);
    return CategoryModel.fromMap(result[0]);
  }

  // update category
  Future<int> updateCategory(CategoryModel category) async {
    final db = await instance.database;
    return await db.update(
      tableCategories,
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  // delete category
  Future<int> deleteCategory(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableCategories,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //save data product
  Future<int> saveProduct(Product product) async {
    final db = await instance.database;
    log("Save product: ${product.toMap()}");
    return await db.insert(tableProducts, product.toMap());
  }

  //get all data product
  Future<List<Product>> getAllProduct() async {
    final db = await instance.database;
    final result = await db.query(tableProducts);

    return result.map((e) => Product.fromMap(e)).toList();
  }

  Future<Product> getProductById(String id) async {
    final db = await instance.database;
    final result =
        await db.query(tableProducts, where: 'productId = ?', whereArgs: [id]);
    log("result: $result");
    return Product.fromMap(result[0]);
  }

// update data product
  Future<int> updateProduct(Product product) async {
    final db = await instance.database;
    return await db.update(
      tableProducts,
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id.toString()],
    );
  }

  // delete data product
  Future<int> deleteProduct(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableProducts,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<TaxDiscountModel>> getAllTaxDiscount() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tableTaxDiscount);
    return List.generate(maps.length, (i) {
      return TaxDiscountModel.fromLocalMap(maps[i]);
    });
  }

  // get discount by id
  // Future<TaxDiscountModel> getTaxDiscountById(int id) async {
  //   final db = await instance.database;
  //   final List<Map<String, dynamic>> maps =
  //       await db.query(tableTaxDiscount, where: 'id = ?', whereArgs: [id]);
  //   return TaxDiscountModel.fromLocalMap(maps[0]);
  // }

  // get tax discount by charge type
  Future<TaxDiscountModel?> getTaxDiscountByChargeType(
      String chargeType) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tableTaxDiscount,
        where: 'chargeType = ?', whereArgs: [chargeType]);

    if (maps.isEmpty) {
      return null;
    } else {
      return TaxDiscountModel.fromLocalMap(maps[0]);
    }
  }

  Future<void> saveTaxDiscount(TaxDiscountModel discount) async {
    final db = await instance.database;
    log("Save tax discount: ${discount.toMap()}");
    await db.insert(tableTaxDiscount, discount.toMap());
  }

  Future<void> updateTaxDiscount(TaxDiscountModel discount) async {
    final db = await instance.database;
    await db.update(tableTaxDiscount, discount.toMap(),
        where: 'id = ?', whereArgs: [discount.id]);
  }

  Future<void> deleteTaxDiscount(int id) async {
    final db = await instance.database;
    await db.delete(tableTaxDiscount, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> saveOrder(TransactionModel transactions) async {
    final db = await instance.database;
    int id = await db.insert(tableTransactions, transactions.toMap());
    log("Save order: ${transactions.toMap()}");
    for (var orderItem in transactions.items!) {
      await db.insert(
          tableTransactionItems, orderItem.toMap(transactions.transactionId!));
    }
    return id;
  }

  Future<int> saveOrderOnly(TransactionModel transactions) async {
    final db = await instance.database;
    int id = await db.insert(tableTransactions, transactions.toMap());
    log("Save order Only: ${transactions.toMap()}");

    return id;
  }

  Future<List<TransactionModel>> getAllOrder() async {
    final db = await instance.database;
    final result = await db.query(
      tableTransactions,
      orderBy: 'createdAt DESC',
    );
    return result.map((e) => TransactionModel.fromMap(e)).toList();
  }

  // save order item
  Future<int> saveOrderItem(Item item) async {
    final db = await instance.database;
    log("Save order item: ${item.toMap2()}");
    return await db.insert(tableTransactionItems, item.toMap2());
  }

  /// get all order Item
  Future<List<Item>> getAllOrderItem() async {
    final db = await instance.database;
    final result = await db.query(
      tableTransactionItems,
      orderBy: 'createdAt DESC',
    );
    log("Get all order item: ${result.toString()}");
    return result.map((e) => Item.fromMap(e)).toList();
  }

  // get order by date
  Future<List<TransactionModel>> getOrderByDate(String dateOnly) async {
    final db = await instance.database;
    final result = await db.query(
      tableTransactions,
      where: 'createdAt LIKE ?',
      whereArgs: ['${dateOnly}T%'],
    );
    // log("Date: $dateOnly, result: ${result.length}");
    return result.map((e) => TransactionModel.fromMap(e)).toList();
  }

  // get order by transaction id
  Future<TransactionModel> getOrderByTransactionId(String transactionId) async {
    final db = await instance.database;
    final result = await db.query(
      tableTransactions,
      where: 'transactionId = ?',
      whereArgs: [transactionId],
    );
    return TransactionModel.fromMap(result[0]);
  }

  // get items by transaction id
  Future<List<Item>> getItemsByTransactionId(String transactionId) async {
    final db = await instance.database;
    final result = await db.query(
      tableTransactionItems,
      where: 'orderId = ?',
      whereArgs: [transactionId],
    );
    return result.map((e) => Item.fromMap(e)).toList();
  }

  // get all user
  Future<List<UserModel>> getAllUser() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tableUsers);

    return List.generate(maps.length, (i) {
      return UserModel.fromMap(maps[i]);
    });
  }

  // get cashier by id
  Future<UserModel> getUserById(String id) async {
    final db = await instance.database;
    final result =
        await db.query(tableUsers, where: 'userId = ?', whereArgs: [id]);
    return UserModel.fromMap(result[0]);
  }

  // get user by email
  Future<UserModel?> getUserByEmail(String email) async {
    final db = await instance.database;
    final result =
        await db.query(tableUsers, where: 'email = ?', whereArgs: [email]);
    if (result.isEmpty) {
      return null;
    } else {
      return UserModel.fromMap(result[0]);
    }
  }

  Future<void> saveUser(UserModel user) async {
    final db = await instance.database;
    log("Save user: ${user.toMap()}");
    await db.insert(tableUsers, user.toMap());
  }

  Future<void> updateUser(UserModel user) async {
    final db = await instance.database;
    await db.update(tableUsers, user.toMap(),
        where: 'id = ?', whereArgs: [user.id]);
  }

  Future<void> deleteUser(int id) async {
    final db = await instance.database;
    await db.delete(tableUsers, where: 'id = ?', whereArgs: [id]);
  }

  // clear all data
  Future<void> clearAllData() async {
    final db = await instance.database;
    await db.delete(tableUsers);
    await db.delete(tableCategories);
    await db.delete(tableProducts);
    await db.delete(tableTransactions);
    await db.delete(tableTransactionItems);
    await db.delete(tableTaxDiscount);
  }
}
