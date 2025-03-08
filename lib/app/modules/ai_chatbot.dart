import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart'; // For Gemini API
import 'package:dash_chat_2/dash_chat_2.dart'; // For chat UI
import 'package:image_picker/image_picker.dart'; // For image upload
import 'dart:convert'; // For base64 encoding
import 'dart:io'; // For File operations

class AIChatbotScreen extends StatefulWidget {
  @override
  _AIChatbotScreenState createState() => _AIChatbotScreenState();
}

class _AIChatbotScreenState extends State<AIChatbotScreen> {
  final Gemini _gemini = Gemini.instance; // Initialize Gemini
  final ChatUser _user = ChatUser(id: '1', firstName: 'User'); // Chat user
  final ChatUser _bot = ChatUser(id: '2', firstName: 'E-sahyog'); // Chat bot
  final List<ChatMessage> _messages = []; // List of chat messages
  final ImagePicker _picker = ImagePicker(); // For image upload

  // List of custom prompts
  final List<String> _customPrompts = [
    "What should I do during an earthquake?",
    "How can I prepare for a flood?",
    "What are the emergency contacts for a cyclone?",
    "How do I use the SOS feature?",
    "Where can I find refugee centers near me?",
    "How do I update my medical records in the app?",
  ];

  bool _showPrompts = true; // Controls visibility of the prompt list

  void _sendMessage(ChatMessage message) async {
    // Add user message to the chat
    setState(() {
      _messages.insert(0, message);
      _showPrompts = false; // Hide prompts after sending a message
    });

    // Send the message to Gemini API
    try {
      print('Sending message: ${message.text}'); // Log the message
      final response = await _gemini.text(message.text);
      if (response != null) {
        print('Received response: ${response.output}'); // Log the response
        // Add bot response to the chat
        setState(() {
          _messages.insert(0, ChatMessage(
            user: _bot,
            text: response.output!,
            createdAt: DateTime.now(),
          ));
        });
      }
    } catch (e) {
      print('Error: $e'); // Log the error
      // Handle errors
      setState(() {
        _messages.insert(0, ChatMessage(
          user: _bot,
          text: 'Error: Failed to fetch response.',
          createdAt: DateTime.now(),
        ));
      });
    }
  }

  void _sendImage() async {
    // Pick an image from the gallery
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Read the image file and encode it as base64
      final bytes = await File(image.path).readAsBytes();
      final base64Image = base64Encode(bytes);

      // Add image message to the chat
      setState(() {
        _messages.insert(0, ChatMessage(
          user: _user,
          createdAt: DateTime.now(),
          medias: [
            ChatMedia(
              url: image.path,
              fileName: "image.jpg",
              type: MediaType.image,
            ),
          ],
        ));
      });

      // Send the image to Gemini API
      try {
        print('Sending image: ${image.path}'); // Log the image
        final response = await _gemini.text(
          'Describe this image: $base64Image', // Send base64 image as a prompt
        );
        if (response != null) {
          print('Received response: ${response.output}'); // Log the response
          // Add bot response to the chat
          setState(() {
            _messages.insert(0, ChatMessage(
              user: _bot,
              text: response.output!,
              createdAt: DateTime.now(),
            ));
          });
        }
      } catch (e) {
        print('Error: $e'); // Log the error
        // Handle errors
        setState(() {
          _messages.insert(0, ChatMessage(
            user: _bot,
            text: 'Error: Failed to process image.',
            createdAt: DateTime.now(),
          ));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('E-Sahyog'),
        backgroundColor: Colors.blue[100],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      backgroundColor: Colors.blue[100],
      body: Stack(
        children: [
          Column(
            children: [
              // Chat interface
              Expanded(
                child: DashChat(
                  currentUser: _user,
                  messages: _messages,
                  onSend: (ChatMessage message) {
                    _sendMessage(message); // Send text message
                  },
                  inputOptions: InputOptions(
                    trailing: [
                      IconButton(
                        icon: Icon(Icons.image),
                        onPressed: _sendImage, // Send image message
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Custom prompts overlay
          if (_showPrompts)
            Positioned(
              bottom: 80, // Adjust position to be above the input box
              left: 0,
              right: 0,
              child: Container(
                height: 100, // Adjust height as needed
                decoration: BoxDecoration(
                  color: Colors.blue[100], // Lightest blue background
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)), // Fixed syntax
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _customPrompts.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[80], // Button color
                          foregroundColor: Colors.grey[900], // Text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20), // Rounded corners
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        onPressed: () {
                          // Automatically send the selected prompt
                          _sendMessage(ChatMessage(
                            user: _user,
                            text: _customPrompts[index],
                            createdAt: DateTime.now(),
                          ));
                        },
                        child: Text(
                          _customPrompts[index],
                          style: TextStyle(fontSize: 14), // Fixed syntax
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