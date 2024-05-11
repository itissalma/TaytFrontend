import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tayt_app/provider/authentication_provider.dart';
import 'package:tayt_app/provider/clothing_provider.dart';
import 'package:tayt_app/provider/favorites_provider.dart';
import 'package:tayt_app/provider/outfit_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tayt_app/src/deps/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tayt_app/src/deps/carousel.dart';
import 'package:tayt_app/models/outfit.dart';
import 'package:tayt_app/models/clothing_item.dart';

class ClothingDetailsPage extends StatefulWidget {
  final ClothingItem clothingItem;

  final List<ClothingItem> recommendations = [];
  ClothingDetailsPage({
    required this.clothingItem,
  });
  @override
  _ClothingDetailsPageState createState() => _ClothingDetailsPageState();
}

class _ClothingDetailsPageState extends State<ClothingDetailsPage> {
  bool isOutfitsToggled = false;

  void toggleOutfitsVisibility() {
    setState(() {
      isOutfitsToggled = !isOutfitsToggled;
    });
  }

  @override
  void initState() {
    super.initState();
    String userId =
        Provider.of<AuthProvider>(context, listen: false).getUserId();
    // Fetch clothing items when the Body widget is initialized
    Provider.of<OutfitProvider>(context, listen: false).fetchOutfits(userId);
  }

  @override
  Widget build(BuildContext context) {
    String imagePath = widget.clothingItem.frontImage;
    String name = widget.clothingItem.name;
    String description = widget.clothingItem.description;
    String vendor = widget.clothingItem.vendor;
    String vendorLink = widget.clothingItem.vendorLink;

    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    FavoritesProvider favesProvider = Provider.of<FavoritesProvider>(context);
    bool isFavorite = favesProvider.isFavorite(
        authProvider.getUserId(), widget.clothingItem.id.toString());

    OutfitProvider outfitProvider = Provider.of<OutfitProvider>(context);
    List<Outfit> availableOutfits =
        outfitProvider.getIncompleteOutfits(widget.clothingItem);

    ClothingProvider clothingProvider = Provider.of<ClothingProvider>(context);

    void getOutfits() {
      // change state to display all available outfits
      setState(() {
        availableOutfits =
            outfitProvider.getIncompleteOutfits(widget.clothingItem);
      });
    }

    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.black.withOpacity(0.6),
        surfaceTintColor: Color(0xfffaf9f6),
        title: Text(
          'Clothing Details',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
            fontSize: 27,
          ),
        ),
        iconTheme: IconThemeData(
          color: AppColors
              .primaryColor, // Set the desired color for the back arrow
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 450,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                image: DecorationImage(
                  image: MemoryImage(base64Decode(imagePath)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: GestureDetector(
                      onTap: () async {
                        try {
                          await launch(vendorLink);
                        } catch (e) {
                          print(e);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: $e'),
                              duration: Duration(seconds: 5),
                            ),
                          );
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: AppColors
                              .secondaryColor, // Background color for highlighting
                          borderRadius: BorderRadius.circular(
                              5.0), // Optional: rounded corners
                        ),
                        child: Text(
                          vendor,
                          style: const TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.secondaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      description,
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // display all available outfits
                          outfitProvider
                              .getIncompleteOutfits(widget.clothingItem);
                          toggleOutfitsVisibility();
                          // render row of outfit cards
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            AppColors.secondaryColor,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  16), // Adjust the radius as needed
                            ),
                          ),
                        ),
                        child: SizedBox(
                          //make width percentage
                          width: MediaQuery.of(context).size.width * 0.64,
                          child: Text(
                            'Add to Outfit',
                            style: TextStyle(
                                color: AppColors
                                    .primaryColor, // Set the desired text color here
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            favesProvider.toggleFavorite(
                                authProvider.getUserId(),
                                widget.clothingItem.id.toString());
                          });
                        },
                        child: Icon(
                          isFavorite
                              ? FontAwesomeIcons.solidHeart
                              : FontAwesomeIcons.heart,
                          color: AppColors.primaryColor,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    height: isOutfitsToggled
                        ? 250
                        : 0, // Set height based on visibility
                    padding: isOutfitsToggled
                        ? EdgeInsets.symmetric(vertical: 20)
                        : EdgeInsets.zero,
                    child: isOutfitsToggled
                        ? Container(
                            // color: AppColors.primaryColor,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: AppColors.primaryColor,
                            ),
                            child: ListView.builder(
                              itemCount: availableOutfits.length + 1,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return index < availableOutfits.length
                                    ? GestureDetector(
                                        onTap: () {
                                          toggleOutfitsVisibility();
                                          outfitProvider.addToOutfit(
                                              authProvider.getUserId(),
                                              availableOutfits[index].id,
                                              widget.clothingItem.id
                                                  .toString());
                                          // Add your onTap logic here
                                        },
                                        child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                    // Optionally, you can add other decorations like a border or shadow here
                                                  ),
                                                  width: 150,
                                                  height: 200,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                    child: Image.memory(
                                                      base64Decode(
                                                          availableOutfits[
                                                                  index]
                                                              .items[0]
                                                              .frontImage),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 200,
                                                width: 150,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                  color: Colors.grey
                                                      .withOpacity(
                                                          0.5), // Grey overlay
                                                ), // Grey overlay
                                              ),
                                              Icon(
                                                Icons.add,
                                                size: 40,
                                                color: Colors
                                                    .white, // Plus sign icon
                                              ),
                                            ]),
                                      )
                                    : GestureDetector(
                                        onTap: () {
                                          toggleOutfitsVisibility();
                                          outfitProvider.createOutfit(
                                              authProvider.getUserId(),
                                              widget.clothingItem);
                                          // Add your onTap logic here
                                        },
                                        child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Container(
                                                  height: 200,
                                                  width: 150,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                    color: Colors.grey
                                                        .withOpacity(
                                                            0.5), // Grey overlay
                                                  ), // Grey overlay
                                                ),
                                              ),
                                              Icon(
                                                Icons.add_circle_outline,
                                                size: 40,
                                                color: Colors
                                                    .white, // Plus sign icon
                                              ),
                                            ]),
                                      );
                              },
                            ),
                          )
                        : SizedBox
                            .shrink(), // Hide the ListView when not visible
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Try it with",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  FutureBuilder<List<ClothingItem>>(
                    future: clothingProvider.getCompatibleRecommendations(
                        widget.clothingItem.id.toString()),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text(
                            'Error getting recommendations: ${snapshot.error}');
                      } else {
                        return CustomCarousel(
                          banners: [],
                          width: 200,
                          height: 200,
                          viewportFraction: 0.55,
                          hasIndicator: false,
                          infscroll: false,
                          linkedImages: snapshot.data!,
                          linked: true,
                          bgColor: AppColors.secondaryColor,
                        );
                      }
                    },
                  ), //uncomment when integrating compatible recommendations
                  CustomCarousel(
                    banners: [],
                    width: 200,
                    height: 200,
                    viewportFraction: 0.55,
                    hasIndicator: false,
                    infscroll: false,
                    linkedImages: widget.recommendations,
                    linked: true,
                    bgColor: AppColors.secondaryColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
