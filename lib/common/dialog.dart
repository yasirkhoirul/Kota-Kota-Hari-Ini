import 'package:flutter/material.dart';

class DialogUtils {
  // Menampilkan Loading
  static void showLoading(BuildContext context) {
    showDialog(
      context: context,
      useRootNavigator: true, // Kunci utama
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }

  // Menutup Dialog (Loading/Error/Success)
  static void hide(BuildContext context) {
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  // Menampilkan Pesan Sukses
  static void showSuccess(
    BuildContext context, {
    required String message,
    VoidCallback? onPressed,
  }) {
    showDialog(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Berhasil"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              hide(context); // Tutup dialog sukses
              if (onPressed != null) {
                onPressed();
              }
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // Menampilkan Pesan Error
  static void showError(BuildContext context, String message) {
    showDialog(
      context: context,
      useRootNavigator: true,
      builder: (_) => AlertDialog(
        title: const Text("Gagal"),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => hide(context), child: const Text("OK")),
        ],
      ),
    );
  }
}
