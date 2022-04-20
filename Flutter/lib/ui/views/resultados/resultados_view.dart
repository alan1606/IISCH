import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evaluaciones_web/providers/variables_globales.dart';
import 'package:evaluaciones_web/services/navigation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../locator.dart';

class MenuResultadosView extends StatefulWidget {
  const MenuResultadosView({ Key? key }) : super(key: key);

  @override
  _MenuResultadosViewState createState() => _MenuResultadosViewState();
}

class _MenuResultadosViewState extends State<MenuResultadosView> {

  List<QueryDocumentSnapshot<Object?>> misDocumentos = [];
  List<Widget> tarjetasBuilder = [];
  String docente = '';
  String grupo = '';

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
        String coleccion = nombreUser.substring(auxUbicGuion + 1, nombreUser.length).trim();
        docente = nombreUser.substring(0, auxUbicGuion).trim();
        grupo = coleccion;

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

      List<Widget> tarjetas = List<Widget>.generate(
        misDocumentos.length, (index) => _tarjetaModel('Evaluacion', misDocumentos[index])
      );
      tarjetasBuilder = tarjetas;
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
          const SizedBox(height: 25),
          Wrap(
            alignment: WrapAlignment.center,
            children: tarjetasBuilder,
          ),
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
              Text('Resultados', style: TextStyle(color: Colors.black, fontSize: 15)),
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

  Widget _tarjetaModel(String tipo, QueryDocumentSnapshot<Object?> data){

    bool isEvaluacion = false;

    Map<String,dynamic> datos = data.data() as Map<String,dynamic>;

    if(tipo.contains('Evaluacion')){
      isEvaluacion = true;
    } else
    if(tipo.contains('Encuesta')){
      isEvaluacion = false;
    }
    // bool isHovering = false;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: StatefulBuilder(
        builder: (BuildContext context, void Function(void Function()) setState) {
          bool isHovering = false;
          return InkWell(
            onHover: (sobreBoton){
              setState(() => isHovering = sobreBoton);
            },
            child: Stack(
              children: [
                Container(
                  height: 300,
                  width: 210,
                  color: Colors.white,
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: 260,
                    width: 210,
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: isHovering ? Colors.pink : const Color.fromRGBO(23, 32, 39, 1)
                    ),
                    child: _modeloContenidoTarjeta(data.id, datos)
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 65,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: isHovering ? Colors.pink : const Color.fromRGBO(23, 32, 39, 1),
                    child: Icon(isEvaluacion ? CupertinoIcons.doc_append : CupertinoIcons.doc_chart, color: Colors.white, size: 50)
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  Widget _modeloContenidoTarjeta(String titulo, Map<String,dynamic> data){
    return Column(
      children: [
        const SizedBox(height: 45),
        _textModel(titulo, true, 12, TextAlign.center),
        const Spacer(),
        Container(
          alignment: AlignmentDirectional.centerStart,
          child: _textModel('Docente: $docente', false, 12, TextAlign.start)
        ),
        const SizedBox(height: 8),
        Container(
          alignment: AlignmentDirectional.centerStart,
          child: _textModel('Grupo: $grupo', false, 12,TextAlign.start)
        ),
        const SizedBox(height: 8),
        Container(
          alignment: AlignmentDirectional.centerStart,
          child: _textModel('Total de reactivos: ${data['NumPreg']}', false, 12, TextAlign.start)
        ),
        const Spacer(),
        _boton(titulo),
        const SizedBox(height: 15),
      ]
    );
  }

  Widget _boton(String titulo){
    
    final modeloDatos = Provider.of<VariablesGlobalesProvider>(context, listen: false);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: (){
          modeloDatos.coleccionReferen = grupo;
          modeloDatos.referenciaContestar = titulo;
          locator<NavigationService>().navigateTo('/resultados/listas');
        },
        child: Container(
          height: 25,
          width: 80,
          alignment: AlignmentDirectional.center,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(186, 66, 69, 1), 
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text('Ver', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.normal))
        ),
      ),
    );
  }

  Widget _textModel(String contenido, bool negrita, double sizeFont, TextAlign alineacion){
    return Text(contenido, 
      style: TextStyle(
        fontSize: sizeFont,
        fontWeight: negrita ? FontWeight.w500 : FontWeight.normal,
        color: Colors.white,
        overflow: TextOverflow.visible
      ),
      textAlign: alineacion,
    );
  }

}