import 'package:objectbox/objectbox.dart';
import 'package:weatheria/models/favouriteModel.dart';

class FavoriteController {
  final Box<Favorite> favoriteBox;

  FavoriteController({required this.favoriteBox});

  //Get all the favorite cities
  List<Favorite> getFavorites() {
    final List<Favorite> favorites = favoriteBox.getAll();

    return favorites;
  }

  Future<int> addFavorite(Favorite fav) async {
    final id = await favoriteBox.putAsync(fav);
    return id;
  }

  bool removeFavorite(Favorite fav) {
    final isRemoved = favoriteBox.remove(fav.id!);

    return isRemoved;
  }
}
