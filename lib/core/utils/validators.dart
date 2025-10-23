
// For Sign up
class Validators{
  static String? validatePassword(String username,String email,String password,String confirmPassword){
    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      return"All fields are required.";
    }

    if (!email.contains("@")) {
      return"Please enter a valid email address.";
    }
    if (password.length < 6) {
      return"Password must be at least 6 characters long.";
    }
    if(!password.contains(RegExp(r'[A-Z]'))){
      return"Password must contain at least one uppercase letter";
    }
    if(!password.contains(RegExp(r'[a-z]'))){
      return"Password must contain at least one lowercase letter";
    }
    if(!password.contains(RegExp(r'[0-9]'))){
      return"Password must contain at least one digit";
    }
    if(!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))){
      return"Password must contain at least one special character";
    }

    if (password != confirmPassword) {
      return"Passwords do not match.";
    }
    return null;
  }
}

// For Sign in
class SigninValidators {
  static String getErrorMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'user-not-found':
        return 'No account found for this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-credential':
        return 'Incorrect email or password. Please try again.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait and try again later.';
      case 'operation-not-allowed':
        return 'Email/password sign-in is not enabled.';
      default:
        return 'Authentication failed. Please check your credentials.';
    }
  }
}

