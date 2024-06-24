import 'package:chickychickyplanner/Provider/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chickychickyplanner/Model/chat_message.dart';
import 'package:chickychickyplanner/provider/prompt_text_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  late final ChatService _chatService;

  @override
  void initState() {
    super.initState();
    _chatService = context.read<ChatService>();
    _chatService.fetchMessages();
  }

  void _clearChatHistory() {
    _chatService.clearChatHistory();
  }

  void _showDeleteChatConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Chat History?'),
          content:
              const Text('Are you sure you want to delete the chat history?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                _clearChatHistory();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _sendMessage() {
    if (_textController.text.isNotEmpty) {
      _chatService.fetchPromptResponse(
        _textController.text.trim(),
        context.read<PromptTextProvider>(),
      );
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PromptTextProvider>(
      builder: (context, promptTextProvider, _) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PopupMenuButton<int>(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 1,
                      child: Text('Delete Chat'),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 1) {
                      _showDeleteChatConfirmation(context);
                    }
                  },
                ),
              ],
            ),
            Expanded(
              child: StreamBuilder<List<ChatMessage>>(
                stream: _chatService.messagesStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                      reverse: true,
                      itemCount: snapshot.data!.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return const SizedBox(height: 16);
                        }
                        final message = snapshot.data![index - 1];
                        return ListTile(
                          title: Text(
                            message.role,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(message.text),
                        );
                      },
                    );
                  } else {
                    return const Center(
                        child: Text('Enter a prompt to get a response'));
                  }
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration:
                          const InputDecoration(hintText: 'Enter your prompt'),
                      maxLines: null,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: _sendMessage,
                    child: const Text('Send'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
