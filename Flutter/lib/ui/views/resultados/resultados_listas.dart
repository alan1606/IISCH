import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evaluaciones_web/providers/variables_globales.dart';
import 'package:evaluaciones_web/services/navigation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../locator.dart';

class ResultadosListas extends StatefulWidget {
  const ResultadosListas({ Key? key }) : super(key: key);

  @override
  _ResultadosListasState createState() => _ResultadosListasState();
}

class _ResultadosListasState extends State<ResultadosListas> {
  
  List<QueryDocumentSnapshot<Object?>> alumnosRes = [];
  List<dynamic> respuestasCorrectas = [];
  List<String> tipoPregunta = [];
  List<String> preguntasAux = [];
  List<List<dynamic>> respuestasAlumnos = [];
  List<dynamic> respuestasTextCorrectas = [];
  List<String> nombresAlumnos = [];
  
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
            
      String evalucionEncuesta = '';

      if(modeloDatos.referenciaContestar.contains('Evaluacion')){
        evalucionEncuesta = 'Evaluaciones';
      } else 
      if(modeloDatos.referenciaContestar.contains('Encuesta')){
        evalucionEncuesta = 'Encuestas';
      }

      final QuerySnapshot listResAlumnos = await FirebaseFirestore.instance
      .collection('Grupos')
      .doc(modeloDatos.coleccionReferen)
      .collection(evalucionEncuesta)
      .doc(modeloDatos.referenciaContestar)
      .collection('Respuestas')
      .where('finis', isGreaterThanOrEqualTo: 1)
      .get();
      alumnosRes = listResAlumnos.docs;

      for(int j = 0; j < alumnosRes.length; j++){
        Map<String,dynamic> claves = alumnosRes[j].data() as Map<String,dynamic>;
        respuestasAlumnos.add(claves['resps']);

        String refAux = alumnosRes[j].id;
        int ubicGuion = refAux.indexOf('-');
        String newTitulo = refAux.substring(0, ubicGuion);
        nombresAlumnos.add(newTitulo);
        modeloDatos.alumnos = nombresAlumnos;
      }

      Map<String,dynamic> clavesMap = {};
      List<dynamic> preguntasBase = [];
      List<Map<String,dynamic>> respuestasText = [];

      // ignore: unused_local_variable
      final QuerySnapshot ? listData = await FirebaseFirestore.instance
      .collection('Grupos')
      .doc(modeloDatos.coleccionReferen)
      .collection(evalucionEncuesta)
      .doc(modeloDatos.referenciaContestar)
      .get()
      .then((DocumentSnapshot documentos) async {
        if(!documentos.exists){
        } else
        if(documentos.exists) {
          clavesMap = documentos.data() as Map<String, dynamic>;
          (clavesMap['Preguntas'] != null ? preguntasBase = clavesMap['Preguntas'] : preguntasBase = []);
        }
        return null; 
      });

      for(int m = 0; m < preguntasBase.length; m++){
        respuestasCorrectas.add(preguntasBase[m]['resCorrect']);
        tipoPregunta.add(preguntasBase[m]['tipo']);
        preguntasAux.add(preguntasBase[m]['pregunta']);

        if(preguntasBase[m]['tipo'] == 'a'){
          respuestasText.add(preguntasBase[m]['respuestas']);
        } else {
          respuestasText.add({});
        }

      }

