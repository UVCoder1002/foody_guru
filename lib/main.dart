// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'welcomepage.dart';
import 'dart:math' as Math;

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
class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin{ 
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
final _resetKey = GlobalKey<FormState>();

String username = '';

int val=0;

  late Image cardFront;
  late Image cardBack;
  bool showFront = true;
  late AnimationController controller;
  double anglePlus=0;

void initState(){
  super.initState();
  // email_controller.addListener(validate_email());
  // password_controller.addListener();
  // email_controller2.addListener();
  // newPassword_controller.addListener();
  // re_newPassword_controller.addListener();
   autoLogin();
    cardFront = Image.asset("Images/foody_guru_logo.png");
    cardBack  = Image.asset("Images/fodd_time.png");
    WidgetsBinding.instance!.addPostFrameCallback((_) {precacheImage(cardFront.image, context);precacheImage(cardBack.image, context); 
    });
    // Initialize the animation controller
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 4000), value: 0);
     controller.forward();
    controller.addListener(() {
      if(controller.isCompleted||controller.isDismissed){
        flipImage();
      }
    
    });
}

// String? get _errorText_newpassword {
//   String value = newPassword_controller.text;
// if(value==null || value.isEmpty){
//                     return '*Mandatory Field';
//                   } 
//   String value2=re_newPassword_controller.text;
//   if(value2==null || value2.isEmpty){
//                     return '*Mandatory Field';
//                   }      
//                   print(value + value2 + "");
//                   if(!identical(value,value)){
//                     return 'Re-Type New Password is incorrect';
//                   }            
//                 return null;
                 
// }
// String? validate_email(){
//  _formKey.currentState.validate();
// }
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


 bool isFrontImage(double angle){
    final degree90 = Math.pi/2;
    final degree270 = 3*Math.pi/2;
    return angle<=degree90 || angle>=degree270;
  }
Future flipImage() async{
//  controller.addListener(() {
  // if(controller.isCompleted){

    showFront = !showFront;
    if(!showFront){
     controller.reverse();
      
  }
  // if(controller.isDismissed){
    else{
 controller.forward();

  }
//  });             
  
    // await controller.reverse();
    // controller.repeat();
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
  controller.dispose();
  super.dispose();
}


@override
Widget build(BuildContext context){
  
  return Scaffold(
    resizeToAvoidBottomInset: false,
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
         AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              double angle = controller.value * -Math.pi;
              // if(showFront) angle += anglePlus; 
        final transform = Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(angle);
              return Transform(
                transform: transform,
                alignment: Alignment.center,
                child: isFrontImage(angle.abs())?Transform(
                  transform: transform,
                  alignment: Alignment.center,              
                  child: Container(
                    height: 105.0,
                    margin: EdgeInsets.only(top: 20),
                    alignment: Alignment.center,
                    child: cardFront,
                  ),
                ):Transform(
                  transform: transform,
                  alignment: Alignment.center,              
                  child: Container(
                    height: 105.0,
                    margin: EdgeInsets.only(top: 20),
                    alignment: Alignment.center,
                    child: cardBack,
                  ),
                ),
              );
            },
          ),                    
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
              // onChanged: (text) {
              //     _formKey.currentState!.validate();
              // },
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
            // onChanged: (Text){
            //   _formKey.currentState!.validate();
        
            // },
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
                            //  flipImage();
        FocusScope.of(context).unfocus();

          if(_formKey.currentState!.validate()){
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(backgroundColor: Colors.orange,
               padding: EdgeInsets.all(15.0),
                   behavior: SnackBarBehavior.floating,
               duration: const Duration(milliseconds: 2000),content: Text('Logging In..')),
            );
           
            //Setting user as LoggedIn Storage
            logindata.setBool('login', false);
                print(logindata.getString('password'));
            
             //Navigating To Welcome Page
          Future.delayed(const Duration(seconds: 2), (){       
                 Navigator.push(context, MaterialPageRoute(builder: (context)=> WelcomePage()));
});
          }
              }, child: Text("Log-In"),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
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
              return Form(
                key: _resetKey,
                child: Visibility(
                  visible: !isVisibile,
                  child: Dialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                  elevation: 16,
                  child: Container(
                    height: MediaQuery.of(context).size.height-400,
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
                    // errorText: _errorText_newpassword,
                     if(value==null || value.isEmpty){
                      return '*Mandatory Field';
                    }      
                    print(re_newPassword_controller.text +" " + newPassword_controller.text + "");
                    if(re_newPassword_controller.text!=newPassword_controller.text){
                      return 'Re-Type New Password is incorrect';
                    }            
                  return null;
                  },
                            ),
                  ),
                  ),
                  ElevatedButton(onPressed:(){ 
                          if(_resetKey.currentState!.validate()){
                            // if(_errorText_newpassword==null){
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