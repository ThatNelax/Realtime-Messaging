import 'package:flutter/material.dart';
import 'package:realtime_messaging/Services/Auth/AuthService.dart';
import '../../Pages/homePage.dart';
import '../../Pages/loadingPage.dart';
import '../../Pages/loginPage.dart';

class AuthLayout extends StatelessWidget{
  const AuthLayout ({super.key, this.pageIsNotConnected});

  final Widget? pageIsNotConnected;
  
  @override
  Widget build(BuildContext context){
    return ValueListenableBuilder(
        valueListenable: authService, 
        builder: (context, authService, child) {
          return StreamBuilder(stream: authService.authStateChanges, builder: (context, snapshot) {
            Widget widget;
            
            if(snapshot.connectionState == ConnectionState.waiting) {
              widget = const LoadingPage();
            } else if (snapshot.hasData) {
              widget = const HomePage();
            } else {
              widget = pageIsNotConnected ?? const LoginPage();
            }
            
            return widget;
          },
          );
        },
    );
  }
}