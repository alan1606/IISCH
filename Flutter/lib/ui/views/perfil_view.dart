import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evaluaciones_web/services/navigation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../locator.dart';

class PerfilView extends StatefulWidget {

  const PerfilView({ Key? key }) : super(key: key);

  @override
  State<PerfilView> createState() => _PerfilViewState();
}

class _PerfilViewState extends State<PerfilView> {

  final formKey = GlobalKey<FormState>();
  TextEditingController controlPass = TextEditingController();

  String userName = '';
  String rol = '';

  bool hasRol = true;
  bool okValidator = false;

  List<String> claves = [];
  List<bool> listaSelect = [true,false];

  @override
  void initState() {
    super.initState();
    _recuperarDatos();
  }

  void _recuperarDatos() async{

    String ? nombreAux = '';
    int posicionAux = 0;
    Map<String,dynamic> calvesMap = {};
    
    await FirebaseFirestore.instance
    .collection('Claves')
    .doc('Acceso')
    .get()
    .then((DocumentSnapshot documentos) async {
      if(!documentos.exists){
      } else
      if(documentos.exists) {
        calvesMap = documentos.data() as Map<String, dynamic>;
        (calvesMap['Alumno'] != null) ? claves.add(calvesMap['Alumno']) : claves.add('');
        (calvesMap['D1'] != null)  ? claves.add(calvesMap['D1']) : claves.add('');
        (calvesMap['D2'] != null)  ? claves.add(calvesMap['D2']) : claves.add('');
        (calvesMap['D3'] != null)  ? claves.add(calvesMap['D3']) : claves.add('');
        (calvesMap['D4'] != null)  ? claves.add(calvesMap['D4']) : claves.add('');
        (calvesMap['D5'] != null)  ? claves.add(calvesMap['D5']) : claves.add('');
        (calvesMap['D6'] != null)  ? claves.add(calvesMap['D6']) : claves.add('');
        (calvesMap['D7'] != null)  ? claves.add(calvesMap['D7']) : claves.add('');
        (calvesMap['D8'] != null)  ? claves.add(calvesMap['D8']) : claves.add('');
        (calvesMap['D9'] != null)  ? claves.add(calvesMap['D9']) : claves.add('');
        (calvesMap['D10'] != null) ? claves.add(calvesMap['D10']) : claves.add('');
        (calvesMap['D11'] != null) ? claves.add(calvesMap['D11']) : claves.add('');
        (calvesMap['D12'] != null) ? claves.add(calvesMap['D12']) : claves.add('');
      }
    });

    if(FirebaseAuth.instance.currentUser != null){
      nombreAux = FirebaseAuth.instance.currentUser!.displayName;
      posicionAux = nombreAux!.indexOf('-');

      if(posicionAux != -1){
        hasRol = true;
        rol = nombreAux.substring(posicionAux + 1, nombreAux.length).trim();
        userName = nombreAux.substring(0, posicionAux).trim();
      } else {
        hasRol = false;
        userName = nombreAux;
      }
    }

    if(mounted){
      setState(() {});
    }

  }

