import 'package:flutter/material.dart';
import '../../core/app_strings.dart';

class ConfirmationDialogView extends StatelessWidget {
  final int dialogType; // 1 or 2, to select which dialog to show
  const ConfirmationDialogView({super.key, this.dialogType = 1});

  @override
  Widget build(BuildContext context) {
    final String imageAsset = dialogType == 1
        ? 'assets/images/confirmation_dialog_1.png'
        : 'assets/images/confirmation_dialog_2.png';
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(imageAsset, height: 120),
            const SizedBox(height: 24),
            const Text(
              AppStrings.confirmationTitle,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              AppStrings.confirmationBody,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text(AppStrings.confirmationCancel),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text(AppStrings.confirmationConfirm),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
