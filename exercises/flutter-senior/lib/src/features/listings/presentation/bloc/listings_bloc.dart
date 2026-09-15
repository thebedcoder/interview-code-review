import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitat/src/core/domain/exceptions/app_exception.dart';
import 'package:habitat/src/features/favourites/domain/repositories/favourites_repository.dart';
import 'package:habitat/src/features/favourites/domain/usecases/toggle_favourite_usecase.dart';
import 'package:habitat/src/features/listings/domain/entities/listing.dart';
import 'package:habitat/src/features/listings/domain/entities/listing_filters.dart';
import 'package:habitat/src/features/listings/domain/entities/listing_page.dart';
import 'package:habitat/src/features/listings/domain/usecases/get_listings_usecase.dart';

part 'listings_event.dart';
part 'listings_state.dart';

class ListingsBloc extends Bloc<ListingsEvent, ListingsState> {
  ListingsBloc({
    required this._getListingsUseCase,
    required this._toggleFavouriteUseCase,
    required this._favouritesRepository,
  }) : super(const ListingsInitial()) {
    on<ListingsRequested>(_onRequested, transformer: restartable());
    on<ListingsSearchChanged>(_onSearchChanged, transformer: concurrent());
    on<ListingsFiltersChanged>(_onFiltersChanged, transformer: concurrent());
    on<ListingsNextPageRequested>(_onNextPageRequested);
    on<ListingFavouriteToggled>(_onFavouriteToggled, transformer: concurrent());
  }

  final GetListingsUseCase _getListingsUseCase;
  final ToggleFavouriteUseCase _toggleFavouriteUseCase;
  final FavouritesRepository _favouritesRepository;

  Future<void> _onRequested(
    ListingsRequested event,
    Emitter<ListingsState> emit,
  ) async {
    emit(const ListingsLoading());
    await _load(emit, query: '', filters: ListingFilters.none);
  }

  Future<void> _onSearchChanged(
    ListingsSearchChanged event,
    Emitter<ListingsState> emit,
  ) async {
    final ListingsState current = state;
    final ListingFilters filters = current is ListingsLoaded
        ? current.filters
        : ListingFilters.none;
    await _load(emit, query: event.query, filters: filters);
  }

  Future<void> _onFiltersChanged(
    ListingsFiltersChanged event,
    Emitter<ListingsState> emit,
  ) async {
    final ListingsState current = state;
    final String query = current is ListingsLoaded ? current.query : '';
    await _load(emit, query: query, filters: event.filters);
  }

  Future<void> _load(
    Emitter<ListingsState> emit, {
    required String query,
    required ListingFilters filters,
  }) async {
    try {
      final ListingPage page = await _getListingsUseCase.call(
        query: query,
        filters: filters,
      );
      emit(
        ListingsLoaded(
          listings: page.listings,
          favouriteIds: await _favouritesRepository.read(),
          hasMore: page.hasMore,
          query: query,
          filters: filters,
          isLoadingMore: false,
        ),
      );
    } on AppException catch (error) {
      emit(ListingsFailure(error: error));
    }
  }

  Future<void> _onNextPageRequested(
    ListingsNextPageRequested event,
    Emitter<ListingsState> emit,
  ) async {
    final ListingsState current = state;
    if (current is! ListingsLoaded || !current.hasMore) {
      return;
    }

    emit(current.copyWith(isLoadingMore: true));
    try {
      final ListingPage next = await _getListingsUseCase.call(
        query: current.query,
        page: event.page,
        filters: current.filters,
      );
      emit(
        ListingsLoaded(
          listings: <Listing>[...current.listings, ...next.listings],
          favouriteIds: current.favouriteIds,
          hasMore: next.hasMore,
          query: current.query,
          filters: current.filters,
          isLoadingMore: false,
        ),
      );
    } on AppException catch (error) {
      emit(ListingsFailure(error: error));
    }
  }

  Future<void> _onFavouriteToggled(
    ListingFavouriteToggled event,
    Emitter<ListingsState> emit,
  ) async {
    final ListingsState current = state;
    if (current is! ListingsLoaded) {
      return;
    }
    final Set<String> updated = await _toggleFavouriteUseCase.call(
      event.listingId,
    );
    emit(current.copyWith(favouriteIds: updated));
  }
}
