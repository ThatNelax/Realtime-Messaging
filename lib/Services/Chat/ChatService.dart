import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:realtime_messaging/Services/Auth/AuthService.dart';
import 'package:realtime_messaging/Services/Chat/Message.dart';

class ChatService{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  
  Stream<List<Map<String, dynamic>>> getUsersStream(){
    return firestore.collection("Users").snapshots().map((snapshot){
      return snapshot.docs.map((doc){
        final user = doc.data();
        
        return user;
     }).toList();
    });
  }
  Stream<List<Map<String, dynamic>>> getContactStream() {
    final String currentUserID = authService.value.currentUser!.uid;

    return firestore
        .collection("Users")
        .doc(currentUserID)
        .collection("contacts")
        .snapshots()
        .asyncMap((snapshot) async {

      List<Map<String, dynamic>> contactDataList = [];

      for (var doc in snapshot.docs) {
        final contactID = doc.data()['contactID'] as String; 

        final userDoc = await firestore
            .collection("Users")
            .doc(contactID)
            .get();

        if (userDoc.exists) {
          contactDataList.add(userDoc.data()!);
        }
      }

      return contactDataList;
    });
  }
  Future<void> addContactByEmail(String contactEmail) async {
    final String currentUserEmail = authService.value.currentUser!.email!;
    final String currentUserID = authService.value.currentUser!.uid;

    if (contactEmail == currentUserEmail) {
      throw Exception("Cannot add yourself as a contact.");
    }

    final usersSnapshot = await firestore
        .collection("Users")
        .where("email", isEqualTo: contactEmail)
        .limit(1)
        .get();

    if (usersSnapshot.docs.isEmpty) {
      throw Exception("User with email $contactEmail not found.");
    }

    final String contactUserID = usersSnapshot.docs.first.id;

    final batch = firestore.batch();

    final currentUserContactRef = firestore
        .collection("Users")
        .doc(currentUserID)
        .collection("contacts")
        .doc(contactUserID);

    batch.set(currentUserContactRef, {
      'contactID': contactUserID,
    });

    final reciprocalContactRef = firestore
        .collection("Users")
        .doc(contactUserID)
        .collection("contacts")
        .doc(currentUserID);

    batch.set(reciprocalContactRef, {
      'contactID': currentUserID,
    });

    await batch.commit();
  }
  
  Future<void> sendMessage(String receiverID, message)async{
    final String currentUserID = authService.value.currentUser!.uid;
    final String currentUserEmail = authService.value.currentUser!.email!;
    final Timestamp timeStamp = Timestamp.now();
    
    Message newMessage = Message(senderID: currentUserID, senderEmail: currentUserEmail, receiverID: receiverID, message: message, timestamp: timeStamp);
    
    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');
    
    await firestore.collection("chat_rooms").doc(chatRoomID).collection("messages").add(newMessage.toMap());
  }
  
  Stream<QuerySnapshot> getMessages(String userID, otherUserID){
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');
    
    return firestore.collection("chat_rooms").doc(chatRoomID).collection("messages").orderBy("timestamp", descending: false).snapshots();
  }
}