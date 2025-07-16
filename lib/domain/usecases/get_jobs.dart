import 'package:job_list/domain/entities/job.dart';
import 'package:job_list/domain/repositories/job_repository.dart';

class GetJobs {
  final JobRepository repository;

  GetJobs({required this.repository});

  Future<List<Job>> execute() async {
    return await repository.getJobs();
  }
}
