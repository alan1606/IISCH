import 'package:flutter/material.dart';


class NavigationService {
  
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future navigateTo( String routeName ) {
    return navigatorKey.currentState!.pushNamed( routeName );
  }

  Future navigateRemove( String routeName ){
    return navigatorKey.currentState!.pushReplacementNamed(routeName);
  }

  void goBack( String routeName ) {
    return navigatorKey.currentState!.pop();
  }

}

