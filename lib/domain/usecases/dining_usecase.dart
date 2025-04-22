import '../../data/repositories/dining_repository.dart';
import '../entities/dining_info.dart';

class DiningUseCase {
  final DiningRepository _diningRepository;

  DiningUseCase(this._diningRepository);

  // Get all dining options
  Future<List<DiningInfo>> getAllDiningOptions() async {
    try {
      final options = await _diningRepository.getAllDiningOptions();
      return options;
    } catch (e) {
      rethrow;
    }
  }

  // Get dining option by ID
  Future<DiningInfo> getDiningOptionById(String id) async {
    if (id.isEmpty) {
      throw ArgumentError('ID cannot be empty');
    }
    
    try {
      return await _diningRepository.getDiningOptionById(id);
    } catch (e) {
      rethrow;
    }
  }

  // Get dining options that accept meal plan
  Future<List<DiningInfo>> getMealPlanOptions() async {
    try {
      return await _diningRepository.getMealPlanOptions();
    } catch (e) {
      rethrow;
    }
  }

  // Search menu items
  Future<Map<String, List<MenuItem>>> searchMenuItems(String query) async {
    try {
      return await _diningRepository.searchMenuItems(query);
    } catch (e) {
      rethrow;
    }
  }

  // Get currently open dining options
  Future<List<DiningInfo>> getCurrentlyOpenDiningOptions() async {
    try {
      final allOptions = await _diningRepository.getAllDiningOptions();
      final now = DateTime.now();
      final currentDay = _getDayOfWeek(now.weekday);
      final currentTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
      
      return allOptions.where((option) {
        final todayHours = option.hours.firstWhere(
          (hours) => hours.day.toLowerCase() == currentDay.toLowerCase(),
          orElse: () => DiningHours(
            day: currentDay,
            openTime: '00:00',
            closeTime: '00:00',
            isClosed: true,
          ),
        );
        
        if (todayHours.isClosed) return false;
        
        return _isTimeInRange(currentTime, todayHours.openTime, todayHours.closeTime);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Helper method to get day of week
  String _getDayOfWeek(int weekday) {
    switch (weekday) {
      case 1: return 'Monday';
      case 2: return 'Tuesday';
      case 3: return 'Wednesday';
      case 4: return 'Thursday';
      case 5: return 'Friday';
      case 6: return 'Saturday';
      case 7: return 'Sunday';
      default: return 'Monday';
    }
  }

  // Helper method to check if time is in range
  bool _isTimeInRange(String current, String open, String close) {
    // Handle case where dining place is open past midnight
    if (close.compareTo(open) < 0) {
      return current.compareTo(open) >= 0 || current.compareTo(close) <= 0;
    }
    
    return current.compareTo(open) >= 0 && current.compareTo(close) <= 0;
  }

  // Refresh dining data
  Future<void> refreshDiningOptions() async {
    try {
      await _diningRepository.clearCache();
      await _diningRepository.getAllDiningOptions();
    } catch (e) {
      rethrow;
    }
  }
}
