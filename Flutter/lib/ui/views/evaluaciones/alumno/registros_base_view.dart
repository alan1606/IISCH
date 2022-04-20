import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evaluaciones_web/providers/variables_globales.dart';
import 'package:evaluaciones_web/services/navigation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../locator.dart';

class RegistrosBaseView extends StatefulWidget {
  const RegistrosBaseView({ Key? key }) : super(key: key);
  @override
  _RegistrosBaseViewState createState() => _RegistrosBaseViewState();
}

class _RegistrosBaseViewState extends State<RegistrosBaseView> {

  List<QueryDocumentSnapshot<Object?>> gruposRegistrados = [];
  List<Widget> cuadroMenu = [];

  @override
  void initState() {
    super.initState();
    recuprarData();
  }

  void recuprarData() async {
    if(FirebaseAuth.instance.currentUser == null){
      locator<NavigationService>().navigateTo('/cuenta');
    } else {
      final QuerySnapshot listGrupos = await FirebaseFirestore.instance
      .collection('Grupos')
      .where('Aux', isGreaterThanOrEqualTo: 1)
      .get();
      gruposRegistrados = listGrupos.docs;

      List<Widget> auxCuadros = List<Widget>.generate(
        gruposRegistrados.length, (index) => _modeloTarjetas(gruposRegistrados[index])
      );

      cuadroMenu = auxCuadros;

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
      children: cuadroMenu,
    );
  }

  Widget _modeloTarjetas(QueryDocumentSnapshot<Object?> data){

    final modeloDatos = Provider.of<VariablesGlobalesProvider>(context, listen: false);
    Map<String,dynamic> misDtos = data.data() as Map<String,dynamic>;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: (){
          modeloDatos.coleccionReferen = data.id;
          modeloDatos.docente = misDtos['Nombre'];
          modeloDatos.materia = misDtos['Materia'];
          locator<NavigationService>().navigateTo('/registrosdocente');
        },
        child: Container(
          height: 220,
          width: 180,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          margin: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey, width: 0.5)
          ),
          child: Column(
            children: [
              const CircleAvatar(
                backgroundColor: Color.fromRGBO(23, 32, 39, 1),
                radius: 45,
                child: Icon(CupertinoIcons.person_solid, color: Colors.white, size: 60)
              ),
              const Spacer(),
              _textModel(misDtos['Materia'], false, 12, Colors.black87),
              const Spacer(),
              _textModel('Docente: ' + misDtos['Nombre'], false, 12, Colors.black87),
            ]
          )
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