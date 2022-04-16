import 'dart:convert';

class Task {
  String id;
  DateTime date;
  bool status;
  Task({
    required this.id,
    required this.date,
    required this.status,
  });

  Task copyWith({
    String? id,
    DateTime? date,
    bool? status,
  }) {
    return Task(
      id: id ?? this.id,
      date: date ?? this.date,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.millisecondsSinceEpoch,
      'status': status,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      status: map['status'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) => Task.fromMap(json.decode(source));

  @override
  String toString() => 'Task(id: $id, date: $date, status: $status)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Task &&
        other.id == id &&
        other.date == date &&
        other.status == status;
  }

  @override
  int get hashCode => id.hashCode ^ date.hashCode ^ status.hashCode;
}
