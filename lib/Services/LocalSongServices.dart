import 'dart:io';
import 'package:file_picker/file_picker.dart';

const List<String> audioExtensions = [
  '.mp3',
  '.flac',
  '.wav',
  '.m4a',
  '.aac',
  '.ogg',
  '.opus',
  '.wma',
];


Future<List<File>> getSongsPath(String path) async {
  List<File> songs = [];

  Directory musicFolder = Directory(path);

  List<FileSystemEntity> items = await musicFolder.list(recursive: true).toList();

  for (FileSystemEntity item in items) {
    if (item is File) {
      for (int i = 0; i < audioExtensions.length; i++) {
        if (item.path.toLowerCase().endsWith(audioExtensions[i])) {
          songs.add(item);
          break;
        }
      }
    }
  }

  return songs;
}

List<String> getSongs(List<File> songFiles) {
  List<String> songs = [];
  for(var songFile in songFiles) {
    songs.add(songFile.path.split('\\').last);
  }
  return songs;
}

Future<String?> pickMusicFolder() async {
  String? path = await FilePicker.getDirectoryPath();
  return path;
}