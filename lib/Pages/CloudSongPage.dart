import 'package:flutter/material.dart';

class cloudSongPage extends StatelessWidget {
  const cloudSongPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SongSync"),
        backgroundColor: Color.fromRGBO(9, 21, 31, 1),
        titleTextStyle: TextStyle(color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.only(left: 50, top: 20),
            title: Text("Song 1"),
            textColor: Colors.white,
          ),
        ],
      ),
      backgroundColor: Color.fromRGBO(9, 21, 31, 1),
    );
  }
}
