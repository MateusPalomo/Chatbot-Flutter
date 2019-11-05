import 'package:chatbot/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:clippy_flutter/message.dart';
import 'package:intl/intl.dart';

class ChatMessageListItem extends StatelessWidget {
  static const double messageBoxWidth = 200.0;
  static const double messageBoxHeight = 80.0;
  static var now = DateTime.now();
  static var _currentDate = DateFormat('HH:mm').format(now);
   
  final ChatMessage chatMessage;

  ChatMessageListItem({this.chatMessage});

  @override
  Widget build(BuildContext context) {
    
    return chatMessage.type == ChatMessageType.sent
        ? _showSentMessage()
        : _showReceivedMessage();
  }
  Widget _showSentMessage({EdgeInsets padding, TextAlign textAlign}) {
    return Container(
      margin: new EdgeInsets.only(left: 60.0,top: 20),
      child:Message(
              
              triangleX1: 1.4 * messageBoxWidth,
              triangleX2: 1.5 * messageBoxWidth,
              triangleX3: 1.5 * messageBoxWidth,
              triangleY1: messageBoxHeight * 0.14,
              clipShadows: [ClipShadow(color: Colors.black)],
              child: Container(
                color: Color.fromRGBO(191, 229, 164, 10),
                width: messageBoxWidth,
                height: messageBoxHeight,
              child: ListTile(
      contentPadding: EdgeInsets.fromLTRB(64.0, 0.0, 8.0, 0.0),
      trailing: CircleAvatar(child: Text(chatMessage.name.toUpperCase()[0])),
      title: Text('$_currentDate                       ' + chatMessage.name, textAlign: TextAlign.right,style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16.5),),
      subtitle: Text(chatMessage.text, textAlign: TextAlign.right,style: TextStyle(fontSize: 18.9),),
      
     
    ),
              ),
      ),
      
    );
  }

  

    Widget _showReceivedMessage() {

    return Container(
      margin: new EdgeInsets.only(right: 60.0,),
      child:DecoratedBox(
        
              decoration: BoxDecoration(
                
                color:Colors.white70,
                    borderRadius: BorderRadius.circular(10.0),
              ),
              
      child: ListTile(
      contentPadding: EdgeInsets.fromLTRB(8.0, 0.0, 64.0, 0.0),
      leading: CircleAvatar(child: Text(chatMessage.name.toUpperCase()[0])),
      title: Text(chatMessage.name, textAlign: TextAlign.left,style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16.5),),
      subtitle: Text(chatMessage.text, textAlign: TextAlign.left,style: TextStyle(fontSize: 18.9),),
    ),
      ),   
      
    );
  }
}
