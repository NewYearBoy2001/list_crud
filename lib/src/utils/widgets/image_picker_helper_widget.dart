import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:list_crud/src/constants/colors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_image_compress/flutter_image_compress.dart';

/// Helper for selecting images with permission handling and base64 conversion.
class ImagePickerHelper {
  final Function(File imageFile, String base64, String extension, String formattedString) onImageSelected;
  final BuildContext context;

  ImagePickerHelper({
    required this.context,
    required this.onImageSelected,
  });

  Future<void> pickImage(ImageSource source) async {
    try {
      PermissionStatus status = await _getPermissionStatus(source);

      if (status.isGranted || status.isLimited) {
        await _pickImageFromSource(source);
      } else if (status.isPermanentlyDenied) {
        // Show settings dialog
        await _handlePermissionDeniedAndRetry(source);
      } else {
        Fluttertoast.showToast(msg: "Permission denied");
      }
    } catch (e) {
      debugPrint("⚠️ pickImage error: $e");
      Fluttertoast.showToast(msg: "Error picking image: $e");
    }
  }

  Future<void> _handlePermissionDeniedAndRetry(ImageSource source) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Permission Required"),
        content: const Text(
            "Please allow access to camera or photos from settings to continue."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await openAppSettings();
              // Wait for user to come back from settings
              await Future.delayed(const Duration(seconds: 1));
              // Re-check permission after returning from settings
              PermissionStatus newStatus = await _getPermissionStatus(source);
              if (newStatus.isGranted || newStatus.isLimited) {
                await _pickImageFromSource(source);
              } else {
                Fluttertoast.showToast(msg: "Permission still denied");
              }
            },
            child: const Text("Settings"),
          ),
        ],
      ),
    );
  }


  // Future<PermissionStatus> _getPermissionStatus(ImageSource source) async {
  //   if (source == ImageSource.camera) {
  //     var status = await Permission.camera.status;
  //     if (!status.isGranted) status = await Permission.camera.request();
  //     return status;
  //   } else {
  //     if (Platform.isIOS) {
  //       var status = await Permission.photos.status;
  //       if (!status.isGranted && !status.isLimited) status = await Permission.photos.request();
  //       return status;
  //     } else if (Platform.isAndroid) {
  //       final androidInfo = await DeviceInfoPlugin().androidInfo;
  //       final sdkInt = androidInfo.version.sdkInt;
  //       if (sdkInt >= 33) {
  //         var status = await Permission.photos.status;
  //         if (!status.isGranted) status = await Permission.photos.request();
  //         return status;
  //       } else if (sdkInt < 30) {
  //         var status = await Permission.storage.status;
  //         if (!status.isGranted) status = await Permission.storage.request();
  //         return status;
  //       } else {
  //         // Android 30+ (Scoped Storage) usually does not need storage permission
  //         var status = await Permission.storage.status;
  //         if (!status.isGranted) status = await Permission.storage.request();
  //         return status;
  //       }
  //     } else {
  //       return PermissionStatus.granted;
  //     }
  //   }
  // }

  Future<PermissionStatus> _getPermissionStatus(ImageSource source) async {
    if (source == ImageSource.camera) {
      // Camera always requires runtime permission
      PermissionStatus status = await Permission.camera.status;
      if (!status.isGranted) {
        status = await Permission.camera.request();
      }
      return status;
    } else {
      // Gallery / photos selection
      if (Platform.isIOS) {
        // iOS 14+ has limited photo access
        PermissionStatus status = await Permission.photos.status;
        if (!status.isGranted && !status.isLimited) {
          status = await Permission.photos.request();
        }
        return status;
      } else if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        final sdkInt = androidInfo.version.sdkInt;

        if (sdkInt >= 33) {
          // Android 13+: Photo picker does NOT require permission
          // Only camera requires runtime permission
          return PermissionStatus.granted;
        } else if (sdkInt >= 30) {
          // Android 11–12 (Scoped Storage): picker works without storage permission
          return PermissionStatus.granted;
        } else {
          // Android 10 and below: need READ_EXTERNAL_STORAGE
          PermissionStatus status = await Permission.storage.status;
          if (!status.isGranted) {
            status = await Permission.storage.request();
          }
          return status;
        }
      } else {
        // Other platforms (web, desktop) – assume granted
        return PermissionStatus.granted;
      }
    }
  }


  Future<void> _pickImageFromSource(ImageSource source) async {
    final picker = ImagePicker();

    // Show loading
    showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator(
      color: Colors.white,
    )));

    final XFile? pickedFile = await picker.pickImage(source: source, imageQuality: 85);

    Navigator.of(context, rootNavigator: true).pop(); // Close loading

    if (pickedFile == null) {
      Fluttertoast.showToast(msg: "No image selected");
      return;
    }

    // Compress image
    List<int>? compressedBytes;
    try {
      compressedBytes = await FlutterImageCompress.compressWithFile(
        pickedFile.path,
        minWidth: 800,
        minHeight: 800,
        quality: 70,
      );
    } catch (e) {
      debugPrint("⚠️ Compression error: $e");
      compressedBytes = await pickedFile.readAsBytes();
    }

    if (compressedBytes == null) {
      Fluttertoast.showToast(msg: "Image compression failed");
      return;
    }

    final compressedSizeMB = compressedBytes.length / (1024 * 1024);
    if (compressedSizeMB > 5) {
      Fluttertoast.showToast(msg: "Image is still greater than 5MB after compression");
      return;
    }

    final compressedPath = '${p.dirname(pickedFile.path)}/${DateTime.now().millisecondsSinceEpoch}${p.extension(pickedFile.path)}';
    final File compressedFile = await File(compressedPath).writeAsBytes(compressedBytes);

    final String base64 = base64Encode(compressedBytes);
    final String extension = p.extension(compressedFile.path).replaceAll('.', '');
    final String formatted = "data:image/$extension;base64,$base64";

    onImageSelected(compressedFile, base64, extension, formatted);
    Fluttertoast.showToast(msg: "Image selected successfully");
  }

  static String? convertFileToBase64(File? file) {
    if (file == null || !file.existsSync() || file.path.isEmpty) return null;
    final bytes = file.readAsBytesSync();
    return base64Encode(bytes);
  }
}

