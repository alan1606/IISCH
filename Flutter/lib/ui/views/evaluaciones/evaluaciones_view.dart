import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evaluaciones_web/providers/variables_globales.dart';
import 'package:evaluaciones_web/services/navigation_service.dart';
import 'package:evaluaciones_web/ui/views/evaluaciones/alumno/registros_base_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../locator.dart';

class EvaluacionView extends StatefulWidget {

  const EvaluacionView({Key? key}) : super(key: key);
  
  @override
  State<EvaluacionView> createState() => _EvaluacionViewState();
}

class _EvaluacionViewState extends State<EvaluacionView> {

  List<QueryDocumentSnapshot<Object?>> misDocumentos = [];
  String coleccion = '';

  @override
  void initState() {
    super.initState();
    navegar();
  }

  void navegar() async {
    if(FirebaseAuth.instance.currentUser == null){
      locator<NavigationService>().navigateTo('/cuenta');
    } else {
      if(!FirebaseAuth.instance.currentUser!.displayName!.contains('Alumno')){
        
        List<QueryDocumentSnapshot<Object?>> evaluaciones = [];
        List<QueryDocumentSnapshot<Object?>> encuestas    = [];

        String? nombreUser = FirebaseAuth.instance.currentUser!.displayName;

        int auxUbicGuion = nombreUser!.indexOf('-');
        coleccion = nombreUser.substring(auxUbicGuion + 1, nombreUser.length).trim();
        
        final QuerySnapshot listEvaluaciones = await FirebaseFirestore.instance
        .collection('Grupos')
        .doc(coleccion)
        .collection('Evaluaciones')
        .where('NumPreg', isGreaterThanOrEqualTo: 1)
        .get();
        evaluaciones = listEvaluaciones.docs;

        final QuerySnapshot listEncuestas = await FirebaseFirestore.instance
        .collection('Grupos')
        .doc(coleccion)
        .collection('Encuestas')
        .where('NumPreg', isGreaterThanOrEqualTo: 1)
        .get();
        encuestas = listEncuestas.docs;

        misDocumentos = evaluaciones + encuestas;

        if(mounted){
          setState(() {});
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){  
        if(snapshot.hasData){
          String ? dataUser = '';
          if(snapshot.data != null){

            dataUser = FirebaseAuth.instance.currentUser!.displayName;

            if(dataUser!.contains('Alumno')){
              return const RegistrosBaseView();
            } else
            if(dataUser.contains('Docente') | dataUser.contains('Maestro')){
              return _byPassAlumnoDocente();
            } else {
              return _noRol();
            }
          } else {
            return _noRol();
          }
        }else{
          return const CircularProgressIndicator();
        }
      }      
    );

  }

  Widget _byPassAlumnoDocente(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: ListView(
        children: [
          const SizedBox(height: 100),
          _encabezado(context),
          const SizedBox(height: 50),
          _opcionCircular(),
          const SizedBox(height: 50),
          _listaExamEval(),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _noRol(){
    return  Center(
      child: Text(
        'Aun no seleccionas la clase de usuario a la que pertenece tu perfil.',
        style: TextStyle(color: Colors.grey.shade500, fontSize: 15)
      )
    );
  }

  // ignore: unused_element
  Widget _titulo(){
    return Container(
      height: 65,
      padding: const EdgeInsets.symmetric(horizontal: 25),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('Evaluaciones', style: TextStyle(color: Colors.black, fontSize: 15)),
              SizedBox(
                width: 50,
                child: Divider(color: Colors.grey),
              )
            ],
          ),
          const Spacer(),
        ],
      )
    );
  }

