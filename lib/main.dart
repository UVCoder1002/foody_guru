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

  //Checking If The Person Has Logout Or Not
   autoLogin();

   //Initialising Image Variables and Caching It To Avoid Flickering
    cardFront = Image.asset("Images/foody_guru_logo.png");
    cardBack  = Image.asset("Images/fodd_time.png");
    WidgetsBinding.instance!.addPostFrameCallback((_) {precacheImage(cardFront.image, context);precacheImage(cardBack.image, context); 
    });

    // Initialize the animation controller
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 4000), value: 0);
     controller.forward();

     //Adding Listener To Controller To Make Animation In Loop
    controller.addListener(() {
      if(controller.isCompleted||controller.isDismissed){
        flipImage();
      }
    
    });
}

String? email_validation(String? value) {
   if(value==null || value.isEmpty){
                  return '*Mandatory Field';
                } 
                bool emailvalid=RegExp( r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(value);
                   print(emailvalid);
                   if(emailvalid==false){
                    return '*Enter Correct Email Address';
                  }
                  if(logindata.getString('email')!=value){
                    return "Invalid email";
                  }
              return null;
}
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
  }


 bool isFrontImage(double angle){
    final degree90 = Math.pi/2;
    final degree270 = 3*Math.pi/2;
    return angle<=degree90 || angle>=degree270;
  }

Future flipImage() async{
  showFront = !showFront;
    if(!showFront){
     controller.reverse();
    }
    else{
 controller.forward();
  }
}

  //Setting visibility and contents of textfield in form
  void setVisibility(){
    setState(() {
      username=email_controller.text;
      isVisibile=false;
      email_controller2.text=username;
    });
  }

//Dispose When Not In Use!!
@override
void dispose(){
  email_controller.dispose();
  password_controller.dispose();
  email_controller2.dispose();
  newPassword_controller.dispose();
  re_newPassword_controller.dispose();
  controller.dispose();
  super.dispose();
}


@override
Widget build(BuildContext context){
  return Scaffold(
    resizeToAvoidBottomInset: false,
    appBar: AppBar(
      title: Text(
        "FoodGuru"
      ),
    ),
    body: Center(
    
      //Form
      child: Form(
         key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
            children: [

      //Logo Animation: ROtation Along Y Axis
         AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              double angle = controller.value * -Math.pi;
        final transform = Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(angle);
              return Transform(
                transform: transform,
                alignment: Alignment.center,
                //
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


          //Login Form                
        Visibility(
          visible: isVisibile,
          child: Column(children: [
            SizedBox(height: 50.0,),
          Text("Login",
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
                return email_validation(value);
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
           FocusScope.of(context).unfocus();
          
          //Validating Form Fields
          if(_formKey.currentState!.validate()){
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(backgroundColor: Colors.orange,
               padding: EdgeInsets.all(15.0),
                   behavior: SnackBarBehavior.floating,
               duration: const Duration(milliseconds: 2000),content: Text('Logging In..')),
            );
           
            //Setting user as LoggedIn In Storage
            logindata.setBool('login', false);
                print(logindata.getString('password'));
            
             //Navigating To Welcome Page
          Future.delayed(const Duration(seconds: 2), (){       
                 Navigator.push(context, MaterialPageRoute(builder: (context)=> WelcomePage()));
});
          }
              }, child: Text("Log-In"),
              ),

              //Forgot Password Section
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
        
          //Email Verification For Form Reset Password
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
               return email_validation(value);
              },
            ),
          ),
          ),
        ElevatedButton(onPressed:(){ 
          if(_formKey.currentState!.validate()){
  
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

                  //Validating New Password Field
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

                  //Update Password Button
                  ElevatedButton(onPressed:(){ 
                          if(_resetKey.currentState!.validate()){
                          String new_password = newPassword_controller.text;
                           Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(backgroundColor: Colors.orange,
               padding: EdgeInsets.all(15.0),
                   behavior: SnackBarBehavior.floating,content: Text('Password Updated Successfully!!')),
                            );
                
                            //Updating Password
                            setState(() {
                             isVisibile=true;
                             logindata.setString("password",new_password);
                           });                            
                            
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