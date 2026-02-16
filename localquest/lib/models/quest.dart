class Quest {
  final String title;
  final double lat;
  final double lng;
  final double radius;
  final List<String> participants;

  Quest({
    required this.title,
    required this.lat,
    required this.lng,
    required this.radius,
    required this.participants,
  });
}
