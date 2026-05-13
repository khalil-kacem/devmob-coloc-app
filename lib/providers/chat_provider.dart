// lib/providers/chat_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/chat_service.dart';
import 'colocation_provider.dart';

final chatServiceProvider = Provider<ChatService>((ref) => ChatService());

final messagesProvider = StreamProvider.autoDispose<List<dynamic>>((ref) {
  final colocationId = ref.watch(userColocationIdProvider);
  if (colocationId == null || colocationId.isEmpty) return Stream.value([]);
  return ref.watch(chatServiceProvider).getMessages(colocationId);
});
