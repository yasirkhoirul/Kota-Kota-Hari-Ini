import 'package:flutter/material.dart';

class Drawercontent extends StatelessWidget {
  final Function(int) _gobranch;
  const Drawercontent(this._gobranch, {super.key});
  @override
  Widget build(BuildContext context) {
    final spasi = SizedBox(height: 10);
    return ListView(
      children: [
        ListTile(title: Text('Kota Kota Hari Ini')),
        Row(
          children: [
            TextButton(
              onPressed: () {
                _gobranch(0);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              child: const Text("Home"),
            ),
          ],
        ),
        spasi,
        Row(
          children: [
            TextButton(
              onPressed: () {
                _gobranch(3);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              child: const Text("About"),
            ),
          ],
        ),
        spasi,
        Row(
          children: [
            TextButton(
              onPressed: () {
                _gobranch(2);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              child: const Text("Kota"),
            ),
          ],
        ),
        spasi,
        Row(
          children: [
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              child: const Text("Contact"),
            ),
          ],
        ),
        spasi,
        Row(
          children: [
            IconButton(
              onPressed: () {
                _gobranch(1);
              },
              icon: Icon(Icons.person, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}
