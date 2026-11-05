import 'dart:io' as io;
import 'dart:convert';

import 'package:googleapis/drive/v3.dart' as driveApi;
import 'package:googleapis_auth/auth_io.dart';

import 'LocalSongServices.dart' as localSongServices;


// ========================
// READ GOOGLE CREDENTIALS
// ========================

Future<Map<String, dynamic>> readJsonFile(String filePath) async {
  final input = await io.File(filePath).readAsString();

  return jsonDecode(input);
}


// ========================
// GOOGLE LOGIN
// ========================

Future<AuthClient> googleLogin() async {
  final clientJson = await readJsonFile(
    r'lib\credentials\client_secret_912086538268-ckmpsb7aia793rqsnq0s27p0hpvd5par.apps.googleusercontent.com.json',
  );

  final clientId = clientJson["installed"]["client_id"];
  final clientSecret = clientJson["installed"]["client_secret"];

  final googleClientId = ClientId(
    clientId,
    clientSecret,
  );

  final scopes = [
    'https://www.googleapis.com/auth/drive',
  ];

  final client = await clientViaUserConsent(
    googleClientId,
    scopes,
    (url) {
      print("Authorize SongSync here:");
      print(url);
    },
  );

  print("Google authorization successful!");

  return client;
}


// ========================
// FIND CLOUD MUSIC FOLDER
// ========================

Future<String?> getMusicFolderId(
  driveApi.DriveApi drive,
) async {
  final result = await drive.files.list(
    q: "name = 'Music' and "
        "mimeType = 'application/vnd.google-apps.folder' and "
        "trashed = false",
  );

  if (result.files == null || result.files!.isEmpty) {
    print("Music folder wasn't found on Google Drive.");
    return null;
  }

  return result.files!.first.id;
}


// ========================
// GET CLOUD SONGS
// ========================

Future<driveApi.FileList?> getSongsFromGoogleDrive(
  driveApi.DriveApi drive,
) async {
  final musicFolderId = await getMusicFolderId(drive);

  if (musicFolderId == null) {
    return null;
  }

  final songs = await drive.files.list(
    q: "'$musicFolderId' in parents and trashed = false",
  );

  return songs;
}


// ========================
// DOWNLOAD ONE SONG
// ========================

Future<void> downloadSong(
  driveApi.DriveApi drive,
  driveApi.File cloudSong,
  String localMusicFolderPath,
) async {
  final songId = cloudSong.id;
  final songName = cloudSong.name;

  if (songId == null || songName == null) {
    return;
  }

  print("Downloading: $songName");

  final media = await drive.files.get(
    songId,
    downloadOptions: driveApi.DownloadOptions.fullMedia,
  ) as driveApi.Media;

  final localFile = io.File(
    '$localMusicFolderPath\\$songName',
  );

  final sink = localFile.openWrite();

  await media.stream.pipe(sink);

  print("Downloaded: $songName");
}


// ========================
// DOWNLOAD ALL MISSING SONGS
// ========================

Future<void> downloadSongs() async {
  // Choose the local Music folder
  final localMusicFolderPath =
      await localSongServices.pickMusicFolder();

  if (localMusicFolderPath == null) {
    print("No local folder selected.");
    return;
  }

  // Scan songs already on the computer
  final localSongPaths =
      await localSongServices.getSongsPath(
    localMusicFolderPath,
  );

  final localSongs =
      localSongServices.getSongs(localSongPaths);

  // Login once
  final client = await googleLogin();

  try {
    final drive = driveApi.DriveApi(client);

    // Get songs from Drive
    final cloudSongs =
        await getSongsFromGoogleDrive(drive);

    if (cloudSongs?.files == null) {
      print("No cloud songs found.");
      return;
    }

    // Compare cloud songs with local songs
    for (final cloudSong in cloudSongs!.files!) {
      final cloudSongName = cloudSong.name;

      if (cloudSongName == null) {
        continue;
      }

      // Already exists locally
      if (localSongs.contains(cloudSongName)) {
        print("Already exists: $cloudSongName");
        continue;
      }

      // Doesn't exist locally → download it
      await downloadSong(
        drive,
        cloudSong,
        localMusicFolderPath,
      );
    }
  } finally {
    client.close();
  }
}


// ========================
// TEST
// ========================

void main() async {
  await downloadSongs();
}