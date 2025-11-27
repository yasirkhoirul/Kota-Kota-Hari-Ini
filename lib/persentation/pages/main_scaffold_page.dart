import 'package:flutter/material.dart';
import 'package:kota_kota_hari_ini/persentation/pages/home_page.dart';
import 'package:kota_kota_hari_ini/widget/appbar.dart';

class MainScaffoldPage extends StatelessWidget{
  const MainScaffoldPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF446733),
      appBar: AppBar(
        flexibleSpace: Appbars(height: 200),   
      ),
      body: SafeArea(child: HomePage()),
    );
  }
}