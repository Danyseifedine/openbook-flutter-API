import 'package:flutter/material.dart';
import 'package:anonymy/screens/Home.dart';
import 'package:anonymy/screens/login.dart';
import 'package:anonymy/services/user_service.dart';
import 'package:anonymy/models/api_response.dart';
import 'package:anonymy/constant/constant.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutSine,
      ),
    );

    // Delay execution of _loadUserInfo() for 5 seconds (changed from 50 seconds for testing)
    Future.delayed(const Duration(seconds: 5), () {
      _loadUserInfo();
    });
  }

  void _loadUserInfo() async {
    String token = await getToken();
    print(token);
    if (token == '') {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Login()),
            (route) => false,
      );
    } else {
      ApiResponse response = await getUser();
      if (response.error == null) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Home()),
              (route) => false,
        );
      } else if (response.error == unauthorized) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Login()),
              (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${response.error}'),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated icon with rotation transition
            RotationTransition(
              turns: _animation,
              child: Icon(
                Icons.menu_book,
                color: Colors.black,
                size: 48.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
