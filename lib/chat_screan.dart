import 'package:chatapp/api_consts.dart';
import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ChatScrean extends StatefulWidget {
  const ChatScrean({super.key});

  @override
  State<ChatScrean> createState() => _ChatScreanState();
}

final ChatUser curentuser =
    ChatUser(id: "1", firstName: "tahsin", lastName: "sakib");
final ChatUser gptchagggtuser =
    ChatUser(id: "2", firstName: "chat", lastName: "gpt");

List<ChatMessage> messageList = <ChatMessage>[];

class _ChatScreanState extends State<ChatScrean> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: DashChat(
                currentUser: curentuser,
                onSend: (ChatMessage m) {
                  message(m);
                },
                messages: messageList),
          ),
          ElevatedButton(
              onPressed: () async {
                String botReply =
                    await getReplyFromAI(msg: 'Capital of Bangladesh!');

                print(botReply);
              },
              child: Text('Send'))
        ],
      ),
    );
  }

  //Send Message fct
  Future<String> getReplyFromAI({
    required String msg,
  }) async {
    final url = Uri.parse('$baseUrl/v1/chat/completions');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    var body = jsonEncode({
      "model": "gpt-3.5-turbo",
      "messages": [
        {"role": "user", "content": msg}
      ],
      "temperature": 0.7
    });

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      // Decode the response body bytes using utf8.decode
      String responseBody = utf8.decode(response.bodyBytes);

      Map jsonResponse = jsonDecode(responseBody);
      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse['error']['message']);
      }

      late String messageContent;
      if (jsonResponse['choices'].length > 0) {
        messageContent = jsonResponse['choices'][0]['message']['content'];
        // print(messageContent);
        // print("Response messege is: $messageContent");
      }
      return messageContent;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> message(ChatMessage m) async {
    setState(() {
      messageList.insert(0, m);
    });
  }
}
