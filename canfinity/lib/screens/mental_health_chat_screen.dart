import 'package:flutter/material.dart';
import 'package:canfinity/services/ai_service.dart';

class MentalHealthChatScreen extends StatefulWidget {
  const MentalHealthChatScreen({super.key});

  @override
  State<MentalHealthChatScreen> createState() => _MentalHealthChatScreenState();
}

class _MentalHealthChatScreenState extends State<MentalHealthChatScreen> {
  final List<ChatMessage> messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    messages.add(
      ChatMessage(
        text: '''Welcome to your Cancer Support Chat. I'm here to:
- Listen and provide emotional support
- Share coping strategies
- Offer information about cancer-related concerns
- Help you find professional resources

How are you feeling today?''',
        isUser: false,
      ),
    );
  }

  // Add suggested questions/topics
  final List<String> suggestedTopics = [
    "I'm feeling anxious about treatment",
    "How do I deal with side effects?",
    "I'm worried about the future",
    "How do I talk to my family?",
    "I'm feeling overwhelmed",
  ];

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      messages.add(ChatMessage(
        text: text,
        isUser: true,
      ));
    });
    _controller.clear();
    _scrollToBottom();

    setState(() {
      messages.add(ChatMessage(
        text: "...",
        isUser: false,
      ));
    });

    try {
      final response = await AIService.getMentalHealthResponse(text);

      setState(() {
        messages.removeLast(); // Remove loading message
        messages.add(ChatMessage(
          text: response,
          isUser: false,
        ));
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        messages.removeLast(); // Remove loading message
        messages.add(ChatMessage(
          text:
              '''I apologize, but I'm having trouble right now. In the meantime:
- Take deep breaths
- Remember you're not alone
- Contact your healthcare provider if needed
- Try again in a moment''',
          isUser: false,
        ));
      });
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cancer Support Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ChatBubble(message: message);
              },
            ),
          ),
          // Add suggested topics
          if (messages.length < 3) // Show only initially
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: suggestedTopics.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () => _sendMessage(suggestedTopics[index]),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black,
                      ),
                      child: Text(suggestedTopics[index]),
                    ),
                  );
                },
              ),
            ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Share how you\'re feeling...',
                      border: InputBorder.none,
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(_controller.text),
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
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({
    required this.text,
    required this.isUser,
  });
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    if (message.text == "...") {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.all(8),
          child: const CircularProgressIndicator(),
        ),
      );
    }
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isUser ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
