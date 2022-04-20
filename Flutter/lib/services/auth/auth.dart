import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<String> get onAuthStateChanged => _firebaseAuth.authStateChanges().map(
    (User ? user) => user!.uid,
  );

  // GET UID
  Future<String> getCurrentUID() async {
    return (_firebaseAuth.currentUser)!.uid;
  }

  // GET CURRENT USER
  Future getCurrentUser() async {
    return _firebaseAuth.currentUser;
  }

  // Email & Password Sign Up
  Future<String> createUserWithEmailAndPassword(String email, String password, String name) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Update the username
    await updateUserName(name, authResult.user!);
    return authResult.user!.uid;

  }

  Future updateUserName(String name, User currentUser) async {
    // ignore: deprecated_member_use
    await currentUser.updateProfile(displayName: name);
    await currentUser.reload();
  }

  // Email & Password Sign In
  Future<String> signInWithEmailAndPassword(String email, String password) async {
    return (await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password)).user!.uid;
  }

  // Sign Out
  signOut() {
    return _firebaseAuth.signOut();
  }

  // Reset Password
  Future sendPasswordResetEmail(String email) async {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

}

class NameValidator {
  static String validate(String ? value) {
    if (value!.isEmpty) {
      return "Nombre obligatorio";
    }
    if (value.length < 2) {
      return "Ingrese nombre y apellidos completo";
    }
    if (value.length > 20) {
      return "El nombre no debe sobrepasar los 20 caracteres";
    }
    return '';
  }
}

class EmailValidator {
  static String validate(String ? value) {
    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return 'Formato de email incorrecto';
    } else {
      return '';
    }
  }
}

class PasswordValidator {
  static String validate(String ? value) {
    if (value!.isEmpty) {
      return 'Contraseña requerida';
    }
    return '';
  }
}

class PasswordValidatorRepit {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Password can't be empty";
    }
    return '';
  }
}