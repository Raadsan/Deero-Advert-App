import 'package:deero_advert_app/features/client/Advert%20Features/controllers/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:deero_advert_app/core/constant.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import '../models/chat_model.dart';

class ChatProvider extends ChangeNotifier {
  IO.Socket? socket;
  List<Conversation> _conversations = [];
  List<ChatMessage> _messages = [];
  List<dynamic> _allUsers = [];
  bool _isLoading = false;
  int? _currentConversationId;

  List<Conversation> get conversations => _conversations;
  List<ChatMessage> get messages => _messages;
  List<dynamic> get allUsers => _allUsers;
  bool get isLoading => _isLoading;
  int get totalUnreadCount => _conversations.fold(0, (sum, conv) => sum + conv.unreadCount);

  final box = GetStorage();

  String get socketUrl => BaseUrl.endsWith('/') ? BaseUrl.substring(0, BaseUrl.length - 1) : BaseUrl;

  Map<int, bool> _onlineUsers = {};
  Map<int, bool> get onlineUsers => _onlineUsers;

  void connectSocket(int userId) {
    if (socket != null && socket!.connected) return;

    socket = IO.io(socketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket!.connect();

    socket!.onConnect((_) {
      print('Socket Connected');
      socket!.emit('join', userId);
    });

    socket!.on('user_status', (data) {
      final int id = int.tryParse(data['userId'].toString()) ?? -1;
      final bool isOnline = data['status'] == 'online';
      _onlineUsers[id] = isOnline;
      notifyListeners();
    });

    socket!.on('messages_read', (data) {
      final int convId = int.tryParse(data['conversationId'].toString()) ?? -1;
      final int readerId = int.tryParse(data['readerId'].toString()) ?? -1;

      for (int i = 0; i < _messages.length; i++) {
        if (_messages[i].conversationId == convId && _messages[i].senderId != readerId) {
          _messages[i] = ChatMessage(
            id: _messages[i].id,
            conversationId: _messages[i].conversationId,
            senderId: _messages[i].senderId,
            text: _messages[i].text,
            isRead: true,
            messageType: _messages[i].messageType,
            mediaUrl: _messages[i].mediaUrl,
            createdAt: _messages[i].createdAt,
          );
        }
      }
      notifyListeners();
    });

    socket!.on('receive_message', (data) {
      final newMessage = ChatMessage.fromJson(data);
      
      // Only add if it's for the current conversation and not already there
      if (newMessage.conversationId == _currentConversationId) {
        final exists = _messages.any((m) => m.id == newMessage.id);
        if (!exists) {
          // Remove optimistic message if exists (same text and sender, or same temporary ID)
          _messages.removeWhere((m) => 
            (m.id > 1000000000 && m.senderId == newMessage.senderId && m.messageType == newMessage.messageType)
          );
          _messages.insert(0, newMessage);
        }
      }
      
      // Update last message in conversation list
      final index = _conversations.indexWhere((c) => c.id == newMessage.conversationId);
      if (index != -1) {
        final conv = _conversations[index];
        bool isCurrentConv = newMessage.conversationId == _currentConversationId;
        
        _conversations[index] = Conversation(
          id: conv.id,
          participant1Id: conv.participant1Id,
          participant2Id: conv.participant2Id,
          lastMessage: newMessage.messageType == 'voice' 
            ? "🎤 Voice Message" 
            : newMessage.messageType == 'image'
              ? "🖼️ Image"
              : newMessage.messageType == 'video'
                ? "🎬 Video"
                : newMessage.messageType == 'document'
                  ? "📄 Document"
                  : newMessage.text,
          updatedAt: DateTime.now(),
          participant1: conv.participant1,
          participant2: conv.participant2,
          unreadCount: isCurrentConv ? 0 : conv.unreadCount + 1,
        );
        
        if (_conversations.isNotEmpty) {
          final updatedConv = _conversations.removeAt(index);
          _conversations.insert(0, updatedConv);
          print("Updated Conv: ${updatedConv.id}, New Unread: ${updatedConv.unreadCount}");
        }
      } else {
        // If conversation doesn't exist in list, fetch all conversations to get the new one
        fetchConversations();
      }

      // Show local notification if not in this conversation
      if (newMessage.conversationId != _currentConversationId) {
        final convIndex = _conversations.indexWhere((c) => c.id == newMessage.conversationId);
        String senderName = "New Message";
        if (convIndex != -1) {
          final conv = _conversations[convIndex];
          final isUser1 = conv.participant1Id == newMessage.senderId;
          senderName = isUser1 ? (conv.participant1?['fullname'] ?? "User") : (conv.participant2?['fullname'] ?? "User");
        }
        
        NotificationService.show(
          senderName,
          newMessage.messageType == 'voice' 
            ? "🎤 Sent a voice message" 
            : newMessage.messageType == 'image'
              ? "🖼️ Sent an image"
              : newMessage.messageType == 'video'
                ? "🎬 Sent a video"
                : newMessage.messageType == 'document'
                  ? "📄 Sent a document"
                  : newMessage.text,
          data: {
            'type': 'chat',
            'conversationId': newMessage.conversationId.toString()
          }
        );
      }
      
      notifyListeners();
    });

    socket!.onDisconnect((_) => print('Socket Disconnected'));
  }

  void markAsRead(int conversationId, int userId) {
    if (socket != null) {
      socket!.emit('mark_read', {
        'conversationId': conversationId,
        'userId': userId,
      });

      // Update local unread count
      final index = _conversations.indexWhere((c) => c.id == conversationId);
      if (index != -1) {
        final conv = _conversations[index];
        _conversations[index] = Conversation(
          id: conv.id,
          participant1Id: conv.participant1Id,
          participant2Id: conv.participant2Id,
          lastMessage: conv.lastMessage,
          updatedAt: conv.updatedAt,
          participant1: conv.participant1,
          participant2: conv.participant2,
          unreadCount: 0,
        );
        notifyListeners();
      }
    }
  }

  void joinRoom(int conversationId) {
    _currentConversationId = conversationId;
    if (socket != null) {
      socket!.emit('join_room', conversationId);
    }
  }

  void leaveRoom() {
    _currentConversationId = null;
    // Optional: socket!.emit('leave_room', ...); 
  }

  Future<void> fetchConversations() async {
    _isLoading = true;
    notifyListeners();

    try {
      final userInfo = box.read('userInfo');
      final token = userInfo != null ? userInfo['token'] : null;
      final response = await http.get(
        Uri.parse('${EndPoint}chat/conversations'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        _conversations = data.map((json) => Conversation.fromJson(json)).toList();
      }
    } catch (e) {
      print("Error fetching conversations: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMessages(int conversationId) async {
    _isLoading = true;
    _messages = []; // Clear current messages to avoid flashing old data
    _currentConversationId = conversationId;
    notifyListeners();

    try {
      final userInfo = box.read('userInfo');
      final token = userInfo != null ? userInfo['token'] : null;
      final response = await http.get(
        Uri.parse('${EndPoint}chat/messages/$conversationId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        _messages = data.map((json) => ChatMessage.fromJson(json)).toList();
        // Reverse for reverse ListView
        _messages = _messages.reversed.toList();
      }
    } catch (e) {
      print("Error fetching messages: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllUsers() async {
    _isLoading = true;
    notifyListeners();

    try {
      final userInfo = box.read('userInfo');
      final token = userInfo != null ? userInfo['token'] : null;
      final response = await http.get(
        Uri.parse('${EndPoint}users'),
        headers: token != null ? {'Authorization': 'Bearer $token'} : {},
      );

      if (response.statusCode == 200) {
        _allUsers = json.decode(response.body);
      }
    } catch (e) {
      print("Error fetching all users: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Conversation?> createOrGetConversation(int participantId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final userInfo = box.read('userInfo');
      final token = userInfo != null ? userInfo['token'] : null;
      final response = await http.post(
        Uri.parse('${EndPoint}chat/conversation'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'participantId': participantId}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        final conversation = Conversation.fromJson(data);
        
        final exists = _conversations.any((c) => c.id == conversation.id);
        if (!exists) {
          _conversations.insert(0, conversation);
        }
        
        return conversation;
      } else {
        throw Exception("Server Error ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      print("Error creating conversation: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void sendMessage(int conversationId, int senderId, int receiverId, String text) {
    print("--- SENDING TEXT MESSAGE ---");
    print("ConvID: $conversationId, Text: $text");
    if (text.trim().isEmpty || socket == null) {
      print("Error: Text empty or Socket null (Socket: $socket)");
      return;
    }

    final data = {
      'conversationId': conversationId,
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'messageType': 'text',
    };

    socket!.emit('send_message', data);
    print("Socket event 'send_message' emitted");
    
    // Optimistic UI update - Insert at 0 for reverse list
    final optimisticMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch,
      conversationId: conversationId,
      senderId: senderId,
      text: text,
      isRead: false,
      messageType: 'text',
      createdAt: DateTime.now(),
    );
    _messages.insert(0, optimisticMsg);
    notifyListeners();
    print("Optimistic text message added to list");
  }

  Future<void> sendVoiceMessage(int conversationId, int senderId, int receiverId, String filePath, int? duration) async {
    print("--- SENDING VOICE MESSAGE ---");
    print("FilePath: $filePath, Duration: $duration");
    if (socket == null) return;

    // 1. Optimistic UI update - Insert immediately
    final tempId = DateTime.now().millisecondsSinceEpoch;
    final optimisticMsg = ChatMessage(
      id: tempId,
      conversationId: conversationId,
      senderId: senderId,
      text: '',
      isRead: false,
      messageType: 'voice',
      mediaUrl: filePath,
      duration: duration,
      createdAt: DateTime.now(),
    );
    _messages.insert(0, optimisticMsg);
    notifyListeners();

    try {
      final userInfo = box.read('userInfo');
      final token = userInfo != null ? userInfo['token'] : null;

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${EndPoint}chat/upload-voice'),
      );

      request.headers.addAll({'Authorization': 'Bearer $token'});

      request.files.add(
        await http.MultipartFile.fromPath(
          'voice',
          filePath,
          contentType: MediaType('audio', 'm4a'),
        ),
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        final String mediaUrl = data['url'];

        final socketData = {
          'conversationId': conversationId,
          'senderId': senderId,
          'receiverId': receiverId,
          'text': '',
          'messageType': 'voice',
          'mediaUrl': mediaUrl,
          'duration': duration,
        };

        socket!.emit('send_message', socketData);
        print("Voice message upload success and socket emitted");
      } else {
        print("Voice upload failed: ${response.body}");
        // Remove optimistic message on failure
        _messages.removeWhere((m) => m.id == tempId);
        notifyListeners();
      }
    } catch (e) {
      print("Error sending voice message: $e");
      _messages.removeWhere((m) => m.id == tempId);
      notifyListeners();
    }
  }

  Future<void> sendFileMessage({
    required int conversationId,
    required int senderId,
    required int receiverId,
    required String filePath,
    required String messageType,
    int? duration,
  }) async {
    print("--- SENDING FILE MESSAGE ---");
    print("Type: $messageType, Path: $filePath, Duration: $duration");
    if (socket == null) return;

    // 1. Optimistic UI update
    final tempId = DateTime.now().millisecondsSinceEpoch;
    final optimisticMsg = ChatMessage(
      id: tempId,
      conversationId: conversationId,
      senderId: senderId,
      text: '',
      isRead: false,
      messageType: messageType,
      mediaUrl: filePath,
      duration: duration,
      createdAt: DateTime.now(),
    );
    _messages.insert(0, optimisticMsg);
    notifyListeners();

    try {
      final userInfo = box.read('userInfo');
      final token = userInfo != null ? userInfo['token'] : null;

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${EndPoint}chat/upload-voice'),
      );

      request.headers.addAll({'Authorization': 'Bearer $token'});

      request.files.add(
        await http.MultipartFile.fromPath(
          'voice',
          filePath,
        ),
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        final String mediaUrl = data['url'];

        final socketData = {
          'conversationId': conversationId,
          'senderId': senderId,
          'receiverId': receiverId,
          'text': '',
          'messageType': messageType,
          'mediaUrl': mediaUrl,
          'duration': duration,
        };

        socket!.emit('send_message', socketData);
        print("File upload success and socket emitted");
      } else {
        print("File upload failed: ${response.body}");
        _messages.removeWhere((m) => m.id == tempId);
        notifyListeners();
      }
    } catch (e) {
      print("Error sending file: $e");
      _messages.removeWhere((m) => m.id == tempId);
      notifyListeners();
    }
  }

  @override
  void dispose() {

    socket?.disconnect();
    super.dispose();
  }
}
