
import 'package:flutter/material.dart';

import '../Services/LocalSongServices.dart';

class localSongPage extends StatefulWidget {
  const localSongPage({super.key});

  @override
  State<localSongPage> createState() => _localSongPageState();
}

class _localSongPageState extends State<localSongPage> {
  List<String> songs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SongSync"),
        backgroundColor: Color.fromRGBO(9, 21, 31, 1),
        titleTextStyle: TextStyle(color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white),
      ),

      backgroundColor: Color.fromRGBO(9, 21, 31, 1),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(18, 101, 191, 1),
        hoverColor: Color.fromRGBO(14, 80, 150, 1),
        mouseCursor: SystemMouseCursors.click,
        foregroundColor: Colors.white,
        child: Icon(Icons.folder),

        onPressed: () async {
          String? path = await pickMusicFolder();

          if (path == null) {
            print("The Path isn't found or something went wrong");
          } else {
            List<String> newSongs =
                getSongs(await getSongsPath(path));

            setState(() {
              songs = newSongs;
            });
          }
        },
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(songs[index]),
                  textColor: Colors.white,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}