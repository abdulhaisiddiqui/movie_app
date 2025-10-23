class FirebaseErrorMapper {
  static String getMessage(String code) {
    switch (code) {
      case "email-already-in-use":
        return "This email is already registered.";
      case "invalid-email":
        return "Invalid email format.";
      case "weak-password":
        return "Your password is too weak.";
      case "user-not-found":
        return "No user found with this email.";
      case "wrong-password":
        return "Incorrect password.";
      default:
        return "Signup failed. Please try again.";
    }
  }
}
