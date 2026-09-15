abstract class FavouritesRepository {
  Future<Set<String>> read();

  Future<void> toggle(String listingId);
}
