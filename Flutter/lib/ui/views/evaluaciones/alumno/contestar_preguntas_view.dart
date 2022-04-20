import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evaluaciones_web/providers/variables_globales.dart';
import 'package:evaluaciones_web/services/navigation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../locator.dart';

class ContestarPreguntasView extends StatefulWidget {
  const ContestarPreguntasView({ Key? key }) : super(key: key);
  @override
  _ContestarPreguntasViewState createState() => _ContestarPreguntasViewState();
}

class _ContestarPreguntasViewState extends State<ContestarPreguntasView> {

  List<QueryDocumentSnapshot<Object?>> listDataCuestionario = [];
  TextEditingController controlPass = TextEditingController();
  TextEditingController controlPreguntaAbierta = TextEditingController();

  List<Map<String,dynamic>> listaRespuestas = [];
  List<Map<dynamic,dynamic>> respuestasAlumno = [];
  List<dynamic> preguntasBase = [];
  List<int> respuestasCorrectas = [];
  List<String> tipoPreguntas = [];
  List<String> alumnosRespondieron = [];
  String passActual = '';

  bool passCorrecto = false;
  bool hasRespuestas = true;
  double newValue = 0;
  int currentPregunta = 0;
  double currentRespuestas = 0;

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

      List<QueryDocumentSnapshot<Object?>> alumnosRes = [];

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
        alumnosRespondieron.add(alumnosRes[j].id);
      }


      String? nombreUser = FirebaseAuth.instance.currentUser!.displayName;

      int auxUbicGuion = nombreUser!.indexOf('-');
      String usuario = nombreUser.substring(0, auxUbicGuion).trim();
      String usuarioUID = FirebaseAuth.instance.currentUser!.uid;

      if(alumnosRespondieron.indexWhere((mj) => mj == '$usuario-$usuarioUID') == -1){

        Map<String,dynamic> clavesMap = {};

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
            (clavesMap['Pass']      != null ? passActual = clavesMap['Pass'] : passActual = '');
            (clavesMap['Preguntas'] != null ? preguntasBase = clavesMap['Preguntas'] : preguntasBase = []);
          }
          return null;
        });

        List<Map<int,dynamic>> listaVaciaRespuestasAlumno = List<Map<int,dynamic>>.generate(
          preguntasBase.length, (i) => {i : 1102}
        );

        respuestasAlumno = listaVaciaRespuestasAlumno;

        for(int m = 0; m < preguntasBase.length; m++){
          if(preguntasBase[m]['respuestas'] == null){
            listaRespuestas.add({'Op0' : ''});
          } else {
            listaRespuestas.add(preguntasBase[m]['respuestas']);
          }
        }

        for(int j = 0; j < preguntasBase.length; j++){
          respuestasCorrectas.add(preguntasBase[j]['resCorrect']);
        }

        for(int j = 0; j < preguntasBase.length; j++){
          tipoPreguntas.add(preguntasBase[j]['tipo']);
        }
        hasRespuestas = false;
      } else {
        hasRespuestas = true;
      }

      if(mounted){
        setState(() {});
      }
    }    
  }

  @override
  Widget build(BuildContext context) {
    if(hasRespuestas){
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        alignment: AlignmentDirectional.center,
        child: _textModel('Usted ya ha respondido este cuestionario.', false, 15, Colors.grey),
      );
    } else
    if(passCorrecto){
      return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        // alignment: AlignmentDirectional.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              _titulo(),
              const SizedBox(height: 30),
              _modeloCuestionario(),
            ],
          )
        ),
      );
    } else {
      return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              _titulo(),
              const SizedBox(height: 30),
              _comprobarPass(),
            ],
          )
        ),
      );
    }
  }

  Widget _titulo(){
    return Container(
      height: 65,
      padding: const EdgeInsets.symmetric(horizontal: 25),
      margin: const EdgeInsets.symmetric(horizontal: 15),
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
          _botonGuardar()
        ],
      )
    );
  }

  Widget _comprobarPass(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      height: 180,
      width: 450,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(26, 32, 40, 1),
        borderRadius: BorderRadius.circular(20)
      ),
      alignment: AlignmentDirectional.center,
      child: Column(
        children: [
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _textModel('Ingresa tu contraseña', false, 15, Colors.white),
            ],
          ),
          const SizedBox(height: 15),
          _formPass(),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _boton(),
            ],
          ),
          const Spacer(),
        ],
      )
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

  Widget _modeloCuestionario(){
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 15),
            _textModel('Tu progreso:', true, 14, Colors.black),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            const SizedBox(width: 15),
            _textModel('0%', true, 14, Colors.black),
            const Spacer(),
            _textModel('100%', true, 14, Colors.black),
            const SizedBox(width: 15),
          ],
        ),
        _progreso(),
        const SizedBox(height: 15),
        _modeloCajaPregunta(),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 80),
          child: (tipoPreguntas[currentPregunta] == 'a') ? _cuadricula() : _modeloPreguntaAbierta()
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _botonAvanceRetroceso(
              'Anterior',
              (){
                FocusManager.instance.primaryFocus?.unfocus();
                if(currentPregunta != 0){
                  currentPregunta--;
                  if(tipoPreguntas[currentPregunta] == 'b'){
                    if(respuestasAlumno[currentPregunta][currentPregunta] == 1102){
                      controlPreguntaAbierta.value = const TextEditingValue(text: '');
                    } else {
                      controlPreguntaAbierta.value = TextEditingValue(text: respuestasAlumno[currentPregunta][currentPregunta]);
                    }
                  }
                  setState(() {});
                }
              }
            ),
            _botonAvanceRetroceso(
              'Siguiente',
              (){
                FocusManager.instance.primaryFocus?.unfocus();
                if(preguntasBase.length != currentRespuestas){
                  if(currentPregunta < (preguntasBase.length - 1)){
                    currentPregunta++;
                    if(tipoPreguntas[currentPregunta] == 'b'){
                      if(respuestasAlumno[currentPregunta][currentPregunta] == 1102){
                        controlPreguntaAbierta.value = const TextEditingValue(text: '');
                      } else {
                        controlPreguntaAbierta.value = TextEditingValue(text: respuestasAlumno[currentPregunta][currentPregunta]);
                      }
                    }
                    setState(() {});
                  }
                } else {
                  mostrarSnakbar('Usted ha respondido todas las preguntas.', 2000);
                }
              }
            ),
          ]
        ),
        const SizedBox(height: 15),
      ]
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

  Widget _modeloPreguntaAbierta(){
    return Container(
      height: 230,
      width: 450,
      alignment: AlignmentDirectional.center,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black54.withOpacity(0.2),
            offset: const Offset(0, 0),
            spreadRadius: 2,
            blurRadius: 5
          )
        ]
      ),
      child:TextFormField(
        decoration: const InputDecoration(
          errorStyle: TextStyle(fontSize: 10),
          filled: true,
          contentPadding: EdgeInsets.only(left: 14.0, bottom: 10.0, top: 10.0),
          // border: InputBorder.none,
          fillColor: Colors.transparent
        ),
        maxLines: 8,
        style: const TextStyle(fontSize: 14),
        controller: controlPreguntaAbierta,
        onChanged: (String valor){
          respuestasAlumno[currentPregunta].update(currentPregunta, (value) => valor);
          currentRespuestas = 0;
          for(int m = 0; m < respuestasAlumno.length; m++){
            if(respuestasAlumno[m][m] != 1102){
              currentRespuestas = currentRespuestas + 1;
            }
          }
          setState(() {});
        },
      )
    );
  }

  Widget _modeloCajaPregunta(){
    return Container(
      height: 400,
      width: MediaQuery.of(context).size.width * 0.75,
      alignment: AlignmentDirectional.center,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black54.withOpacity(0.2),
            offset: const Offset(0, 0),
            spreadRadius: 2,
            blurRadius: 5
          )
        ]
      ),
      child: _textModel(preguntasBase[currentPregunta]['pregunta'], true, 20, Colors.grey)
    );
  }

  Widget _cuadricula(){

    List<Widget> auxPreguntas = List<Widget>.generate(
      listaRespuestas[currentPregunta].length, (index) => _modeloTarjetas(listaRespuestas[currentPregunta]['Op$index'], index)
    );

    if(listaRespuestas.isNotEmpty){
      return Wrap(
        alignment: WrapAlignment.center,

        children: auxPreguntas,
      );
    } else {
      return const SizedBox();
    }
  }

  Widget _modeloTarjetas(String titulo, int index){

    Color fondo = const Color.fromRGBO(59, 60, 82, 1);

    if(index == respuestasAlumno[currentPregunta][currentPregunta]){
      fondo = const Color.fromRGBO(76, 217, 96, 1);
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: (){
          respuestasAlumno[currentPregunta].update(currentPregunta, (value) => index);
          currentRespuestas = 0;
          for(int m = 0; m < respuestasAlumno.length; m++){
            if(respuestasAlumno[m][m] != 1102){
              currentRespuestas = currentRespuestas + 1;
            }
          }
          setState(() {});
        },
        child: Container(
          height: 50,
          width: 230,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          alignment: AlignmentDirectional.center,
          decoration: BoxDecoration(
            color: fondo,
            borderRadius: BorderRadius.circular(8),
          ),
          child: _textModel(titulo, false, 13, Colors.white)
        ),
      ),
    );
  }

  Widget _progreso(){
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            height: 10,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10)
            ),
          ),
          Slider(
            value: currentRespuestas, 
            divisions: preguntasBase.isEmpty ? 1 : preguntasBase.length,
            min: 0,
            max: preguntasBase.isEmpty ? 1 : preguntasBase.length.toDouble(),
            activeColor: Colors.grey.shade300,
            inactiveColor: Colors.grey.shade300,
            thumbColor: const Color.fromRGBO(23, 139, 246, 1),
            onChanged: (valor){
              // setState(() {
              //   newValue = valor;
              // });
            }
          ),
        ],
      ),
    );
  }

  Widget _botonGuardar(){
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: ()=> guardarRespuestas(),
        child: Container(
          height: 30,
          alignment: AlignmentDirectional.center,
          width: 80,
          decoration: BoxDecoration(
            color: (currentRespuestas == preguntasBase.length) ? const Color.fromRGBO(23, 139, 246, 1) : Colors.grey,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text('Guardar', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal))
        ),
      ),
    );
  }

  void guardarRespuestas(){

    if(currentRespuestas == preguntasBase.length){
      
      _esperarRegistro(context);

      String? nombreUser = FirebaseAuth.instance.currentUser!.displayName;

      int auxUbicGuion = nombreUser!.indexOf('-');
      String usuario = nombreUser.substring(0, auxUbicGuion).trim();
      String usuarioUID = FirebaseAuth.instance.currentUser!.uid;

      final modeloDatos = Provider.of<VariablesGlobalesProvider>(context, listen: false);
      String evalucionEncuesta = '';

      if(modeloDatos.referenciaContestar.contains('Evaluacion')){
        evalucionEncuesta = 'Evaluaciones';
      } else 
      if(modeloDatos.referenciaContestar.contains('Encuesta')){
        evalucionEncuesta = 'Encuestas';
      }

      List<dynamic> respuestasDB = [];

      for(int mj = 0; mj < respuestasAlumno.length; mj++){
        respuestasDB.add(respuestasAlumno[mj][mj]);
      }

      FirebaseFirestore.instance
      .collection('Grupos')
      .doc(modeloDatos.coleccionReferen)
      .collection(evalucionEncuesta)
      .doc(modeloDatos.referenciaContestar)
      .collection('Respuestas')
      .doc('$usuario-$usuarioUID')
      .set(
        {
          'idDoc' : '$usuario-$usuarioUID',
          'resps' : respuestasDB,
          'finis' : 1
        }, SetOptions(merge : true)
      );

      Navigator.pop(context);
      locator<NavigationService>().navigateRemove('/evaluaciones');
    } else {
      mostrarSnakbar('Faltan preguntas por responder.', 1500);
    }
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

  Widget _boton(){
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if(controlPass.text == passActual){
            passCorrecto = true;
            setState(() {});
          } else {
            mostrarSnakbar('Contraseña incorrecta.', 1500);
          }
        },
        child: Container(
          height: 40,
          alignment: AlignmentDirectional.center,
          width: 140,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(23, 139, 246, 1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Text('Ir al examen', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.normal))
        ),
      ),
    );
  }

  Widget _botonAvanceRetroceso(String titulo, Function onpress){
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: (){
          if((titulo == 'Anterior') | (respuestasAlumno[currentPregunta][currentPregunta] != 1102)){
            onpress();
          }
        },
        child: Container(
          height: 40,
          alignment: AlignmentDirectional.center,
          width: 140,
          decoration: BoxDecoration(
            color: ((respuestasAlumno[currentPregunta][currentPregunta] == 1102) && (titulo == 'Siguiente')) ? Colors.grey : const Color.fromRGBO(23, 139, 246, 1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(titulo, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.normal))
        ),
      ),
    );
  }

  Widget _textModel(String contenido, bool negrita, double sizeFont, Color color){
    return Text(contenido, 
      style: TextStyle(
        fontSize: sizeFont,
        fontWeight: negrita ? FontWeight.normal : FontWeight.normal,
        color: color,
        overflow: TextOverflow.visible
      )
    );
  }
}