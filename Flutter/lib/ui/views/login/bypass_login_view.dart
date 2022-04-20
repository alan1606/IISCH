import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:evaluaciones_web/ui/views/login/nueva_cuenta_view.dart';
import 'package:evaluaciones_web/ui/views/login/recuperar_pass_view.dart';
import 'package:evaluaciones_web/providers/variables_globales.dart';
import 'package:evaluaciones_web/ui/views/login/login_view.dart';

class ByPassLogin extends StatelessWidget {

  const ByPassLogin({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final modeloDatos = Provider.of<VariablesGlobalesProvider>(context);

    if(modeloDatos.posicionLogin == 0){
      return const LoginView();
    } else
    if(modeloDatos.posicionLogin == 1){
      return const RegistroPage();
    } else {
      return const RecuperarPassView();
    }
  }
}