import 'package:job_list/domain/entities/job.dart';

abstract class JobRepository {
  Future<List<Job>> getJobs();
}
