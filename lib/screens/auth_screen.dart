import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/auth/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  void _submitAuthForm(String email, String password, String username,
      File image, bool isLogin, BuildContext ctx) async {
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        final authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        final authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        final refrence = FirebaseStorage.instance
            .ref()
            .child('images')
            .child(authResult.user.uid + '.jpg');

        await refrence.putFile(image).onComplete;
        final url = await refrence.getDownloadURL();
        await Firestore.instance
            .collection('users')
            .document(authResult.user.uid)
            .setData({
          'username': username,
          'email': email,
          'imageUrl': url,
        });
      }
    } on PlatformException catch (error) {
      var message = 'An error occured please check your credentials';
      if (error.message != null) {
        message = error.message;
      }
      Scaffold.of(ctx).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).errorColor,
        content: Text(message),
      ));
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      print(error);
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}
