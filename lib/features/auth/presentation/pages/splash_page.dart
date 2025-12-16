import 'package:flutter/material.dart';
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height/2,
        width: MediaQuery.of(context).size.width-20,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/auth_image.png" ),fit: BoxFit.cover)
        ),      
      ),
    );
  }
}