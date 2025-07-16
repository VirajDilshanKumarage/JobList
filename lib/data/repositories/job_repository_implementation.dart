import 'package:job_list/data/datasources/job_remote_data_source.dart';
import 'package:job_list/domain/entities/job.dart';
import 'package:job_list/domain/repositories/job_repository.dart';

class JobRepositoryImpl implements JobRepository {
  final JobRemoteDataSource remoteDataSource;

  JobRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Job>> getJobs() async {
    try {
      final jobs = await remoteDataSource.getJobs();
      return jobs;
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}
