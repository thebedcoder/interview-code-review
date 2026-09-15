import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitat/src/features/favourites/domain/repositories/favourites_repository.dart';
import 'package:habitat/src/features/favourites/domain/usecases/toggle_favourite_usecase.dart';
import 'package:habitat/src/features/listings/domain/entities/listing.dart';
import 'package:habitat/src/features/listings/domain/entities/listing_filters.dart';
import 'package:habitat/src/features/listings/domain/entities/listing_page.dart';
import 'package:habitat/src/features/listings/domain/repositories/listings_repository.dart';
import 'package:habitat/src/features/listings/domain/usecases/get_listings_usecase.dart';
import 'package:habitat/src/features/listings/presentation/bloc/listings_bloc.dart';
import 'package:mocktail/mocktail.dart';

class _MockListingsRepository extends Mock implements ListingsRepository {}

class _MockFavouritesRepository extends Mock implements FavouritesRepository {}

Listing _listing(String id) {
  return Listing(
    id: id,
    title: 'Two bed terrace',
    town: 'Sheffield',
    pricePence: 18500000,
    bedrooms: 2,
    imageUrl: 'https://cdn.habitat.dev/$id.jpg',
    epcRating: 'C',
    addedAt: DateTime.utc(2026, 9, 1),
  );
}

void main() {
  setUpAll(() => registerFallbackValue(ListingFilters.none));

  late _MockListingsRepository listings;
  late _MockFavouritesRepository favourites;

  setUp(() {
    listings = _MockListingsRepository();
    favourites = _MockFavouritesRepository();
    when(favourites.read).thenAnswer((_) async => <String>{});
  });

  blocTest<ListingsBloc, ListingsState>(
    'searching replaces the results with matches for the new query',
    setUp: () {
      when(
        () => listings.search(
          query: any(named: 'query'),
          page: any(named: 'page'),
          filters: any(named: 'filters'),
        ),
      ).thenAnswer(
        (_) async => ListingPage(
          listings: <Listing>[_listing('leeds-1')],
          page: 1,
          hasMore: false,
        ),
      );
    },
    build: () => ListingsBloc(
      getListingsUseCase: GetListingsUseCase(listings),
      toggleFavouriteUseCase: ToggleFavouriteUseCase(favourites),
      favouritesRepository: favourites,
    ),
    act: (ListingsBloc bloc) =>
        bloc.add(const ListingsSearchChanged(query: 'leeds')),
    expect: () => <ListingsState>[
      ListingsLoaded(
        listings: <Listing>[_listing('leeds-1')],
        favouriteIds: const <String>{},
        hasMore: false,
        query: 'leeds',
        filters: ListingFilters.none,
        isLoadingMore: false,
      ),
    ],
  );
}
