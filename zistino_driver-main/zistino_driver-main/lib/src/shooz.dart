import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class CryptoCurrencyPage extends StatefulWidget {
  @override
  _CryptoCurrencyPageState createState() => _CryptoCurrencyPageState();
}

class _CryptoCurrencyPageState extends State<CryptoCurrencyPage> {
  WebSocketChannel? _channel;
  Map<String, dynamic>? _data;

  @override
  void initState() {
    super.initState();
    _channel = IOWebSocketChannel.connect("wss://ws.coincap.io/prices?assets=bitcoin");
    _channel?.stream.listen((data) {
      setState(() {
        _data = json.decode(data);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cryptocurrency'),
      ),
      body: _data == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _data?.keys.length,
        itemBuilder: (context, index) {
          final currency = _data?.keys.elementAt(index);
          return ListTile(
            title: Text(currency ?? ''),
            subtitle: Text(_data?[currency].toString() ?? ''),
          );
        },
      ),
    );
  }
}
