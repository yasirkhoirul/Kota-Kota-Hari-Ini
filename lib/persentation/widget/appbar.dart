import 'package:flutter/material.dart';

class Appbars extends StatefulWidget {
  const Appbars({super.key, required this.height,required this.ontaps});
  final double height;
  final void Function(int) ontaps;

  @override
  State<Appbars> createState() => _AppbarsState();
}

class _AppbarsState extends State<Appbars> {
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
              Icon(Icons.menu,color: Colors.white,)
              :Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () {
                      widget.ontaps(0);
                    }, style: TextButton.styleFrom(
                      foregroundColor: Colors.white
                    ),child: const Text("Home"),),
                    spasi,
                    TextButton(onPressed: () {
                      widget.ontaps(1);
                    }, style: TextButton.styleFrom(
                      foregroundColor: Colors.white
                    ),child: const Text("About"),),
                    spasi,
                    TextButton(onPressed: () {
                      widget.ontaps(2);
                    }, style: TextButton.styleFrom(
                      foregroundColor: Colors.white
                    ),child: const Text("Kota"),),
                    spasi,
                    TextButton(onPressed: () {}, style: TextButton.styleFrom(
                      foregroundColor: Colors.white
                    ),child: const Text("Contact"),),
                    spasi,
                    IconButton(onPressed: () {}, icon: Icon(Icons.person,color: Colors.white,)),
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
