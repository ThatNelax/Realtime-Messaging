import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Services/Auth/AuthService.dart';
import '../Theme/themeProvider.dart';
import 'homePage.dart';
import 'loginPage.dart';

class RegisterPage extends StatefulWidget{
  const RegisterPage({super.key});
  @override
  State<StatefulWidget> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage>{
  TextEditingController emailField = TextEditingController();
  TextEditingController passwordField = TextEditingController();

  String errorMessage = "";

  void register() async {
    try{
      await authService.value.createAccount(email: emailField.text, password: passwordField.text);
      
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
    } on FirebaseAuthException catch (e){
      setState(() {
        errorMessage = e.message ?? "There is an error.";
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
      ]),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(padding: EdgeInsetsGeometry.only(bottom: 20), child: Text("Register", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),)),
          Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 10,horizontal: 50), child: TextField(controller: emailField, decoration: InputDecoration(icon: Icon(Icons.person),hintText: "Email", border: UnderlineInputBorder())),),
          Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 10,horizontal: 50), child: TextField(obscureText: true, enableSuggestions: false,
              autocorrect: false,controller: passwordField, decoration: InputDecoration(icon: Icon(Icons.password),hintText: "Password", border: UnderlineInputBorder())),),
          Text(errorMessage),
          SizedBox(width: 20, height: 20),
          SizedBox(width: 200,height: 50, child: 
          FilledButton(
              onPressed: () => register(),
              child: Text("REGISTER", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)
          ),
          ),
          SizedBox(width: 20, height: 20),
          Divider(indent: 40,endIndent: 40,),
          Padding(padding: EdgeInsetsGeometry.symmetric(),
            child: TextButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage())),
                child: Text("Already have an account?",
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