import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/event.dart';
import '../models/participant.dart';

class EventProvider with ChangeNotifier {
  EventModel? _currentEvent;
  List<Participant> _participants = [];
  
  EventModel? get currentEvent => _currentEvent;
  List<Participant> get participants => _participants;

  bool get isEventSetup => _currentEvent != null;

  int get checkedInCount => _participants.length;
  int get remainingCapacity => (_currentEvent?.maxCapacity ?? 0) - checkedInCount;

  Future<void> init() async {
    var eventBox = await Hive.openBox<EventModel>('eventBox');
    var participantBox = await Hive.openBox<Participant>('participantBox');

    if (eventBox.isNotEmpty) {
      _currentEvent = eventBox.getAt(0);
    }
    
    _participants = participantBox.values.toList();
    notifyListeners();
  }

  Future<void> setupEvent(String name, int capacity, DateTime date) async {
    var eventBox = await Hive.openBox<EventModel>('eventBox');
    var participantBox = await Hive.openBox<Participant>('participantBox');

    await eventBox.clear();
    await participantBox.clear(); // Clear previous event's participants

    _currentEvent = EventModel(name: name, maxCapacity: capacity, date: date);
    await eventBox.add(_currentEvent!);
    
    _participants = [];
    notifyListeners();
  }

  Future<String?> checkInParticipant(String id, String name) async {
    if (_currentEvent == null) return "No event configured.";

    // Check duplicate
    bool isDuplicate = _participants.any((p) => p.id == id);
    if (isDuplicate) {
      return "Participant already checked in!";
    }

    // Check capacity
    if (checkedInCount >= _currentEvent!.maxCapacity) {
      return "Event is at full capacity!";
    }

    var participantBox = await Hive.openBox<Participant>('participantBox');
    final newParticipant = Participant(id: id, name: name, checkInTime: DateTime.now());
    
    await participantBox.add(newParticipant);
    _participants.add(newParticipant);
    notifyListeners();
    
    return null; // Success
  }
}
