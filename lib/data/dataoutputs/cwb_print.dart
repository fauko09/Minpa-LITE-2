import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/services.dart';


import 'package:intl/intl.dart';
import 'package:minpa_lite/core/extensions/int_ext.dart';
import 'package:minpa_lite/core/extensions/string_ext.dart';
import 'package:minpa_lite/data/datasources/auth_local_datasource.dart';
import 'package:minpa_lite/data/models/product_quantity.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:image/image.dart' as img;

class CwbPrint {
  CwbPrint._init();

  static final CwbPrint instance = CwbPrint._init();

  Future<void> printReceipt(List<int> printValue) async {
    try {
      await PrintBluetoothThermal.writeBytes(printValue);
    } on PlatformException catch (e) {
      print('Error: $e');
    }
  }

  Future<List<int>> printOrderV2(
    List<ProductQuantity> products,
    int totalQuantity,
    int totalPrice,
    String paymentMethod,
    int nominalBayar,
    String namaKasir,
    String customerName,
    double tax,
    double subtotal,
    String noNota,
    double discount,
    bool isReprint,
    int paper,
    Uint8List barcode,
  ) async {
    List<int> bytes = [];
    final profile = await CapabilityProfile.load();
    final generator =
        Generator(paper == 80 ? PaperSize.mm80 : PaperSize.mm58, profile);
    final img.Image? orginalImage = img.decodeImage(barcode);
    // final ByteData data = await rootBundle.load('assets/logo/jfl4.png');
    // final Uint8List bytesData = data.buffer.asUint8List();
    // final img.Image? orginalImage = img.decodeImage(bytesData);
    bytes += generator.reset();

    // if (orginalImage != null) {
    //   final img.Image grayscalledImage = img.grayscale(orginalImage);
    //   final img.Image resizedImage =
    //       img.copyResize(grayscalledImage, width: 240);
    //   bytes += generator.imageRaster(resizedImage, align: PosAlign.center);
    //   bytes += generator.feed(2);
    // }

    // final outletData = await AuthLocalDatasource().getOutletData();

    final authData = await AuthLocalDatasource().getUserData();
    final store = await AuthLocalDatasource().getStore();

    bytes += generator.text('${store?.name}',
        styles: const PosStyles(
          bold: true,
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ));

    bytes += generator.text('${store?.address}',
        styles: const PosStyles(bold: false, align: PosAlign.center));

    // bytes += generator.feed(1);
    //58 mm
    bytes += generator.text(
        paper == 80
            ? '------------------------------------------------'
            : '--------------------------------',
        styles: const PosStyles(bold: false, align: PosAlign.center));

    bytes += generator.row([
      PosColumn(
        text: 'No Nota',
        width: 5,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: ':',
        width: 1,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: noNota,
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'Waktu',
        width: 5,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: ':',
        width: 1,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: DateFormat('dd MMM yy HH:mm').format(DateTime.now()),
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'Kasir',
        width: 5,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: ':',
        width: 1,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: '${authData?.name}',
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),
    ]);
    bytes += generator.text(
        paper == 80
            ? '------------------------------------------------'
            : '--------------------------------',
        styles: const PosStyles(bold: false, align: PosAlign.center));

    for (final product in products) {
      bytes += generator.row([
        PosColumn(
          text: '${product.quantity} ${product.product.name}',
          width: 9,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: '${product.product.price!.toDouble.toInt() * product.quantity}'
              .currencyFormatRpV2,
          width: 3,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }
    bytes += generator.text(
        paper == 80
            ? '------------------------------------------------'
            : '--------------------------------',
        styles: const PosStyles(bold: false, align: PosAlign.center));

    bytes += generator.row([
      PosColumn(
        text: 'Subtotal $totalQuantity Items',
        width: 8,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: subtotal.currencyFormatRpV2,
        width: 4,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    bytes += generator.row([
      PosColumn(
        text: 'Total Tax',
        width: 8,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: tax.currencyFormatRpV2,
        width: 4,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'Total Discount',
        width: 8,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: discount.currencyFormatRpV2,
        width: 4,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    bytes += generator.row([
      PosColumn(
        text: 'Total',
        width: 8,
        styles: const PosStyles(align: PosAlign.left, bold: true),
      ),
      PosColumn(
        text: totalPrice.currencyFormatRpV2,
        width: 4,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);
    bytes += generator.text(
        paper == 80
            ? '------------------------------------------------'
            : '--------------------------------',
        styles: const PosStyles(bold: false, align: PosAlign.center));
    bytes += generator.row([
      PosColumn(
        text: 'Metode Pembayaran',
        width: 8,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: paymentMethod == 'QRIS' ? 'QRIS' : 'Tunai',
        width: 4,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    if (orginalImage != null) {
      final img.Image resizedImage = img.copyResize(orginalImage, width: 200);
      bytes += generator.text(
          paper == 80
              ? '================================================'
              : '================================',
          styles: const PosStyles(bold: false, align: PosAlign.center));
      bytes += generator.feed(1);
      bytes += generator.imageRaster(resizedImage, align: PosAlign.center);
      bytes += generator.feed(2);
      bytes += generator.text('Pindai QR code untuk menemukan transaksi Anda.',
          styles: const PosStyles(
            bold: true,
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ));
    }

    //reprint
    if (isReprint) {
      bytes += generator.feed(1);
      bytes += generator.text(
          paper == 80
              ? '=====================REPRINT===================='
              : '=========REPRINT=========',
          styles: const PosStyles(
            bold: true,
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ));
    } else {
      bytes += generator.text(
          paper == 80
              ? '================================================'
              : '================================',
          styles: const PosStyles(bold: false, align: PosAlign.center));
    }
    bytes += generator.feed(2);

    //cut
    if (paper == 80) {
      bytes += generator.cut();
    }

    return bytes;
  }

  // Future<List<int>> printQRIS(
  //   int totalPrice,
  //   Uint8List imageQris,
  // ) async {
  //   List<int> bytes = [];

  //   final profile = await CapabilityProfile.load();
  //   final generator = Generator(PaperSize.mm58, profile);

  //   final img.Image? orginalImage = img.decodeImage(imageQris);
  //   bytes += generator.reset();

  //   bytes += generator.text('Scan QRIS Below for Payment',
  //       styles: const PosStyles(bold: false, align: PosAlign.center));
  //   bytes += generator.feed(2);
  //   if (orginalImage != null) {
  //     final img.Image grayscalledImage = img.grayscale(orginalImage);
  //     final img.Image resizedImage =
  //         img.copyResize(grayscalledImage, width: 330);
  //     bytes += generator.imageRaster(resizedImage, align: PosAlign.center);
  //     bytes += generator.feed(4);
  //   }
  //   bytes += generator.text('Price : ${totalPrice.currencyFormatRp}',
  //       styles: const PosStyles(bold: false, align: PosAlign.center));

  //   bytes += generator.feed(3);

  //   return bytes;
  // }

  //print checker
//   Future<List<int>> printChecker(
//     List<OrderItem> products,
//     int tableNumber,
//     String draftName,
//     String cashierName,
//   ) async {
//     List<int> bytes = [];

//     final profile = await CapabilityProfile.load();
//     final generator = Generator(PaperSize.mm58, profile);

//     bytes += generator.reset();

//     bytes += generator.text('Table Checker',
//         styles: const PosStyles(
//           bold: true,
//           align: PosAlign.center,
//           height: PosTextSize.size1,
//           width: PosTextSize.size1,
//         ));
//     bytes += generator.feed(1);
//     bytes += generator.text(tableNumber.toString(),
//         styles: const PosStyles(
//           bold: true,
//           align: PosAlign.center,
//           height: PosTextSize.size2,
//           width: PosTextSize.size2,
//         ));
//     bytes += generator.feed(1);

//     bytes += generator.text(
//         'Date: ${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now())}',
//         styles: const PosStyles(bold: false, align: PosAlign.left));
//     //reciept number
//     bytes += generator.text(
//         'Receipt: JF-${DateFormat('yyyyMMddhhmm').format(DateTime.now())}',
//         styles: const PosStyles(bold: false, align: PosAlign.left));
// //cashier name
//     bytes += generator.text('Cashier: $cashierName',
//         styles: const PosStyles(bold: false, align: PosAlign.left));
//     //customer name
//     //column 2
//     bytes += generator.row([
//       PosColumn(
//         text: 'Customer: $draftName',
//         width: 8,
//         styles: const PosStyles(align: PosAlign.left),
//       ),
//       PosColumn(
//         text: 'DINE IN',
//         width: 4,
//         styles: const PosStyles(align: PosAlign.right),
//       ),
//     ]);

//     //----
//     bytes += generator.text('--------------------------------',
//         styles: const PosStyles(bold: false, align: PosAlign.center));

//     for (final product in products) {
//       bytes += generator.text('${product.quantity} x  ${product.product.name}',
//           styles: const PosStyles(
//             align: PosAlign.left,
//             bold: false,
//             height: PosTextSize.size2,
//             width: PosTextSize.size1,
//           ));
//     }

//     bytes += generator.feed(1);
//     bytes += generator.text('-----ORDER CHECKER-----',
//         styles: const PosStyles(bold: false, align: PosAlign.center));
//     bytes += generator.feed(3);

//     return bytes;
//   }
}
