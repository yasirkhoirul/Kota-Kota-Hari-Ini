import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kota_kota_hari_ini/persentation/widget/frostglass.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  final _formkey = GlobalKey<FormState>();
  final _urcontroller = TextEditingController();
  final _pwcontroller = TextEditingController();
  bool? ismobile;
  bool needscrollview = false;
  bool statehide = true;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 900),
    );
    animation = Tween<double>(begin: 0, end: 100).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    _urcontroller.dispose();
    _pwcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: Colors.white),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withAlpha(51),
                  Colors.black.withAlpha(256),
                ],
                begin: AlignmentGeometry.bottomCenter,
                end: AlignmentGeometry.topCenter,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: Image.asset("assets/image/kotlam.png", fit: BoxFit.fitWidth),
        ),
        LayoutBuilder(
          builder: (context,constrian) {
            if (constrian.maxWidth>800) {
              ismobile = false;
            }else{
              ismobile = true;
            }
            if (constrian.maxHeight < 800){
              needscrollview = true;
            }else{
              needscrollview = false;
            }
            return Center(
              child: SingleChildScrollView(
                child: FrostedGlassScreen(
                  width: ismobile! ? 400 : 800,
                  height: needscrollview ? 800 : MediaQuery.of(context).size.height *0.8,
                  child: Padding(
                    padding: const EdgeInsets.all(50),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 20,
                        children: [
                          AnimatedBuilder(
                            animation: animation,
                            builder: (context, child) {
                              return CircleAvatar(
                                backgroundColor: Color(0xFF474747),
                                radius: 5 + animation.value,
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: animation.value,
                                ),
                              );
                            },
                          ),
                          Text(
                            "LOGIN",
                            style: GoogleFonts.robotoFlex(
                              color: Color(0xFF474747),
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          BoxInput(
                            lead: 'USERNAME',
                            icon: Icon(Icons.person),
                            controller: _urcontroller,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "email tidak boleh kosong";
                              }
                              return null;
                            },
                            obsecure: false,
                          ),
                          BoxInput(
                            lead: 'PASSWORD',
                            icon: IconButton(
                              onPressed: () {
                                setState(() {
                                  statehide = !statehide;
                                });
                              },
                              icon: Icon(
                                statehide ? Icons.visibility : Icons.visibility_off,
                              ),
                            ),
                            controller: _pwcontroller,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "pw tidak boleh kosong";
                              }
                              if (value.length < 8) {
                                return "pw tidak boleh kurang dari 8";
                              }
                              return null;
                            },
                            obsecure: statehide,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF474747), // warna latar belakang
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                
                              if (_formkey.currentState!.validate()) {
                                print("yee");
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Center(
                                child: Text(
                                  "Login",
                                  style: GoogleFonts.robotoFlex(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        ),
      ],
    );
  }
}

class BoxInput extends StatelessWidget {
  final String lead;
  final Widget icon;
  final TextEditingController controller;
  final FormFieldValidator<String> validator;
  final bool obsecure;
  const BoxInput({
    super.key,
    required this.lead,
    required this.icon,
    required this.obsecure,
    required this.controller,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obsecure,
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.white),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        suffixIcon: icon,
        suffixIconColor: Colors.white,
        label: Text(
          lead,
          style: GoogleFonts.robotoFlex(
            fontWeight: FontWeight.w300,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
