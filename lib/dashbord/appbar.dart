import 'package:arames_project/authentification/login.dart';
import 'package:flutter/material.dart';
import '../colors/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: navbar,
      elevation:4.0,
      leadingWidth: 150,
      leading: 
      
       Image.asset(
            'assets/images/logo.png',
            width: 60,
            height: 60,
                 ),
      actions: [
        IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.black,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        IconButton(
          icon: Icon(Icons.account_circle,color: Colors.black,),
         onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
          }
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
