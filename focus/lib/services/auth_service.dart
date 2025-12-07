import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AuthService extends ChangeNotifier{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? _currentUser;
  User?  get currentUser => _currentUser;

  AuthService(){
    _auth.authStateChanges().listen((user){ // listen for auth state changes
      _currentUser = user;
      notifyListeners();
    });
  }


  // sign up
  Future<String?>signUp({
    required String email,
    required String name,
    required String password,

  })async{
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User user = result.user!;

      // create user record in fire store
      await _db.collection("user").doc(user.uid).set({
        "uid": user,
        "name": name,
        "email": email,
        "create_at": FieldValue.serverTimestamp(),
        "lastactive": FieldValue.serverTimestamp(),

      });
      return null;
    } on FirebaseAuthException catch(e){
      return e.message; // return errer mesage
    }
  }

  Future<void> logout()async{
    await _auth.signOut();
  }
  bool get isLoggedIn => _currentUser != null; // checks is user is loged in

  Future<String?> login({
    required String password,
    required String email,

  }) async {
    try {


      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; 

    }on FirebaseAuthException catch(e){
      return e.message;
    }
  }

  Future<void> updateLastActive() async{
    if (_currentUser == null) return;
    await _db.collection("users").doc(_currentUser!.uid).update({
      "last active": FieldValue.serverTimestamp(),
    });
  }
}

