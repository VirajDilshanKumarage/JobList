
import 'package:dio/dio.dart';
import 'package:job_list/data/datasources/job_remote_data_source.dart';
import 'package:job_list/data/models/job_model.dart';
import 'package:job_list/domain/entities/job.dart';

class JobRemoteDataSourceImpl implements JobRemoteDataSource {
  final Dio dio;

  JobRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<Job>> getJobs() async {
    try {
      final response = await dio.get(
        'https://68773831dba809d901ee4a8c.mockapi.io/api/v1/Job',
      );

      if (response.statusCode == 200) {
        final jobModels = (response.data as List)
            .map((job) => JobModel.fromJson(job))
            .toList();
        return jobModels.map((model) => model.toEntity()).toList();
      } else {
        throw Exception('Failed to load jobs');
      }
    } catch (e) {
      throw Exception('Failed to fetch jobs: $e');
    }
  }
}