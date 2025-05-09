import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kichukini/authScreen/auth_screen.dart';
import 'package:kichukini/mainScreen/home_screen.dart';
class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}


class _MySplashScreenState extends State<MySplashScreen> {

  splashScreenTimer()
 {
   Timer(const Duration(seconds: 4),() async
   {
    //user is already logged in
    if(FirebaseAuth.instance.currentUser!=null){
       Navigator.push(context, MaterialPageRoute(builder: (c)=>HomeScreen()));

    }
    else
    {
       Navigator.push(context, MaterialPageRoute(builder: (c)=>AuthScreen()));
    }


   

   });
 }
 @override
  void initState() //called automatically
   {
    // TODO: implement initState
    super.initState(); 

    splashScreenTimer();
  }

  @override
  Widget build(BuildContext context) {
    return  Material(
      child: Container(
         decoration:const BoxDecoration(
            gradient: LinearGradient(
              colors:[
                Colors.pinkAccent,
                Colors.purpleAccent,
              ],
              begin: FractionalOffset(0.0, 0.0),
              end:FractionalOffset(1.0, 0.0),
              stops: [0.0,1.0],
              tileMode: TileMode.clamp)
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(
                    "images/welcome.png"
                  ),
                ),

                const SizedBox(height: 10,),


                Text(
                  "KichuKini",
                  style: TextStyle(
                    fontSize: 30,
                    letterSpacing: 3,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            )
          ),
        ),
      
    );
  }
}