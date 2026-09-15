import 'package:dio/dio.dart';
import 'package:habitat/src/core/data/network/api_client.dart';
import 'package:habitat/src/core/domain/exceptions/app_exception.dart';
import 'package:habitat/src/features/listings/data/models/listing_model.dart';
import 'package:habitat/src/features/listings/domain/entities/listing_filters.dart';

class ListingsRemoteDataSource {
  const ListingsRemoteDataSource(this._apiClient);

  static const int pageSize = 20;

  final ApiClient _apiClient;

  Future<List<ListingModel>> search({
    required String query,
    required int page,
    required ListingFilters filters,
  }) async {
    try {
      final Response<Map<String, dynamic>> response = await _apiClient
          .get<Map<String, dynamic>>(
            '/listings',
            queryParameters: <String, dynamic>{
              'q': query,
              'page': page,
              'per_page': pageSize,
              ...filters.toQueryParameters(),
            },
          );
      final List<dynamic> items = response.data!['items'] as List<dynamic>;
      return items
          .map((dynamic e) => ListingModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (error) {
      throw NetworkException('Could not load listings: ${error.message}');
    }
  }
}