      modeloDatos.respuestasCuestionario = respuestasText;

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
              )
            ],
          ),
          const Spacer(),
          _verGraficas()
        ],
      )
    );
  }

  Widget _verGraficas(){
    final modeloDatos = Provider.of<VariablesGlobalesProvider>(context, listen: false);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: (){
          if(respuestasAlumnos.isNotEmpty){
            modeloDatos.listTipoPregunta = tipoPregunta;
            modeloDatos.listResCorrect = respuestasCorrectas;
            modeloDatos.listPreguntas = preguntasAux;
            modeloDatos.listRespuestasTodosAlumnos = respuestasAlumnos;
            locator<NavigationService>().navigateTo('/resultados/graficos');
          }
        },
        child: Container(
          height: 30,
          alignment: AlignmentDirectional.center,
          width: 80,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(23, 139, 246, 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(CupertinoIcons.chart_bar_circle, color: Colors.white)
        ),
      ),
    );
  }

  Widget _listaExamEval(){
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: alumnosRes.length,
      itemBuilder: (BuildContext context, int index) {
        return _itemTipeCuestionario(alumnosRes[index].id, index);
      },
    );
  }

  Widget _itemTipeCuestionario(String titulo, index){
    String refAux = titulo;
    int ubicGuion = titulo.indexOf('-');
    String newTitulo = titulo.substring(0, ubicGuion);
    int aciertos = 0;
    int fallos = 0;

    double size = MediaQuery.of(context).size.width;

    for(int mj = 0; mj < respuestasCorrectas.length; mj++){
      if(tipoPregunta[mj] == 'a'){
        if(respuestasAlumnos[index][mj] == respuestasCorrectas[mj]){
          aciertos = aciertos + 1;
        }
        if(respuestasAlumnos[index][mj] != respuestasCorrectas[mj]){
          fallos = fallos + 1;
        }
      } else {
        if(respuestasAlumnos[index][mj].toString().contains('1102')){
          aciertos = aciertos + 1;
        }
      }
    }

    return Container(
      width: double.infinity,
      height: (size >= 600) ? 50 : 80,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(23, 32, 39, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: _detallesItem(newTitulo, index, refAux, aciertos, fallos)
    );
  }

  Widget _detallesItem(String titulo, int index, String refAux, int aciertos, int fallos){
    
    final modeloDatos = Provider.of<VariablesGlobalesProvider>(context, listen: false);
    double size = MediaQuery.of(context).size.width;

    if(size >= 600){
      return Row(
        children: [
          _logo(),
          const SizedBox(width: 10),
          _textModel(titulo, false, 12, Colors.white),

          const Spacer(),
          (modeloDatos.referenciaContestar.contains('Encuesta')) ? const Text('') : _modelAciertoFallo('Aciertos', aciertos),
          const SizedBox(width: 10),
          (modeloDatos.referenciaContestar.contains('Encuesta')) ? const Text('') : _modelAciertoFallo('Fallos', fallos),
          const SizedBox(width: 10),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: (){
                modeloDatos.listResAlumno = respuestasAlumnos[index];
                modeloDatos.listResCorrect = respuestasCorrectas;
                modeloDatos.listTipoPregunta = tipoPregunta;
                modeloDatos.currentAlumno = titulo;
                modeloDatos.listPreguntas = preguntasAux;
                modeloDatos.referenciaDocumentoID = refAux;
                locator<NavigationService>().navigateTo('/resultados/listas/revision');
              },
              child: _editarEliminar('editar')
            ),
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
              (modeloDatos.referenciaContestar.contains('Encuesta')) ? const Text('') : _modelAciertoFallo('Aciertos', aciertos),
              const SizedBox(width: 10),
              (modeloDatos.referenciaContestar.contains('Encuesta')) ? const Text('') : _modelAciertoFallo('Fallos', fallos),
              const SizedBox(width: 10),
              const Spacer(),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: (){
                    modeloDatos.listResAlumno = respuestasAlumnos[index];
                    modeloDatos.listResCorrect = respuestasCorrectas;
                    modeloDatos.listTipoPregunta = tipoPregunta;
                    modeloDatos.currentAlumno = titulo;
                    modeloDatos.listPreguntas = preguntasAux;
                    modeloDatos.referenciaDocumentoID = refAux;
                    locator<NavigationService>().navigateTo('/resultados/listas/revision');
                  },
                  child: _editarEliminar('editar')
                ),
              ),
            ]
          ),
          const Spacer(),
        ],
      );
    }
  }

  Widget _modelAciertoFallo(String titulo, int numero){
    return SizedBox(
      width: 60,
      child: _textModel('$titulo: $numero', false, 12, Colors.white)
    );
  }

  Widget _logo(){
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: CircleAvatar( 
        backgroundColor: Colors.white,
        child: Image.asset('assets/jpg/logo_escuela.jpeg')
      ),
    );
  }

  Widget _editarEliminar(String tipo){
    return SvgPicture.asset(
      'assets/svg/$tipo.svg',
      height: 20,
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