import 'package:ficonsax/ficonsax.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toastification/toastification.dart';
import 'chat_list_page.dart';
import '../providers/image_provider.dart';
import '../widgets/auth_button.dart';

import '../utils/dialogs.dart';

class UploadPhotoPage extends ConsumerStatefulWidget {
  final UserCredential userCredentials;
  const UploadPhotoPage({
    super.key,
    required this.userCredentials,
  });

  @override
  ConsumerState<UploadPhotoPage> createState() => _UploadPhotoPageState();
}

class _UploadPhotoPageState extends ConsumerState<UploadPhotoPage> {
  bool _isUploading = false;
  Future<void> _uploadPhoto() async {
    final selectedPhoto = ref.watch(profilePhotoProvider);
    try {
      setState(() {
        _isUploading = true;
      });
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_photos')
          .child('${widget.userCredentials.user!.uid}.jpg');

      await storageRef.putFile(selectedPhoto);
      final imageUrl = await storageRef.getDownloadURL();
      if (!mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      toastification.show(
        context: context,
        alignment: Alignment.bottomCenter,
        icon: const Icon(
          IconsaxBold.tick_circle,
          color: Color(0xFF00B2FF),
        ),
        type: ToastificationType.success,
        style: ToastificationStyle.flat,
        title: 'Photo uploaded!',
        autoCloseDuration: const Duration(seconds: 3),
        showProgressBar: false,
        borderRadius: BorderRadius.circular(12.0),
        closeButtonShowType: CloseButtonShowType.none,
        closeOnClick: false,
        dragToClose: true,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ChatListPage(),
        ),
      );
      setState(() {
        _isUploading = false;
      });
      print('Uploaded image url: $imageUrl');
    } catch (error) {
      setState(() {
        _isUploading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      toastification.show(
        context: context,
        alignment: Alignment.bottomCenter,
        icon: const Icon(
          IconsaxBold.info_circle,
          color: Colors.red,
        ),
        type: ToastificationType.error,
        style: ToastificationStyle.flat,
        title: error.toString(),
        autoCloseDuration: const Duration(seconds: 3),
        showProgressBar: false,
        borderRadius: BorderRadius.circular(12.0),
        closeButtonShowType: CloseButtonShowType.none,
        closeOnClick: false,
        dragToClose: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedPhoto = ref.watch(profilePhotoProvider);
    Widget content = InkWell(
      onTap: () {
        Dialogs.uploadImageDialog(
          context,
          () {
            ref.read(profilePhotoProvider.notifier).takePhoto();
          },
          () {
            ref.read(profilePhotoProvider.notifier).pickPhoto();
          },
        );
      },
      child: Icon(
        IconsaxOutline.gallery_add,
        size: 50,
        color: Colors.grey[600],
      ),
    );
    if (selectedPhoto.path.isNotEmpty) {
      content = ClipOval(
        child: Stack(
          children: [
            Image.file(
              selectedPhoto,
              width: 160,
              height: 160,
              fit: BoxFit.cover,
            ),
            InkWell(
              onTap: () {
                Dialogs.uploadImageDialog(
                  context,
                  () {
                    ref.read(profilePhotoProvider.notifier).takePhoto();
                  },
                  () {
                    ref.read(profilePhotoProvider.notifier).pickPhoto();
                  },
                );
              },
              child: Center(
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.black.withOpacity(0.2),
                  child: const Icon(
                    IconsaxOutline.gallery_edit,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatListPage(),
                ),
              );
            },
            child: const Text(
              'Skip',
              style: TextStyle(
                color: Color(0xFF00B2FF),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add a profile photo 📸',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Upload your profile photo so your friends know it\'s you',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: CircleAvatar(
                radius: 70,
                backgroundColor: const Color(0xFFF4F4F4),
                child: content,
              ),
            ),
            const Spacer(),
            AuthButton(
              onPressed: selectedPhoto.path != ''
                  ? (_isUploading ? null : _uploadPhoto)
                  : null,
              isSubmitting: _isUploading,
              label: 'Upload photo',
            )
          ],
        ),
      ),
    );
  }
}
