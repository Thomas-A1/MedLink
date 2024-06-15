class MFirebaseException implements Exception {
  final String code;

  MFirebaseException(this.code);

  String get message {
    switch (code) {
      case 'unknown':
        return 'An unknown Firebase error occured. Please try again!';
      case 'user-diabled':
        return 'The user acccount has been disabled';
      case 'user-not-found':
        return 'No user found for tthe given email or UID';
      case 'invalid-email':
        return 'The email address provided is invalid. Please enter a valid email';
      case 'email-already-in-use':
        return 'The email address is already registered. Please usee a different email';
      case 'wrong-password':
        return 'Incorrect password. Please check your password and try again';
      case 'weak-password':
        return 'The password is too weak. Please choose a stronger password';
      default:
        return 'An unexpected Firebase error occured. Please try again';
    }
  }
}
