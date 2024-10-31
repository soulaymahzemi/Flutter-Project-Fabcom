import 'package:arames_project/colors/colors.dart';
import 'package:arames_project/dashbord/UapList.dart';
import 'package:flutter/material.dart';
import '../dashbord/appbar.dart';

class Ligne extends StatefulWidget {
  const Ligne({super.key});

  @override
  State<Ligne> createState() => _LigneState();
}

class _LigneState extends State<Ligne> {
  List<bool> _isListVisible1 = [false, false, false];

  void _toggleListVisibility(int index) {
    setState(() {
      _isListVisible1[index] = !_isListVisible1[index];
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: ListView(
        children: [
          _ListCard(
            title: 'TBS',
            subtitle: 'Ligne',
            imagePath: 'assets/images/mach.png',
            isListVisible: _isListVisible1[0],
            onToggleVisibility: () => _toggleListVisibility(0),
            contentwidget: TBScontent(),
          ),
          SizedBox(height: 10),
          _ListCard(
            title: 'SOVEMA1',
            subtitle: 'Ligne',
            imagePath: 'assets/images/mach.png',
            isListVisible: _isListVisible1[1],
            onToggleVisibility: () => _toggleListVisibility(1),
            contentwidget: Sovema1content()
          ),
          SizedBox(height: 10),
          _ListCard(
            title: 'SOVEMA2',
            subtitle: 'Ligne',
            imagePath: 'assets/images/mach.png',
            isListVisible: _isListVisible1[2],
            onToggleVisibility: () => _toggleListVisibility(2),
            contentwidget: Sovema2content()
          ),
        ],
      ),
    );
  }
    // card1
  Widget TBScontent(){
    return  Column(
                      children: [
                       fun2('OF | Progression d\'OF', 'assets/images/of.png'),
                       Container(
                        constraints: BoxConstraints(maxHeight: 400),
                         child: Uaplist(),
                       ),
                       fun2('KPI | Performance de l\'UAP', 'assets/images/iconKpi.webp'),
                       Container(

                       ),
                       fun2('Process | Paramètres process', 'assets/images/process.png')
                      ],
                    );
  }
  //card2
  Widget Sovema1content(){
    return  Column(
                      children: [
                       fun2('OF | Progression d\'OF', 'assets/images/of.png'),
                       Container(
                        constraints: BoxConstraints(maxHeight: 400),
                      
                       ),
                       fun2('KPI | Performance de l\'UAP', 'assets/images/iconKpi.webp'),
                       Container(

                       ),
                       fun2('Process | Paramètres process', 'assets/images/process.png')
                      ],
                    );
  }
  //card3
  Widget Sovema2content(){
    return  Column(
                      children: [
                       fun2('OF | Progression d\'OF', 'assets/images/of.png'),
                       Container(
                        constraints: BoxConstraints(maxHeight: 400),
                      
                       ),
                       fun2('KPI | Performance de l\'UAP', 'assets/images/iconKpi.webp'),
                       Container(

                       ),
                       fun2('Process | Paramètres process', 'assets/images/process.png')
                      ],
                    );
  }
//******************************* */
  Widget _ListCard({
    required String title,
    required String subtitle,
    required String imagePath,
    required bool isListVisible,
    required VoidCallback onToggleVisibility,
    required Widget contentwidget,

  }) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              color: green1,
              boxShadow: [
                BoxShadow(
                  color: shadowcolor,
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: ListTile(
              title: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: textcolor),
              ),
              subtitle: Text(
                subtitle,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: textcolor),
              ),
            ),
          ),
          Image.asset(imagePath),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Poste: Après-midi',
                      style: TextStyle(fontSize: 10),
                    ),
                    IconButton(
                      onPressed: onToggleVisibility,
                      icon: Icon(
                        isListVisible ? Icons.arrow_circle_up_rounded : Icons.arrow_circle_down_rounded,
                      ),
                    ),
                  ],
                ),
                if (isListVisible) contentwidget,
                    
                
              ],
            ),
          ),
        ],
      ),
    );
  }
//******************* */
    Widget fun2(String title, String pathimage) {
    return Container(
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
          Flexible(
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 18, color: textcolor, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        
          
          Image.asset(
            pathimage, width: 30,fit: BoxFit.contain,
        ),
        ],
      ),
    );
  }
}
