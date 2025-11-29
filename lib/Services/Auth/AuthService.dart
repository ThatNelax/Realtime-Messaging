import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

ValueNotifier<AuthService> authService = ValueNotifier(AuthService());   

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  User? get currentUser => firebaseAuth.currentUser;
  
  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();
  
  Future<UserCredential> signIn({required String email, required String password}) async {
    UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    firestore.collection("Users").doc(userCredential.user!.uid).set(
        {
          'uid': userCredential.user!.uid,
          'email': email,
        }
    );
    return userCredential;
  }
  
  Future<UserCredential> createAccount({required String email, required String password}) async{ 
    UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    firestore.collection("Users").doc(userCredential.user!.uid).set(
      {
        'uid': userCredential.user!.uid,
        'email': email,
      }
    );
    return userCredential;
  }
  
  Future<void> signOut() async { await firebaseAuth.signOut(); }
  
  
}