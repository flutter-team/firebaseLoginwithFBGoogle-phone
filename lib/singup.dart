import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  final Map<String, dynamic> _formData = {
    'email': '',
    'password': '',
    'acceptTerms': false
  };
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  DecorationImage _buildBackgroundImage() {
    return DecorationImage(fit: BoxFit.cover,
        colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.1), BlendMode.dstATop),
      image: AssetImage(
        'images/waterfall.jpg',
      ),


    );
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'E-mail',
          icon: Icon(Icons.person),
          filled: true,
          fillColor: Colors.blueGrey[200]),
      onSaved: (String value) {
        _formData['email'] = value;
      },
      validator: (value) {
        if (value.isEmpty ||
            !RegExp(r'^\w+([-_.]*)@\w{5,6}\.\w{3,4}$').hasMatch(value)) {
          return 'Please enter a valid email';
        }
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Password',
          icon: Icon(Icons.lock),
          filled: true,
          fillColor: Colors.blueGrey[200]), controller: _passwordController,
      onSaved: (String value) {
        _formData['password'] = value;
      },
      validator: (value) {
        if (value.isEmpty || value.length < 6) {
          return 'Please enter valid password';
        }
      },
    );
  }

  Widget _buildConfirmPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Confirm Password',
          icon: Icon(Icons.lock),
          filled: true,
          fillColor: Colors.blueGrey[200]),
      obscureText: true,

      validator: (String value) {
        if (_passwordController.text != value) {
          return 'password dont match';
        }
      },
    );
  }

  Widget _buildAcceptTerms() {
    return SwitchListTile(
      value: _formData['acceptTerms'],
      onChanged: (bool value) {
        setState(() {
          _formData['acceptTerms'] = value;
        });
      },
      title: Text('Accept Terms'),
    );
  }
  Future<String> createUserWithEmailAndPassword(String email, String password) async {
    final FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    return user?.uid;
  }


  void _submitForm() async {
    
    if (!_formKey.currentState.validate() || !_formData['acceptTerms']) {
      return;
    }
    _formKey.currentState.save();
    createUserWithEmailAndPassword(_formData['email'], _formData['password']);
    Navigator.pop(context);
    }
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final targetWidth = deviceWidth > 768.0 ? 500.0 : deviceWidth * .8;
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
          decoration: BoxDecoration(
          image: _buildBackgroundImage(),
    ),
    padding: EdgeInsets.all(20.0),
    child: Form(
    key: _formKey,
    child: Container(
    alignment: Alignment.center,
    child: SingleChildScrollView(
    child: Container(
    width: targetWidth,
    child: Column(children: <Widget>[
    _buildEmailTextField(),
    SizedBox(
    height: 10.0,
    ),
    _buildPasswordTextField(),
    SizedBox(
    height: 10.0,
    ),
    _buildConfirmPasswordTextField(),
    _buildAcceptTerms(),
    SizedBox(
    height: 10.0,
    ),
    RaisedButton(child: Text('sign Up'),onPressed:(){
  _submitForm();
    }
    ,),
    ]
  )
    )
    )
    )
    )
    )
    )
    );
  }}