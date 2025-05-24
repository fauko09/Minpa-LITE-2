import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';

void snackbarInfo(BuildContext context, String text) {
  AnimatedSnackBar.material(
    text,
    type: AnimatedSnackBarType.info,
    mobileSnackBarPosition: MobileSnackBarPosition.top,
    duration: const Duration(milliseconds: 2000),
    desktopSnackBarPosition: DesktopSnackBarPosition.topCenter,
    snackBarStrategy: RemoveSnackBarStrategy(),
  ).show(context);
}

void snackbarEror(BuildContext context, String text) {
  AnimatedSnackBar.material(
    text,
    type: AnimatedSnackBarType.error,
    mobileSnackBarPosition: MobileSnackBarPosition.top,
    desktopSnackBarPosition: DesktopSnackBarPosition.topCenter,
    snackBarStrategy: RemoveSnackBarStrategy(),
  ).show(context);
}

void snackbarSucces(BuildContext context, String text) {
  AnimatedSnackBar.material(
    text,
    type: AnimatedSnackBarType.success,
    mobileSnackBarPosition: MobileSnackBarPosition.top,
    desktopSnackBarPosition: DesktopSnackBarPosition.topCenter,
    snackBarStrategy: RemoveSnackBarStrategy(),
  ).show(context);
}