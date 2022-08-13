import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  final int duration;
  final Widget gotoPage;
  const SplashScreen({Key? key, required this.duration, required this.gotoPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: duration), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => gotoPage));
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Icon(
              Icons.military_tech,
              size: 100,
              color: Colors.green,
            ),
            SizedBox(height: 10),
            Text(
              'Image Recognizer',
              style: TextStyle(
                fontSize: 26,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
