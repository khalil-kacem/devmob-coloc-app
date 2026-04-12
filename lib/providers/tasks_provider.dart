// lib/providers/tasks_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/task_service.dart';
import '../models/task.dart';
import 'colocation_provider.dart';

final taskServiceProvider = Provider<TaskService>((ref) => TaskService());

final tasksProvider = StreamProvider.autoDispose<List<Task>>((ref) {
  final colocationId = ref.watch(userColocationIdProvider);
  if (colocationId == null || colocationId.isEmpty) return Stream.value([]);
  return ref.watch(taskServiceProvider).getTasks(colocationId);
});
