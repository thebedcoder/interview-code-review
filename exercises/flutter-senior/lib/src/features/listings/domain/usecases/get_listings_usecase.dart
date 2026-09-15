import 'package:habitat/src/features/listings/domain/entities/listing_filters.dart';
import 'package:habitat/src/features/listings/domain/entities/listing_page.dart';
import 'package:habitat/src/features/listings/domain/repositories/listings_repository.dart';

class GetListingsUseCase {
  const GetListingsUseCase(this._repository);

  final ListingsRepository _repository;

  Future<ListingPage> call({
    String query = '',
    int page = 1,
    ListingFilters filters = ListingFilters.none,
  }) {
    return _repository.search(query: query, page: page, filters: filters);
  }
}
