import 'package:flutter/material.dart';
import 'package:kanban/screens/signup_screen.dart';

import 'homepage_screen.dart';

class LoginScreen extends StatelessWidget {
  Widget _buildPageContent(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          SizedBox(height: 40.0,),
          CircleAvatar(backgroundImage: NetworkImage('https://cdn.dribbble.com/users/540920/screenshots/2355118/trello.png'), maxRadius: 80, backgroundColor: Colors.transparent,),
          SizedBox(height: 10.0,),
          _buildLoginForm(context),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (BuildContext context) => SignupScreen()
                  ));
                },
                child: Text("Sign Up", style: TextStyle(color: Colors.blue, fontSize: 15.0)),
              )
            ],
          )
        ],
      ),
    );
  }

  Container _buildLoginForm(context) {
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
        primary: Colors.blueAccent, //background color of button
        side: BorderSide(width:3, color:Colors.blue.shade500), //border width and color
        elevation: 3, //elevation of button
        shape: RoundedRectangleBorder( //to set border radius to button
            borderRadius: BorderRadius.circular(30)
        ),
        padding: EdgeInsets.symmetric(horizontal: 36, vertical: 15),
    );
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Stack(
        children: <Widget>[
          ClipPath(
            child: Container(
              height: 400,
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 90.0,),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextField(
                        style: TextStyle(color: Colors.blue),
                        decoration: InputDecoration(
                            hintText: "Email address",
                            hintStyle: TextStyle(color: Colors.blue.shade200),
                            border: InputBorder.none,
                            icon: Icon(Icons.email, color: Colors.blue,)
                        ),
                      )
                  ),
                  Container(child: Divider(color: Colors.blue.shade400,), padding: EdgeInsets.only(left: 20.0,right: 20.0, bottom: 10.0),),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextField(
                        style: TextStyle(color: Colors.blue),
                        decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: TextStyle(color: Colors.blue.shade200),
                            border: InputBorder.none,
                            icon: Icon(Icons.lock, color: Colors.blue,)
                        ),
                      )
                  ),
                  Container(child: Divider(color: Colors.blue.shade400,), padding: EdgeInsets.only(left: 20.0,right: 20.0, bottom: 10.0),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(padding: EdgeInsets.only(right: 20.0),
                          child: Text("Forgot Password",
                            style: TextStyle(color: Colors.black45),
                          )
                      )
                    ],
                  ),
                  SizedBox(height: 10.0,),

                ],
              ),
            ),
          ),

          Container(
            height: 420,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (BuildContext context) => HomePage()
                  ));
                },
                child: Text("Login", style: TextStyle(color: Colors.white70)),
                style: raisedButtonStyle,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPageContent(context),
    );
  }
}