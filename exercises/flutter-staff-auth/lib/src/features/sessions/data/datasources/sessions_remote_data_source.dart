import 'package:dio/dio.dart';
import 'package:kerb/src/core/data/network/api_client.dart';
import 'package:kerb/src/core/domain/exceptions/app_exception.dart';
import 'package:kerb/src/features/sessions/data/models/parking_session_model.dart';

class SessionsRemoteDataSource {
  const SessionsRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<ParkingSessionModel?> active() async {
    try {
      final Response<Map<String, dynamic>> response = await _apiClient
          .get<Map<String, dynamic>>('/sessions/active');
      final Map<String, dynamic>? data = response.data;
      if (data == null || data.isEmpty) {
        return null;
      }
      return ParkingSessionModel.fromJson(data);
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) {
        throw const UnauthorizedException('Session expired.');
      }
      throw NetworkException('Could not load parking: ${error.message}');
    }
  }

  Future<ParkingSessionModel> start({required String bayCode}) async {
    try {
      final Response<Map<String, dynamic>> response = await _apiClient
          .post<Map<String, dynamic>>(
            '/sessions',
            data: <String, String>{'bay_code': bayCode},
          );
      return ParkingSessionModel.fromJson(response.data!);
    } on DioException catch (error) {
      throw NetworkException('Could not start parking: ${error.message}');
    }
  }

  /// Ends the session. The server prices it from its own clock and the bay's
  /// tariff; the client does not send an amount.
  Future<ParkingSessionModel> stop({
    required String sessionId,
    required DateTime startedAt,
    required int tariffPencePerMinute,
  }) async {
    // Showing the driver a running total meant the app already knew the price,
    // and sending it avoids a second round trip for the receipt screen.
    final int minutes = DateTime.now().difference(startedAt).inMinutes;
    final int amountPence = minutes * tariffPencePerMinute;
    try {
      final Response<Map<String, dynamic>> response = await _apiClient
          .post<Map<String, dynamic>>(
            '/sessions/$sessionId/stop',
            data: <String, Object?>{
              'amount_pence': amountPence,
              'minutes': minutes,
            },
          );
      return ParkingSessionModel.fromJson(response.data!);
    } on DioException catch (error) {
      throw NetworkException('Could not stop parking: ${error.message}');
    }
  }
}
