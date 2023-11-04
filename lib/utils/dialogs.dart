import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';

class Dialogs {
  static uploadImageDialog(
      BuildContext context, Function onCamera, Function onGallery) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Select a photo',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () {
                onCamera();
                Navigator.pop(context);
              },
              contentPadding: EdgeInsets.zero,
              leading: const Icon(IconsaxBold.camera),
              title: const Text('Take a photo'),
            ),
            ListTile(
              onTap: () {
                onGallery();
                Navigator.pop(context);
              },
              contentPadding: EdgeInsets.zero,
              leading: const Icon(IconsaxBold.gallery),
              title: const Text('Pick from gallery'),
            ),
          ],
        ),
      ),
    );
  }
}
