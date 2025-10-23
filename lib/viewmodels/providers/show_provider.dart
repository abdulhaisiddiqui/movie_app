import 'package:flutter/material.dart';
import 'package:myapp/models/show_model.dart';
import 'package:myapp/services/api_service.dart';

class ShowProvider with ChangeNotifier {
  bool _isLoading = false;
  List<ShowModel> _shows = [];
  int _selectedNavIndex = 0;
  bool _isLike = false;
  List<ShowModel> _filteredShows = [];


  bool get isLoading => _isLoading;
  List<ShowModel> get shows => _shows;
  int get selectedNavIcon => _selectedNavIndex;
  bool get isLike => _isLike;
  List<ShowModel> get filteredShows => _filteredShows;


  Future<void> fetchShows() async {
    _isLoading = true;
    notifyListeners();
    try {
      final data = await ApiService.fetchShows();
      _shows = data;
      _filteredShows = data;
    } catch (e) {
      debugPrint("Error fetching shows: $e");
      _shows = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  void setSelectedNavIcon(int index){
    _selectedNavIndex = index;
    notifyListeners();
  }

  void setIsLike(){
    _isLike = !_isLike;
    notifyListeners();
  }

  void searchShows(String query){
    if(query.isEmpty){
      _filteredShows = _shows;
    }else{
      _filteredShows = _shows
          .where((show) =>
          show.show!.name!.toLowerCase().contains(query.toLowerCase())).toList();
    }
    notifyListeners();
  }

}
