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
  @override
  void initState(){
    super.initState();
    initial_fun();
  }
  void initial_fun() async{
    logindata = await SharedPreferences.getInstance();
    setState(() {
      userId = logindata.getString('email').toString();
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome To The DashBoard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(26.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Welcome $userId',
                style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: (){
                logindata.setBool('login',true);
              Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => LoginPage()));
            }, 
            child: Text('LogOut'),
            ),
          ],
        )
      ),
    );
  }
}