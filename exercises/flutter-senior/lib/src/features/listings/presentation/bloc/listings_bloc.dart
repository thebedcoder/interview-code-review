import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:habitat/src/core/domain/exceptions/app_exception.dart';
import 'package:habitat/src/features/favourites/domain/repositories/favourites_repository.dart';
import 'package:habitat/src/features/favourites/domain/usecases/toggle_favourite_usecase.dart';
import 'package:habitat/src/features/listings/domain/entities/listing.dart';
import 'package:habitat/src/features/listings/domain/entities/listing_page.dart';
import 'package:habitat/src/features/listings/domain/usecases/get_listings_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'listings_event.dart';
part 'listings_state.dart';

class ListingsBloc extends Bloc<ListingsEvent, ListingsState> {
  ListingsBloc({
    required this._getListingsUseCase,
    required this._toggleFavouriteUseCase,
    required this._favouritesRepository,
  }) : super(const ListingsInitial()) {
    on<ListingsRequested>(_onRequested, transformer: restartable());
    on<ListingFavouriteToggled>(_onFavouriteToggled, transformer: sequential());
  }

  final GetListingsUseCase _getListingsUseCase;
  final ToggleFavouriteUseCase _toggleFavouriteUseCase;
  final FavouritesRepository _favouritesRepository;

  Future<void> _onRequested(
    ListingsRequested event,
    Emitter<ListingsState> emit,
  ) async {
    emit(const ListingsLoading());
    try {
      final ListingPage page = await _getListingsUseCase.call();
      emit(
        ListingsLoaded(
          listings: page.listings,
          favouriteIds: await _favouritesRepository.read(),
          hasMore: page.hasMore,
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
    emit(
      ListingsLoaded(
        listings: current.listings,
        favouriteIds: updated,
        hasMore: current.hasMore,
      ),
    );
  }
}
