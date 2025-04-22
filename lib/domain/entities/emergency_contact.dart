class EmergencyContact {
  final String id;
  final String name;
  final String phoneNumber;
  final String description;
  final String category;
  final bool isEmergency;

  EmergencyContact({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.description,
    required this.category,
    this.isEmergency = false,
  });
}
