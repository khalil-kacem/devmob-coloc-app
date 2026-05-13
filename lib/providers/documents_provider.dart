// lib/providers/documents_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/file_service.dart';
import 'colocation_provider.dart';

final fileServiceProvider = Provider<FileService>((ref) => FileService());

final documentsProvider = StreamProvider.autoDispose<List<dynamic>>((ref) {
  final colocationId = ref.watch(userColocationIdProvider);
  if (colocationId == null || colocationId.isEmpty) return Stream.value([]);
  return ref.watch(fileServiceProvider).getDocuments(colocationId);
});
