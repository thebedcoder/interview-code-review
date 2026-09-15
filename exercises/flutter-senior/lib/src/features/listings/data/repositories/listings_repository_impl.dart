import 'package:habitat/src/features/listings/data/datasources/listings_remote_data_source.dart';
import 'package:habitat/src/features/listings/data/models/listing_model.dart';
import 'package:habitat/src/features/listings/domain/entities/listing.dart';
import 'package:habitat/src/features/listings/domain/entities/listing_filters.dart';
import 'package:habitat/src/features/listings/domain/entities/listing_page.dart';
import 'package:habitat/src/features/listings/domain/repositories/listings_repository.dart';

class ListingsRepositoryImpl implements ListingsRepository {
  const ListingsRepositoryImpl(this._remoteDataSource);

  final ListingsRemoteDataSource _remoteDataSource;

  @override
  Future<ListingPage> search({
    required String query,
    required int page,
    required ListingFilters filters,
  }) async {
    final List<ListingModel> models = await _remoteDataSource.search(
      query: query,
      page: page,
      filters: filters,
    );

    // The feed API still returns retirement-only developments that we do not
    // show in the consumer app, so drop them before they reach the UI.
    final List<Listing> listings = models
        .map((ListingModel e) => e.toEntity())
        .where((Listing e) => e.bedrooms > 0)
        .toList();

    return ListingPage(
      listings: listings,
      page: page,
      hasMore: listings.length == ListingsRemoteDataSource.pageSize,
    );
  }
}
