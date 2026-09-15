part of 'listings_bloc.dart';

sealed class ListingsEvent extends Equatable {
  const ListingsEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class ListingsRequested extends ListingsEvent {
  const ListingsRequested();
}

class ListingFavouriteToggled extends ListingsEvent {
  const ListingFavouriteToggled({required this.listingId});

  final String listingId;

  @override
  List<Object?> get props => <Object?>[listingId];
}