  @override
  void dispose() {
    super.dispose();
    controlPass.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Form(
        key: formKey,
        child: _datos(context),
      ), 
    );
  }

  Widget _datos(context){
    return SingleChildScrollView(
      child: Container(
        color: const Color.fromRGBO(23, 32, 39, 1), 
        margin: const EdgeInsets.symmetric(horizontal: 80, vertical: 80),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          children: [
            const Text('Bienvenido', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 20),
            Text(
              hasRol ? '$rol: $userName' : userName, 
              style: const TextStyle(fontSize: 15, color: Color.fromRGBO(188, 194, 210, 1), fontWeight: FontWeight.normal)
            ),
            SizedBox(
              height: hasRol ? 0 : 310,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _textModel('Elije el tipo de usuario al que pertenece tu perfil.', false, 13),
                  const SizedBox(height: 20),
                  _botones(),
                  const SizedBox(height: 50),
                  _textModel('Para confirmar tu elección, ingresa la contraseña que te proporciono la institución.', false, 13),
                  const SizedBox(height: 15),
                  _formPass(),
                  const SizedBox(height: 15),
                  _botonVerificarPass(context),
                ]
              )
            ),
            const SizedBox(height: 50),
            _boton(context),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
  
  Widget _botones(){
    if(hasRol){
      return const SizedBox(height: 0);
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _modeloBoton('Alumno', 0),
          _modeloBoton('Maestro', 1),
        ]
      );
    }
  }

  Widget _modeloBoton(String titulo, int index){
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: (){
          if(index == 0){
            listaSelect = [true,false];
          } else
          if(index == 1){
            listaSelect = [false,true];
          }
          setState(() {});
        },
        child: Container(
          height: 30,
          width: 100,
          alignment: AlignmentDirectional.center,
          decoration: BoxDecoration(
            color: listaSelect[index] ? Colors.grey : Colors.grey.withOpacity(0.01),
            borderRadius: BorderRadius.circular(5)
          ),
          child: Text(titulo, style: TextStyle(color: listaSelect[index] ? Colors.white : Colors.grey))
        ),
      ),
    );
  }

  Widget _boton(context){
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          await FirebaseAuth.instance.signOut();
          locator<NavigationService>().navigateRemove('/cuenta'); 
        },
        child: Container(
          height: 40,
          alignment: AlignmentDirectional.center,
          width: 140,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(186, 66, 69, 1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Text('Cerrar sesión', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.normal))
        ),
      ),
    );
  }

  Widget _botonVerificarPass(context){
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: ()=> _vlidarPassRol(),
        child: Container(
          height: 40,
          alignment: AlignmentDirectional.center,
          width: 100,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(186, 66, 69, 0.8),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Text('Verificar', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.normal))
        ),
      ),
    );
  }

  
  void _vlidarPassRol() async {
    pruebaValidar();
    if((claves.indexWhere((mj) => mj.contains(controlPass.text)) != -1)){

      if((okValidator) && (mounted)){
        FocusScope.of(context).requestFocus(FocusNode());
        _esperarRegistro(context);
        try {

          int ubicAux = claves.indexWhere((mj) => mj.contains(controlPass.text));

          if(ubicAux == 0){
            rol = 'Alumno';
          } else 
          if(ubicAux == 1){
            rol = 'Docente 1';
          } else 
          if(ubicAux == 2){
            rol = 'Docente 2';
          } else 
          if(ubicAux == 3){
            rol = 'Docente 3';
          } else 
          if(ubicAux == 4){
            rol = 'Docente 4';
          } else 
          if(ubicAux == 5){
            rol = 'Docente 5';
          } else 
          if(ubicAux == 6){
            rol = 'Docente 6';
          } else 
          if(ubicAux == 7){
            rol = 'Docente 7';
          } else 
          if(ubicAux == 8){
            rol = 'Docente 8';
          } else 
          if(ubicAux == 9){
            rol = 'Docente 9';
          } else 
          if(ubicAux == 10){
            rol = 'Docente 10';
          } else 
          if(ubicAux == 11){
            rol = 'Docente 11';
          } else 
          if(ubicAux == 12){
            rol = 'Docente 12';
          }

          await FirebaseAuth.instance.currentUser!.updateDisplayName('$userName - $rol');
          await FirebaseAuth.instance.currentUser!.reload();
          Navigator.pop(context);
          _recuperarDatos();

        } on FirebaseAuthException catch (e) {
          Navigator.pop(context);
          if(mounted){
            switch(e.code){
              case "unknown":
                mostrarSnakbar("Verifica tu conexión a internet", 2500);
                break;
              default: mostrarSnakbar("Error", 1500);
            }
          }
        }
      }

    } else {
      mostrarSnakbar('Contraseña incorrecta', 1500);
    }

  }

  Widget _formPass(){
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Contraseña',
        errorStyle: const TextStyle(fontSize: 10),
        filled: true,
        fillColor: Colors.white,
        focusColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.only(left: 14.0, bottom: 10.0, top: 10.0),
      ),
      controller: controlPass,
      keyboardType: TextInputType.emailAddress,
      autovalidateMode: AutovalidateMode.disabled,
      style: const TextStyle(fontSize: 14),
      validator: (value){
        if (value!.isEmpty) {
          return 'Ingrese la contraseña';
        }
        else {
          return null;
        }
      },
    );
  }

  Widget _textModel(String contenido, bool negrita, double sizeFont){
    return Text(contenido, 
      style: TextStyle(
        fontSize: sizeFont,
        fontWeight: negrita ? FontWeight.bold : FontWeight.normal,
        color: Colors.white,
        overflow: TextOverflow.visible
      )
    );
  }
  
  void pruebaValidar() async {
    if(!formKey.currentState!.validate()){
      okValidator = false;
    } else {
      okValidator = true;
    }
  }

  void mostrarSnakbar (String mensaje, int duracion){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color.fromRGBO(186, 66, 69, 0.9),
        content: Text(mensaje),
        duration: Duration(milliseconds: duracion),
      ),
    );
  }

  void _esperarRegistro(BuildContext context){      
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white.withOpacity(0.001),
          elevation: 0,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              SizedBox(height: 15),
              SizedBox(
                height: 60,
                width: 60,
                child: CircularProgressIndicator()
              ),
              SizedBox(height: 18),
              Text('Guardando...',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 18),
            ]
          ),
        );
      }
    );
  }
}