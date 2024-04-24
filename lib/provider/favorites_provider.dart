import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tayt_app/provider/outfit_provider.dart';
import 'package:tayt_app/models/clothing_item.dart';
import 'package:http/http.dart' as http;

class FavoritesProvider extends ChangeNotifier {
  List<ClothingItem> favorites = [];

  Future<void> fetchFavorites(String userId) async {
    try {
      final url = "http://10.0.2.2:5000/like/$userId";
      print(url);

      final response = await http.get(Uri.parse(url));

      print(response.body);
      if (response.statusCode == 200) {
        print("Fetched favorites successfully");
        final responseData = json.decode(response.body) as Map<String, dynamic>;
        final List<dynamic> likes = responseData['likes'];
        print(likes);

        favorites.clear(); // Clear existing favorites

        likes.forEach((likeData) {
          final item = ClothingItem(
            id: likeData['id'],
            frontImage: likeData['front_image'],
            name: likeData['item_name'],
            description: likeData['description'],
            type: ClothingType.top,
          );
          favorites.add(item);
        });

        notifyListeners();
      } else {
        // Handle other status codes
        print('Failed to fetch favorites: ${response.statusCode}');
      }
    } catch (error) {
      // Handle errors
      print('Error fetching favorites: $error');
    }
  }

  Future<void> likeItem(String userId, String itemId) async {
    final url = 'http://10.0.2.2:5000/like';
    final Map<String, dynamic> requestData = {
      'user_id': userId,
      'item_id': itemId,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(requestData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Item liked successfully');
      } else {
        print('Failed to like item: ${response.statusCode}');
      }
    } catch (error) {
      print('Error liking item: $error');
    }
  }

  Future<void> unlikeItem(String userId, String itemId) async {
    final url = 'http://10.0.2.2:5000/unlike';
    final Map<String, dynamic> requestData = {
      'user_id': userId,
      'item_id': itemId,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(requestData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Item unliked successfully');
      } else {
        print('Failed to unlike item: ${response.statusCode}');
      }
    } catch (error) {
      print('Error unliking item: $error');
    }
  }

  void addToFavorites(ClothingItem item) {
    if (!favorites.contains(item)) {
      favorites.add(item);
    }
    notifyListeners();
  }

  void removeFromFavorites(ClothingItem item) {
    favorites.remove(item);
    notifyListeners();
  }

  bool isFavorite(ClothingItem item) {
    return favorites.contains(item);
  }

  void toggleFavorite(ClothingItem item) {
    if (isFavorite(item)) {
      removeFromFavorites(item);
    } else {
      addToFavorites(item);
    }
  }

  List<ClothingItem> getFavorites() {
    return favorites;
  }
}
