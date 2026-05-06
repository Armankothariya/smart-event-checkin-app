import 'package:hive/hive.dart';

class EventModel {
  final String name;
  final int maxCapacity;
  final DateTime date;

  EventModel({
    required this.name,
    required this.maxCapacity,
    required this.date,
  });
}

class EventModelAdapter extends TypeAdapter<EventModel> {
  @override
  final int typeId = 2;

  @override
  EventModel read(BinaryReader reader) {
    return EventModel(
      name: reader.readString(),
      maxCapacity: reader.readInt(),
      date: DateTime.parse(reader.readString()),
    );
  }

  @override
  void write(BinaryWriter writer, EventModel obj) {
    writer.writeString(obj.name);
    writer.writeInt(obj.maxCapacity);
    writer.writeString(obj.date.toIso8601String());
  }
}
