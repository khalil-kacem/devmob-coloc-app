// lib/providers/calendar_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/calendar_service.dart';
import 'colocation_provider.dart';

final calendarServiceProvider =
    Provider<CalendarService>((ref) => CalendarService());

final eventsProvider = StreamProvider.autoDispose<List<dynamic>>((ref) {
  final colocationId = ref.watch(userColocationIdProvider);
  if (colocationId == null || colocationId.isEmpty) return Stream.value([]);
  return ref.watch(calendarServiceProvider).getEvents(colocationId);
});
