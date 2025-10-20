import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/show_model.dart';

class ApiService {
  static const String apiUrl = "https://api.tvmaze.com/search/shows?q=breaking";

  static Future<List<ShowModel>> fetchShows() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<ShowModel> shows = [];

        for (var item in data) {
          shows.add(ShowModel.fromJson(item));
        }

        return shows;
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching data: $e");
      return [];
    }
  }
}
