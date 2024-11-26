// custom_drawer.dart
import 'package:arames_project/authentification/login.dart';
import 'package:arames_project/colors/colors.dart';
import 'package:arames_project/dashbord/homepage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: navbar,
            ),
            child: Icon(
              Icons.account_circle_outlined,
              size:100,
              )
          ),
         
       
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async {
            final prefs=await SharedPreferences.getInstance();
            await prefs.clear();
            Navigator.pushAndRemoveUntil(context,
             MaterialPageRoute(builder: (context)=>Login()), (Route)=>false);


            },
          ),
        ],
      ),
    );
  }
}
