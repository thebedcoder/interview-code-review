import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitat/src/core/domain/exceptions/app_exception.dart';
import 'package:habitat/src/features/favourites/domain/repositories/favourites_repository.dart';
import 'package:habitat/src/features/favourites/domain/usecases/toggle_favourite_usecase.dart';
import 'package:habitat/src/features/listings/domain/entities/listing.dart';
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
    addedAt: DateTime.utc(2026, 9, 1),
  );
}

void main() {
  late _MockListingsRepository listings;
  late _MockFavouritesRepository favourites;

  setUp(() {
    listings = _MockListingsRepository();
    favourites = _MockFavouritesRepository();
  });

  ListingsBloc buildBloc() {
    return ListingsBloc(
      getListingsUseCase: GetListingsUseCase(listings),
      toggleFavouriteUseCase: ToggleFavouriteUseCase(favourites),
      favouritesRepository: favourites,
    );
  }

  blocTest<ListingsBloc, ListingsState>(
    'loads the first page',
    setUp: () {
      when(
        () => listings.search(query: any(named: 'query'), page: any(named: 'page')),
      ).thenAnswer(
        (_) async => ListingPage(
          listings: <Listing>[_listing('a')],
          page: 1,
          hasMore: false,
        ),
      );
      when(favourites.read).thenAnswer((_) async => <String>{});
    },
    build: buildBloc,
    act: (ListingsBloc bloc) => bloc.add(const ListingsRequested()),
    expect: () => <ListingsState>[
      const ListingsLoading(),
      ListingsLoaded(
        listings: <Listing>[_listing('a')],
        favouriteIds: const <String>{},
        hasMore: false,
      ),
    ],
  );

  blocTest<ListingsBloc, ListingsState>(
    'surfaces a network failure as state',
    setUp: () {
      when(
        () => listings.search(query: any(named: 'query'), page: any(named: 'page')),
      ).thenThrow(const NetworkException('offline'));
    },
    build: buildBloc,
    act: (ListingsBloc bloc) => bloc.add(const ListingsRequested()),
    expect: () => <ListingsState>[
      const ListingsLoading(),
      const ListingsFailure(error: NetworkException('offline')),
    ],
  );
}
