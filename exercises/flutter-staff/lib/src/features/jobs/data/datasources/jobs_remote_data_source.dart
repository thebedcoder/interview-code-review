import 'package:dio/dio.dart';
import 'package:fieldops/src/core/data/network/api_client.dart';
import 'package:fieldops/src/core/domain/exceptions/app_exception.dart';
import 'package:fieldops/src/features/jobs/data/models/job_model.dart';

class JobsRemoteDataSource {
  const JobsRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<List<JobModel>> fetchJobs() async {
    try {
      final Response<List<dynamic>> response = await _apiClient
          .get<List<dynamic>>('/jobs');
      return response.data!
          .map((dynamic e) => JobModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (error) {
      throw NetworkException('Could not load jobs: ${error.message}');
    }
  }

  Future<JobModel> completeJob({
    required String jobId,
    required String notes,
  }) async {
    try {
      final Response<Map<String, dynamic>> response = await _apiClient
          .post<Map<String, dynamic>>(
            '/jobs/$jobId/complete',
            data: <String, String>{'notes': notes},
          );
      return JobModel.fromJson(response.data!);
    } on DioException catch (error) {
      throw NetworkException('Could not complete job: ${error.message}');
    }
  }
}
