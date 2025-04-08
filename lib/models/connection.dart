class Connection {
  final DateTime startTime;
  final Duration duration;

  Connection(this.startTime, this.duration);

  Map<String, dynamic> toJson() => {
    'startTime': startTime.toIso8601String(),
    'duration': duration.inSeconds,
  };

  factory Connection.fromJson(Map<String, dynamic> json) => Connection(
    DateTime.parse(json['startTime']),
    Duration(seconds: json['duration']),
  );
}
