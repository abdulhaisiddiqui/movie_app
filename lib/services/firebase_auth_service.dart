import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/views/screens/Home/home_screen.dart';
import 'package:myapp/views/screens/Login_Signup/login_screen.dart';

class FirebaseAuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> signUp({required String username, required String email, required String password, required String cnfPassword, required BuildContext context,}) async {
    if (username.isEmpty || email.isEmpty || password.isEmpty || cnfPassword.isEmpty) {
      _showSnackBar(context, "All fields are required.");
      return;
    }

    if (!email.contains("@")) {
      _showSnackBar(context, "Please enter a valid email address.");
      return;
    }

    if (password.length < 6) {
      _showSnackBar(context, "Password must be at least 6 characters long.");
      return;
    }

    if (password != cnfPassword) {
      _showSnackBar(context, "Passwords do not match.");
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        "uid": userCredential.user!.uid,
        "username": username,
        "email": email,
        "createdAt": DateTime.now(),
      });

      _showSnackBar(context, "Signup successful!");
      Navigator.pop(context); // or navigate to Dashboard/HomeScreen
    } on FirebaseAuthException catch (e) {

      String errorMessage = "";

      switch (e.code) {
        case "email-already-in-use":
          errorMessage = "This email is already registered.";
          break;
        case "invalid-email":
          errorMessage = "Invalid email format.";
          break;
        case "weak-password":
          errorMessage = "Your password is too weak.";
          break;
        default:
          errorMessage = "Signup failed. Please try again.";
      }

      _showSnackBar(context, errorMessage);
    } catch (e) {
      _showSnackBar(context, "Something went wrong: $e");
    } finally {
      _isLoading = false;
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.message}"), backgroundColor: Colors.red),
      );
    } catch (e) {
      print("Login error: $e");
    }
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
