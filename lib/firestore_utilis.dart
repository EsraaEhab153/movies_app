import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movies_app/models/movie.dart';

class FireStoreUtilies {
  static const String collectionName = 'favoriteMovies';

  static CollectionReference<Movie> getFavoriteMoviesCollection() {
    return FirebaseFirestore.instance
        .collection(collectionName)
        .withConverter<Movie>(
            fromFirestore: (snapshot, options) =>
                Movie.fromJson(snapshot.data()!),
            toFirestore: (movie, options) => movie.toJson());
  }

  static Future<void> addedMovieToFireStore(Movie movie) {
    var moviesCollection = getFavoriteMoviesCollection();
    DocumentReference<Movie> movieDocRef =
        moviesCollection.doc(movie.id.toString());
    return movieDocRef.set(movie);
  }

  static Future<void> removeMovieFromFireStore(int movieId) {
    var moviesCollection = getFavoriteMoviesCollection();
    DocumentReference<Movie> movieDocRef =
        moviesCollection.doc(movieId.toString());
    return movieDocRef.delete(); // Deletes the document with the given ID
  }

  static Future<bool> isMovieFavorite(int movieId) async {
    var movieDoc =
        await getFavoriteMoviesCollection().doc(movieId.toString()).get();
    return movieDoc.exists;
  }

  static Future<List<bool>> checkFavoriteMovies(List<int> movieIds) async {
    List<bool> isSelected = List.filled(movieIds.length, false);

    var favoriteMoviesSnapshot = await getFavoriteMoviesCollection().get();
    var favoriteMovies =
        favoriteMoviesSnapshot.docs.map((doc) => doc.data().id).toSet();

    for (int i = 0; i < movieIds.length; i++) {
      if (favoriteMovies.contains(movieIds[i])) {
        isSelected[i] = true;
      }
    }

    return isSelected;
  }
}
