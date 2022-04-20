import 'package:evaluaciones_web/providers/variables_globales.dart';
import 'package:evaluaciones_web/services/navigation_service.dart';
import 'package:evaluaciones_web/ui/shared/custom_flat_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../locator.dart';

// ignore: avoid_web_libraries_in_flutter, unused_import
import 'dart:html' as html;

class CustomAppMenu extends StatelessWidget {

  const CustomAppMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return _TableDesktopMenu();

  }
}

class _TableDesktopMenu extends StatefulWidget {
  @override
  State<_TableDesktopMenu> createState() => _TableDesktopMenuState();
}

class _TableDesktopMenuState extends State<_TableDesktopMenu> {

  List<bool> activarButton = [true, false, false];
  bool maestro = false;
  bool rolSelect = false;
  bool login = false;

  List<bool> activoBotonesMaestro = [true, false, false, false];
  String url = '';

  @override
  void initState() {
    super.initState();
    _recupreraUsuario();
  }

  void _recupreraUsuario(){
    
    String ? dataUser = '';

    if(FirebaseAuth.instance.currentUser != null){

      login = true;
      dataUser = FirebaseAuth.instance.currentUser!.displayName;

      if(dataUser!.contains('Alumno')){
        rolSelect = true;
        maestro = false;
      } else
      if(dataUser.contains('Docente')){
        rolSelect = true;
        maestro = true;
      } else {
        rolSelect = false;
        maestro = false;
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    double size = MediaQuery.of(context).size.width;
    final modeloDatos = Provider.of<VariablesGlobalesProvider>(context);

    if(size >= 450){
      return Container(
        padding: const EdgeInsets.symmetric( horizontal: 10, vertical: 10 ),
        margin: const EdgeInsets.symmetric( horizontal: 20, vertical: 10 ),
        width: MediaQuery.of(context).size.width,
        height: 55,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(23, 32, 39, 0.5),
          borderRadius: BorderRadius.circular(15)
        ),
        child: _futureUser(),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric( horizontal: 10, vertical: 10 ),
        margin: const EdgeInsets.symmetric( horizontal: 20, vertical: 10 ),
        width: (modeloDatos.mostrarMenu) ? 125 : 60,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(23, 32, 39, 0.5),
          borderRadius: BorderRadius.circular(15)
        ),
        child: _futureUser(),
      );
    }
  }

