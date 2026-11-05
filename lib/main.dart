import 'package:flutter/material.dart';

import 'Pages/LocalSongPage.dart';
import 'Pages/CloudSongPage.dart';

void main() => runApp(const SongSync());

class SongSync extends StatelessWidget {
  const SongSync({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SongSync',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(9, 21, 31, 1),

      appBar: AppBar(
        title: Text("SongSync"),
        backgroundColor: Color.fromRGBO(9, 21, 31, 1),
        titleTextStyle: TextStyle(color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white),
      ),

      drawer: Drawer(
        backgroundColor: Color.fromRGBO(22, 51, 74, 1),

        child: Column(
          children: [
            SizedBox(height: 30),

            ListTile(
              title: Text("Local Songs"),
              titleTextStyle: TextStyle(color: Colors.white),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const localSongPage(),
                  ),
                );
              },
            ),

            ListTile(
              title: Text("Cloud Songs"),
              titleTextStyle: TextStyle(
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const cloudSongPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}