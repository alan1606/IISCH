import 'package:evaluaciones_web/providers/variables_globales.dart';
import 'package:evaluaciones_web/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../locator.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class LoginView extends StatefulWidget {

  const LoginView({ Key? key }) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  
  // final prefs = PreferenciasUsuario();
  // final notificaciones = NotificacionesProvider();

  final _controlEmail = TextEditingController();
  final _controlPassw = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool okValidator = false;
  bool verPass1 = true;

  @override
  void dispose() {
    super.dispose();
    _controlEmail.dispose();
    _controlPassw.dispose();
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
      child: Row(
        children: [
          Container(
            width: (MediaQuery.of(context).size.width >= 450) ? 450 : MediaQuery.of(context).size.width,
            alignment: AlignmentDirectional.center,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            child: Column(
              children: [
                const SizedBox(height: 70),
                const Text('Bienvenido', style: TextStyle(fontSize: 20, color: Color.fromRGBO(188, 194, 210, 1))),
                const SizedBox(height: 30),
                _formCorreo(),
                const SizedBox(height: 30),
                _formPass(),
                const SizedBox(height: 30),
                _botonRestablecerPass(),
                const SizedBox(height: 30),
                _boton(context),
                const SizedBox(height: 15),
                _crearCuenta(context),
                const SizedBox(height: 30),
                _redesSociales(),
                const SizedBox(height: 30),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: (MediaQuery.of(context).size.width >= 500) ? MediaQuery.of(context).size.width : 0,
              height: MediaQuery.of(context).size.height,
              color: Colors.cyan,
              child: Image.asset(
                'assets/jpg/image_slide_a.jpeg',
                fit: BoxFit.cover,  
              )
            )
          )
        ],
      ),
    );
  }

  Widget _redesSociales(){
    return SizedBox(
      width: 200,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _modeloIcono('assets/svg/Icono_What.svg', 'https://api.whatsapp.com/send?phone=+5216271484552'),
              _modeloIcono('assets/svg/Icono_Facebook.svg', 'https://es-la.facebook.com/IISCH/'),
              _modeloIcono('assets/svg/Icono_Maps.svg', 'https://www.google.com/maps/place/Instituto+de+Investigaciones+Sociales+de+Chihuahua/@26.935698,-105.667954,16z/data=!4m5!3m4!1s0x0:0xf895178426e10c6d!8m2!3d26.9356979!4d-105.6679538?hl=es-ES'),
              _modeloIcono('assets/svg/Icono_Mail.svg', ''),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Contactanos en cualquiera de nuestras redes sociales', 
            style: TextStyle(color: Colors.black, fontSize: 12),
            textAlign: TextAlign.center
          )
        ],
      ),
    );
  }

  Widget _modeloIcono(String pathImage, String url){
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: (){
          if(url.isNotEmpty){
            html.window.open(url,'_blank');
          } else {
            Clipboard.setData(const ClipboardData(text: 'iisch@outlook.com.mx'));
            mostrarSnakbar('Email copiado al portapapeles.', 1500);
          }
        },
        child: SvgPicture.asset(
          pathImage,
          height: 20,
        ),
      ),
    );
  }

  void mostrarSnakbar(String mensaje, int duracion){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color.fromRGBO(186, 66, 69, 0.9),
        content: Text(mensaje),
        duration: Duration(milliseconds: duracion),
      ),
    );
  }

  Widget _botonRestablecerPass(){
    final modeloDatos = Provider.of<VariablesGlobalesProvider>(context, listen: false);
    return Row(
      children: [
        const Expanded(child: SizedBox()),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: (){
              modeloDatos.posicionLogin = 3;        
            },
            child: const Text('Olvidaste la contraseña', style: TextStyle(fontSize: 12, color: Color.fromRGBO(188, 194, 210, 1)))
          ),
        ),
      ],
    );
  }

  Widget _formCorreo(){
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Email',
        errorStyle: const TextStyle(fontSize: 10),
        filled: true,
        fillColor: Colors.white,
        focusColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.only(left: 14.0, bottom: 10.0, top: 10.0),
      ),
      controller: _controlEmail,
      keyboardType: TextInputType.emailAddress,
      autovalidateMode: AutovalidateMode.disabled,
      style: const TextStyle(fontSize: 14),
      validator: (value){
        String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regex = RegExp(pattern);
        if (!regex.hasMatch(value!)) {
          return 'Formato de correo incorrecto.';
        }
        else {
          return null;
        }
      },
    );
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
        suffixIcon: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: (){
              if(verPass1 == true){
                verPass1 = false;
                setState(() {});
              } else
              if(verPass1 == false){
                verPass1 = true;
                setState(() {});
              }
            },
            child: Icon(Icons.remove_red_eye, 
              color: verPass1 ? Colors.grey : const Color.fromRGBO(186, 66, 69, 1), 
              size: 20
            )
          ),
        )
      ),
      controller: _controlPassw,
      keyboardType: TextInputType.streetAddress,
      autovalidateMode: AutovalidateMode.disabled,
      obscureText: verPass1,
      style: const TextStyle(fontSize: 14),
      validator: (value){
        if(value!.length < 5) {
          return 'Ingreses su contraseña.';
        }
        else {
          return null;
        }
      },
    );
  }

  Widget _boton(context){
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: ()=> ingresarLogin(),
        child: Container(
          height: 45,
          width: 150,
          alignment: AlignmentDirectional.center,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(186, 66, 69, 1), 
            borderRadius: BorderRadius.circular(25),
          ),
          child: const Text('Ingresar', style: TextStyle(color: Colors.white, fontSize: 15))
        ),
      ),
    );
  }
  
  void pruebaValidar() async {
    if(!formKey.currentState!.validate()){
      okValidator = false;
    } else {
      okValidator = true;
    }
  }

  void ingresarLogin() async {
    final modeloDatos = Provider.of<VariablesGlobalesProvider>(context, listen: false);
    pruebaValidar();
    if((okValidator) && (mounted)){
      FocusScope.of(context).requestFocus(FocusNode());
      _ventanaRegistrando(context);
      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _controlEmail.text,
          password: _controlPassw.text
        );
        userCredential.user!.uid;
        
        Navigator.pop(context);
        modeloDatos.ubicacionRuta = 'inicio';
        locator<NavigationService>().navigateRemove('/inicio');

      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        if(mounted){
          switch(e.code){
            case "unknown":
              mostrarSnakbar("Verifica tu conexión a internet", 2500);
              break;
            case "user-not-found":
              mostrarSnakbar("Usuario no encontrado, verifique sus datos.", 2500);
              break;
            case "wrong-password":
              mostrarSnakbar("Contraseña incorrecta", 1500);
              break;
            default: mostrarSnakbar("Error desconocido", 1500);
          }
        }
      }
    }
  }

  void _ventanaRegistrando(BuildContext context){      
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: const Text ('Sesión',style: TextStyle(fontSize: 17, color: Color.fromRGBO(8, 129, 200, 1), fontWeight: FontWeight.w400)),
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
              Text('Iniciando sesión...',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 18),
            ]
          ),
        );
      }
    );
  }

  Widget _crearCuenta(context){
    final modeloDatos = Provider.of<VariablesGlobalesProvider>(context, listen: false);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: (){
          modeloDatos.posicionLogin = 1;     
        },
        child: SizedBox(
          child: Center(
            child: RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'No tienes cuenta? ',
                    style: TextStyle(color: Color.fromRGBO(188, 194, 210, 1), fontSize: 15)
                  ),TextSpan(
                    text: 'Registrate',
                    style: TextStyle(color: Colors.grey.shade900, fontWeight: FontWeight.normal, fontSize: 15)
                  ),
                ]
              )
            ),
          ),
        ),
      ),
    );
  }
}