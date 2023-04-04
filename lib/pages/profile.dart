import 'dart:convert';

import 'package:emi_app/components/details.dart';
import 'package:emi_app/pages/editprofile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../components/constant.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late SharedPreferences prefs;
  Map user = {};
  Map emi = {};
  bool haveEmi = false;

  Future getProfile() async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      final Uri url = Uri.parse("$api/profile");
      final http.Response reponse =
          await http.get(url, headers: {"token": token});

      var data = jsonDecode(reponse.body);
      print(data);
      if (reponse.statusCode == 200) {
        prefs.setString('user', jsonEncode(data));
        setState(() {
          user = data;
          if (data["active_emi"] != null) haveEmi = true;
        });
      }
    } catch (e) {
      mySnackBar(context, e.toString(), type: "error");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder: (context, _) {
              return [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Container(
                        // color: Color(0xFF01B1F6),
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(
                                      "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg.jpg"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                 Text(
                                  user["name"] ?? "Name",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF565656),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                 Text(user["email"] ?? "Email",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF565656),
                                    )),
                                const SizedBox(
                                  height: 5,
                                ),
                                 Text(user["phone"] ?? "Phone",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF565656),
                                    )),
                                const SizedBox(
                                  height: 5,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const EditProfile()));
                                  },
                                  child: const Text("Edit",
                                      style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      //Horizontal Scroll View
                    ],
                  ),
                ),
              ];
            },
            body: const Details()));
  }
}
