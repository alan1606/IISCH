import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evaluaciones_web/providers/variables_globales.dart';
import 'package:evaluaciones_web/services/navigation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../locator.dart';

class EvaluacionesAlumnosView extends StatefulWidget {
  const EvaluacionesAlumnosView({ Key? key }) : super(key: key);

  @override
  _EvaluacionesAlumnosViewState createState() => _EvaluacionesAlumnosViewState();
}

class _EvaluacionesAlumnosViewState extends State<EvaluacionesAlumnosView> {

  List<QueryDocumentSnapshot<Object?>> listDocs = [];
  List<Widget> listaCuadros = [];

  @override
  void initState() {
    super.initState();
    recuprarData();
  }

  void recuprarData() async {
    if(FirebaseAuth.instance.currentUser == null){
      locator<NavigationService>().navigateTo('/cuenta');
    } else {
      
      final modeloDatos = Provider.of<VariablesGlobalesProvider>(context, listen: false);

      List<QueryDocumentSnapshot<Object?>> listEvaluaciones = [];
      List<QueryDocumentSnapshot<Object?>> listEncuestas = [];

      final QuerySnapshot listEval = await FirebaseFirestore.instance
      .collection('Grupos')
      .doc(modeloDatos.coleccionReferen)
      .collection('Evaluaciones')
      .where('NumPreg', isGreaterThanOrEqualTo: 1)
      .get();
      listEvaluaciones = listEval.docs;

      final QuerySnapshot listEncu = await FirebaseFirestore.instance
      .collection('Grupos')
      .doc(modeloDatos.coleccionReferen)
      .collection('Encuestas')
      .where('NumPreg', isGreaterThanOrEqualTo: 1)
      .get();
      listEncuestas = listEncu.docs;

      listDocs = listEvaluaciones + listEncuestas;

      List<Widget> auxCuadricula = List<Widget>.generate(
        listDocs.length, (index) => _modeloTarjetas(listDocs[index])
      );
      listaCuadros = auxCuadricula;

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
          _cuadricula(),
        ],
      ),
    );
  }

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
            ],
          ),
          const Spacer(),
        ],
      )
    );
  }

  Widget _cuadricula(){
    return Wrap(
      alignment: WrapAlignment.center,
      children: listaCuadros,
    );
  }

  Widget _modeloTarjetas(QueryDocumentSnapshot<Object?> data){

    final modeloDatos = Provider.of<VariablesGlobalesProvider>(context, listen: false);
    Map<String,dynamic> misDtos = data.data() as Map<String,dynamic>;

    return GestureDetector(
      onTap: (){

      },
      child: Container(
        height: 260,
        width: 190,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey, width: 0.5)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircleAvatar(
                  backgroundColor: Color.fromRGBO(23, 32, 39, 1),
                  radius: 45,
                  child: Icon(CupertinoIcons.text_badge_checkmark, color: Colors.white, size: 60)
                ),
              ],
            ),
            const Spacer(),
            _textModel('Titulo: ' + misDtos['IDevaluacion'], false, 10, Colors.black87),
            _textModel('Docente: ' + modeloDatos.docente, false, 10, Colors.black87),
            _textModel('Materia: ' + modeloDatos.materia, false, 10, Colors.black87),
            _textModel('Total Preguntas: ${misDtos['NumPreg']}', false, 10, Colors.black87),
            const Spacer(),
            _boton(misDtos['IDevaluacion'])
          ]
        )
      ),
    );
  }


  Widget _boton(String refe){
    final modeloDatos = Provider.of<VariablesGlobalesProvider>(context, listen: false);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: (){
          modeloDatos.referenciaContestar = refe;
          locator<NavigationService>().navigateTo('/aplicarcuestionario');
        },
        child: Container(
          height: 35,
          alignment: AlignmentDirectional.center,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(23, 139, 246, 1), 
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text('Comenzar', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.normal))
        ),
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