import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtime_messaging/Pages/registerPage.dart';
import '../Services/Auth/AuthService.dart';
import '../Theme/themeProvider.dart';
import 'homePage.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({super.key});
  @override
  State<StatefulWidget> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage>{
  TextEditingController emailField = TextEditingController();
  TextEditingController passwordField = TextEditingController();
  
  String errorMessage = "";

  void tryToLogin() async {
    try{
      await authService.value.signIn(email: emailField.text, password: passwordField.text);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
    }on FirebaseAuthException catch(e){
      setState(() {
        errorMessage = e.message ?? "There is an error with login.";
      });
    }
  }
  
  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Switch(
              value: Provider.of<ThemeProvider>(context, listen:false).isDarkMode, 
              onChanged: (value) => setState(() {
                Provider.of<ThemeProvider>(context, listen:false).toggleTheme();
              }) )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(padding: EdgeInsetsGeometry.only(bottom: 20), child: Text("Login", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Theme.of(context).colorScheme.onSurface),)),
          Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 10,horizontal: 50), child: TextField(controller: emailField, decoration: InputDecoration(icon: Icon(Icons.person),hintText: "Email", border: UnderlineInputBorder())),),
          Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 10,horizontal: 50), child: TextField(obscureText: true, enableSuggestions: false,
              autocorrect: false,controller: passwordField, decoration: InputDecoration(icon: Icon(Icons.password),hintText: "Password", border: UnderlineInputBorder())),),
          Text(errorMessage),
          SizedBox(width: 20, height: 20),
          SizedBox(width: 200,height: 50, child: 
          FilledButton(
              onPressed: () => tryToLogin(),
              child: Text("LOGIN", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)
          ),
          ),
          SizedBox(width: 20, height: 20),
          Divider(indent: 40,endIndent: 40),
          Padding(padding: EdgeInsetsGeometry.symmetric(),
            child: TextButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RegisterPage())),
                child: Text("Don't have an account ?",
                  style: TextStyle(
                    fontSize: 17,
                    decoration: TextDecoration.underline,
                    decorationColor: Theme.of(context).colorScheme.primary
                  )
                  ,)
            ),
          )
        ],
      ),
    );
  }
}