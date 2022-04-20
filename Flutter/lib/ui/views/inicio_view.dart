import 'package:evaluaciones_web/ui/shared/custom_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class InicioView extends StatelessWidget {
  const InicioView({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 0),
      color: Colors.white,
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: [ 
          _slides(context),
          const SizedBox(height: 50),
          _textos(context),
          const SizedBox(height: 20),
          cards(),
          const SizedBox(height: 100),
          _footer(context),
        ],
      )
    );
  }

  Widget _slides(context){
    return Container(
      height: (MediaQuery.of(context).size.width >= 450) ? 650 : 450,
      color: Colors.black,
      padding: const EdgeInsets.all(0),
      child: Slideshow(
        slides: [
          _imagen('assets/jpg/image_slide_a.jpg'),
          _imagen('assets/jpg/image_slide_b.jpg'),
          _imagen('assets/jpg/image_slide_c.jpg'),
        ],
      ),
    );
  }

  Widget _imagen(String path){
    return Image.asset(
      path,
      fit: BoxFit.cover,
    );
  }

  Widget _textos(context){
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Center(
            child: _textModel('¿Qué ofrece la Universidad a sus estudiantes?', true, 18)
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: _textModel(
                'El instituto de Investigaciones Sociales de Chihuahua es una organización productora de cambios e impulsora del bien común y social, además formadora de los perfiles. Teniendo como herramientas el desarrollo de investigaciones sociales, la aplicación de programas de intervención y la concentración de información útil para intervenir en el fenómeno humano.', 
                false, 
                13
              )
            ),
          ),
        ]
      ),
    );
  }

  Widget cards(){
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        _modeloCard(
          'Licenciatura en Ciencia Política',
          'Porpone un modelo fundamentación científica y responsanbilidad social en la educación de nuestros jóvenes, lo que equivale a la ruptura de la dinámica de pasividad y divorcio humano en el que se ha ido insertando la sociedad, propugnar por el interés social y la resolución de los problemas.',
          'assets/svg/Icono_Menu.svg'
        ),
        const SizedBox(width: 30),
        _modeloCard(
          'Licenciatura en Psicología',
          'Porpone un modelo fundamentación científica y responsanbilidad social en la educación de nuestros jóvenes, lo que equivale a la ruptura de la dinámica de pasividad y divorcio humano en el que se ha ido insertando la sociedad, propugnar por el interés social y la resolución de los problemas.',
          'assets/svg/Icono_Paint.svg'
        ),
      ],
    );
  }

  Widget _modeloCard(String titulo, String contenido, String pathImage){
    return Container(
      height: 250,
      width: 190,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SvgPicture.asset(
            pathImage,
            height: 30,
          ),
          _textModel(titulo, false, 12),
          _textModel(contenido, false, 12),
        ]
      ),
    );
  }

  Widget _footer(context){

    double size = MediaQuery.of(context).size.width;

    return Container(
      color: const Color.fromRGBO(23, 32, 39, 1),
      width: double.infinity,
      height: (size >= 630) ? 250 : 365,
      child: _arregloFooter(context),
    );
  }

  Widget _arregloFooter(context){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          const SizedBox(height: 15),
          Row(
            children: [
              Image.asset('assets/jpg/logo_escuela_b.jpeg',
                width: 150,
              ),
            ],
          ),
          const SizedBox(height: 15),
          Wrap(
            children: [
              SizedBox(
                width: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _textModelFooter('Contacto:'),
                    const SizedBox(height: 5),
                    _textModelFooter('Oficinas: 128102391023'),
                    const SizedBox(height: 5),
                    _textModelFooter('Whatsapp: 128102391023'),
                    const SizedBox(height: 5),
                  ]
                ),
              ),
              SizedBox(
                width: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _textModelFooter('Correo:'),
                    const SizedBox(height: 5),
                    _textModelFooter('iisch@outlook.com'),
                  ]
                ),
              ),
              SizedBox(
                width: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _textModelFooter('Dirección:'),
                    _textModelFooter('C. Jesús Garcia #62, Col.'),
                    _textModelFooter('Centro. Hidalgo del Parral,'),
                    _textModelFooter('Chihuahua. CP: 33800'),
                  ]
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              const Spacer(),
              SizedBox(
                width: 200,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _modeloIcono(context, 'assets/svg/Icono_What.svg', 'https://api.whatsapp.com/send?phone=+5216271484552'),
                        _modeloIcono(context, 'assets/svg/Icono_Facebook.svg', 'https://es-la.facebook.com/IISCH/'),
                        _modeloIcono(context, 'assets/svg/Icono_Maps.svg', 'https://www.google.com/maps/place/Instituto+de+Investigaciones+Sociales+de+Chihuahua/@26.935698,-105.667954,16z/data=!4m5!3m4!1s0x0:0xf895178426e10c6d!8m2!3d26.9356979!4d-105.6679538?hl=es-ES'),
                        _modeloIcono(context, 'assets/svg/Icono_Mail.svg', ''),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Contactanos en cualquiera de nuestras redes sociales', 
                      style: TextStyle(color: Colors.white, fontSize: 12),
                      textAlign: TextAlign.center
                    )
                  ],
                ),
              ),
              const SizedBox(width: 20)
            ],
          ),
        ],
      ),
    );
  }

  Widget _textModelFooter(String titulo){
    return Text(
      titulo, 
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15)
    );
  }

  Widget _modeloIcono(context, String pathImage, String url){
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: (){
          if(url.isNotEmpty){
            html.window.open(url,'_blank');
          } else {
            Clipboard.setData(const ClipboardData(text: 'iisch@outlook.com.mx'));
            mostrarSnakbar(context, 'Email copiado al portapapeles.', 1500);
          }
        },
        child: SvgPicture.asset(
          pathImage,
          height: 20,
        ),
      ),
    );
  }

  void mostrarSnakbar(context, String mensaje, int duracion){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color.fromRGBO(186, 66, 69, 0.9),
        content: Text(mensaje),
        duration: Duration(milliseconds: duracion),
      ),
    );
  }

  Widget _textModel(String contenido, bool negrita, double sizeFont){
    return Text(contenido, 
      style: TextStyle(
        fontSize: sizeFont,
        fontWeight: negrita ? FontWeight.bold : FontWeight.normal,
        color: Colors.black,
        overflow: TextOverflow.visible
      ),
      textAlign: TextAlign.center,
    );
  }

}