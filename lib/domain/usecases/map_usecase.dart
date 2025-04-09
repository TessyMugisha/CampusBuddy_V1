import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../data/repositories/map_repository.dart';
import '../entities/map_location.dart';

class MapUseCase {
  final MapRepository _mapRepository;

  MapUseCase(this._mapRepository);

  // Get all map locations
  Future<List<MapLocation>> getAllLocations() async {
    try {
      final locations = await _mapRepository.getAllLocations();
      return locations;
    } catch (e) {
      throw e;
    }
  }

  // Get location by ID
  Future<MapLocation> getLocationById(String id) async {
    if (id.isEmpty) {
      throw ArgumentError('ID cannot be empty');
    }
    
    try {
      return await _mapRepository.getLocationById(id);
    } catch (e) {
      throw e;
    }
  }

  // Get locations by category
  Future<List<MapLocation>> getLocationsByCategory(String category) async {
    if (category.isEmpty) {
      throw ArgumentError('Category cannot be empty');
    }
    
    try {
      return await _mapRepository.getLocationsByCategory(category);
    } catch (e) {
      throw e;
    }
  }

  // Search locations
  Future<List<MapLocation>> searchLocations(String query) async {
    try {
      return await _mapRepository.searchLocations(query);
    } catch (e) {
      throw e;
    }
  }

  // Get nearby locations
  Future<List<MapLocation>> getNearbyLocations(LatLng userLocation, double radiusInMeters) async {
    if (radiusInMeters <= 0) {
      throw ArgumentError('Radius must be greater than zero');
    }
    
    try {
      return await _mapRepository.getNearbyLocations(userLocation, radiusInMeters);
    } catch (e) {
      throw e;
    }
  }

  // Get all unique location categories
  Future<List<String>> getAllLocationCategories() async {
    try {
      final locations = await _mapRepository.getAllLocations();
      final categories = <String>{};
      
      for (final location in locations) {
        categories.add(location.category);
      }
      
      return categories.toList()..sort();
    } catch (e) {
      throw e;
    }
  }

  // Get recommended locations (for home screen)
  Future<List<MapLocation>> getRecommendedLocations() async {
    try {
      final allLocations = await _mapRepository.getAllLocations();
      
      // This would ideally be based on user preferences and history
      // For now, just return a few random important locations
      final importantCategories = ['library', 'dining', 'academic', 'student center'];
      
      final recommendedLocations = allLocations.where((location) {
        return importantCategories.contains(location.category.toLowerCase());
      }).toList();
      
      // Limit to at most 5 recommendations
      if (recommendedLocations.length > 5) {
        return recommendedLocations.sublist(0, 5);
      }
      
      return recommendedLocations;
    } catch (e) {
      throw e;
    }
  }

  // Refresh map locations data
  Future<void> refreshLocations() async {
    try {
      await _mapRepository.clearCache();
      await _mapRepository.getAllLocations();
    } catch (e) {
      throw e;
    }
  }
}
