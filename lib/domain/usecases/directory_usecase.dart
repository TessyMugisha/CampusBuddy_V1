import '../../data/repositories/directory_repository.dart';
import '../entities/directory_entry.dart';

class DirectoryUseCase {
  final DirectoryRepository _directoryRepository;

  DirectoryUseCase(this._directoryRepository);

  // Get all directory entries
  Future<List<DirectoryEntry>> getAllDirectoryEntries() async {
    try {
      final entries = await _directoryRepository.getAllDirectoryEntries();
      return entries;
    } catch (e) {
      throw e;
    }
  }

  // Search directory entries
  Future<List<DirectoryEntry>> searchDirectory(String query) async {
    try {
      return await _directoryRepository.searchDirectory(query);
    } catch (e) {
      throw e;
    }
  }

  // Get directory entries by department
  Future<List<DirectoryEntry>> getEntriesByDepartment(String department) async {
    if (department.isEmpty) {
      throw ArgumentError('Department cannot be empty');
    }
    
    try {
      return await _directoryRepository.getEntriesByDepartment(department);
    } catch (e) {
      throw e;
    }
  }

  // Get directory entry by ID
  Future<DirectoryEntry?> getEntryById(String id) async {
    if (id.isEmpty) {
      throw ArgumentError('ID cannot be empty');
    }
    
    try {
      return await _directoryRepository.getEntryById(id);
    } catch (e) {
      throw e;
    }
  }

  // Get all unique departments
  Future<List<String>> getAllDepartments() async {
    try {
      final entries = await _directoryRepository.getAllDirectoryEntries();
      final departments = <String>{};
      
      for (final entry in entries) {
        departments.add(entry.department);
      }
      
      return departments.toList()..sort();
    } catch (e) {
      throw e;
    }
  }

  // Refresh directory data
  Future<void> refreshDirectory() async {
    try {
      await _directoryRepository.clearCache();
      await _directoryRepository.getAllDirectoryEntries();
    } catch (e) {
      throw e;
    }
  }
}
