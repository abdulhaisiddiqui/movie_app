import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/core/utils/validators.dart';
import 'package:myapp/models/signup_model.dart';
import 'package:myapp/views/screens/Home/home_screen.dart';
import 'package:myapp/views/screens/Login_Signup/login_screen.dart';
import 'package:myapp/core/utils/validators.dart';

import '../core/errors/firebase_error_mapper.dart';

class FirebaseAuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value){
    _isLoading = value;
    notifyListeners();
  }

  Future<void> signUp({required String username, required String email, required String password, required String cnfPassword, required BuildContext context,}) async {
    final passwordError = Validators.validatePassword(username, email, password, cnfPassword);

    if(passwordError != null){
      _showSnackBar(context, passwordError);
      return;
    }

    isLoading = true;


    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
SignupModel signupModel =SignupModel(username: username, email: email, password: password, cnfPassword: cnfPassword);
      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        "uid": userCredential.user!.uid,
        "username": signupModel.username,
        "email": signupModel.email,
        "createdAt": DateTime.now(),
      });

      _showSnackBar(context, "Signup successful!");
      Navigator.pop(context); // or navigate to Dashboard/HomeScreen
    } on FirebaseAuthException catch (e) {

      final errorMessage = FirebaseErrorMapper.getMessage(e.code);

      _showSnackBar(context, errorMessage);
    } catch (e) {
      _showSnackBar(context, "Something went wrong: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signIn(BuildContext context, String email, String password) async {

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar(context, 'All fields are required!');
      return;
    }

    try {
      UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      final user = userCredential.user!;
      await _firestore.collection('users').doc(user.uid).set({
        'email': email,
        'lastLogin': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
      _showSnackBar(context, 'Login in Successfully.');
    } on FirebaseAuthException catch (e) {
      final errorMessage = SigninValidators.getErrorMessage(e.code);

        _showSnackBar(context, errorMessage);
      isLoading = true;

    } catch (e) {
      print("Login error: $e");
    }
    isLoading = false;
  }

  Future<void> logout(BuildContext context) async {
    try {
      await _auth.signOut();

      _showSnackBar(context, "Logout Successfully");

     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));

      notifyListeners();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Color(0xFFC60077),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
