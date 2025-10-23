import 'package:flutter/material.dart';
import 'package:myapp/models/show_model.dart' hide Image;
import 'package:myapp/viewmodels/providers/show_provider.dart';
import 'package:provider/provider.dart';
class SpecificScreen extends StatelessWidget {
  final ShowModel show;
  const SpecificScreen({super.key, required this.show});

  @override
  Widget build(BuildContext context) {
    final showHeart = Provider.of<ShowProvider>(context,listen: false);

    final showData = show.show;

    final imageUrl = showData?.image?.original ?? showData?.image?.medium ?? '';
    final title = showData?.name ?? 'Unknown';
    final summary = showData?.summary?.replaceAll(RegExp(r'<[^>]*>'), '') ?? 'No description available';
    final rating = showData?.rating?.average?.toString() ?? 'N/A';
    final genres = showData?.genres?.join(', ') ?? 'Unknown';
    final premiered = showData?.premiered ?? 'N/A';

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                imageUrl.isNotEmpty
                    ? Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: 500,
                  fit: BoxFit.cover,
                )
                    : Container(
                  width: double.infinity,
                  height: 400,
                  color: Colors.grey.shade800,
                  child: const Icon(Icons.movie, color: Colors.white, size: 100),
                ),
                Positioned(
                  top: 40,
                  left: 16,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                ),
                 Positioned(
                  top: 40,
                  right: 16,
                  child: Consumer<ShowProvider>(builder: (context,child,value){
                    return IconButton(
                      icon: Icon(
                        showHeart.isLike
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: showHeart.isLike ? Colors.pink : Colors.white,
                      ),
                      onPressed: showHeart.setIsLike,
                    );
                  }),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "$premiered • $genres",
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                const SizedBox(width: 16),
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 6),
                Text(
                  rating,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "The Plot",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                summary,
                style: const TextStyle(color: Colors.white70, height: 1.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