/// Image picker card widget
class ImagePickerCard extends StatelessWidget {
  final File? imageFile;
  final VoidCallback onTap;

  const ImagePickerCard({Key? key, required this.imageFile, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        color: AppColors.primaryBlueColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          height: 180,
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          child: imageFile != null
              ? ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(imageFile!, width: double.infinity, fit: BoxFit.cover),
          )
              : Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.add_photo_alternate_outlined, size: 40, color: Colors.grey),
                SizedBox(height: 8),
                Text("Tap to upload image", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Bottom sheet to pick image
Future<void> showImagePickerBottomSheet({
  required BuildContext context,
  required Function(File file, String base64, String ext, String formatted) onImageSelected,
}) async {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (_) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Upload Profile Picture",
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.blueGrey[900])),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageOption(
                  icon: Icons.camera_alt,
                  label: "Camera",
                  color: Colors.blue,
                  onTap: () {
                    Navigator.pop(context);
                    ImagePickerHelper(context: context, onImageSelected: onImageSelected)
                        .pickImage(ImageSource.camera);
                  },
                ),
                _buildImageOption(
                  icon: Icons.image,
                  label: "Gallery",
                  color: Colors.green,
                  onTap: () {
                    Navigator.pop(context);
                    ImagePickerHelper(context: context, onImageSelected: onImageSelected)
                        .pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.redAccent, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildImageOption({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(0.1)),
          child: Icon(icon, size: 28, color: color),
        ),
        const SizedBox(height: 8),
        Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.blueGrey[800])),
      ],
    ),
  );
}
