import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/auth_user_cubit.dart';

class Appbaradmin extends StatefulWidget {
  const Appbaradmin({super.key, required this.height,required this.ontaps, required this.drawetaps});
  final double height;
  final void Function(int) ontaps;
  final void Function() drawetaps;

  @override
  State<Appbaradmin> createState() => _AppbaradminState();
}

class _AppbaradminState extends State<Appbaradmin> {
  late bool ismobile;
  @override
  Widget build(BuildContext context) {
    final Widget spasi = SizedBox(width: 10,);
    return Container(
      color: Color(0xFF000000),
      height: widget.height,
      padding: EdgeInsets.symmetric(horizontal: 22),
      child: LayoutBuilder(
        builder: (context,constrain) {
          if (constrain.maxWidth>800) {
            ismobile = false;
          }else{
            ismobile = true;
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text("logo",style: TextStyle(fontWeight: FontWeight.bold),),
                    const Text("kota kota hari ini",style: TextStyle(color: Colors.white),),
                  ],
                ),
              ),
              

              ismobile?
              IconButton(onPressed: widget.drawetaps, icon: Icon(Icons.menu,color: Colors.white,))
              :Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    
                    TextButton(onPressed: () {
                      widget.ontaps(4);
                    }, style: TextButton.styleFrom(
                      foregroundColor: Colors.white
                    ),child: const Text("Upload"),),
                    spasi,
                    IconButton(onPressed: () {
                      context.read<AuthUserCubit>().gologout();
                    }, icon: Icon(Icons.logout,color: Colors.white,)),
                  ],
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}



