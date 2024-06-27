import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isCurrentUser;
  const ChatBubble({
    super.key,
    required this.isCurrentUser,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isCurrentUser
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.secondary),
      child: Text(
        text,
        style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
      ),
    );
  }
}
