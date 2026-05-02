import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/models/chat_model.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/controllers/chat_provider.dart';
import 'package:deero_advert_app/features/auth/controllers/user_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';

class AdvertChatConversationPage extends StatefulWidget {
  final Conversation conversation;

  const AdvertChatConversationPage({super.key, required this.conversation});

  @override
  State<AdvertChatConversationPage> createState() =>
      _AdvertChatConversationPageState();
}

class _AdvertChatConversationPageState
    extends State<AdvertChatConversationPage> {
  final TextEditingController _messageController = TextEditingController();
  final AudioRecorder _audioRecorder = AudioRecorder();
  final ImagePicker _imagePicker = ImagePicker();

  int currentUserId = -1;
  int otherUserId = -1;
  Map<String, dynamic>? otherUser;

  bool _isRecording = false;
  String? _recordingPath;
  Duration _recordDuration = Duration.zero;
  Timer? _recordTimer;

  late ChatProvider _chatProvider;

  @override
  void initState() {
    super.initState();
    _chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.userModel?.user != null) {
      currentUserId =
          int.tryParse(userProvider.userModel!.user!.id.toString()) ?? -1;
    }

    final conv = widget.conversation;
    final isUser1 = conv.participant1Id == currentUserId;
    otherUserId = isUser1 ? conv.participant2Id : conv.participant1Id;
    otherUser = isUser1 ? conv.participant2 : conv.participant1;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _chatProvider.connectSocket(currentUserId);
      _chatProvider.joinRoom(conv.id);
      _chatProvider.fetchMessages(conv.id);
      _chatProvider.markAsRead(conv.id, currentUserId);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _audioRecorder.dispose();
    _recordTimer?.cancel();
    _chatProvider.leaveRoom();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      _sendFile(image.path, 'image');
    }
  }

  Future<void> _pickVideo() async {
    final XFile? video = await _imagePicker.pickVideo(
      source: ImageSource.gallery,
    );
    if (video != null) {
      _sendFile(video.path, 'video');
    }
  }

  Future<void> _pickDocument() async {
    FilePickerResult? result = await FilePicker.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      final path = result.files.first.path;
      if (path != null) {
        _sendFile(path, 'document');
      }
    }
  }

  void _sendFile(String path, String type) {
    Provider.of<ChatProvider>(context, listen: false).sendFileMessage(
      conversationId: widget.conversation.id,
      senderId: currentUserId,
      receiverId: otherUserId,
      filePath: path,
      messageType: type,
    );
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _attachmentOption(
                  IconlyBold.image,
                  "Image",
                  Colors.blue,
                  _pickImage,
                ),
                _attachmentOption(
                  IconlyBold.video,
                  "Video",
                  Colors.red,
                  _pickVideo,
                ),
                _attachmentOption(
                  IconlyBold.document,
                  "File",
                  Colors.orange,
                  _pickDocument,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _attachmentOption(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      await _stopRecording(send: false);
    } else {
      await _startRecording();
    }
  }

  Future<void> _startRecording() async {
    try {
      if (await Permission.microphone.request().isGranted) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath =
            '${directory.path}/record_${DateTime.now().millisecondsSinceEpoch}.m4a';
        const config = RecordConfig();
        await _audioRecorder.start(config, path: filePath);
        setState(() {
          _isRecording = true;
          _recordDuration = Duration.zero;
        });
        _startTimer();
      }
    } catch (e) {
      print("Error starting record: $e");
    }
  }

  void _startTimer() {
    _recordTimer?.cancel();
    _recordTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordDuration += const Duration(seconds: 1);
      });
    });
  }

  Future<void> _stopRecording({bool send = true}) async {
    _recordTimer?.cancel();
    final path = await _audioRecorder.stop();
    setState(() {
      _isRecording = false;
    });
    if (send && path != null) {
      Provider.of<ChatProvider>(context, listen: false).sendVoiceMessage(
        widget.conversation.id,
        currentUserId,
        otherUserId,
        path,
        _recordDuration.inSeconds,
      );
    }
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 6,
      itemBuilder: (context, index) {
        bool isLeft = index % 2 == 0;
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Align(
            alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              width: MediaQuery.of(context).size.width * 0.6,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(IconlyLight.arrow_left_2, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Consumer<ChatProvider>(
          builder: (context, chatProvider, _) {
            final isOnline = chatProvider.onlineUsers[otherUserId] ?? false;
            return Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color(0xffEF7044).withOpacity(0.2),
                      backgroundImage:
                          otherUser?['image'] != null &&
                              otherUser!['image'].toString().isNotEmpty
                          ? NetworkImage(otherUser!['image'])
                          : null,
                      child:
                          otherUser?['image'] == null ||
                              otherUser!['image'].toString().isEmpty
                          ? Text(
                              otherUser?['fullname']?.isNotEmpty == true
                                  ? otherUser!['fullname'][0].toUpperCase()
                                  : '?',
                              style: GoogleFonts.poppins(
                                color: const Color(0xffEF7044),
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    ),
                    PositionImage(isOnline: isOnline),
                  ],
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      otherUser?['fullname'] ?? "Support Team",
                      style: GoogleFonts.poppins(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      isOnline ? "Online" : "Offline",
                      style: GoogleFonts.poppins(
                        color: isOnline ? Colors.green : Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                if (chatProvider.isLoading && chatProvider.messages.isEmpty)
                  return _buildShimmerLoading();

                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  reverse: true,
                  itemCount: chatProvider.messages.length,
                  itemBuilder: (context, index) {
                    final message = chatProvider.messages[index];
                    final isSender = message.senderId == currentUserId;
                    final time =
                        "${message.createdAt.hour.toString().padLeft(2, '0')}:${message.createdAt.minute.toString().padLeft(2, '0')}";

                    return _buildMessageBubble(
                      message,
                      isSender,
                      time,
                      chatProvider.onlineUsers[otherUserId] ?? false,
                    );
                  },
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(
    ChatMessage message,
    bool isSender,
    String time,
    bool isOtherOnline,
  ) {
    Widget content;
    switch (message.messageType) {
      case 'image':
        content = ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child:
              message.mediaUrl != null && message.mediaUrl!.startsWith('http')
              ? Image.network(
                  message.mediaUrl!,
                  width: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image),
                )
              : (message.mediaUrl != null
                    ? Image.file(
                        File(message.mediaUrl!),
                        width: 200,
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.image_not_supported)),
        );
        break;
      case 'video':
        content = VideoMessageBubble(url: message.mediaUrl ?? "");
        break;
      case 'document':
        content = GestureDetector(
          onTap: () {
            if (message.mediaUrl != null) {
              launchUrl(Uri.parse(message.mediaUrl!));
            }
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSender
                  ? Colors.white.withOpacity(0.2)
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(IconlyBold.document, size: 24),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    "View Document",
                    style: GoogleFonts.poppins(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
        break;
      case 'voice':
        content = VoiceMessageBubble(
          message: message,
          isSender: isSender,
          time: time,
          isOtherOnline: isOtherOnline,
        );
        break;
      default:
        content = Text(
          message.text,
          style: GoogleFonts.poppins(
            color: isSender ? Colors.white : Colors.black87,
            fontSize: 14,
          ),
        );
    }

    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSender ? const Color(0xffEF7044) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: isSender
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            content,
            const SizedBox(height: 4),
            Text(
              time,
              style: GoogleFonts.poppins(
                color: isSender ? Colors.white70 : Colors.grey,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(IconlyLight.paper_plus, color: Colors.grey),
              onPressed: _showAttachmentOptions,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: _isRecording
                    ? Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                            onPressed: () => _stopRecording(send: false),
                          ),
                          const Spacer(),
                          const Icon(Icons.mic, color: Colors.red),
                          const SizedBox(width: 10),
                          Text(
                            "${_recordDuration.inMinutes}:${(_recordDuration.inSeconds % 60).toString().padLeft(2, '0')}",
                            style: GoogleFonts.poppins(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                        ],
                      )
                    : TextField(
                        controller: _messageController,
                        onChanged: (val) {
                          setState(() {});
                        },
                        decoration: const InputDecoration(
                          hintText: "Type a message...",
                          border: InputBorder.none,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              onPressed: () {
                if (_messageController.text.isNotEmpty) {
                  Provider.of<ChatProvider>(context, listen: false).sendMessage(
                    widget.conversation.id,
                    currentUserId,
                    otherUserId,
                    _messageController.text,
                  );
                  _messageController.clear();
                } else if (_isRecording) {
                  _stopRecording();
                } else {
                  _toggleRecording();
                }
              },
              icon: CircleAvatar(
                backgroundColor: const Color(0xffEF7044),
                child: Icon(
                  _messageController.text.isNotEmpty
                      ? IconlyBold.send
                      : (_isRecording ? IconlyBold.send : IconlyBold.voice),
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoMessageBubble extends StatefulWidget {
  final String url;
  const VideoMessageBubble({super.key, required this.url});

  @override
  State<VideoMessageBubble> createState() => _VideoMessageBubbleState();
}

class _VideoMessageBubbleState extends State<VideoMessageBubble> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) => setState(() => _initialized = true));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) return const CircularProgressIndicator();
    return GestureDetector(
      onTap: () => setState(
        () => _controller.value.isPlaying
            ? _controller.pause()
            : _controller.play(),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 200,
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          ),
          if (!_controller.value.isPlaying)
            const Icon(Icons.play_circle_fill, color: Colors.white, size: 40),
        ],
      ),
    );
  }
}

class VoiceMessageBubble extends StatefulWidget {
  final ChatMessage message;
  final bool isSender;
  final String time;
  final bool isOtherOnline;

  const VoiceMessageBubble({
    super.key,
    required this.message,
    required this.isSender,
    required this.time,
    required this.isOtherOnline,
  });

  @override
  State<VoiceMessageBubble> createState() => _VoiceMessageBubbleState();
}

class _VoiceMessageBubbleState extends State<VoiceMessageBubble> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();

    // 1. Set duration from message if available
    if (widget.message.duration != null && widget.message.duration! > 0) {
      _duration = Duration(seconds: widget.message.duration!);
    }

    _player.onDurationChanged.listen((d) {
      if (mounted) setState(() => _duration = d);
    });
    _player.onPositionChanged.listen((p) {
      if (mounted) setState(() => _position = p);
    });
    _player.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
      }
    });

    // 2. Pre-load source to get duration if not already known
    final mediaUrl = widget.message.mediaUrl ?? "";
    if (mediaUrl.isNotEmpty) {
      _player.setSource(
        mediaUrl.startsWith('http')
            ? UrlSource(mediaUrl)
            : DeviceFileSource(mediaUrl),
      );
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String minutes = duration.inMinutes.toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            _isPlaying ? Icons.pause : Icons.play_arrow,
            color: widget.isSender ? Colors.white : const Color(0xffEF7044),
          ),
          onPressed: () async {
            if (_isPlaying) {
              await _player.pause();
            } else {
              // Use resume if already set, or play if first time
              await _player.resume();
            }
            if (mounted) setState(() => _isPlaying = !_isPlaying);
          },
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Voice Message",
              style: GoogleFonts.poppins(
                color: widget.isSender ? Colors.white : Colors.black87,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              _isPlaying
                  ? "${_formatDuration(_position)} / ${_formatDuration(_duration)}"
                  : _formatDuration(_duration),
              style: GoogleFonts.poppins(
                color: widget.isSender ? Colors.white70 : Colors.grey,
                fontSize: 10,
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

class PositionImage extends StatelessWidget {
  final bool isOnline;
  const PositionImage({super.key, required this.isOnline});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: isOnline ? Colors.green : Colors.grey,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
      ),
    );
  }
}
