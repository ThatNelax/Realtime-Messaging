import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:realtime_messaging/Services/Auth/AuthService.dart';
import 'package:realtime_messaging/Services/Chat/ChatService.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;
  ChatPage({super.key, required this.receiverEmail, required this.receiverID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();

  final ChatService chatService= ChatService();
  late final AuthService authService = AuthService();
  
  FocusNode focusNode = FocusNode();
  
  @override
  void initState() {
    super.initState();
    
    focusNode.addListener(() {
      if(focusNode.hasFocus){
        Future.delayed(const Duration(milliseconds: 200),() => scrollDown(),);
      }
    });
    
    Future.delayed(const Duration(milliseconds: 200), () => scrollDown(),);
  }

  @override
  void dispose() {
    super.dispose();
    
    messageController.dispose();
    focusNode.dispose();
  }
  final ScrollController scrollController = ScrollController();
  
  void scrollDown(){
    scrollController.animateTo(scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
  }
  
  void sendMessage() async{
    if(messageController.text.isNotEmpty){
      await chatService.sendMessage(widget.receiverID, messageController.text);
      
      messageController.clear();
    }
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiverEmail ?? "No Email")),
      body: Column(
        children: [
          Expanded(child: buildMessageList()),
          buildUserInput()
        ],
      ),
    );
  }

  Widget buildMessageList(){
    String senderID = authService.currentUser!.uid;
    return StreamBuilder(stream: chatService.getMessages(widget.receiverID, senderID), builder: (context, snapshot) {
      if(snapshot.hasError){
        return const Text("There are errors");
      }
      if(snapshot.connectionState == ConnectionState.waiting){
        return const Text("Loading");
      }
      
      return ListView(
        controller: scrollController,
        children: snapshot.data!.docs.map((doc) => buildMessageItem(doc)).toList(),
      );
    });
  }

  Widget buildMessageItem(DocumentSnapshot doc){
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    bool isCurrentUser = data['senderID'] == authService.currentUser!.uid;
    var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      
      child: Column(
        crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsetsGeometry.all(5),
              padding: EdgeInsetsGeometry.all(9),
              decoration: BoxDecoration(
                  color: isCurrentUser ? Theme.of(context).colorScheme.primary : Colors.grey,
                  borderRadius: BorderRadius.circular(15)
              ),
              child: Text(data["message"]!.toString(), style: TextStyle(fontSize: 22, color: Colors.white),)),
        ],
      ),
    );
  }

  Widget buildUserInput(){
    return Container(
      padding: const EdgeInsets.only(bottom: 25.0, right: 20, left: 20, top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(child: TextField(
            focusNode: focusNode,
            controller: messageController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Message",
            ),
          )),
          SizedBox(width: 10),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle
            ),
            child: IconButton(
                onPressed: sendMessage, 
                icon: Icon(Icons.send, color: Colors.white,)),
          )
        ],
      ),
    );
  }
}
