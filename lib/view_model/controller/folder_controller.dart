import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:path_provider/path_provider.dart';

class FolderController extends GetxController {
  // Each map contains the metadata for an audio file.
  final folderList = <Map<String, dynamic>>[].obs;

  Future<void> getList() async {
    // Retrieve an accessible directory; adjust as needed.
    final Directory? baseDir = await getExternalStorageDirectory();
    if (baseDir == null) return;

    // Recursively list files from the base directory.
    final files = await Directory(baseDir.path)
        .list(recursive: true, followLinks: false)
        .toList();

    folderList.clear();

    for (var file in files) {
      // Filter audio files by extension.
      if (file is File &&
          (file.path.endsWith('.mp3') ||
              file.path.endsWith('.m4a') ||
              file.path.endsWith('.wav'))) {
        try {
          // Retrieve metadata from the file.
          final metadata = await MetadataRetriever.fromFile(file);

          // Build a map using the correct getters.
          Map<String, dynamic> metadataMap = {
            'path': file.path,
            'trackName': metadata.trackName ?? 'Unknown',
            'trackArtistNames': metadata.trackArtistNames ?? ['Unknown'],
            'albumName': metadata.albumName ?? 'Unknown',
            'albumArtistName': metadata.albumArtistName ?? 'Unknown',
            'trackNumber': metadata.trackNumber ?? 0,
            'albumLength': metadata.albumLength ?? 0,
            'year': metadata.year ?? 0,
            'genre': metadata.genre ?? 'Unknown',
            'authorName': metadata.authorName ?? 'Unknown',
            'writerName': metadata.writerName ?? 'Unknown',
            'discNumber': metadata.discNumber ?? 0,
            'mimeType': metadata.mimeType ?? 'Unknown',
            'trackDuration': metadata.trackDuration ?? 0,
            'bitrate': metadata.bitrate ?? 0,
            'albumArt': metadata.albumArt, // Uint8List? (could be null)
          };

          folderList.add(metadataMap);
        } catch (e) {
          // Log error if metadata retrieval fails.
          print("Error retrieving metadata for ${file.path}: $e");
        }
      }
    }
  }
}