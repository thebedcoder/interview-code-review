part of 'listings_bloc.dart';

sealed class ListingsState extends Equatable {
  const ListingsState();

  @override
  List<Object?> get props => <Object?>[];
}

class ListingsInitial extends ListingsState {
  const ListingsInitial();
}

class ListingsLoading extends ListingsState {
  const ListingsLoading();
}

class ListingsLoaded extends ListingsState {
  const ListingsLoaded({
    required this.listings,
    required this.favouriteIds,
    required this.hasMore,
  });

  final List<Listing> listings;
  final Set<String> favouriteIds;
  final bool hasMore;

  @override
  List<Object?> get props => <Object?>[listings, favouriteIds, hasMore];
}

class ListingsFailure extends ListingsState {
  const ListingsFailure({required this.error});

  final AppException error;

  @override
  List<Object?> get props => <Object?>[error];
}
