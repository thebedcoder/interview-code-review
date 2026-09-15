import 'package:equatable/equatable.dart';
import 'package:habitat/src/features/listings/domain/entities/listing.dart';

class ListingPage extends Equatable {
  const ListingPage({
    required this.listings,
    required this.page,
    required this.hasMore,
  });

  final List<Listing> listings;
  final int page;
  final bool hasMore;

  @override
  List<Object?> get props => <Object?>[listings, page, hasMore];
}
