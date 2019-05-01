import 'package:flutter/material.dart';
import 'singup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
//Google provider
import 'package:google_sign_in/google_sign_in.dart';
import 'homepage.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'phonelogin.dart';
//Facebook provider
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email;
  String _password;

//google sign in

  final GoogleSignIn _googleSignIn = GoogleSignIn();
FirebaseAuth _auth=FirebaseAuth.instance;
//Facebook sign in
  FacebookLogin fbLogin = new FacebookLogin();

 Future<String> _testSignInWithGoogle() async {

    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user = await _auth.signInWithCredential(credential);
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return 'signInWithGoogle succeeded: $user ';
    
  }

 
DecorationImage _buildBackgroundImage() {
    return DecorationImage(fit: BoxFit.cover,
        colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
      image: AssetImage(
        'images/waterfall.jpg',
      ),


    );
  }
 
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Center(
      child: Container(
        decoration: BoxDecoration(
          image: _buildBackgroundImage(),
    ),
          padding: EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                  decoration: InputDecoration(hintText: 'Email'),
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  }),
              SizedBox(height: 15.0),
              TextField(
                decoration: InputDecoration(hintText: 'Password'),
                onChanged: (value) {
                  setState(() {
                    _password = value;
                  });
                },
                obscureText: true,
              ),
              SizedBox(height: 20.0),
              RaisedButton(
                child: Text('Login'),
                color: Colors.blue,
                textColor: Colors.white,
                elevation: 7.0,
                onPressed: () {
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: _email, password: _password)
                      .then((FirebaseUser user) {
                    Navigator.of(context).push(MaterialPageRoute<Null>(
                        builder: (BuildContext context) {
                      return new DashboardPage();
                    }));
                  }).catchError((e) {
                    print(_email);
                    print(_password);
                    print(e);
                  });
                },
              ),
              SizedBox(height: 15.0),
             FacebookSignInButton(
              
                onPressed: () {
                  fbLogin.logInWithReadPermissions(
                      ['email', 'public_profile']).then((result) {
                    switch (result.status) {
                      case FacebookLoginStatus.loggedIn:
                      
                      FacebookAccessToken myToken = result.accessToken;
      AuthCredential credential =
          FacebookAuthProvider.getCredential(accessToken: myToken.token);

                        FirebaseAuth.instance
                            .signInWithCredential(
                                credential)
                            .then((signedInUser) {
                          print('Signed in as ${signedInUser.displayName}');
                          
                           Navigator.of(context).push(MaterialPageRoute<Null>(
                        builder: (BuildContext context) {
                      return new DashboardPage();
                    }));
                        }).catchError((e) {
                          print(e);
                        });
                        break;
                      case FacebookLoginStatus.cancelledByUser:
                        print('Cancelled by you');
                        break;
                      case FacebookLoginStatus.error:
                        print('Error');
                        break;
                    }
                  }).catchError((e) {
                    print(e);
                  });
                }
              ),
              SizedBox(height: 15.0),
              GoogleSignInButton(
               
                onPressed: () {
                  _testSignInWithGoogle();
                },
              ),
              SizedBox(height: 15.0),
              Text('Don\'t have an account?'),
              SizedBox(height: 10.0),
              RaisedButton(
                child: Text('Sign Up'),
                color: Colors.blue,
                textColor: Colors.white,
                elevation: 7.0,
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute<Null>(builder: (BuildContext context) {
                    return new AuthPage();
                  }));
                },
              ),
             
               SizedBox(height: 10.0),
              RaisedButton(
                child: Text('login with phone number'),
                color: Colors.blue,
                textColor: Colors.white,
                elevation: 7.0,
                onPressed: () {
                   Navigator.of(context).push(
                      MaterialPageRoute<Null>(builder: (BuildContext context) {
                    return new MyHomePage();
                  }));
                },
              ),
            ],
          )),
    ));
  }
}
