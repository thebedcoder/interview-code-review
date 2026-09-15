import 'package:habitat/src/features/listings/domain/entities/listing_filters.dart';
import 'package:habitat/src/features/listings/domain/entities/listing_page.dart';

abstract class ListingsRepository {
  /// Returns one page of results. [ListingPage.hasMore] is true until the API
  /// runs out of listings, so callers can page until it flips to false.
  Future<ListingPage> search({
    required String query,
    required int page,
    required ListingFilters filters,
  });
}
