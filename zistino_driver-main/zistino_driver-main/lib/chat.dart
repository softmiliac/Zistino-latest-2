import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatService {
  final WebSocketChannel channel;
  final String username;

  ChatService(this.username, String url) : channel = IOWebSocketChannel.connect(url);

  void sendMessage(String message) {
    channel.sink.add(jsonEncode({
      'username': username,
      'message': message,
    }));
  }

  void dispose() {
    channel.sink.close();
  }
}

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatService? _chatService;
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _chatService = ChatService('User1', 'ws://echo.websocket.org');
    _chatService?.channel.stream.listen((message) {
      setState(() {
        _messages.add(jsonDecode(message));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${_messages[index]['username']}: ${_messages[index]['message']}'),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                  ),
                ),
                ElevatedButton(
                  child: Text('Send'),
                  onPressed: () {
                    _chatService?.sendMessage(_controller.text);
                    _controller.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _chatService?.dispose();
    super.dispose();
  }
}
