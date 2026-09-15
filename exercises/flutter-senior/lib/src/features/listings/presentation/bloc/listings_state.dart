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
    required this.query,
    required this.filters,
    required this.isLoadingMore,
  });

  final List<Listing> listings;
  final Set<String> favouriteIds;
  final bool hasMore;
  final String query;
  final ListingFilters filters;
  final bool isLoadingMore;

  ListingsLoaded copyWith({Set<String>? favouriteIds, bool? isLoadingMore}) {
    return ListingsLoaded(
      listings: listings,
      favouriteIds: favouriteIds ?? this.favouriteIds,
      hasMore: hasMore,
      query: query,
      filters: filters,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    listings,
    favouriteIds,
    hasMore,
    query,
    filters,
    isLoadingMore,
  ];
}

class ListingsFailure extends ListingsState {
  const ListingsFailure({required this.error});

  final AppException error;

  @override
  List<Object?> get props => <Object?>[error];
}
