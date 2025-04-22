class DiningInfo {
  final String id;
  final String name;
  final String location;
  final String description;
  final List<DiningHours> hours;
  final List<MenuItem> menu;
  final bool acceptsMealPlan;
  final double? rating;
  final String? imageUrl;

  DiningInfo({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    required this.hours,
    required this.menu,
    this.acceptsMealPlan = false,
    this.rating,
    this.imageUrl,
  });
}

class DiningHours {
  final String day;
  final String openTime;
  final String closeTime;
  final bool isClosed;

  DiningHours({
    required this.day,
    required this.openTime,
    required this.closeTime,
    this.isClosed = false,
  });

  String get formattedHours {
    if (isClosed) return 'Closed';
    return '$openTime - $closeTime';
  }
}

class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> dietaryInfo;
  final String category;
  final bool isAvailable;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.dietaryInfo = const [],
    required this.category,
    this.isAvailable = true,
  });
}
