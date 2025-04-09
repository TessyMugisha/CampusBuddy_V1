class DirectoryEntry {
  final String id;
  final String name;
  final String title;
  final String department;
  final String email;
  final String phoneNumber;
  final String? officeLocation;
  final String? photoUrl;
  final List<String> researchInterests;

  DirectoryEntry({
    required this.id,
    required this.name,
    required this.title,
    required this.department,
    required this.email,
    required this.phoneNumber,
    this.officeLocation,
    this.photoUrl,
    this.researchInterests = const [],
  });
}
