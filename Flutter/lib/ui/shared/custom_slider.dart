// ignore_for_file: unnecessary_getters_setters

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Slideshow extends StatelessWidget {

  final List<Widget> slides;
  final bool puntosArriba;
  final Color colorPrimario;
  final Color colorSecundario;
  final double bulletPrimario;
  final double bulletSecundario;

  // ignore: use_key_in_widget_constructors
  const Slideshow({
    Key ? key,
    required this.slides,
    this.puntosArriba     = false,
    this.colorPrimario    = Colors.blue,
    this.colorSecundario  = Colors.grey,
    this.bulletPrimario   = 12.0,
    this.bulletSecundario = 12.0,
  });

  
  @override
  Widget build(BuildContext context) {


    return ChangeNotifierProvider(
      create: (_) => _SlideshowModel(),
      child: Center(
        child: Builder(
          builder: (BuildContext context) {

            Provider.of<_SlideshowModel>(context).colorPrimario   = colorPrimario;
            Provider.of<_SlideshowModel>(context).colorSecundario = colorSecundario;
            
            Provider.of<_SlideshowModel>(context).bulletPrimario   = bulletPrimario;
            Provider.of<_SlideshowModel>(context).bulletSecundario = bulletSecundario;
            
            return _CrearEstructuraSlideshow(puntosArriba: puntosArriba, slides: slides);
          },
        )
      ),
    );
    
  }
}

class _CrearEstructuraSlideshow extends StatelessWidget {
  const _CrearEstructuraSlideshow({
    Key ? key,
    required this.puntosArriba,
    required this.slides,
  }) : super(key: key);

  final bool puntosArriba;
  final List<Widget> slides;

  @override
  Widget build(BuildContext context) {
    return _Slides(slides, puntosArriba);
  }
}



// ignore: unused_element
class _Dots extends StatelessWidget {

  final int totalSlides;

  const _Dots( this.totalSlides );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(totalSlides, (i) => _Dot(i) ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
 
  final int index;

  const _Dot( this.index );

  @override
  Widget build(BuildContext context) {

    final ssModel = Provider.of<_SlideshowModel>(context);
    double tamano;
    Color color;
    bool circular;

    if ( ssModel.currentPage >= index - 0.5 && ssModel.currentPage < index + 0.5 ) {
      tamano = ssModel.bulletPrimario;
      color  = ssModel.colorPrimario;
      circular = false;
    } else {
      tamano = ssModel.bulletSecundario;
      color  = ssModel.colorSecundario;
      circular = true;
    }

    return AnimatedContainer(
      duration: const Duration( milliseconds: 200 ),
      width: circular ? tamano : tamano * 4,
      height: tamano,
      margin: const EdgeInsets.symmetric( horizontal: 5 ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(tamano)
      ),
    );
  }
}


class _Slides extends StatefulWidget {

  final List<Widget> slides;
  final bool puntosArriba;

  const _Slides( 
    this.slides,
    this.puntosArriba
  );

  @override
  __SlidesState createState() => __SlidesState();
}

class __SlidesState extends State<_Slides> {

  final pageViewController = PageController();
  // final prefs = PreferenciasUsuario();

  @override
  void initState() { 
    super.initState();
    
    pageViewController.addListener(() {
      Provider.of<_SlideshowModel>(context, listen: false).currentPage = pageViewController.page!;
    });

  }

  @override
  void dispose() { 
    pageViewController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        PageView(
          controller: pageViewController,
          children: widget.slides.map( (slide) => _Slide( slide ) ).toList(),
        ),
        // Align(
        //   alignment: Alignment.bottomCenter,
        //   child: _Dots(widget.slides.length)
        // ),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            onPressed: (){  
              if(pageViewController.page! < (widget.slides.length - 1)){
                pageViewController.nextPage(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.fastLinearToSlowEaseIn
                );
              } else 
              if(pageViewController.page == (widget.slides.length - 1)){
                pageViewController.jumpToPage(0);
              }
            },
            icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white)
          )
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            onPressed: (){
              if(pageViewController.page != 0){
                pageViewController.previousPage(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.fastLinearToSlowEaseIn
                );
              } else 
              if(pageViewController.page == 0){
                pageViewController.jumpToPage(widget.slides.length - 1);
              }
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white)
          )
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: ClipPath(
            clipper: MyClipper(),
            child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              height: 120,
            ),
          )
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            alignment: AlignmentDirectional.center,
            child: FittedBox(
              fit: BoxFit.contain,
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Bienvenido a la Universidad\nIISCH',
                      style: TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold)
                    ),TextSpan(
                      text: '\n\nInformación sobre la institución',
                      style: TextStyle(color: Colors.white, fontSize: 15)
                    ),
                  ]
                )
              ),
            ),
          )
        )
      ],
    );
  }
}

class MyClipper extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {

    Path lineaDibujo = Path()
      ..lineTo(0, 0)
      ..lineTo(0, size.height * 0.1)
      ..lineTo(size.width * 0.5, size.height * 1)
      ..lineTo(size.width, size.height * 0.1)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height);
    return lineaDibujo;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}


// ignore: unused_element
class _BotonAvance extends StatelessWidget {

  final String titulo;
  final VoidCallback funcion;
  final Color color;
  final Color colorLetra;
  final double elevacion;

  const _BotonAvance({
    Key? key,
    required this.titulo,
    required this.funcion,
    required this.color,
    required this.colorLetra,
    this.elevacion = 4
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: ()=> funcion(),
      style: ElevatedButton.styleFrom(
        primary: color, 
        elevation: elevacion,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        )
      ),
      child: Text(titulo, style: TextStyle(color: colorLetra)),
    );
  }
}

class _Slide extends StatelessWidget {
  
  final Widget slide;

  const _Slide( this.slide );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(0),
      child: slide
    );
  }
}



class _SlideshowModel with ChangeNotifier{

  double _currentPage     = 0;
  Color _colorPrimario    = Colors.blue;
  Color _colorSecundario  = Colors.grey;
  double _bulletPrimario   = 12;
  double _bulletSecundario = 12;

  double get currentPage => _currentPage;

  set currentPage( double pagina ) {
    _currentPage = pagina;
    notifyListeners();
  }

  Color get colorPrimario => _colorPrimario;
  set colorPrimario( Color color ) {
    _colorPrimario = color;
  }

  Color get colorSecundario => _colorSecundario;
  set colorSecundario( Color color ) {
    _colorSecundario = color;
  }

  double get bulletPrimario => _bulletPrimario;
  set bulletPrimario( double tamano ) {
    _bulletPrimario = tamano;
  }

  double get bulletSecundario => _bulletSecundario;
  set bulletSecundario( double tamano ) {
    _bulletSecundario = tamano;
  }

}


