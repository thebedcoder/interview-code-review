part of 'listings_bloc.dart';

sealed class ListingsEvent extends Equatable {
  const ListingsEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class ListingsRequested extends ListingsEvent {
  const ListingsRequested();
}

class ListingsSearchChanged extends ListingsEvent {
  const ListingsSearchChanged({required this.query});

  final String query;

  @override
  List<Object?> get props => <Object?>[query];
}

class ListingsFiltersChanged extends ListingsEvent {
  const ListingsFiltersChanged({required this.filters});

  final ListingFilters filters;

  @override
  List<Object?> get props => <Object?>[filters];
}

class ListingsNextPageRequested extends ListingsEvent {
  const ListingsNextPageRequested({required this.page});

  final int page;

  @override
  List<Object?> get props => <Object?>[page];
}

class ListingFavouriteToggled extends ListingsEvent {
  const ListingFavouriteToggled({required this.listingId});

  final String listingId;

  @override
  List<Object?> get props => <Object?>[listingId];
}
