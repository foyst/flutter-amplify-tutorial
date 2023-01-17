import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

class ProfilePicture extends StatefulWidget {
  const ProfilePicture({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  ImageProvider? _image;
  bool _isLoading = true;
  static const String profilePictureKey = "ProfilePicture.jpg";

  @override
  void initState() {
    super.initState();
    _retrieveProfilePicture();
  }

  void _retrieveProfilePicture() async {
    final userFiles = await Amplify.Storage.list(
        options: ListOptions(accessLevel: StorageAccessLevel.protected));
    if (userFiles.items.any((element) => element.key == profilePictureKey)) {
      final documentsDir = await getApplicationDocumentsDirectory();
      final filepath = "${documentsDir.path}/ProfilePicture.jpg";
      final file = File(filepath);
      await Amplify.Storage.downloadFile(
          key: profilePictureKey,
          local: file,
          options:
              DownloadFileOptions(accessLevel: StorageAccessLevel.protected));

      setState(() {
        _image = FileImage(file);
        _isLoading = false;
      });
    } else {
      setState(() {
        _image = const AssetImage("assets/profile-placeholder.png");
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const CircularProgressIndicator(
        value: null,
        semanticsLabel: 'Circular progress indicator',
      );
    }

    return GestureDetector(
      onTap: _selectNewProfilePicture,
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              image: _image ?? _placeholderProfilePicture(), fit: BoxFit.fill),
        ),
      ),
    );
  }

  void _selectNewProfilePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _isLoading = true;
      });

      var imageBytes = await image.readAsBytes();

      final UploadFileResult result = await Amplify.Storage.uploadFile(
          local: File.fromUri(Uri.file(image.path)),
          key: profilePictureKey,
          onProgress: (progress) {
            safePrint('Fraction completed: ${progress.getFractionCompleted()}');
          },
          options:
              UploadFileOptions(accessLevel: StorageAccessLevel.protected));

      setState(() {
        _image = MemoryImage(imageBytes);
        _isLoading = false;
      });
    }
  }

  _placeholderProfilePicture() {
    return const AssetImage("assets/profile-placeholder.png");
  }
}
