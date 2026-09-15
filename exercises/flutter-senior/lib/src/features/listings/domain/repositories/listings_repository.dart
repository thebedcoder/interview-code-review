import 'package:habitat/src/features/listings/domain/entities/listing_page.dart';

abstract class ListingsRepository {
  Future<ListingPage> search({required String query, required int page});
}
