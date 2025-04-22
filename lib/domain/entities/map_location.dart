
class MapLocation {
  final String id;
  final String name;
  final String category;
  final double latitude;
  final double longitude;
  final String description;
  final String? hours;
  final String? imageUrl;
  final List<String> floor;
  final Map<String, String> details;
  final List<String> facilities;

  MapLocation({
    required this.id,
    required this.name,
    required this.category,
    required this.latitude,
    required this.longitude,
    required this.description,
    this.hours,
    this.imageUrl,
    this.floor = const [],
    this.details = const {},
    this.facilities = const [],
  });
}
