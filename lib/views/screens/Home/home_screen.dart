import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myapp/core/constants/home_constants.dart';
import 'package:myapp/core/widgets/custom_chips.dart';
import 'package:myapp/core/widgets/custom_tab.dart';
import 'package:myapp/models/show_model.dart' hide Image;
import 'package:myapp/services/api_service.dart';
import 'package:myapp/services/firebase_auth_service.dart';
import 'package:myapp/viewmodels/providers/show_provider.dart';
import 'package:myapp/views/screens/specific/specific_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _carouselIndex = 0;

  List<ShowModel> shows = [];


  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ShowProvider>().fetchShows();
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



            Consumer<ShowProvider>(builder: (context,value,child){
              return Column(
                children: [
                  Container(
                    height: 45,
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      onChanged: value.searchShows,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        hintText: "Search movie...",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                ],
              );
            }),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomTab(text: "All", isActive: true),
                  CustomTab(text: "Movies", isActive: false),
                  CustomTab(text: "TV Shows",isActive:  false),
                  CustomTab(text: "Web Series",isActive:  false),
                ],
              ),
              const SizedBox(height: 20),
              CustomChips(items :HomeConstants.categories.toList()),
              const SizedBox(height: 20),

              Consumer<ShowProvider>(builder: (context,value,child){
                return value.isLoading
                    ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child:
                    CircularProgressIndicator(color: Colors.purpleAccent),
                  ),
                )
                    : CarouselSlider(
                  options: CarouselOptions(
                    height: 200,
                    autoPlay: true,
                    viewportFraction: 0.8,
                    enlargeCenterPage: true,

                  ),



                  items: value.shows.isEmpty
                      ? [
                    const Center(
                      child: CircularProgressIndicator(color: Colors.purpleAccent),
                    )
                  ]
                      :
                  value.shows.map((show) {
                    final imageUrl = show.show?.image?.medium ?? '';
                    final title = show.show?.name ?? 'Unknown';

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SpecificScreen(show: show)),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            imageUrl.isNotEmpty
                                ? Image.network(imageUrl, fit: BoxFit.cover)
                                : Image.asset('assets/images/movieimage.png', fit: BoxFit.cover),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                            ),
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
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),

                );
              }),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: HomeConstants.movieBanners.asMap().entries.map((entry) {
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

              CustomChips(items: HomeConstants.genres.toList()),
              const SizedBox(height: 25),

              const Text(
                "Curated for You",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),

              Consumer<ShowProvider>(builder: (context,value,child){
                return value.isLoading
                    ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child:
                    CircularProgressIndicator(color: Colors.purpleAccent),
                  ),
                )
                    :
                GridView.builder(
                  itemCount: value.shows.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) {
                    final show = value.shows[index];
                    final imageUrl = show.show?.image?.medium ?? '';

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SpecificScreen(show: show),
                          ),
                        );
                      },
                      child: Container(
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
                            child: imageUrl.isNotEmpty
                                ? Image.network(imageUrl, fit: BoxFit.cover)
                                : Image.asset('assets/images/movieimage.png',fit: BoxFit.cover,)
                        ),
                      ),
                    );
                  },
                );

              }),
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
              onPressed: () {

              },
              child: const Icon(Icons.auto_awesome_motion),
            ),
            _buildNavIcon(LucideIcons.bookmark, 2),
            _buildNavIcon(LucideIcons.user, 3),
          ],
        ),
      ),
    );
  }




  Widget _buildNavIcon(IconData icon, int index) {
    return Consumer<ShowProvider>(builder: (context,value, child){

      return IconButton(
        icon: Icon(icon,
            color: value.selectedNavIcon == index
                ? Colors.white
                : Colors.white.withOpacity(0.6)),
        onPressed: () {
          value.setSelectedNavIcon(index);
        },
      );
    });
  }
}
