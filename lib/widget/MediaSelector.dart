import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image/image.dart' as img;


class MediaSelector extends StatefulWidget {
  final void Function(File? image) onMediaUploaded;

  const MediaSelector({Key? key, required this.onMediaUploaded}) : super(key: key);

  @override
  State<MediaSelector> createState() => _MediaSelectorState();
}

class _MediaSelectorState extends State<MediaSelector> {
  final Reference storageReference = FirebaseStorage.instance.ref();

  File? coverImage; // Change XFile? to File?
  late List<File?> mediaFiles; // Change XFile? to File?
  List<String> selectedMediaPaths = [];

  @override
  void initState() {
    super.initState();
    mediaFiles = List<File?>.generate(4, (_) => null); // Change XFile? to File?
  }

  Future<void> pickMedia(ImageSource source, int index) async {
    final picker = ImagePicker();
    final pickedMedia = await picker.pickImage(source: source);

    if (pickedMedia != null) {
      final pickedFile = File(pickedMedia.path);
      File compressedFile = await _compressImage(pickedFile);

      setState(() {
        if (index == -1) {
          coverImage = compressedFile;
        } else if (index >= 0 && index < mediaFiles.length) {
          mediaFiles[index] = compressedFile;
        }

        selectedMediaPaths.add(compressedFile.path);

        widget.onMediaUploaded(compressedFile);
      });
    }
  }

  Future<File> _compressImage(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);

    // Define your desired width and height for the compressed image
    final resizedImage = img.copyResize(image!, width: 800, height: 600);

    final compressedBytes = img.encodeJpg(resizedImage, quality: 75); // Adjust the quality as needed

    // Create a new file with the compressed image data
    final compressedFile = File(imageFile.path);
    await compressedFile.writeAsBytes(compressedBytes);

    return compressedFile;
  }

  void discardMedia(int index) {
    setState(() {
      if (index == -1) {
        coverImage = null;
      } else if (index >= 0 && index < mediaFiles.length) {
        if (mediaFiles[index] != null) {
          // Check if the file has been uploaded before discarding
          selectedMediaPaths.remove(mediaFiles[index]!.path);
          mediaFiles[index] = null;
        }
      }

      if (index >= 0 && index < selectedMediaPaths.length) {
        selectedMediaPaths.removeAt(index);
      }
    });
  }

  Future<List<String>> uploadMedia(List<File?> selectedMediaFiles) async {
    List<String> mediaURLs = [];

    for (File? mediaFile in selectedMediaFiles) {
      if (mediaFile != null) {
        final Reference mediaReference = storageReference.child(
          'events/${DateTime.now().millisecondsSinceEpoch}_${mediaFile.path.split('/').last}',
        );
        final UploadTask uploadTask = mediaReference.putFile(mediaFile);

        await uploadTask.whenComplete(() async {
          final mediaURL = await mediaReference.getDownloadURL();
          mediaURLs.add(mediaURL);
        });
      }
    }

    return mediaURLs; // Return the list of media URLs
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DottedBorder(
            color: const Color(0xff02cad0),
            borderType: BorderType.RRect,
            radius: const Radius.circular(12),
            child: GestureDetector(
              onTap: () => pickMedia(ImageSource.gallery, -1),
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xffeef7f8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    if (coverImage != null)
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            File(coverImage!.path),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    if (coverImage == null)
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xff02cad0)),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.add, color: Color(0xff02cad0)),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (int i = 0; i < mediaFiles.length; i++)
              GestureDetector(
                onTap: () => pickMedia(ImageSource.gallery, i),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DottedBorder(
                        color: const Color(0xff02cad0),
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(12),
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: const Color(0xffeef7f8),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: mediaFiles[i] == null
                              ? Icon(Icons.add, color: Color(0xff02cad0))
                              : null,
                        ),
                      ),
                    ),
                    if (mediaFiles[i] != null)
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            File(mediaFiles[i]!.path),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    if (mediaFiles[i] != null)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => discardMedia(i),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}