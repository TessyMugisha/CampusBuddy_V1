import '../../data/repositories/emergency_repository.dart';
import '../entities/emergency_contact.dart';

class EmergencyUseCase {
  final EmergencyRepository _emergencyRepository;

  EmergencyUseCase(this._emergencyRepository);

  // Get all emergency contacts
  Future<List<EmergencyContact>> getAllEmergencyContacts() async {
    try {
      final contacts = await _emergencyRepository.getAllEmergencyContacts();
      return contacts;
    } catch (e) {
      throw e;
    }
  }

  // Get emergency contacts by category
  Future<List<EmergencyContact>> getEmergencyContactsByCategory(String category) async {
    if (category.isEmpty) {
      throw ArgumentError('Category cannot be empty');
    }
    
    try {
      return await _emergencyRepository.getEmergencyContactsByCategory(category);
    } catch (e) {
      throw e;
    }
  }

  // Get emergency-only contacts
  Future<List<EmergencyContact>> getEmergencyOnlyContacts() async {
    try {
      return await _emergencyRepository.getEmergencyOnlyContacts();
    } catch (e) {
      throw e;
    }
  }

  // Get contacts organized by category
  Future<Map<String, List<EmergencyContact>>> getContactsByCategory() async {
    try {
      final allContacts = await _emergencyRepository.getAllEmergencyContacts();
      final Map<String, List<EmergencyContact>> categorizedContacts = {};
      
      for (final contact in allContacts) {
        if (!categorizedContacts.containsKey(contact.category)) {
          categorizedContacts[contact.category] = [];
        }
        categorizedContacts[contact.category]!.add(contact);
      }
      
      return categorizedContacts;
    } catch (e) {
      throw e;
    }
  }

  // Clear cache
  Future<void> refreshContacts() async {
    try {
      await _emergencyRepository.clearCache();
      await _emergencyRepository.getAllEmergencyContacts();
    } catch (e) {
      throw e;
    }
  }
}
