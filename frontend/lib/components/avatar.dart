import 'package:flutter/material.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/providers/user_providers.dart';
import 'package:frontend/services/image_service.dart';
import 'package:frontend/services/storage_service.dart';
import 'package:frontend/services/user_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mime_type/mime_type.dart';

class Avatar extends ConsumerStatefulWidget {
  const Avatar({
    super.key,
    this.size,
    this.readOnly = false,
  });

  final double? size;
  final bool readOnly;

  @override
  ConsumerState<Avatar> createState() => _AvatarState();
}

class _AvatarState extends ConsumerState<Avatar> {
  bool processingImage = false;

  bool hasAvatarImage(AppUser user) {
    return user.avatarImage != null && user.avatarImage!.isNotEmpty;
  }

  Future<void> deleteAvatar(AppUser user) async {
    await StorageService.deleteFile(user.avatarImage!);
    await UserService.updateAvatarImage('');
    ref.read(userProvider.notifier).setAvatar('');
    ref.read(userProvider.notifier).setAvatarImageUrl('');
  }

  Future<void> onAvatarChange(AppUser user) async {
    final selectedMedia = await ImageService.selectAvatarMediaActions(
      context: context,
      onDeleteAvatar: () async {
        try {
          setState(() {
            processingImage = true;
          });
          await deleteAvatar(user);
        } catch (e) {
          debugPrint('Error deleting avatar: $e');
        } finally {
          setState(() {
            processingImage = false;
          });
        }
      },
      hasAvatar: hasAvatarImage(user),
    );

    if (selectedMedia == null) {
      return;
    }

    if (mounted) {
      final isFileFormatValid =
          ImageService.isImageFile(selectedMedia.fileName, context);
      if (!isFileFormatValid) {
        String mimetype = mime(selectedMedia.fileName) ?? '';
        debugPrint('Invalid file format: $mimetype');
        return;
      }

      try {
        setState(() {
          processingImage = true;
        });

        String? newAvatar =
            await StorageService.uploadProfilePicture(user.id!, selectedMedia);
        if (newAvatar != null) {
          if (hasAvatarImage(user)) {
            await deleteAvatar(user);
          }
          UserService.updateAvatarImage(newAvatar);
          ref.read(userProvider.notifier).setAvatar(newAvatar);
        }
      } catch (e) {
        debugPrint('Error uploading avatar: $e');
      } finally {
        setState(() {
          processingImage = false;
        });
      }
    }
  }

  Future<ImageProvider<Object>?> getAvatarImage(AppUser? user) async {
    if (user == null) {
      return null;
    }

    if (user.avatarImageUrl != null && user.avatarImageUrl!.isNotEmpty) {
      return NetworkImage(user.avatarImageUrl!);
    }

    if (hasAvatarImage(user)) {
      final avatarImageUrl =
          await StorageService.getFileDownloadUrl(user.avatarImage!);
      if (avatarImageUrl != null) {
        ref.read(userProvider.notifier).setAvatarImageUrl(avatarImageUrl);
        return NetworkImage(avatarImageUrl);
      }
      return null;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final theme = Theme.of(context);

    if (processingImage) {
      return SizedBox(
        height: widget.size ?? 150,
        width: widget.size ?? 150,
        child: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          radius: 100,
          child: CircularProgressIndicator(
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
      );
    }

    return SizedBox(
      height: widget.size ?? 150,
      width: widget.size ?? 150,
      child: FutureBuilder(
        future: getAvatarImage(user),
        builder: (context, snapshot) {
          return CircleAvatar(
            backgroundColor: theme.colorScheme.primaryContainer,
            backgroundImage: snapshot.hasData ? snapshot.data : null,
            radius: 100,
            child: !widget.readOnly
                ? Container(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          theme.colorScheme.inversePrimary,
                        ),
                      ),
                      icon: const Icon(Icons.edit),
                      color: theme.colorScheme.onPrimaryContainer,
                      onPressed: () {
                        onAvatarChange(user!);
                      },
                    ),
                  )
                : const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
