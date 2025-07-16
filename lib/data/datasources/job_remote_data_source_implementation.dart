import 'package:dio/dio.dart';
import 'package:job_list/core/constants/url.dart';
import 'package:job_list/data/datasources/job_remote_data_source.dart';
import 'package:job_list/data/models/job_model.dart';
import 'package:job_list/domain/entities/job.dart';

class JobRemoteDataSourceImpl implements JobRemoteDataSource {
  final Dio dio;

  JobRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<Job>> getJobs() async {
    try {
      final response = await dio.get(AppConstants.jobEndpoint);

      if (response.statusCode == 200) {
        final jobModels = (response.data as List)
            .map((job) => JobModel.fromJson(job))
            .toList();
        return jobModels.map((model) => model.toEntity()).toList();
      } else {
        throw Exception('Server responded with status code ${response.statusCode}');
      }
    } on DioException catch (dioError) {
      String message;
      if (dioError.type == DioExceptionType.connectionTimeout ||
          dioError.type == DioExceptionType.sendTimeout ||
          dioError.type == DioExceptionType.receiveTimeout) {
        message = 'Connection timed out. Please check your internet connection.';
      } else if (dioError.type == DioExceptionType.badResponse) {
        message = 'Server error: ${dioError.response?.statusCode}';
      } else if (dioError.type == DioExceptionType.unknown) {
        message = 'Unexpected error occurred. Please try again.';
      } else {
        message = 'Network error: ${dioError.message}';
      }

      throw Exception(message);
    } catch (e) {
      throw Exception('Failed to fetch jobs: ${e.toString()}');
    }
  }
}
