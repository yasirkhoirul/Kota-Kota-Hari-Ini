import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/auth_user_cubit.dart';

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
                Navigator.pop(context);
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
                Navigator.pop(context);
                _gobranch(3);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              child: const Text("Contact"),
            ),
          ],
        ),
        spasi,
        Row(
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
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
              onPressed: () {
                Navigator.pop(context);
                _gobranch(4);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              child: const Text("About"),
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
class DrawercontentAdmin extends StatelessWidget {
  final Function(int) _gobranch;
  const DrawercontentAdmin(this._gobranch, {super.key});
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
                Navigator.pop(context);
                _gobranch(0);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              child: const Text("Upload"),
            ),
          ],
        ),
        spasi,
        Row(
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _gobranch(1);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              child: const Text("List Kota"),
            ),
          ],
        ),
        spasi,
        Row(
          children: [
            IconButton(onPressed: () {
                      context.read<AuthUserCubit>().gologout();
                    }, icon: Icon(Icons.logout,color: Colors.white,)),
          ],
        ),
      ],
    );
  }
}
