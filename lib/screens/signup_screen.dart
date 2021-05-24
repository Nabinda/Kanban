import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  Widget _buildPageContent(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          SizedBox(height: 30.0,),
          SizedBox(height: 20.0,),
          _buildLoginForm(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              FloatingActionButton(
                mini: true,
                onPressed: (){
                  Navigator.pop(context);
                },
                backgroundColor: Colors.blue,
                child: Icon(Icons.arrow_back),
              )
            ],
          )
        ],
      ),
    );
  }

  Container _buildLoginForm() {
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
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextField(
                        style: TextStyle(color: Colors.blue),
                        decoration: InputDecoration(
                            hintText: "Confirm password",
                            hintStyle: TextStyle(color: Colors.blue.shade200),
                            border: InputBorder.none,
                            icon: Icon(Icons.lock, color: Colors.blue,)
                        ),
                      )
                  ),
                  Container(child: Divider(color: Colors.blue.shade400,), padding: EdgeInsets.only(left: 20.0,right: 20.0, bottom: 10.0),),
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
                onPressed: (){},
                child: Text("Sign Up", style: TextStyle(color: Colors.white70)),
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