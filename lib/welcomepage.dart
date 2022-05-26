import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foody_guru/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'FoodyGuru',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: WelcomePage(),
    );
  }
}
class WelcomePage extends StatefulWidget{
  @override
  _WelcomePageState createState() => _WelcomePageState();
}
class _WelcomePageState extends State<WelcomePage>{
  late SharedPreferences logindata;
  late String userId = '';
  late Image bgImg ;

  @override
  void initState(){
    super.initState();
    initial_fun();
    bgImg=Image.asset("Images/qoute.png");
  }
  //Getting UserEmail From Shared Preference
  void initial_fun() async{
    logindata = await SharedPreferences.getInstance();
    setState(() {
      userId = logindata.getString('email').toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children:[ 
         Padding(
           padding: EdgeInsets.all(5.0),
           child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("Images/quote.png"), // <-- BACKGROUND IMAGE
                fit: BoxFit.fill,
              ),
            ),
                 ),
         ),
        
        Scaffold( backgroundColor: Colors.transparent, // <-- SCAFFOLD WITH TRANSPARENT BG
         appBar: AppBar(
          title: Text('Welcome To The DashBoard'),
        ),
        body:Column(
              children: [
                SizedBox(height: 10.0,),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0,5.0,0),
                  child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                    Align(
                    alignment: Alignment.topRight,
                    child: ElevatedButton(
                    onPressed: (){
                    logindata.setBool('login',true);
                     Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => LoginPage()));
                                  }, 
                     child: Text('LogOut'),
                        ),
                     ),
                      Text(
                       'Welcome $userId',
                       style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
                                     ),    
                           ],
                         ),
                       ),
                     ),
                
                   ],
                 ),
                 ),
              ],
        );      
       
  }
}