// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'welcomePage.dart';

void main() => runApp(MyApp());
class MyApp extends StatelessWidget{
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'FOODYGURU',
      theme: ThemeData(
        primarySwatch: Colors.orange
      ),
      home: LoginPage(),
    );

  }
}
class LoginPage extends StatefulWidget{
  _LoginPageState createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage>{
//Controllers for  :- Login
final email_controller = TextEditingController();
final password_controller= TextEditingController();
//Controllers for :-Reset Password Email Verification
final email_controller2 = TextEditingController();
//Controllers for  :- Reset Password Password Update
final newPassword_controller = TextEditingController();
final re_newPassword_controller = TextEditingController();

late SharedPreferences logindata;
late bool isLoggedIn = false;
//For hiding forgot password link
late bool isVisibile = true;
final _formKey = GlobalKey<FormState>();
String username = '';

void initState(){
  super.initState();
   autoLogin();
}


//Checking if user logout or not before leaving the app;
void autoLogin() async{
  logindata = await SharedPreferences.getInstance();
  if(logindata.getString('email')==null){
  logindata.setString('email',"abc@def.com");
  }
  if(logindata.getString('password')==null){
    logindata.setString('password',"123456");
  }
  bool userid = logindata.getBool('login') ?? true;
  if(!userid){
    Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=> WelcomePage()));
  }
  // if(userId!=null){setState(() {
  //    isLoggedIn=true;
  //   name=userId;
  // });
  //  return;
  }


  //Setting visibility and contents of textfield for form2
  void setVisibility(){
    setState(() {
      username=email_controller.text;
      isVisibile=false;
      email_controller2.text=username;
    });
  }


@override
void dispose(){
  email_controller.dispose();
  password_controller.dispose();
  super.dispose();
}


@override
Widget build(BuildContext context){
  return Scaffold(
    appBar: AppBar(
      title: Text(
        "FoodGuru Login"
      ),
    ),
    body: Center(

      //Form1
      child: Form(
         key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Visibility(
          visible: isVisibile,
          child: Column(children: [
            SizedBox(height: 50.0,),
          Text("Login Form",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),

          //Email TextField
          Padding(padding: const EdgeInsets.all(15.0),
          child: SizedBox(
            width: 300.0,
            child: TextFormField(
              controller: email_controller,
              decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'email',
              ),

              //Email Validation
              validator: (value) {
                if(value==null || value.isEmpty){
                  return '*Mandatory Field';
                } 
                bool emailvalid=RegExp( r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(email_controller.text);
                   print(emailvalid);
                   if(emailvalid==false){
                    return '*Enter Correct Email Address';
                  }
                  if(logindata.getString('email')!=value){
                    return "Invalid email";
                  }
              return null;
              },
            ),
          ),
          ),

          //Password TextField For Form1
              Padding(padding: const EdgeInsets.all(15.0),
              child: SizedBox(
          width: 300.0,
          child: TextFormField(
              obscureText: true,
              controller: password_controller,
              decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'password',
              ),

              // Password Validation
              validator: (value) {
                print(logindata.getString('password'));

                 if(value==null || value.isEmpty){
                  return '*Mandatory Field';
                }           
                 if(logindata.getString('password')!=value){
                  return "Incorrect Password";
                }       
              return null;
              },
            ),
              ),
              ),

              ElevatedButton(onPressed:(){ 
          if(_formKey.currentState!.validate()){
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Logging In..')),
            );

            //Setting user as LoggedIn Storage
            logindata.setBool('login', false);
                print(logindata.getString('password'));
            
             //Navigating To Welcome Page
            Navigator.push(context, MaterialPageRoute(builder: (context)=> WelcomePage()));
          
          }
              }, child: Text("Log-In"),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    Text("Does Not Have Account?"),
              TextButton(onPressed: (){ setVisibility();}, child: Text('Forgot Password')),
                ],
              )
              ],    
              ),
        ),
      Visibility(
        visible: !isVisibile,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 50.0,),
          Text("Forgot Password ",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),

          //Email Verification For Form1 Reset Password
          Padding(padding: const EdgeInsets.all(15.0),
          child: SizedBox(
            width: 300.0,
            child: TextFormField(
              controller: email_controller2,
              decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'email',
              ),
              //Email Validation
              validator: (value) {
                if(value==null || value.isEmpty){
                  return '*Mandatory Field';
                } 
                bool emailvalid=RegExp( r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(email_controller2.text);
                if(logindata.getString('email')!=value){
                  return "Invalid email";
                }   
                   print(emailvalid);
                   if(emailvalid==false){
                    return '*Enter Correct Email Address';
                  }
              return null;
              },
            ),
          ),
          ),
        ElevatedButton(onPressed:(){ 
          if(_formKey.currentState!.validate()){
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(content: Text('A reset password mail has been sent')),
            // );

            //Dialog Box For Updating Password
            showDialog(context: context, builder: (context){
              return Visibility(
                visible: !isVisibile,
                child: Dialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                elevation: 16,
                child: Container(
                  child:Column(children: [
                          SizedBox(height: 50.0,),
                        Text("Reset Password",
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        //New Password Field
                        Padding(padding: const EdgeInsets.all(15.0),
                        child: SizedBox(
                          width: 300.0,
                          child: TextFormField(
                 obscureText: true,
                controller: newPassword_controller,
                decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'New Password',
                ),
                validator: (value) {
                  if(value==null || value.isEmpty){
                    return '*Mandatory Field';
                  } 
                 
                return  null;
                },
                          ),
                        ),
                        ),

                        //Re-Enter New Password Field
                Padding(padding: const EdgeInsets.all(15.0),
                child: SizedBox(
                        width: 300.0,
                        child: TextFormField(
                obscureText: true,
                controller: re_newPassword_controller,
                decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Re-Type New Password',
                ),
                //Re-Enter New Password Field Validation
                validator: (value) {
                   if(value==null || value.isEmpty){
                    return '*Mandatory Field';
                  }      
                  if(re_newPassword_controller.text!=newPassword_controller.text){
                    return 'Re-Type New Password is incorrect';
                  }            
                return null;
                },
                          ),
                ),
                ),
                ElevatedButton(onPressed:(){ 
                        if(_formKey.currentState!.validate()){
                         
                        
                        
                        String new_password = newPassword_controller.text;
                         Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password Updated Successfully!!')),
                          );
                          print(logindata.getString('password'));

                          //Updating Password
                          setState(() {
                           isVisibile=true;
                           logindata.setString("password",new_password);
                         });
                          // Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage()));
                          
                          
                        }
                }, child: Text("Update Password"),
                ),
                ],    
                ),
                ),
                ),
              ); 
              });
          }
        }, child: Text("Submit"),
        ),
        //For Going Back To Login Page
        ElevatedButton(onPressed: () {
           setState(() {
             isVisibile=true;
           });
        }, child: Text("Back"),)
        ],    
        ),
      )
      ]
      ),
      ),
    ),
  ); 
}
}