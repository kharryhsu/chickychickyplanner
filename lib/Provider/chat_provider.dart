import 'dart:async';
import 'dart:convert';
import 'package:chickychickyplanner/Model/chat_message.dart';
import 'package:chickychickyplanner/provider/prompt_text_provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatService with ChangeNotifier {
  final String _apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';
  static const String _url = 'https://api.edenai.run/v2/text/generation';

  final _messagesStreamController =
      StreamController<List<ChatMessage>>.broadcast();
  final List<ChatMessage> _messages = [];

  Stream<List<ChatMessage>> get messagesStream =>
      _messagesStreamController.stream;

  ChatService() {
    loadChatHistory();
  }

  Future<void> loadChatHistory() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? messagesJson = prefs.getString('chat_history');
      if (messagesJson != null) {
        Iterable decoded = jsonDecode(messagesJson);
        _messages.clear();
        _messages.addAll(decoded.map((item) => ChatMessage.fromJson(item)));
        _messagesStreamController.add(List.from(_messages));
      }
    } catch (e) {
      throw Exception('Failed to load chat history: $e');
    }
  }

  Future<void> saveChatHistory() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String messagesJson = jsonEncode(_messages);
      await prefs.setString('chat_history', messagesJson);
    } catch (e) {
      throw Exception('Failed to save chat history: $e');
    }
  }

  Future<void> clearChatHistory() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('chat_history');
      _messages.clear();
      _messagesStreamController.add(List.from(_messages));
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to clear chat history: $e');
    }
  }

  Future<void> fetchMessages() async {
    await Future.delayed(const Duration(seconds: 1));
    _messagesStreamController.add(List.of(_messages));
  }

  Future<void> fetchPromptResponse(
      String prompt,
      PromptTextProvider
          promptTextProvider /*, TaskProvider taskProvider*/) async {
    String fullPrompt = _buildFullPrompt(
        /*taskProvider.promptTextTask() +*/ '${promptTextProvider.text} $prompt.');

    _messages.insert(0, ChatMessage(role: 'User Chicky Chicky', text: prompt));
    _messages.insert(
        0, ChatMessage(role: 'AI Assistant', text: 'Generating response...'));
    _messagesStreamController.add(List.from(_messages));

    var requestBody = jsonEncode({
      'providers': 'cohere',
      'text': fullPrompt,
      'temperature': 0.2,
      'max_tokens': 1000,
    });

    try {
      var response = await http.post(
        Uri.parse(_url),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: requestBody,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch response: ${response.statusCode}');
      }

      var data = json.decode(response.body);
      if (data != null && data['cohere'] != null) {
        var assistantResponse = data['cohere']['generated_text'];
        if (assistantResponse != null) {
          _messages[0] =
              ChatMessage(role: 'AI Assistant', text: assistantResponse);
        } else {
          throw Exception('Empty assistant response');
        }
      } else {
        throw Exception('Unexpected API response format');
      }
    } catch (e) {
      _messages[0] = ChatMessage(
          role: 'AI Assistant', text: 'Failed to generate response.');
      rethrow;
    } finally {
      _messagesStreamController.add(List.from(_messages));
      saveChatHistory();
      //taskProvider.promptTextTaskClear();
    }
  }

  String _buildFullPrompt(String currentPrompt) {
    StringBuffer fullPromptBuffer = StringBuffer(currentPrompt);
    for (int i = 1; i < _messages.length; i++) {
      fullPromptBuffer.write(' ');
      fullPromptBuffer.write(_messages[i].text);
    }
    return fullPromptBuffer.toString();
  }

  @override
  void dispose() {
    _messagesStreamController.close();
    super.dispose();
  }
}
