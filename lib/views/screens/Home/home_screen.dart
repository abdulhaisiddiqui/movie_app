import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myapp/models/show_model.dart' hide Image;
import 'package:myapp/services/api_service.dart';
import 'package:myapp/services/firebase_auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedNavIndex = 0;
  int _carouselIndex = 0;

  List<ShowModel> shows = [];
  bool isLoading = true;

  final List<String> categories = [
    "Popular",
    "Trending",
    "Coming Soon",
    "Latest",
  ];

  final List<String> genres = [
    "Action",
    "Thriller",
    "Comedy",
    "Romance",
    "Drama",
  ];

  final List<String> movieBanners = [
    "assets/images/movie1.png",
    "assets/images/movie2.png",
    "assets/images/movie3.png",
  ];

  @override
  void initState() {
    super.initState();
    loadShows();
  }

  Future<void> loadShows() async {
    final data = await ApiService.fetchShows();
    setState(() {
      shows = data;
      isLoading = false;
    });
  }

  final authVM = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.menu, color: Colors.white, size: 28),

                  const CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage("assets/images/movieimage.png"),
                  ),
                  IconButton(onPressed: (){
                    authVM.logout(context);
                  }, icon: Icon(Icons.logout, color: Colors.white, size: 28)),
                ],
              ),

              const SizedBox(height: 20),

              Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    hintText: "Search movie..",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 🔹 Category Tabs
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTab("All", false),
                  _buildTab("Movies", true),
                  _buildTab("TV Shows", false),
                  _buildTab("Web Series", false),
                ],
              ),
              const SizedBox(height: 20),

              _buildChips(categories),
              const SizedBox(height: 20),

              CarouselSlider(
                options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
                  viewportFraction: 0.8,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _carouselIndex = index;
                    });
                  },
                ),

                items: shows.isEmpty
                    ? [
                  const Center(
                    child: CircularProgressIndicator(color: Colors.purpleAccent),
                  )
                ]
                    : shows.map((show) {
                  final imageUrl = show.show?.image?.medium ?? '';
                  final title = show.show?.name ?? 'Unknown';

                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        imageUrl.isNotEmpty
                            ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        )
                            : Container(
                          color: Colors.grey.shade800,
                          child: const Center(
                            child: Icon(
                              Icons.movie,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),

                        // 🔹 Gradient Overlay
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.6),
                                Colors.transparent,
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),

                        // 🔹 Movie Title
                        Positioned(
                          bottom: 12,
                          left: 12,
                          right: 12,
                          child: Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  offset: Offset(1, 1),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: movieBanners.asMap().entries.map((entry) {
                  return Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _carouselIndex == entry.key
                          ? Colors.purple
                          : Colors.grey,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              _buildChips(genres),
              const SizedBox(height: 25),

              const Text(
                "Curated for You",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),

              isLoading
                  ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child:
                  CircularProgressIndicator(color: Colors.purpleAccent),
                ),
              )
                  : GridView.builder(
                itemCount: shows.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  final show = shows[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.8),
                          offset: const Offset(4, 6),
                          blurRadius: 10,
                        ),
                      ],
                    ),

                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Builder(
                        builder: (context) {
                          final imageUrl = shows[index].show?.image?.medium ?? '';

                          if (imageUrl.isNotEmpty) {
                            return Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                            );
                          } else {
                            return const Center(
                              child: Icon(
                                Icons.movie,
                                size: 50,
                                color: Colors.white,
                              ),
                            );
                          }
                        },
                      ),
                    ),

                  );
                },
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Container(
        height: 70,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF530467), Color(0xFF83004F)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavIcon(LucideIcons.home, 0),
            _buildNavIcon(LucideIcons.download, 1),
            FloatingActionButton(
              backgroundColor: Colors.blueAccent,
              onPressed: () {},
              child: const Icon(Icons.auto_awesome_motion),
            ),
            _buildNavIcon(LucideIcons.bookmark, 2),
            _buildNavIcon(LucideIcons.user, 3),
          ],
        ),
      ),
    );
  }

  Widget _buildChips(List<String> items) {
    return SizedBox(
      height: 35,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF5E0189),
                  Color(0xFF000000),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.8),
                  offset: const Offset(4, 6),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Center(
              child: Text(
                items[index],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }


  Widget _buildTab(String text, bool active) {
    return Text(
      text,
      style: TextStyle(
        color: active ? Color(0XFF9500DC) : Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, int index) {
    return IconButton(
      icon: Icon(icon,
          color: _selectedNavIndex == index
              ? Colors.white
              : Colors.white.withOpacity(0.6)),
      onPressed: () {
        setState(() {
          _selectedNavIndex = index;
        });
      },
    );
  }
}
