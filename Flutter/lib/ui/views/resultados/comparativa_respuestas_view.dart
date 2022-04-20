import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evaluaciones_web/providers/variables_globales.dart';
import 'package:evaluaciones_web/services/navigation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../locator.dart';

class ComparativaRespuestasView extends StatefulWidget {
  const ComparativaRespuestasView({ Key? key }) : super(key: key);

  @override
  _ComparativaRespuestasViewState createState() => _ComparativaRespuestasViewState();
}

class _ComparativaRespuestasViewState extends State<ComparativaRespuestasView> {
  
  List<dynamic> respuestasCorrectas = [];
  List<String> tipoPregunta = [];
  List<dynamic> respuestasAlumnos = [];
  List<String> preguntasTitulo = [];
  List<Map<String,dynamic>> respuestasCuestionario = [];
  String alumno = '';
  String evalucionEncuesta = '';

  String userName = '';
  String userUID  = '';


  @override
  void initState() {
    super.initState();
    recuperarData();
  }

  void recuperarData() async {
    if(FirebaseAuth.instance.currentUser == null){
      locator<NavigationService>().navigateTo('/cuenta');
    } else {

      final modeloDatos = Provider.of<VariablesGlobalesProvider>(context, listen: false);
                  
      if(modeloDatos.referenciaContestar.contains('Evaluacion')){
        evalucionEncuesta = 'Evaluaciones';
      } else 
      if(modeloDatos.referenciaContestar.contains('Encuesta')){
        evalucionEncuesta = 'Encuestas';
      }

      userName = FirebaseAuth.instance.currentUser!.displayName!;
      userUID = FirebaseAuth.instance.currentUser!.uid;

      respuestasCorrectas = modeloDatos.listResCorrect;
      tipoPregunta = modeloDatos.listTipoPregunta;
      respuestasAlumnos = modeloDatos.listResAlumno;
      preguntasTitulo = modeloDatos.listPreguntas;
      alumno = modeloDatos.currentAlumno;
      respuestasCuestionario = modeloDatos.respuestasCuestionario;

      if(mounted){
        setState(() {});
      }
    }    
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: ListView(
        children: [
          const SizedBox(height: 80),
          _titulo(),
          const SizedBox(height: 50),
          _listaExamEval()
        ],
      ),
    );
  }

  Widget _titulo(){
    final modeloDatos = Provider.of<VariablesGlobalesProvider>(context, listen: false);
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
            children: [
              Text(modeloDatos.referenciaContestar, style: const TextStyle(color: Colors.black, fontSize: 15)),
              const SizedBox(
                width: 50,
                child: Divider(color: Colors.grey),
              ),
              Text(alumno, style: const TextStyle(color: Colors.black, fontSize: 13)),
            ],
          ),
          const Spacer(),
        ],
      )
    );
  }

  Widget _listaExamEval(){
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: respuestasAlumnos.length,
      itemBuilder: (BuildContext context, int index) {
        return _itemTipeCuestionario(preguntasTitulo[index], index);
      },
    );
  }

  Widget _itemTipeCuestionario(String titulo, int index){
    final modeloDatos = Provider.of<VariablesGlobalesProvider>(context, listen: false);

    Color fondo = const Color.fromRGBO(23, 32, 39, 1);
    String respuestaAbierta = '';

    if(tipoPregunta[index] == 'b'){
      if(respuestasAlumnos[index].toString().contains('1102')){
        respuestaAbierta = respuestasAlumnos[index].toString().substring(0, respuestasAlumnos[index].toString().length - 4);
      } else {
        respuestaAbierta = respuestasAlumnos[index].toString();
      }
    }

    if(tipoPregunta[index] == 'a'){
      if(respuestasAlumnos[index] == respuestasCorrectas[index]){
        fondo = const Color.fromRGBO(76, 217, 96, 1);
      } else {
        fondo = Colors.redAccent;
      }
    } else {
      if(respuestasAlumnos[index].toString().contains('1102')){
        fondo = const Color.fromRGBO(76, 217, 96, 1);
      } else {
        fondo = Colors.amber;
      }
    }

    return Container(
      width: double.infinity,
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(23, 32, 39, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const Spacer(),
          Row(
            children: [
              StatefulBuilder(
                builder: (BuildContext context, void Function(void Function()) setState) {  
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: (){
                        if(tipoPregunta[index] == 'b'){
                          if(respuestasAlumnos[index].toString().contains('1102')){
                            fondo = Colors.amber;
                            respuestasAlumnos[index] = respuestasAlumnos[index].toString().substring(0, respuestasAlumnos[index].toString().length - 4);

                            FirebaseFirestore.instance.collection('Grupos')
                            .doc(modeloDatos.coleccionReferen)
                            .collection(evalucionEncuesta)
                            .doc(modeloDatos.referenciaContestar)
                            .collection('Respuestas')
                            .doc(modeloDatos.referenciaDocumentoID)
                            .set(
                              {
                                'resps' : respuestasAlumnos,
                              }, SetOptions(merge : true)
                            );
                            
                          } else {
                            respuestasAlumnos[index] = respuestasAlumnos[index].toString() + '1102';
                            fondo = const Color.fromRGBO(76, 217, 96, 1);

                            FirebaseFirestore.instance.collection('Grupos')
                            .doc(modeloDatos.coleccionReferen)
                            .collection(evalucionEncuesta)
                            .doc(modeloDatos.referenciaContestar)
                            .collection('Respuestas')
                            .doc(modeloDatos.referenciaDocumentoID)
                            .set(
                              {
                                'resps' : respuestasAlumnos,
                              }, SetOptions(merge : true)
                            );

                          }
                          setState((){});
                        }
                      },
                      child: _logo(fondo)
                    )
                  );
                },
              ),
              const SizedBox(width: 10),
              _textModel(titulo, false, 12, Colors.white),
            ]
          ),
          const SizedBox(height: 5),
          SizedBox(
            child: Row(
              children: [//respuestasCuestionario
                Expanded(
                  child: Column(
                    children: [
                      _textModel('Respuesta Alumno', true, 12, Colors.white),
                      (tipoPregunta[index] == 'b') ? _textModel(respuestaAbierta, false, 12, Colors.white) : _textModel(respuestasCuestionario[index]['Op${respuestasAlumnos[index]}'], false, 12, Colors.white),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      _textModel('Respuesta Correcta', true, 12, Colors.white),
                      ((tipoPregunta[index] == 'b') | (modeloDatos.referenciaContestar.contains('Encuesta'))) ? _textModel('', false, 12, Colors.white) : _textModel(respuestasCuestionario[index]['Op${respuestasCorrectas[index]}'], false, 12, Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      )
    );
  }

  Widget _logo(Color fondo){
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: CircleAvatar( 
        backgroundColor: fondo,
        child: const Text('')
      ),
    );
  }

  // Widget _editarEliminar(String tipo){
  //   return SvgPicture.asset(
  //     'assets/svg/$tipo.svg',
  //     height: 20,
  //   );
  // }

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