import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

Future<Uint8List?> generateQrBytes({
  required String data,
  int size = 200,
  Color qrColor = Colors.black,
  Color backgroundColor = Colors.white,
}) async {
  final validation = QrValidator.validate(
    data: data,
    version: QrVersions.auto,
    errorCorrectionLevel: QrErrorCorrectLevel.L,
  );

  if (validation.status != QrValidationStatus.valid ||
      validation.qrCode == null) {
    print('❌ QR data tidak valid: $data');
    return null;
  }

  final painter = QrPainter.withQr(
    qr: validation.qrCode!,
    color: qrColor,
    emptyColor: backgroundColor,
    gapless: false,
  );

  final byteData = await painter.toImageData(size.toDouble());
  return byteData?.buffer.asUint8List();
}
