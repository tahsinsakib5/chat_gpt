import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
class ChatScrean extends StatefulWidget {
  const ChatScrean({super.key});

  @override
  State<ChatScrean> createState() => _ChatScreanState();
}

  var chatgptapikeys ="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";

  final _openapi =OpenAI.instance.build(token:chatgptapikeys,baseOption:HttpSetup(
    receiveTimeout: Duration(seconds:5)
  ),
  enableLog:true,
  );


  final ChatUser curentuser = ChatUser(id: "1",firstName: "tahsin",lastName: "sakib");
  final ChatUser gptchatuser = ChatUser(id: "1",firstName: "chat",lastName: "gpt");

   List<ChatMessage> MessageList = <ChatMessage>[];

class _ChatScreanState extends State<ChatScrean> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:DashChat(currentUser:curentuser, onSend:(ChatMessage m) {
        message(m);
      }, messages: MessageList),
    );
  }
  Future<void> message(ChatMessage m)async{
    setState(() {
      MessageList.insert(0,m);
    });
    List<Messages> Messagehistory = MessageList.map((m) {
      if(m.user == curentuser){
        return Messages(role: Role.user,content:m.text);
      }else{
        return  Messages(role: Role.assistant,content:m.text);
      }
    }).toList();

    final request = ChatCompleteText(model:Gpt40314ChatModel(), messages:Messagehistory,maxToken:200);
   final response = await  _openapi.onChatCompletion(request: request);
   for(var elament in response!.choices){
    if(elament.message!=null){
     setState(() {
       MessageList.insert(0,ChatMessage(user:gptchatuser, createdAt:DateTime.now(),text:elament.message!.content));
     });
    }
   }
  }


  
}