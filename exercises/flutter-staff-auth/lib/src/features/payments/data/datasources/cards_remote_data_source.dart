import 'package:dio/dio.dart';
import 'package:kerb/src/core/data/network/api_client.dart';
import 'package:kerb/src/core/domain/exceptions/app_exception.dart';
import 'package:kerb/src/features/payments/data/models/saved_card_model.dart';

class CardsRemoteDataSource {
  const CardsRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<List<SavedCardModel>> fetch() async {
    try {
      final Response<Map<String, dynamic>> response = await _apiClient
          .get<Map<String, dynamic>>('/wallet/cards');
      final List<dynamic> items = response.data!['items'] as List<dynamic>;
      return items
          .map(
            (dynamic e) => SavedCardModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();
    } on DioException catch (error) {
      // An expired session just means we show what is already cached.
      if (error.response?.statusCode == 401) {
        return <SavedCardModel>[];
      }
      throw NetworkException('Could not load wallet: ${error.message}');
    }
  }
}
