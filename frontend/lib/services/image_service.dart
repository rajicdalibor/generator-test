import 'package:flutter/material.dart';
import 'package:frontend/models/upload_file.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime_type/mime_type.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum MediaSource {
  photoGallery,
  camera,
}

class ImageService {
  static const allowedFormats = {'image/png', 'image/jpeg', 'image/jpg'};

  static Future<UploadFile?> selectMedia({
    MediaSource mediaSource = MediaSource.camera,
  }) async {
    final picker = ImagePicker();
    final source = mediaSource == MediaSource.camera
        ? ImageSource.camera
        : ImageSource.gallery;
    // imageQuality is a number between 0 and 100 and it represents the quality of the image
    final pickedMedia =
        await picker.pickImage(source: source, imageQuality: 65);
    final mediaBytes = await pickedMedia?.readAsBytes();
    if (mediaBytes == null) {
      return null;
    }
    final fileName = _getFileName(pickedMedia!.name);

    return UploadFile(
      fileName: fileName,
      filePath: pickedMedia.path,
      bytes: mediaBytes,
    );
  }

  static String _getFileName(String mediaName) {
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final ext = mediaName.split('.').last;
    return '$timestamp.$ext';
  }

  static Future<UploadFile?> selectAvatarMediaActions({
    required BuildContext context,
    required GestureTapCallback onDeleteAvatar,
    bool hasAvatar = false,
  }) async {
    final translations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final mediaSource = await showModalBottomSheet<MediaSource>(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(
                    translations.chooseMediaSource,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                const Divider(),
                createUploadMediaListTile(context, translations.mediaGallery,
                    MediaSource.photoGallery),
                const Divider(),
                createUploadMediaListTile(
                    context, translations.mediaCamera, MediaSource.camera),
                if (hasAvatar) const Divider(),
                if (hasAvatar)
                  ListTile(
                    title: Text(
                      translations.commonDelete,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(color: Colors.red),
                    ),
                    onTap: () {
                      onDeleteAvatar();
                      context.pop();
                    },
                  ),
              ],
            ),
          );
        });

    if (mediaSource == null) {
      return null;
    }
    return selectMedia(mediaSource: mediaSource);
  }

  static Future<UploadFile?> selectImageMediaActions({
    required BuildContext context,
  }) async {
    final translations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final mediaSource = await showModalBottomSheet<MediaSource>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  translations.chooseMediaSource,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge,
                ),
              ),
              const Divider(),
              createUploadMediaListTile(
                  context, translations.mediaGallery, MediaSource.photoGallery),
              const Divider(),
              createUploadMediaListTile(
                  context, translations.mediaCamera, MediaSource.camera),
            ],
          ),
        );
      },
    );

    if (mediaSource == null) {
      return null;
    }

    return selectMedia(mediaSource: mediaSource);
  }

  static Widget createUploadMediaListTile(
      BuildContext context, String label, MediaSource mediaSource) {
    final theme = Theme.of(context);
    return ListTile(
      title: Text(
        label,
        textAlign: TextAlign.center,
        style: theme.textTheme.titleMedium,
      ),
      onTap: () => context.pop(mediaSource),
    );
  }

  static bool isImageFile(String filePath, BuildContext context) {
    return allowedFormats.contains(mime(filePath));
  }
}
