import 'package:chatting_app/services/auth/auth_service.dart';
import 'package:chatting_app/services/chat/chat_service.dart';
import 'package:chatting_app/widgets/chat_bubble.dart';
import 'package:chatting_app/widgets/my_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverId;
  const ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverId,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatService _chatService = ChatService();

  final AuthService _authService = AuthService();

  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    myFocusNode.addListener(
      () {
        if (myFocusNode.hasFocus) {
          Future.delayed(
            const Duration(milliseconds: 500),
            () => scrollDown(),
          );
        }
      },
    );
    Future.delayed(
      const Duration(milliseconds: 500),
      () => scrollDown(),
    );
    super.initState();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    messageController.dispose();
    super.dispose();
  }

  final ScrollController scrollController = ScrollController();

  void scrollDown() async {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  final TextEditingController messageController = TextEditingController();

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await _chatService.sendMessage(widget.receiverId, messageController.text);
      messageController.clear();
    }

    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(widget.receiverEmail),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderId = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverId, senderId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          );
        }

        return ListView(
          controller: scrollController,
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = data['senderId'] == _authService.getCurrentUser()!.uid;
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
        alignment: alignment,
        child: Column(
          crossAxisAlignment:
              isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            ChatBubble(isCurrentUser: isCurrentUser, text: data['message'])
          ],
        ));
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
              focusNode: myFocusNode,
              hintText: 'Silakan masukan pesan anda',
              obscureText: false,
              controller: messageController,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
                color: Colors.green, shape: BoxShape.circle),
            margin: const EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(Icons.arrow_upward),
            ),
          )
        ],
      ),
    );
  }
}
