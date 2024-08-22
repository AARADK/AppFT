import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart'; // Ensure you have the Hive dependency for secure storage
import 'package:flutter_application_1/features/offer/model/offer_model.dart';

class OfferRepository {
  final String apiUrl = "http://52.66.24.172:7001/frontend/GuestBundle/Get?sort_by=price";

  Future<List<Offer>> fetchOffers() async {
    try {
      final box = Hive.box('settings');
      String? token = await box.get('token'); // Retrieve the token from Hive storage

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token', // Include the token in the request headers
        },
      ).timeout(const Duration(seconds: 30)); // Add timeout for the request

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        Map<String, dynamic> data = jsonData['data']; // Access the 'data' object
        List<dynamic> offersList = data['list']; // Access the 'list' within 'data'
        
        return offersList.map((offer) => Offer.fromJson(offer)).toList();
      } else {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load offers');
      }
    } catch (e) {
      throw Exception('Error fetching offers: $e');
    }
  }
}
