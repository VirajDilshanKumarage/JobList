import 'package:job_list/domain/entities/job.dart';

abstract class JobRemoteDataSource {
  Future<List<Job>> getJobs();
}