  Widget _encabezado(context){

    double size = MediaQuery.of(context).size.width;

    return Container(
      padding: (size >= 595) ? const EdgeInsets.symmetric(horizontal: 100) : const EdgeInsets.symmetric(horizontal: 50),
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          SizedBox(
            height: (size >= 595) ? 100 : 135,
            width: (size >= 595) ? 400 : 450 ,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _textModel('Bienvenido', true, 25, Colors.black87),
                _textModel('Se encuentra en el apartado de evaluaciones, donde se examinaran los aprendizajes de los alumnos y podras indagar acerca de un tema de interes con la sociedad.', false, 15, Colors.black87),
              ],
            ),
          ),
          SvgPicture.asset(
            'assets/svg/cerebro.svg',
            height: 70,
          ),
        ],
      ),
    );
  }

  Widget _opcionCircular(){
    final modeloDatos = Provider.of<VariablesGlobalesProvider>(context, listen: false);
    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      children: [
        itemOpcionCircular('Crear un nuevo examen', CupertinoIcons.doc_append,
          (){
            modeloDatos.docReferenciEdit = '';
            locator<NavigationService>().navigateTo('/evaluaciones/Evaluacion');
          }
        ),
        itemOpcionCircular('Crear un nueva encuesta', CupertinoIcons.doc_chart,
          (){
            modeloDatos.docReferenciEdit = '';
            locator<NavigationService>().navigateTo('/evaluaciones/Encuesta');
          }
        ),
      ],
    );
  }

  Widget itemOpcionCircular(String titulo, IconData icono, Function onTap){
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: ()=> onTap(),
        child: CircleAvatar(
          radius: 130,
          backgroundColor: const Color.fromRGBO(23, 32, 39, 1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _textModel(titulo, false, 14, Colors.white),
              const SizedBox(
                width: 150,
                child: Divider(color: Colors.white),
              ),
              const SizedBox(height: 10),
              Icon(icono, color: Colors.white, size: 60)
            ]
          )
        ),
      ),
    );
  }

  Widget _listaExamEval(){
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: misDocumentos.length,
      itemBuilder: (BuildContext context, int index) {
        return _itemTipeCuestionario(misDocumentos[index].id, misDocumentos[index]);
      },
    );
  }

  Widget _itemTipeCuestionario(String titulo,  QueryDocumentSnapshot<Object?> datos){

    Map<String,dynamic> data = datos.data() as Map<String,dynamic>;
    double size = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      height: (size >= 600) ? 50 : 80,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(23, 32, 39, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: _detallesItem(titulo, data['Pass'])
    );
  }

  void _eliminarEvaluacion(String titulo) async {

    String tituloAux = '';

    if(titulo.contains('Encuesta')){
      tituloAux = 'Encuestas';
    } else 
    if(titulo.contains('Evaluacion')){
      tituloAux = 'Evaluaciones';
    }

    final QuerySnapshot listaRes = await FirebaseFirestore.instance
    .collection('Grupos')
    .doc(coleccion)
    .collection(tituloAux)
    .doc(titulo)
    .collection('Respuestas')
    .where('finis', isGreaterThanOrEqualTo: 1)
    .get();
    List<QueryDocumentSnapshot<Object?>> listRespuestas = listaRes.docs;

    if(listRespuestas.isNotEmpty){
      for(int m = 0; m < listRespuestas.length; m++){
        FirebaseFirestore.instance
        .collection('Grupos')
        .doc(coleccion)
        .collection(tituloAux)
        .doc(titulo)
        .collection('Respuestas')
        .doc(listRespuestas[m].id)
        .delete();
      }
    }

    FirebaseFirestore.instance
    .collection('Grupos')
    .doc(coleccion)
    .collection(tituloAux)
    .doc(titulo)
    .delete();

    Navigator.pop(context);

    List<QueryDocumentSnapshot<Object?>> evaluaciones = [];
    List<QueryDocumentSnapshot<Object?>> encuestas    = [];
        
    final QuerySnapshot listEvaluaciones = await FirebaseFirestore.instance
    .collection('Grupos')
    .doc(coleccion)
    .collection('Evaluaciones')
    .where('NumPreg', isGreaterThanOrEqualTo: 1)
    .get();
    evaluaciones = listEvaluaciones.docs;

    final QuerySnapshot listEncuestas = await FirebaseFirestore.instance
    .collection('Grupos')
    .doc(coleccion)
    .collection('Encuestas')
    .where('NumPreg', isGreaterThanOrEqualTo: 1)
    .get();
    encuestas = listEncuestas.docs;

    misDocumentos = evaluaciones + encuestas;

    if(mounted){
      setState(() {});
    }

  }

  void _ventanaCrearCuestionario(String titulo){      
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromRGBO(23, 32, 39, 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: const Text ('Atención', style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.normal)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 220,
                  width: 250,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    'Confirmar la eliminación completa de:\n\n$titulo\n\nSe pueden perder las respuestas almacenadas y es un proceso irreversible.', 
                    textAlign: TextAlign.start,
                    style: const TextStyle(fontSize: 14, color: Colors.white)
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: ()=> _eliminarEvaluacion(titulo),
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromRGBO(186, 66, 69, 1), 
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        )
                      ),
                      child: Container(
                        width: 70,
                        alignment: AlignmentDirectional.center,
                        child: const Text('Eliminar', style: TextStyle(color: Colors.white))
                      ),
                    ),
                    ElevatedButton(
                      onPressed: ()=> Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey, 
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        )
                      ),
                      child: Container(
                        width: 70,
                        alignment: AlignmentDirectional.center,
                        child: const Text('Cancelar', style: TextStyle(color: Colors.white))
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
              ]
            ),
          ),
        );
      }
    );
  }

  Widget _detallesItem(String titulo, String pass){
    
    final modeloDatos = Provider.of<VariablesGlobalesProvider>(context, listen: false);
    double size = MediaQuery.of(context).size.width;

    if(size >= 600){
      return Row(
        children: [
          _logo(),
          const SizedBox(width: 10),
          _textModel(titulo, false, 12, Colors.white),
          const Spacer(),
          SizedBox(
            width: 200,
            child: _textModel('Contraseña:   $pass', false, 12, Colors.white)
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: (){
                modeloDatos.docReferenciEdit = titulo;
                if(titulo.contains('Evaluacion')){
                  locator<NavigationService>().navigateTo('/evaluaciones/Evaluacion');
                } else
                if(titulo.contains('Encuesta')){
                  locator<NavigationService>().navigateTo('/evaluaciones/Encuesta');
                }
              },
              child: _editarEliminar('editar')
            ),
          ),
          const SizedBox(width: 15),
          GestureDetector(
            onTap: ()=> _ventanaCrearCuestionario(titulo),
            child: _editarEliminar('eliminar')
          ),
        ]
      );
    } else {
      return Column(
        children: [
          const Spacer(),
          Row(
            children: [
              _logo(),
              const SizedBox(width: 10),
              _textModel(titulo, false, 12, Colors.white),
              const Spacer(),
            ]
          ),
          Row(
            children: [
              SizedBox(
                width: 200,
                child: _textModel('Contraseña:   $pass', false, 12, Colors.white)
              ),
              const Spacer(),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: (){
                    modeloDatos.docReferenciEdit = titulo;
                    if(titulo.contains('Evaluacion')){
                      locator<NavigationService>().navigateTo('/evaluaciones/Evaluacion');
                    } else
                    if(titulo.contains('Encuesta')){
                      locator<NavigationService>().navigateTo('/evaluaciones/Encuesta');
                    }
                  },
                  child: _editarEliminar('editar')
                ),
              ),
              const SizedBox(width: 15),
              GestureDetector(
                onTap: ()=> _ventanaCrearCuestionario(titulo),
                child: _editarEliminar('eliminar')
              ),
            ]
          ),
          const Spacer(),
        ],
      );
    }
  }

  Widget _logo(){
    return CircleAvatar( 
      backgroundColor: Colors.white,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Image.asset('assets/jpg/logo_escuela.jpeg')
      )
    );
  }

  Widget _editarEliminar(String tipo){
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: SvgPicture.asset(
        'assets/svg/$tipo.svg',
        height: 20,
      ),
    );
  }

  Widget _textModel(String contenido, bool negrita, double sizeFont, Color color){
    return Text(contenido, 
      style: TextStyle(
        fontSize: sizeFont,
        fontWeight: negrita ? FontWeight.bold : FontWeight.normal,
        color: color,
        overflow: TextOverflow.visible
      )
    );
  }
}