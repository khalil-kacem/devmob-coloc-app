// lib/views/chat/chat_screen.dart
import 'package:devmob_coloc_flutter_project/models/message.dart';
import 'package:devmob_coloc_flutter_project/providers/auth_provider.dart';
import 'package:devmob_coloc_flutter_project/providers/chat_provider.dart';
import 'package:devmob_coloc_flutter_project/providers/colocation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/chat_service.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(messagesProvider);
    final colocationId = ref.watch(userColocationIdProvider);
    final currentUser = ref.watch(currentUserProvider).value;

    return Column(
      children: [
        // Messages
        Expanded(
          child: messagesAsync.when(
            data: (messages) => messages.isEmpty
                ? const Center(child: Text("Aucun message pour le moment"))
                : ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index] as Message;
                      final isMe = msg.senderId == currentUser?.uid;
                      return Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.teal : Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                msg.senderName,
                                style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isMe ? Colors.white : Colors.black),
                              ),
                              Text(
                                msg.text,
                                style: GoogleFonts.poppins(
                                    color: isMe ? Colors.white : Colors.black),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const Center(child: Text("Erreur de chargement")),
          ),
        ),

        // Input field
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: "Écrire un message...",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.teal),
                onPressed: () {
                  if (_messageController.text.trim().isEmpty ||
                      colocationId == null) return;

                  final user = currentUser!;
                  final message = Message(
                    id: '',
                    senderId: user.uid,
                    senderName: user.displayName,
                    text: _messageController.text.trim(),
                    timestamp: DateTime.now(),
                  );

                  ChatService().sendMessage(colocationId, message);
                  _messageController.clear();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
