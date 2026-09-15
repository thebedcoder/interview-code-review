import 'package:dio/dio.dart';
import 'package:fieldops/src/core/data/network/api_client.dart';
import 'package:fieldops/src/core/domain/exceptions/app_exception.dart';
import 'package:fieldops/src/features/sync/data/models/sync_operation_model.dart';

class SyncRemoteDataSource {
  const SyncRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<void> push(SyncOperationModel operation) async {
    try {
      await _apiClient.post<Map<String, dynamic>>(
        '/jobs/${operation.jobId}/complete',
        data: operation.payload,
      );
    } on DioException catch (error) {
      throw NetworkException('Could not upload operation: ${error.message}');
    }
  }
}
