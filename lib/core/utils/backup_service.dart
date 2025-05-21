import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:minpa_lite/data/datasources/db_local_datasource.dart';
import 'package:minpa_lite/data/models/responses/category_response_model.dart';
import 'package:minpa_lite/data/models/responses/product_response_model.dart';
import 'package:minpa_lite/data/models/responses/tax_discount_model.dart';
import 'package:minpa_lite/data/models/responses/transaction_response_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:async';
import 'package:path/path.dart' as p;
import '../../data/models/responses/user_model.dart';
import 'package:permission_handler/permission_handler.dart';

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}

class BackupService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [drive.DriveApi.driveFileScope],
  );

  Future<File> createBackupFile() async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String backupFilePath = path.join(
      appDocDir.path,
      'backup_data_${DateTime.now().millisecondsSinceEpoch}.json',
    );

    final categories = await DBLocalDatasource.instance.getAllCategory();
    final products = await DBLocalDatasource.instance.getAllProduct();
    final transactiosn = await DBLocalDatasource.instance.getAllOrder();
    final transactionItems = await DBLocalDatasource.instance.getAllOrderItem();
    final taxDiscounts = await DBLocalDatasource.instance.getAllTaxDiscount();
    final users = await DBLocalDatasource.instance.getAllUser();
    log('Get All Data Success');

    final Map<String, dynamic> jsonData = {
      'categories': categories.map((e) => e!.toJson()).toList(),
      'products': products.map((e) => e.toJson()).toList(),
      'transactions': transactiosn.map((e) => e.toJson()).toList(),
      'transactionItems': transactionItems.map((e) => e.toJson()).toList(),
      'taxDiscounts': taxDiscounts.map((e) => e.toJson()).toList(),
      'users': users.map((e) => e.toJson()).toList(),
    };

    final String jsonString = jsonEncode(jsonData);
    final File backupFile = File(backupFilePath);
    await backupFile.writeAsString(jsonString);

    log('Backup File Saved: ${backupFile.path}');
    return backupFile;
  }

  Future<void> uploadBackupFile(File file) async {
    final account = await _googleSignIn.signIn();
    if (account == null) {
      throw Exception('Login Google gagal');
    }

    final authHeaders = await account.authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders);

    final driveApi = drive.DriveApi(authenticateClient);

    final driveFile = drive.File();
    driveFile.name = path.basename(file.path);
    driveFile.mimeType = 'application/json';

    await driveApi.files.create(
      driveFile,
      uploadMedia: drive.Media(file.openRead(), await file.length()),
    );

    log('Backup uploaded successfully to Google Drive.');
  }

  // Future<void> restoreDataFromDrive() async {
  //   final account = await _googleSignIn.signIn();
  //   if (account == null) throw Exception('Login Google gagal');

  //   final authHeaders = await account.authHeaders;
  //   final authenticateClient = GoogleAuthClient(authHeaders);
  //   final driveApi = drive.DriveApi(authenticateClient);

  //   // 1. Cari file backup (pakai nama atau mimeType)
  //   final fileList = await driveApi.files.list(
  //     q: "mimeType='application/json'",
  //     spaces: 'drive',
  //     orderBy: 'createdTime desc',
  //     $fields: 'files(id, name, createdTime)',
  //   );

  //   if (fileList.files == null || fileList.files!.isEmpty) {
  //     throw Exception('Tidak ada file backup ditemukan di Google Drive.');
  //   }

  //   final latestFile = fileList.files!.first;
  //   final media = await driveApi.files.get(
  //     latestFile.id!,
  //     downloadOptions: drive.DownloadOptions.fullMedia,
  //   ) as drive.Media;

  //   final List<int> dataBytes = [];
  //   final completer = Completer<void>();

  //   media.stream.listen(
  //     dataBytes.addAll,
  //     onDone: () => completer.complete(),
  //     onError: (e) => completer.completeError(e),
  //     cancelOnError: true,
  //   );

  //   await completer.future;

  //   // 2. Decode dan simpan ke database lokal
  //   final String jsonString = utf8.decode(dataBytes);
  //   final jsonMap = jsonDecode(jsonString);
  //   log('Restore berhasil dari backup Google Drive JSON MAP ${jsonMap}');
  //   final categories = jsonMap['categories'] as List<dynamic>;
  //   final products = jsonMap['products'] as List<dynamic>;

  //   // await DBLocalDatasource.instance.clearAllData();

  //   // for (var cat in categories) {
  //   //   await DBLocalDatasource.instance.insertCategoryFromJson(cat);
  //   // }

  //   // for (var prod in products) {
  //   //   await DBLocalDatasource.instance.insertProductFromJson(prod);
  //   // }

  //   // log('Restore berhasil dari backup Google Drive');
  // }

  Future<List<drive.File>> listBackupFilesFromDrive() async {
    final account = await _googleSignIn.signIn();
    if (account == null) throw Exception('Login Google gagal');

    final authHeaders = await account.authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders);
    final driveApi = drive.DriveApi(authenticateClient);

    final fileList = await driveApi.files.list(
      q: "mimeType='application/json' and name contains 'backup_data_'",
      spaces: 'drive',
      orderBy: 'createdTime desc',
      $fields: 'files(id, name, createdTime)',
    );

    if (fileList.files == null || fileList.files!.isEmpty) {
      throw Exception('Tidak ada file backup ditemukan.');
    }

    return fileList.files!;
  }

  Future<Map<String, dynamic>> downloadBackupFile(String fileId) async {
    final account = await _googleSignIn.signIn();
    if (account == null) throw Exception('Login Google gagal');

    final authHeaders = await account.authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders);
    final driveApi = drive.DriveApi(authenticateClient);

    final media = await driveApi.files.get(
      fileId,
      downloadOptions: drive.DownloadOptions.fullMedia,
    ) as drive.Media;

    final List<int> dataBytes = [];
    final completer = Completer<void>();

    media.stream.listen(
      dataBytes.addAll,
      onDone: () => completer.complete(),
      onError: (e) => completer.completeError(e),
      cancelOnError: true,
    );

    await completer.future;

    final jsonString = utf8.decode(dataBytes);
    return jsonDecode(jsonString);
  }

  /// Pilih file JSON dari local storage dan parse menjadi Map
  Future<Map<String, dynamic>?> pickLocalBackupJson() async {
    // Tampilkan dialog pilih file
    final params = OpenFileDialogParams(
      allowEditing: false,
      fileExtensionsFilter: ['json'],
      dialogType: OpenFileDialogType.document,

      // bisa tambahkan mimeTypes jika perlu
    );
    final String? filePath = await FlutterFileDialog.pickFile(params: params);
    if (filePath == null) return null; // user batal

    final File file = File(filePath);
    final String content = await file.readAsString();
    // log("JSON content: ${jsonDecode(content)}");
    return jsonDecode(content) as Map<String, dynamic>;
  }

  Future<void> restoreDataFromJson(Map<String, dynamic> jsonMap) async {
    try {
      final categories = jsonMap['categories'] as List<dynamic>;
      final products = jsonMap['products'] as List<dynamic>;
      final transactions = jsonMap['transactions'] as List<dynamic>;
      final transactionItems = jsonMap['transactionItems'] as List<dynamic>;
      final taxDiscounts = jsonMap['taxDiscounts'] as List<dynamic>;
      final users = jsonMap['users'] as List<dynamic>;
      log("Restore Data jsonMap: $jsonMap");
      await DBLocalDatasource.instance.clearAllData();

      for (var cat in categories) {
        final category = CategoryModel.fromJson(cat);
        await DBLocalDatasource.instance.saveCategory(category);
      }

      for (var prod in products) {
        final product = Product.fromJson(prod);
        await DBLocalDatasource.instance.saveProduct(product);
      }

      for (var trans in transactions) {
        final transaction = TransactionModel.fromJson(trans);
        await DBLocalDatasource.instance.saveOrderOnly(transaction);
      }

      for (var transItem in transactionItems) {
        final transactionItem = Item.fromJson(transItem);
        await DBLocalDatasource.instance.saveOrderItem(transactionItem);
      }

      for (var taxDisc in taxDiscounts) {
        final taxDiscount = TaxDiscountModel.fromJson(taxDisc);
        await DBLocalDatasource.instance.saveTaxDiscount(taxDiscount);
      }

      for (var user in users) {
        final userModel = UserModel.fromJson(user);
        await DBLocalDatasource.instance.saveUser(userModel);
      }
    } catch (e) {
      log("Restore Data Error: $e");
    }
  }

  Future<String?> saveBackupToDownloads(File file) async {
    await requestStoragePermissions();
    final params = SaveFileDialogParams(
      sourceFilePath: file.path,
      // Nama file default yang akan di‑suggest
      fileName: 'backup_data_${DateTime.now().millisecondsSinceEpoch}.json',
    );

    // Panggil dialog “Save as...”
    final String? savedFilePath =
        await FlutterFileDialog.saveFile(params: params);
    log("saveBackupToDownloads: $savedFilePath");
    // savedFilePath adalah content URI di Android 11+, atau full path di iOS/desktop
    return savedFilePath;
  }

  Future<bool> requestStoragePermissions() async {
    if (Platform.isAndroid) {
      // Untuk Android ≤ 10
      if (await Permission.storage.request().isGranted) {
        return true;
      }
      // Untuk Android 11+, minta MANAGE_EXTERNAL_STORAGE
      if (await Permission.manageExternalStorage.request().isGranted) {
        return true;
      }
      return false;
    }
    return true;
  }
}
