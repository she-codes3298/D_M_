import 'package:flutter/material.dart';
import 'package:gemini/gemini.dart'; // Import the Gemini API package

class AIChatbotScreen extends StatefulWidget {
  @override
  _AIChatbotScreenState createState() => _AIChatbotScreenState();
}

class _AIChatbotScreenState extends State<AIChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final Gemini _gemini = Gemini(apiKey: 'YOUR_GEMINI_API_KEY'); // Replace with your Gemini API key

  void _sendMessage() async {
    String userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;

    // Add user message to the chat
    setState(() {
      _messages.add({'role': 'user', 'message': userMessage});
    });

    // Clear the input field
    _controller.clear();

    // Send the message to Gemini API
    try {
      final response = await _gemini.generateText(prompt: userMessage);
      setState(() {
        _messages.add({'role': 'bot', 'message': response});
      });
    } catch (e) {
      setState(() {
        _messages.add({'role': 'bot', 'message': 'Error: Failed to fetch response.'});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('E-sahyog Chatbot'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ChatBubble(
                  role: message['role']!,
                  message: message['message']!,
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Write a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String role;
  final String message;

  ChatBubble({required this.role, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: role == 'user' ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: role == 'user' ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: role == 'user' ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}