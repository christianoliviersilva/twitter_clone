import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireflutter/Constants/constants.dart';
import 'package:fireflutter/Models/user_model.dart';
import 'package:fireflutter/Screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _fireStore = FirebaseFirestore.instance;

  static Future<bool> signUp(String name, String email, String password) async {
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User signedInUser = authResult.user;

      if (signedInUser != null) {
        _fireStore.collection('users').doc(signedInUser.uid).set({
          'name': name,
          'email': email,
          'profilePicture': '',
          'coverImage': '',
          'bio': ''
        });
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static void signOut(UserModel user) async {
    await _auth.signOut();
    user = null;
    // UserModel user = UserModel(
    //   id: UserModel().id,
    //     name: UserModel().name,
    //     profilePicture: UserModel().profilePicture,
    //     coverImage: UserModel().coverImage,
    //     bio: UserModel().bio,
    // );
  }
}
