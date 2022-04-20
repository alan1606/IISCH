import 'package:evaluaciones_web/ui/views/login/bypass_login_view.dart';
import 'package:evaluaciones_web/ui/views/perfil_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginNoLogin extends StatelessWidget {

  const LoginNoLogin({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _loginOrNot();
  }

  Widget _loginOrNot(){
    if(FirebaseAuth.instance.currentUser == null){
      return const ByPassLogin();
    } else {
      return const PerfilView(); 
    }
  }
}