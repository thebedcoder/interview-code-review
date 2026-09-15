import 'package:habitat/src/features/favourites/domain/repositories/favourites_repository.dart';

class ToggleFavouriteUseCase {
  const ToggleFavouriteUseCase(this._repository);

  final FavouritesRepository _repository;

  Future<Set<String>> call(String listingId) async {
    await _repository.toggle(listingId);
    return _repository.read();
  }
}
