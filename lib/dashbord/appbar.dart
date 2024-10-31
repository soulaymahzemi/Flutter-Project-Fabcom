import 'package:flutter/material.dart';
import '../colors/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: navbar,
      elevation: 4.0,
      leading: 
         Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.contain,
          width: 40.0,
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
           
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
