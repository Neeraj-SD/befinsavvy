import 'dart:convert';

List<Amount> amountFromJson(String str) =>
    List<Amount>.from(json.decode(str).map((x) => Amount.fromJson(x)));

String amountToJson(List<Amount> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Amount {
  double value;
  Amount({
    required this.value,
  });

  Amount copyWith({
    double? value,
  }) {
    return Amount(
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'value': value,
    };
  }

  factory Amount.fromMap(Map<String, dynamic> map) {
    return Amount(
      value: map['value']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Amount.fromJson(String source) => Amount.fromMap(json.decode(source));

  @override
  String toString() => 'Amount(value: $value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Amount && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}
