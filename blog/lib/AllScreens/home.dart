import 'package:blog/AllScreens/login.dart';
import 'package:blog/AllScreens/post_form.dart';
import 'package:blog/AllScreens/post_screen.dart';
import 'package:blog/AllScreens/profile.dart';
import 'package:blog/services/user_service.dart';

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  static const String idScreen = "Home";
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text('Blog App'),
          actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                logout().then((value) => {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => Login()),
                        (Route<dynamic> route) => false,
                      )
                    });
              },
            )
          ],
        ),
        body: currentIndex == 0 ? PostScreen() : Profile(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PostForm(
                          title: 'Add new Post',
                        )));
          },
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          height: 85,
          notchMargin: 8,
          elevation: 5,
          clipBehavior: Clip.antiAlias,
          shape: CircularNotchedRectangle(),
          child: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
            ],
            currentIndex: currentIndex,
            onTap: (val) {
              setState(() {
                currentIndex = val;
              });
            },
          ),
        ),
      ),
    );
  }
}
