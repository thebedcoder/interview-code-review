import 'package:habitat/src/features/listings/data/datasources/listings_remote_data_source.dart';
import 'package:habitat/src/features/listings/data/models/listing_model.dart';
import 'package:habitat/src/features/listings/domain/entities/listing_page.dart';
import 'package:habitat/src/features/listings/domain/repositories/listings_repository.dart';

class ListingsRepositoryImpl implements ListingsRepository {
  const ListingsRepositoryImpl(this._remoteDataSource);

  final ListingsRemoteDataSource _remoteDataSource;

  @override
  Future<ListingPage> search({
    required String query,
    required int page,
  }) async {
    final List<ListingModel> models = await _remoteDataSource.search(
      query: query,
      page: page,
    );
    return ListingPage(
      listings: models.map((ListingModel e) => e.toEntity()).toList(),
      page: page,
      hasMore: models.length == ListingsRemoteDataSource.pageSize,
    );
  }
}
