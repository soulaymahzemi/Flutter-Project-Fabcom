import 'package:arames_project/dashbord/UapList.dart';
import 'package:arames_project/dashbord/ofList.dart';
import 'package:arames_project/dashbord/quantiteslist.dart';
import 'package:flutter/material.dart';
import 'package:arames_project/authentification/login.dart';
import 'package:arames_project/dashbord/appbar.dart';
import 'package:arames_project/Assemblage/Assemblagepage.dart';

import '../colors/colors.dart';
import 'eng.dart';
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool _islistvisible = false;

  void _toggleListVisibility() {
    setState(() {
      _islistvisible = !_islistvisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Card(
                elevation: 4,
                margin: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: shadowcolor,
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                          color: navbar,
                          boxShadow: [
                            BoxShadow(
                              color: shadowcolor,
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(
                            'Assemblage',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: textcolor),
                          ),
                          subtitle: Text(
                            'UAP',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: textcolor),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Ligne()),
                            );
                          },
                        ),
                      ),
                      Image.asset('assets/images/mach.png'),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: _toggleListVisibility,
                            icon: Icon(
                              _islistvisible
                                  ? Icons.arrow_circle_up_rounded
                                  : Icons.arrow_circle_down_rounded,
                            ),
                          ),
                        ],
                      ),
                      if (_islistvisible)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            children: [
                              fun1("KPI | Performance de l'UAP",'assets/images/iconKpi.webp'),

                              Container(
                                constraints: BoxConstraints(maxHeight: 400),
                                child: Uaplist(),
                              ),
                              
                              SizedBox(height: 10,),
                              fun1('OF | Running OFs', 'assets/images/of.png'),
                              Container(
                                constraints: BoxConstraints(maxHeight: 400),
                                child:OfSList() ,
                              ),
                               SizedBox(height: 10,),
                              fun1('Qté | Détail des quantités produites', 'assets/images/quantity.png'),
                              Container(
                                constraints: BoxConstraints(maxHeight: 400),
                                child:Quantiteslist() ,
                              ),
                               SizedBox(height: 10,),
                              fun1('Eng | Performance énergétique', 'assets/images/eng.png'),
                              Container(
                                constraints: BoxConstraints(maxHeight: 400),
                                child:Energielist() ,
                              ),
                              SizedBox(height: 10,),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget fun1(String title, String pathimage) {
    return Container(
      margin: EdgeInsets.all(2),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(230, 219, 219, 1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 18, color: textcolor, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Image.asset(pathimage, width: 30),
        ],
      ),
    );
  }
}
