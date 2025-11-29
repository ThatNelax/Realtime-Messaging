import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtime_messaging/Services/Chat/ChatService.dart';
import '../Services/Auth/AuthService.dart';
import '../Theme/themeProvider.dart';
import 'chatPage.dart';
import 'loginPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ChatService chatService = ChatService();
  TextEditingController addContactField = TextEditingController();
  void logout() async {
    try {
      await authService.value.signOut();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
    } on FirebaseAuthException catch(e){
      print(e.message);
    }
  }
  
  @override
  Widget build(BuildContext context) {

    
    return Scaffold(
      appBar: AppBar(
        title: Text("Messages"), 
        actions: [
          IconButton(onPressed: addContact, icon: Icon(Icons.add)),
          Switch(
              value: Provider.of<ThemeProvider>(context, listen:false).isDarkMode,
              onChanged: (value) => setState(() {
                Provider.of<ThemeProvider>(context, listen:false).toggleTheme();
              }) ),
        IconButton(onPressed: logout, icon: Icon(Icons.logout)),
      ],),
      body: buildUserList() 
    );
  }
  
  void addContact(){
    showDialog(context: context, builder: (context) => AlertDialog(
      title: const Text("Add Contact"),
      content: TextField(controller: addContactField, decoration: InputDecoration(hintText: "User Email"),),
      actions: [
        TextButton(onPressed: tryAddContact, child: Text("Add"))
      ],
    ));
  }
 
  void tryAddContact(){
    chatService.addContactByEmail(addContactField.text);
    Navigator.pop(context);
  }
  
  Widget buildUserList(){
    return StreamBuilder(stream: chatService.getContactStream(), 
        builder: (context, snapshot) {
          if(snapshot.hasError){
            return const Text("Error");
          } 
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Text("Loading");
          }
          return ListView(
            children: snapshot.data!.map<Widget>((userData) => buildUserListItem(userData, context)).toList(),
          );
        });
  }
  
  Widget buildUserListItem(Map<String, dynamic> userData, BuildContext context){
    if(userData["email"] != authService.value.currentUser!.email){
      return UserTile(
        text: userData["email"],
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(receiverEmail: userData["email"], receiverID: userData["uid"],))),
      );
    } else return Container();
  }
}

class UserTile extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  const UserTile({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsetsGeometry.all(20),
        padding: EdgeInsetsGeometry.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(12)
        ),
        child: Row(
          children: [
            Icon(Icons.person_2),
            const SizedBox(width: 80,),
            Text(text)
          ],
        ),
      ),
    );
  }
}
