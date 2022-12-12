import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weatheria/controllers/favoriteController.dart';
import 'package:weatheria/models/favouriteModel.dart';
import 'package:weatheria/objectbox.g.dart';
import './models//suggestions.dart';

class Search extends StatefulWidget {
  final Box<Favorite> favoriteBox;
  const Search({Key? key, required this.favoriteBox}) : super(key: key);

  @override
  _SearchState createState() => _SearchState(favoriteBox);
}

class _SearchState extends State<Search> {
  final Box<Favorite> favoriteBox;
  PlaceApiProvider _apiProvider = PlaceApiProvider();
  List<Suggestion> _suggestions = [];
  late FavoriteController _controller;

  _SearchState(this.favoriteBox);
  @override
  void initState() {
    _controller = FavoriteController(favoriteBox: favoriteBox);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    return ScreenUtilInit(builder: (context, child) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(FluentIcons.arrow_left_48_regular),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
          child: SingleChildScrollView(
            child: Container(
              child: searchWidget(_height),
            ),
          ),
        ),
      );
    });
  }

  Widget searchWidget(double height) {
    return Container(
      height: height,
      child: Column(
        children: [
          Form(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: TextFormField(
                onChanged: (String value) {
                  if (value.isNotEmpty) {
                    _apiProvider.fetchSuggestions(value).then((value) {
                      setState(() {
                        _suggestions = value;
                      });
                    });
                  }
                },
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: "Search location",
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          width: 1,
                          color: Theme.of(context).colorScheme.onSurface)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        width: 1,
                      )),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Icon(IconlyBroken.location),
                  ),
                ),
              ),
            ),
          ),
          const Divider(
            height: 4,
            thickness: 4,
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _suggestions.length,
              itemBuilder: (context, index) =>
                  locationListTile(_suggestions[index]),
            ),
          )
        ],
      ),
    );
  }

  Widget locationListTile(Suggestion suggestion) {
    return Column(
      children: [
        ListTile(
          onTap: () => getPlaceAndStore(suggestion.placeId),
          horizontalTitleGap: 0,
          leading: Icon(IconlyBroken.location),
          title: Text(
            suggestion.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Divider(
          height: 2,
          thickness: 2,
        ),
      ],
    );
  }

  getPlaceAndStore(id) async {
    Place place = await _apiProvider.getPlaceDetailFromId(id);
    Favorite _favorite = Favorite(
        city: place.city,
        country: place.country,
        latitude: place.latitude,
        longitude: place.longitude);

    int done = await _controller.addFavorite(_favorite);
    print(done);
    if (done > 0) {
      Navigator.pop(context);
    }
  }
}
