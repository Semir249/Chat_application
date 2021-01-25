import 'dart:io';
import 'package:flutter/material.dart';
import '../image_picker/image_picker.dart';

class AuthForm extends StatefulWidget {
  final Function submitFunction;
  final bool isLoading;
  AuthForm(this.submitFunction, this.isLoading);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var isLogin = true;
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  File _pickedImage;

  void saveImage(File image) {
    _pickedImage = image;
  }

  void _submitForm() {
    final isValid = _formKey.currentState.validate();

    FocusScope.of(context).unfocus();

    if (_pickedImage == null && !isLogin) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Please provide an image')));
      return;
    }

    if (isValid) {
      _formKey.currentState.save();
      widget.submitFunction(_userEmail.trim(), _userPassword, _userName,
          _pickedImage, isLogin, context);
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (!isLogin) ImageInput(saveImage),
                  TextFormField(
                    autocorrect: false,
                    key: ValueKey('email'),
                    textCapitalization: TextCapitalization.none,
                    decoration: InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter an email';
                      }
                      if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userEmail = value;
                    },
                  ),
                  if (!isLogin)
                    AnimatedContainer(
                      duration: Duration(milliseconds: 400),
                      height: !isLogin ? 100 : 0,
                      child: TextFormField(
                        textCapitalization: TextCapitalization.words,
                        key: ValueKey('Username'),
                        decoration: InputDecoration(labelText: 'Username'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a username';
                          }
                          if (value.length < 4) {
                            return 'Username should be greater than three';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _userName = value;
                        },
                      ),
                    ),
                  TextFormField(
                    key: ValueKey('Password'),
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty || value.length < 6) {
                        return 'Password should be atleast 6 characters';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userPassword = value;
                    },
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    RaisedButton(
                      child: isLogin ? Text('Login') : Text('Signup'),
                      onPressed: _submitForm,
                    ),
                  if (!widget.isLoading)
                    FlatButton(
                      child: isLogin
                          ? Text('Create new account')
                          : Text('Already have an account'),
                      textColor: Theme.of(context).primaryColor,
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
