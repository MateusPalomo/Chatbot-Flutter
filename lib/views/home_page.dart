import 'package:chatbot/models/chat_message.dart';
import 'package:chatbot/widgets/chat_message_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:intl/intl.dart';
import 'package:timezone/standalone.dart';
import 'package:timezone/timezone.dart';


class HomePage extends StatefulWidget {
  
  @override
  _HomePageState createState() => _HomePageState();
  
}

class _HomePageState extends State<HomePage> {
   
  static const double messageBoxWidth = 200.0;
  static const double messageBoxHeight = 50.0;
  final _messageList = <ChatMessage>[];
  final _controllerText = new TextEditingController();

   static var now = DateTime.now();
   static var _currentDate = DateFormat('HH:mm').format(now);

   Future<void> setup() async {
  await initializeTimeZone();
  final detroit = getLocation('America/Detroit');
  setLocalLocation(detroit);
  final now = new TZDateTime.now(detroit);
  print(now.toString());
}

void dispose() {
    
    super.dispose();
    _controllerText.dispose();
  }

  @override
  
  Widget build(BuildContext context) {
    
    return Container(
      
      decoration: BoxDecoration(
        
            image: DecorationImage(

                image: AssetImage("assets/background.jpg"), fit: BoxFit.fill)),
    child: Scaffold(
      backgroundColor: Colors.white12,
      appBar: new AppBar(
        title: Text('ChatBot' ),
      ),
      body: Column(
        children: <Widget>[
          _buildList(),
          Divider(height: 1.0),
          _buildUserInput(),
        ],
      ),
    ),
  
    );
  }

  // Cria a lista de mensagens (de baixo para cima)
  Widget _buildList() {
    return Flexible(
      
      child: ListView.builder(
        
        padding: EdgeInsets.all(8.0),
        reverse: true,
        itemBuilder: (_, int index) => ChatMessageListItem(chatMessage: _messageList[index]),
        itemCount: _messageList.length,
      ),
    );
  }

  Future _dialogFlowRequest({String query}) async {
    // Adiciona uma mensagem temporária na lista
    _addMessage(
        name: 'Wiley',
        text: 'Escrevendo...',
        type: ChatMessageType.received);

    // Faz a autenticação com o serviço, envia a mensagem e recebe uma resposta da Intent
    AuthGoogle authGoogle = await AuthGoogle(fileJson: "assets/credentials.json").build();
    Dialogflow dialogflow = Dialogflow(authGoogle: authGoogle, language: "pt-BR");
    AIResponse response = await dialogflow.detectIntent(query);

    // remove a mensagem temporária
    setState(() {
      _messageList.removeAt(0);
    });

    // adiciona a mensagem com a resposta do DialogFlow
    _addMessage(
        name: 'Wiley',
        text: response.getMessage() ?? '',
        type: ChatMessageType.received);
  }

  // Envia uma mensagem com o padrão a direita
  void _sendMessage({String text}) {
    _controllerText.clear();
    _addMessage(name: 'Mateus' , text: text, type: ChatMessageType.sent);
  }

  // Adiciona uma mensagem na lista de mensagens
  void _addMessage({String name, String text, ChatMessageType type}) {
    var message = ChatMessage(
        text: text , name: name, type: type);
    setState(() {
      _messageList.insert(0, message);
    });

    if (type == ChatMessageType.sent) {
      // Envia a mensagem para o chatbot e aguarda sua resposta
      _dialogFlowRequest(query: message.text);  
    }
  }

  // Campo para escrever a mensagem
  Widget _buildTextField() {
    return new Flexible(
      child: Container(
        height: 49,
        decoration: BoxDecoration(color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(70)),
        ),
      child: new TextField(
                  controller: _controllerText,
                decoration: InputDecoration(
                    
                    border: OutlineInputBorder(
                      
                      borderRadius: BorderRadius.all(Radius.circular(70.0)),
                    
                      borderSide: BorderSide(color: Colors.white24)
                    ),

                    hintStyle: TextStyle(color: Colors.black87, fontSize: 18),
                    fillColor: Colors.white24,
                    hintText: 'Enviar mensagem'),
              ),
      ),
    );
  }

  // Botão para enviar a mensagem
  Widget _buildSendButton() {
    return new Container(
      margin: new EdgeInsets.only(left: 8.0),
      child: new IconButton(
          icon: new Icon(Icons.send, color: Theme.of(context).accentColor),
          onPressed: () {
            if (_controllerText.text.isNotEmpty) {
              _sendMessage(text: _controllerText.text);
               print(new DateTime.now().hour);
            }
          }),
    );
  }


  // Monta uma linha com o campo de text e o botão de enviao
  Widget _buildUserInput() {
    return Container(
      height: 60,
      color: Colors.black12,
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildTextField(),
          _buildSendButton(),
        ],
      ),
    );
  }
}
