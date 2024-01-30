import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class ChatMessage {
  final String text;
  final bool isMe;
  final String imageUrl;

  ChatMessage({required this.text, required this.isMe, this.imageUrl = ""});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [];

  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _handleSubmitted(String text) {
    _textController.clear();

    setState(() {
      _messages.add(ChatMessage(text: text, isMe: true));
      // Simulating a reply from someone else after a delay
      Future.delayed(Duration(seconds: 1), () {
        _messages.add(ChatMessage(
          text: 'Hello! How can I help you?',
          isMe: false,
        ));
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    });
  }

  void _handleImageSelected(String imageUrl) {
    setState(() {
      _messages.add(ChatMessage(text: "", isMe: true, imageUrl: imageUrl));
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Widget _buildMessage(ChatMessage message) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment:
            message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          message.imageUrl.isEmpty
              ? Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: message.isMe ? Colors.blue : Colors.green,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : Image.network(
                  message.imageUrl,
                  height: 150.0,
                  width: 150.0,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessage(_messages[index]);
              },
            ),
          ),
          Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration:
                    InputDecoration.collapsed(hintText: 'Send a message'),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () => _handleSubmitted(_textController.text),
            ),
            IconButton(
              icon: Icon(Icons.image),
              onPressed: () => _selectImage(),
            ),
          ],
        ),
      ),
    );
  }

  void _selectImage() async {
    // Replace this with your image selection logic (e.g., image picker)
    String imageUrl = "https://placekitten.com/200/300"; // Example image URL
    _handleImageSelected(imageUrl);
  }
}
