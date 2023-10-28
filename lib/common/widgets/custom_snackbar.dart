import 'package:flutter/material.dart';

customSnackBar({required String content, required BuildContext context}) {
  return SnackBar(
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: 'Dismiss',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
      content: Text(content));
}
