import 'package:anonymy/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:anonymy/screens/Home.dart';
import 'package:anonymy/screens/register.dart';
import 'package:anonymy/services/user_service.dart';
import 'package:anonymy/models/api_response.dart';
import 'package:anonymy/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _loginUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Start showing the loading indicator
      });

      ApiResponse res = await login(_emailController.text, _passwordController.text);

      setState(() {
        _isLoading = false; // Hide the loading indicator
      });

      if (res.error == null) {
        _saveAndRedirect(res.data as User);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${res.error}'),
          ),
        );
      }
    }
  }

  void _saveAndRedirect(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    print(user.token);
    await pref.setString('token', user.token ?? '');
    await pref.setInt('user_id', user.id ?? 0);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const Home()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                'assets/images/paper-bg.jpg',
                fit: BoxFit.cover,
              ),
            ),
            // Main Content
            Container(
              color: Colors.transparent, // Make the container transparent
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'OpenBook',
                        style: TextStyle(
                          fontSize: 46.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Set text color to black
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey, // Set text color to black
                        ),
                      ),
                      SizedBox(height: 130.0),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'Email...',
                                labelStyle: TextStyle(color: Colors.grey, fontSize: 10),
                                prefixIcon: Icon(Icons.email, color: Colors.grey, size: 30,),
                                fillColor: Colors.white.withOpacity(0.4),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(color: Colors.transparent),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(color: Colors.transparent),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(color: Colors.transparent),
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.0),
                            TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password...',
                                labelStyle: TextStyle(color: Colors.grey, fontSize: 10),
                                prefixIcon: Icon(Icons.lock, color: Colors.grey, size: 30,),
                                fillColor: Colors.white.withOpacity(0.4),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(color: Colors.transparent),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(color: Colors.transparent),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(color: Colors.transparent),
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters long';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 24.0),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _loginUser,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 16.0,
                                  ),
                                ),
                                child: _isLoading
                                    ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                )
                                    : Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                      SizedBox(height: 150.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.0,
                            ),
                          ),
                          SizedBox(width: 8.0),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Register()),
                              );
                            },
                            child: Text(
                              "Create one",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}