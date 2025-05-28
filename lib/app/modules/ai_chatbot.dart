import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart'; // For Gemini API
import 'package:dash_chat_2/dash_chat_2.dart'; // For chat UI
import 'package:image_picker/image_picker.dart'; // For image upload
import 'dart:convert'; // For base64 encoding
import 'dart:io'; // For File operations

class AIChatbotScreen extends StatefulWidget {
  const AIChatbotScreen({super.key});

  @override
  _AIChatbotScreenState createState() => _AIChatbotScreenState();
}

class _AIChatbotScreenState extends State<AIChatbotScreen> {
  final ChatUser _user = ChatUser(id: '1', firstName: 'User');
  final ChatUser _bot = ChatUser(id: '2', firstName: 'E-sahyog');
  final List<ChatMessage> _messages = [];
  final ImagePicker _picker = ImagePicker();
  bool _isTyping = false;

  final List<String> _customPrompts = [
    "How to manage an earthquake response?",
    "Steps to handle a flood?",
    "How to set up shelters for cyclone victims?",
    "What are the SOS alert protocols?",
    "How to update refugee center data?",
    "Best practices for medical records?",
    "How to distribute relief supplies?",
    "Guidelines for rescue team deployment?",
    "Tracking real-time disaster updates?",
    "How to improve emergency communication?",
  ];

  bool _showPrompts = true;

  void _sendMessage(ChatMessage message) async {
    setState(() {
      _messages.insert(0, message);
      _showPrompts = false;
      _isTyping = true;
    });

    try {
      final response = await Gemini.instance.text(message.text);
      setState(() {
        _messages.insert(
          0,
          ChatMessage(
            user: _bot,
            text: response?.output ?? 'No response received',
            createdAt: DateTime.now(),
          ),
        );
        _isTyping = false;
      });
    } catch (e) {
      setState(() {
        _messages.insert(
          0,
          ChatMessage(
            user: _bot,
            text: 'Error: ${e.toString()}',
            createdAt: DateTime.now(),
          ),
        );
        _isTyping = false;
      });
    }
  }

  Future<void> _sendImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final bytes = await File(image.path).readAsBytes();

    setState(() {
      _messages.insert(
        0,
        ChatMessage(
          user: _user,
          createdAt: DateTime.now(),
          medias: [
            ChatMedia(
              url: image.path,
              fileName: "image.jpg",
              type: MediaType.image,
            ),
          ],
        ),
      );
      _isTyping = true;
    });

    try {
      final response = await Gemini.instance.textAndImage(
        text: "Describe this image in detail",
        images: [bytes], // Changed from File to Uint8List
      );

      setState(() {
        _messages.insert(
          0,
          ChatMessage(
            user: _bot,
            text: response?.output ?? 'No description available',
            createdAt: DateTime.now(),
          ),
        );
        _isTyping = false;
      });
    } catch (e) {
      setState(() {
        _messages.insert(
          0,
          ChatMessage(
            user: _bot,
            text: 'Error processing image: ${e.toString()}',
            createdAt: DateTime.now(),
          ),
        );
        _isTyping = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Sahyog', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.grey[900],
      body: Stack(
        children: [
          DashChat(
            currentUser: _user,
            messages: _messages,
            typingUsers: _isTyping ? [_bot] : [],
            messageOptions: MessageOptions(
              containerColor: const Color.fromARGB(255, 66, 66, 66),
              textColor: Colors.white,
              currentUserContainerColor: Colors.blue,
            ),
            inputOptions: InputOptions(
              inputTextStyle: const TextStyle(color: Colors.white),
              inputDecoration: InputDecoration(
                fillColor: Colors.black,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.grey, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.grey, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.white, width: 2),
                ),
                hintText: 'Type your message...',
                hintStyle: const TextStyle(color: Colors.grey),
              ),
              trailing: [
                IconButton(
                  icon: const Icon(Icons.image, color: Colors.white),
                  onPressed: _sendImage,
                ),
              ],
              alwaysShowSend: true,
            ),
            onSend: _sendMessage,
          ),
          if (_showPrompts)
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _customPrompts.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[700],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        onPressed: () {
                          _sendMessage(
                            ChatMessage(
                              user: _user,
                              text: _customPrompts[index],
                              createdAt: DateTime.now(),
                            ),
                          );
                        },
                        child: Text(
                          _customPrompts[index],
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
