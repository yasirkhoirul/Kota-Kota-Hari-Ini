import 'package:flutter/material.dart';
import 'package:kota_kota_hari_ini/persentation/widget/frostglass.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Center(
      child: FrostedGlassScreen(width: 500, height: 500,),
    );
    
  }
}