  Widget _futureUser(){

    double size = MediaQuery.of(context).size.width;
    final modeloDatos = Provider.of<VariablesGlobalesProvider>(context);

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){  
        if(snapshot.hasData){
          if(snapshot.data != null){

            late String dataUser = '';
            String ? ususario = FirebaseAuth.instance.currentUser!.displayName;
            if(ususario != null){
              dataUser = FirebaseAuth.instance.currentUser!.displayName!;
            }

            if(dataUser.contains('Alumno')){
              if(size >= 450){
                return Row(children: listAlumno(true));
              } else {
                if(modeloDatos.mostrarMenu){
                  return SizedBox(
                    height: 150,
                    child: Column(
                      children: listAlumno(true)
                    ),
                  );
                } else {
                  return _logo(); 
                }
              }
            } else
            if(dataUser.contains('Docente') | dataUser.contains('Maestro')){
              if(size >= 450){
                return Row(children: listMaestro(true));
              } else {
                if(modeloDatos.mostrarMenu){
                  return SizedBox(
                    height: 180,
                    child: Column(
                      children: listMaestro(true)
                    ),
                  );
                } else {
                  return _logo(); 
                }
              }
            } else {
              if(size >= 450){
                return Row(children: listNoLogin(true));
              } else {
                if(modeloDatos.mostrarMenu){
                  return SizedBox(
                    height: 105,
                    child: Column(
                      children: listNoLogin(true),
                    )
                  );
                } else {
                  return _logo(); 
                }
              }
            }
          } else {
            if(size >= 450){
              return Row(children: listNoLogin(true));
            } else {
              if(modeloDatos.mostrarMenu){
                return SizedBox(
                  height: 105,
                  child: Column(
                    children: listNoLogin(true),
                  )
                );
              } else {
                return _logo(); 
              }
            }
          }
        }else{
          if(size >= 450){
            return Row(children: listNoLogin(true));
          } else {
            if(modeloDatos.mostrarMenu){
              return SizedBox(
                height: 105,
                child: Column(
                  children: listNoLogin(true)
                ),
              );
            } else {
              return _logo(); 
            }
          }
        }
      }      
    );
  }

  List<Widget> listMaestro(bool escritorio){
    final modeloDatos = Provider.of<VariablesGlobalesProvider>(context);
    return [
      Row(
        children: [
          _logo(),
        ],
      ),
      (escritorio) ? const SizedBox(height: 15) : const SizedBox(height: 0),
      (escritorio) ? const Spacer() : const SizedBox(width: 0),
      CustomFlatButton(
        text: 'Inicio',
        onPressed: (){
          modeloDatos.ubicacionRuta = 'inicio';
          locator<NavigationService>().navigateTo('/inicio');
          modeloDatos.mostrarMenu = false;
        },
        color: (modeloDatos.ubicacionRuta == 'inicio') ? const Color.fromARGB(255, 53, 116, 250) : Colors.transparent,
      ),

      const SizedBox(width: 10),
      CustomFlatButton(
        text: 'Evaluaciones',
        onPressed: (){
          modeloDatos.ubicacionRuta = 'evaluaciones';
          locator<NavigationService>().navigateTo('/evaluaciones');
          modeloDatos.mostrarMenu = false;
        },
        color:(modeloDatos.ubicacionRuta == 'evaluaciones') ? const Color.fromARGB(255, 53, 116, 250) : Colors.transparent,
      ),

      const SizedBox(width: 10),
      CustomFlatButton(
        text: 'Resultados',
        onPressed: (){
          modeloDatos.ubicacionRuta = 'resultados';
          locator<NavigationService>().navigateTo('/resultados');
          modeloDatos.mostrarMenu = false;
        },
        color: (modeloDatos.ubicacionRuta == 'resultados') ? const Color.fromARGB(255, 53, 116, 250) : Colors.transparent,
      ),

      const SizedBox(width: 10),
      CustomFlatButton(
        text: 'Perfil',
        onPressed: (){
          modeloDatos.ubicacionRuta = 'cuenta';
          locator<NavigationService>().navigateTo('/cuenta');
          modeloDatos.mostrarMenu = false;
        },
        color: (modeloDatos.ubicacionRuta == 'cuenta') ? const Color.fromARGB(255, 53, 116, 250) : Colors.transparent,
      ),
    ];
  }

  List<Widget> listAlumno(bool escritorio){
    final modeloDatos = Provider.of<VariablesGlobalesProvider>(context);
    return [
      Row(
        children: [
          _logo(),
        ],
      ),
      (escritorio) ? const SizedBox(height: 15) : const SizedBox(height: 0),
      (escritorio) ? const Spacer() : const SizedBox(width: 0),
      CustomFlatButton(
        text: 'Inicio',
        onPressed: (){
          modeloDatos.ubicacionRuta = 'inicio';
          locator<NavigationService>().navigateTo('/inicio');
          modeloDatos.mostrarMenu = false;
        },
        color: (modeloDatos.ubicacionRuta == 'inicio') ? const Color.fromARGB(255, 53, 116, 250) : Colors.transparent,
      ),

      const SizedBox(width: 10),
      CustomFlatButton(
        text: 'Evaluaciones',
        onPressed: (){
          modeloDatos.ubicacionRuta = 'evaluaciones';
          locator<NavigationService>().navigateTo('/evaluaciones');
          modeloDatos.mostrarMenu = false;
        },
        color: (modeloDatos.ubicacionRuta == 'evaluaciones') ? const Color.fromARGB(255, 53, 116, 250) : Colors.transparent,
      ),

      const SizedBox(width: 10),
      CustomFlatButton(
        text: 'Perfil',
        onPressed: (){
          modeloDatos.ubicacionRuta = 'cuenta';
          locator<NavigationService>().navigateTo('/cuenta');
          modeloDatos.mostrarMenu = false;
        },
        color: (modeloDatos.ubicacionRuta == 'cuenta') ? const Color.fromARGB(255, 53, 116, 250) : Colors.transparent,
      ),
    ];
  }

  List<Widget> listNoLogin(bool escritorio){
    final modeloDatos = Provider.of<VariablesGlobalesProvider>(context);
    return [
      Row(
        children: [
          _logo(),
        ],
      ),
      (escritorio) ? const SizedBox(height: 5) : const SizedBox(height: 0),
      (escritorio) ? const Spacer() : const SizedBox(width: 0),
      CustomFlatButton(
        text: 'Inicio',
        onPressed: (){
          modeloDatos.ubicacionRuta = 'inicio';
          locator<NavigationService>().navigateTo('/inicio');
          modeloDatos.mostrarMenu = false;
        },
        color: (modeloDatos.ubicacionRuta == 'inicio') ? const Color.fromARGB(255, 53, 116, 250) : Colors.transparent,
      ),
      CustomFlatButton(
        text: 'Perfil',
        onPressed: (){
          modeloDatos.ubicacionRuta = 'cuenta';
          locator<NavigationService>().navigateTo('/cuenta');
          modeloDatos.mostrarMenu = false;
        },
        color: (modeloDatos.ubicacionRuta == 'cuenta') ? const Color.fromARGB(255, 53, 116, 250) : Colors.transparent,
      ),
    ];
  }

  Widget _logo(){

    final modeloDatos = Provider.of<VariablesGlobalesProvider>(context);
    double size = MediaQuery.of(context).size.width;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: (){
          if(size < 450){
            if(modeloDatos.mostrarMenu){
              modeloDatos.mostrarMenu = false;
            } else {
              modeloDatos.mostrarMenu = true;
            }
          }
        },
        child: (size > 450) ? CircleAvatar(
          backgroundColor: Colors.white,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.asset('assets/jpg/logo_escuela.jpeg')
          )
        ) : const Icon(Icons.menu, color: Colors.white),
      ),
    );
  }
}