import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evaluaciones_web/providers/variables_globales.dart';
import 'package:evaluaciones_web/services/navigation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../locator.dart';

class NewEvaluacionView extends StatefulWidget {

  final String base;
  const NewEvaluacionView({
    Key ? key,
    required this.base
  }) : super(key: key);

  @override
  _NewEvaluacionViewState createState() => _NewEvaluacionViewState();
}

class _NewEvaluacionViewState extends State<NewEvaluacionView> {

  List<TextEditingController> controllersPreguntas = [];
  List<List<TextEditingController>> controllersRespuesta = [];
  List<Map<String,dynamic>> listDatosPreguntas = [];

  TextEditingController tituloController = TextEditingController();

  String passActual = '';
  String refColeccion = '';

  @override
  void initState() {
    super.initState();
    recuperarData();
  }

  void recuperarData() async {

    final modeloDatos = Provider.of<VariablesGlobalesProvider>(context, listen: false);
    refColeccion = modeloDatos.docReferenciEdit;
    tituloController.value = TextEditingValue(text: refColeccion);

    if(refColeccion.isNotEmpty){

      String? nombreUser = FirebaseAuth.instance.currentUser!.displayName;
      int auxUbicGuion = nombreUser!.indexOf('-');
      String coleccion = nombreUser.substring(auxUbicGuion + 1, nombreUser.length).trim();

      String idDoc = '';
      if(refColeccion.contains('Evaluacion')){
        idDoc = 'Evaluaciones';
      } else 
      if(refColeccion.contains('Encuesta')){
        idDoc = 'Encuestas';
      }

      Map<String,dynamic> clavesMap = {};
      List<dynamic> preguntasBase = [];

      await FirebaseFirestore.instance
      .collection('Grupos')
      .doc(coleccion)
      .collection(idDoc)
      .doc(refColeccion)
      .get()
      .then((DocumentSnapshot documentos) async {
        if(!documentos.exists){
        } else
        if(documentos.exists) {
          clavesMap = documentos.data() as Map<String, dynamic>;
          (clavesMap['Pass']         != null ? passActual = clavesMap['Pass'] : passActual = '');
          (clavesMap['Preguntas']    != null ? preguntasBase = clavesMap['Preguntas'] : preguntasBase = []);
        } 
      });
      
      for(int m = 0; m < preguntasBase.length; m++){
        var textEditingController = TextEditingController(text: preguntasBase[m]['pregunta']);
        controllersPreguntas.add(textEditingController);
      }

      List<List<TextEditingController>> listaVaciaRespuestas = List<List<TextEditingController>>.generate(
        controllersPreguntas.length, (i) => []
      );

      List<Map<String,dynamic>> listaVaciaDatos = List<Map<String,dynamic>>.generate(
        controllersPreguntas.length, (i) => {}
      );

      for(int m = 0; m < preguntasBase.length; m++){
        if(preguntasBase[m]['respuestas'] != null){
          Map<String,dynamic> acumulacionRespuestas = {};
          for(int j = 0; j < preguntasBase[m]['respuestas'].length; j++){
            String valueRespuesta = preguntasBase[m]['respuestas']['Op$j'];
            var textEditingController = TextEditingController(text: valueRespuesta);
            listaVaciaRespuestas[m].add(textEditingController);

            acumulacionRespuestas.addEntries({'Op$j' : preguntasBase[m]['respuestas']['Op$j']}.entries);

            listaVaciaDatos[m].addEntries({'respuestas' :  acumulacionRespuestas}.entries);
            listaVaciaDatos[m].addEntries({'resCorrect' : preguntasBase[m]['resCorrect']}.entries);
            listaVaciaDatos[m].addEntries({'tipo' : preguntasBase[m]['tipo']}.entries);
            listaVaciaDatos[m].addEntries({'pregunta' : preguntasBase[m]['pregunta']}.entries);
            //pregunta
          }
        }
      }

      listDatosPreguntas = listaVaciaDatos;
      controllersRespuesta = listaVaciaRespuestas;

      if(mounted){
        setState(() {});
      }
    }
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   // dispose textEditingControllers to prevent memory leaks
  //   for (TextEditingController textEditingController in textEditingControllers) {
  //     textEditingController.dispose();
  //   }
  // }

  String chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random rnd = Random();
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(height: 80),
          _titulo(),
          const SizedBox(height: 30),
          _addTitulo(),
          const SizedBox(height: 30),
          _preguntas(context),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _addTitulo(){
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(23, 32, 39, 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: TextField(
          controller: tituloController,
          readOnly: (refColeccion.isNotEmpty) ? true : false,
          textCapitalization: TextCapitalization.sentences,
          style: const TextStyle(color: Colors.white, fontSize: 13),
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Agrega un titulo *',
            hintStyle: TextStyle(color: Colors.white)
          ),
        ),
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
          Text(widget.base, style: const TextStyle(color: Colors.black, fontSize: 16)),
          const Spacer(),
          _opcionesPreguntas(),
          ElevatedButton(
            onPressed: (){
              _ventanaCrearCuestionario(context);
            },
            style: ElevatedButton.styleFrom(
              primary:  const Color.fromRGBO(186, 66, 69, 1), 
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50)
              )
            ),
            child: Text(refColeccion.isEmpty ? 'Crear' : 'Actualizar', style: const TextStyle(color: Colors.white, fontSize: 13)),
          )
        ],
      )
    );
  }

  Widget _opcionesPreguntas(){
    return PopupMenuButton(
      elevation: 0,
      onSelected: (value){
        if(value.toString() == 'a'){
          var textEditingController = TextEditingController(text: 'Nueva pregunta de opción multiple *');
          listDatosPreguntas.add({'tipo' : 'a', 'resCorrect' : 0});
          controllersPreguntas.add(textEditingController);
          controllersRespuesta.add([]);
        } else {
          var textEditingController = TextEditingController(text: 'Nueva pregunta abierta *');
          listDatosPreguntas.add({'tipo' : 'b', 'resCorrect' : 0});
          controllersPreguntas.add(textEditingController);
          controllersRespuesta.add([]);
        }
        setState(() {});
      },
      icon: const Icon(Icons.add_circle_outline, color: Colors.black),
      color: Colors.grey.withOpacity(0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      itemBuilder: (context){
        return const [
          PopupMenuItem(
            value: 'a',
            child: Text('Opción múltiple', style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
          PopupMenuItem(
            value: 'b',
            child: Text('Pregunta abierta', style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
        ];
      } 
    );
  }

  Widget _preguntas(context){
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: controllersPreguntas.length,
      itemBuilder: (BuildContext context, int index) {
        return _itemPregunta(controllersPreguntas[index], index, listDatosPreguntas[index]);
      },
    );
  }

  Widget _itemPregunta(TextEditingController controlPregunta, int index, Map<String,dynamic> dataItem){
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(23, 32, 39, 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Row(
            children: [
              Text('${index + 1}.- ', style: const TextStyle(color: Colors.white, fontSize: 13)),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: TextField(
                  controller: controlPregunta,
                  onTap: (){
                    if((controlPregunta.text == 'Nueva pregunta de opción multiple *') | (controlPregunta.text == 'Nueva pregunta abierta *')){
                      controlPregunta.clear();
                    }
                  },
                  textCapitalization: TextCapitalization.sentences,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: const InputDecoration(
                    border: InputBorder.none
                  ),
                  onChanged: (value){
                    dataItem.addEntries({'pregunta' : controlPregunta.text}.entries);
                    listDatosPreguntas[index] = dataItem;
                  }
                ),
              ),
              const Spacer(),
              (dataItem['tipo'] == 'a') ? IconButton(
                icon: const Icon(Icons.add_task_sharp, size: 20, color: Colors.white),
                onPressed: (){
                  var textEditingController = TextEditingController(text: 'Opción *');
                  controllersRespuesta[index].add(textEditingController);
                  setState(() {});
                }
              ) : const SizedBox(height: 0, width: 0),
              const SizedBox(width: 15),
              _editarEliminar('eliminar', index),
            ],
          ),
          (dataItem['tipo'] == 'a') ? _listOpcionesPregunta(index, dataItem) : const SizedBox(height: 0),
        ],
      )
    );
  }

  Widget _editarEliminar(String tipo, int index){
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: (){
          controllersPreguntas.removeAt(index);
          listDatosPreguntas.removeAt(index);
          controllersRespuesta.removeAt(index);
          setState(() {});
        },
        child: const Icon(CupertinoIcons.delete_solid, size: 20, color: Colors.white)
      ),
    );
  }

  Widget _listOpcionesPregunta(int posicion, Map<String,dynamic> dataItem){

    int respuestaCorrecta = 0;
    if(dataItem.containsKey('resCorrect')){
      respuestaCorrecta = dataItem['resCorrect'];
    } else {
      respuestaCorrecta = 0;
    }

    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controllersRespuesta[posicion].length,
          itemBuilder: (BuildContext context, int index) { 
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Icon(Icons.panorama_fish_eye, color: Colors.white, size: 20),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: TextField(
                      controller: controllersRespuesta[posicion][index],
                      onTap: (){
                        if(controllersRespuesta[posicion][index].text == 'Opción *'){
                          controllersRespuesta[posicion][index].clear();
                        }
                      },
                      textCapitalization: TextCapitalization.sentences,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      decoration: const InputDecoration(
                        border: InputBorder.none
                      ),
                      onChanged: (value){
                        if(!dataItem.containsKey('respuestas')){
                          dataItem.addEntries({
                            'respuestas' : {'Op$index' : controllersRespuesta[posicion][index].text}
                          }.entries);
                          listDatosPreguntas[posicion] = dataItem;
                        } else {
                          Map<String,dynamic> respuestas = dataItem['respuestas'];
                          respuestas.addEntries(
                            {'Op$index' : controllersRespuesta[posicion][index].text}.entries
                          );
                          dataItem['respuestas'] = respuestas;
                          listDatosPreguntas[posicion] = dataItem;
                        }
                      }
                    ),
                  ),
                  Radio(
                    value: index,
                    groupValue: respuestaCorrecta,
                    activeColor: Colors.white,
                    onChanged: (value){
                      setState(() {
                        respuestaCorrecta = index;
                        if(!dataItem.containsKey('resCorrect')){
                          dataItem.addEntries({
                            'resCorrect' : respuestaCorrecta
                          }.entries);
                          listDatosPreguntas[posicion] = dataItem;
                        } else {
                          dataItem.update('resCorrect', (value) => respuestaCorrecta);
                          listDatosPreguntas[posicion] = dataItem;
                        }
                      });
                    },
                  ),
                  Icon(Icons.check, color: (respuestaCorrecta == index) ? Colors.white : const Color.fromRGBO(23, 32, 39, 1), size: 20),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 20),
                    onPressed: (){
                      Map<String,dynamic> respuestas = dataItem['respuestas'];
                      Map<String,dynamic> newOrden = {};
                      respuestas.remove('Op$index');
                      
                      List<dynamic> ordenValues = respuestas.values.toList();
                      for(int j = 0; j < ordenValues.length; j++){
                        newOrden.addEntries({'Op$j' : ordenValues[j]}.entries);
                      }
                      dataItem['respuestas'] = newOrden;
                      listDatosPreguntas[posicion] = dataItem;
                      controllersRespuesta[posicion].removeAt(index);
                      setState(() {});
                    },
                  )
                ]
              )
            );
          },
        );
      }
    );
  }

  void _ventanaCrearCuestionario(BuildContext context){      
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromRGBO(23, 32, 39, 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text (refColeccion.isEmpty ? 'CREAR NUEVO CUESTIONARIO': 'ACTUALIZAR INFORMACIÓN', style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.normal)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 150,
                  width: 150,
                  alignment: AlignmentDirectional.center,
                  child: Text(
                    refColeccion.isEmpty ? 'Agregar nuevo cuestionario a la base de datos.': 'Actualizar la información del cuestionario.', 
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Colors.white)
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: ()=> _crearEvaluacion(),
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
                        child: Text(refColeccion.isEmpty ? 'Crear' : 'Actualizar', style: const TextStyle(color: Colors.white))
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

  void _crearEvaluacion(){

    // DateTime fechaHoy = DateTime.now();
    // String fechaString = '';
    // String horaString = '';
    // String secondStrg = '';

    // if ((fechaHoy.day <= 9) && (fechaHoy.month <= 9)){
    //   fechaString = '${fechaHoy.year}0${fechaHoy.month}0${fechaHoy.day}';
    // } if ((fechaHoy.day <= 9) && (fechaHoy.month >= 10)){
    //   fechaString = '${fechaHoy.year}${fechaHoy.month}0${fechaHoy.day}';
    // } if ((fechaHoy.day >= 10) && (fechaHoy.month <= 9)){
    //   fechaString = '${fechaHoy.year}0${fechaHoy.month}${fechaHoy.day}';
    // } if ((fechaHoy.day >= 10) && (fechaHoy.month >= 10)){
    //   fechaString = '${fechaHoy.year}${fechaHoy.month}${fechaHoy.day}';
    // }

    // if ((fechaHoy.hour <= 9) && (fechaHoy.minute <= 9)){
    //   horaString = '0${fechaHoy.hour}0${fechaHoy.minute}';
    // } if ((fechaHoy.hour <= 9) && (fechaHoy.minute >= 10)){
    //   horaString = '0${fechaHoy.hour}${fechaHoy.minute}';
    // } if ((fechaHoy.hour >= 10) && (fechaHoy.minute <= 9)){
    //   horaString = '${fechaHoy.hour}0${fechaHoy.minute}';
    // } if ((fechaHoy.hour >= 10) && (fechaHoy.minute >= 10)){
    //   horaString = '${fechaHoy.hour}${fechaHoy.minute}';
    // }

    // if (fechaHoy.second <= 9){
    //   secondStrg = '0${fechaHoy.second}';
    // } else {
    //   secondStrg = '${fechaHoy.second}';
    // }

    if(tituloController.text.isNotEmpty && (FirebaseAuth.instance.currentUser != null)){
      
      _esperarRegistro(context);

      String? nombreUser = FirebaseAuth.instance.currentUser!.displayName;

      int auxUbicGuion = nombreUser!.indexOf('-');
      String coleccion = nombreUser.substring(auxUbicGuion + 1, nombreUser.length);

      String idDoc = '';
      if(widget.base == 'Evaluacion'){
        idDoc = 'Evaluaciones';
      } else 
      if(widget.base == 'Encuesta'){
        idDoc = 'Encuestas';
      }
      
      FirebaseFirestore.instance
      .collection('Grupos')
      .doc(coleccion.trim())
      .collection(idDoc)
      .doc(refColeccion.isEmpty ? '${widget.base} - ${tituloController.text.trim()}' : refColeccion)
      .set(
        {
          'IDevaluacion': refColeccion.isEmpty ? '${widget.base} - ${tituloController.text.trim()}' : refColeccion,
          'NumPreg'     : controllersPreguntas.length,
          'Pass'        : passActual.isEmpty ? getRandomString(6) : passActual,
          'Preguntas'   : listDatosPreguntas,
          'Tipo'        : widget.base
        }, SetOptions(merge : true)
      );

      Navigator.pop(context);
      locator<NavigationService>().navigateRemove('/evaluaciones');
    } else {
      mostrarSnakbar('No olvide colocar titulo a su documento', 1500);
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