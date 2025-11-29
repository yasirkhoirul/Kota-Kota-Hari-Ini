import 'package:flutter/material.dart';

class Appbars extends StatelessWidget {
  const Appbars({super.key, required this.height,required this.ontaps});
  final double height;
  final void Function(int) ontaps;

  @override
  Widget build(BuildContext context) {
    final Widget spasi = SizedBox(width: 10,);
    return Container(
      color: Color(0xFF000000),
      height: height,
      padding: EdgeInsets.symmetric(horizontal: 22),
      child: Row(
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
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () {
                  ontaps(0);
                }, style: TextButton.styleFrom(
                  foregroundColor: Colors.white
                ),child: const Text("Home"),),
                spasi,
                TextButton(onPressed: () {
                  ontaps(1);
                }, style: TextButton.styleFrom(
                  foregroundColor: Colors.white
                ),child: const Text("About"),),
                spasi,
                TextButton(onPressed: () {}, style: TextButton.styleFrom(
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
      ),
    );
  }
}
