import 'dart:async';
import 'dart:convert';

import 'package:emi_app/components/constant.dart';
import 'package:emi_app/pages/Splash.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late SharedPreferences prefs;
  bool loading = false;

  Future handleLogin() async {
    setState(() {
      loading = true;
    });
    try {
      prefs = await SharedPreferences.getInstance();
      String email = _emailController.text;
      String password = _passwordController.text;
      final Uri url = Uri.parse("$api/login");
      final response = await http.post(url,
          body: jsonEncode(<String, String>{
            "email": email.toString(),
            "password": password.toString(),
          }),
          headers: <String, String>{
            'Content-Type': 'application/json',
          });
      var data = jsonDecode(response.body);

      if (!mounted) return;
      if (response.statusCode == 200) {
        prefs.setString('token', data['token']);
        prefs.setString('user', jsonEncode(data['user']));
        mySnackBar(context, data["message"], type: "success");
        Timer(const Duration(seconds: 2), () {
          Navigator.pushReplacementNamed(context, '/home');
        });
      } else {
        mySnackBar(context, data["message"], type: "warning");
      }
    } catch (err) {
      mySnackBar(context, err.toString(), type: "error");
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  bool ischecking = true;

  checkLogin() async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      final Uri url = Uri.parse("$api/login/check");

      final http.Response response =
          await http.get(url, headers: <String, String>{"token": token});

      var data = jsonDecode(response.body);
      // print(data);

      if (response.statusCode == 200 && data["user"]["role"] == "user") {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        ischecking = false;
      });
    }
  }

  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ischecking
        ? const SplashScreen()
        : Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        "Login Now !!",
                        style: GoogleFonts.poppins(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 50),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: primaryAccent),
                        child: TextField(
                          controller: _emailController,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 56, 56, 56),
                              fontSize: 18),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Email',
                            hintStyle: TextStyle(
                                color: Color.fromARGB(255, 97, 97, 97),
                                fontSize: 18),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: primaryAccent),
                        child: TextField(
                          obscureText: true,
                          controller: _passwordController,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 56, 56, 56),
                              fontSize: 18),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Password',
                            hintStyle: TextStyle(
                                color: Color.fromARGB(255, 97, 97, 97),
                                fontSize: 18),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (!loading) handleLogin();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: primaryColor),
                          child: loading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                  color: Colors.white,
                                ))
                              : const Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      //     const Text(
                      //       "Don't have an account ?",
                      //       style: TextStyle(color: Colors.grey, fontSize: 16),
                      //     ),
                      //     TextButton(
                      //       onPressed: () {
                      //         Navigator.pushNamed(context, '/signup');
                      //       },
                      //       child: const Text(
                      //         "Sign Up",
                      //         style: TextStyle(
                      //           color: Color.fromARGB(255, 56, 56, 56),
                      //           fontSize: 18,
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // )
                    ]),
              ),
            ),
          );
  }
}
