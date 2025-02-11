import 'package:arames_project/authentification/login.dart';
import 'package:arames_project/colors/colors.dart';
import 'package:arames_project/dashbord/homepage.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 220,
            decoration: BoxDecoration(
              color: navbar,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_circle_outlined,
                  size: 100,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildCustomDivider(),
                  ListTile(
                    leading: Icon(Icons.dashboard, color: Colors.black),
                    title: Text(
                      'Dashboard',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Homepage()));
                    },
                  ),
                  _buildCustomDivider(),
                  ListTile(
                    leading: Icon(Icons.logout, color: Colors.black),
                    title: Text('Déconnexion',
                        style: TextStyle(fontSize: 18, color: Colors.black)),
                    onTap: () {
                      Navigator.pop(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                  ),
                  _buildCustomDivider(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomDivider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      height: 2,
      color: Colors.grey[300],
    );
  }
}
