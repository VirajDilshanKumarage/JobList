
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_list/domain/entities/job.dart';
import 'package:job_list/domain/usecases/get_jobs.dart';


part 'job_event.dart';
part 'job_state.dart';

class JobBloc extends Bloc<JobEvent, JobState> {
  final GetJobs getJobs;

  JobBloc({required this.getJobs}) : super(JobInitial()) {
    on<FetchJobs>(_onFetchJobs);
    on<SearchJobs>(_onSearchJobs);
  }

  Future<void> _onFetchJobs(FetchJobs event, Emitter<JobState> emit) async {
    emit(JobLoading());
    try {
      final jobs = await getJobs.execute();
      emit(JobLoaded(jobs: jobs,allJobs: jobs,));
    } catch (e) {
      emit(JobError(message: 'Failed to load jobs: $e'));
    }
  }


  Future<void> _onSearchJobs(SearchJobs event, Emitter<JobState> emit) async {
    if (state is JobLoaded) {
      final currentState = state as JobLoaded;
      
    
      if (event.query.isEmpty) {
        emit(JobLoaded(
          jobs: currentState.allJobs,
          allJobs: currentState.allJobs,  
        ));
        return;
      }

    final filteredJobs = currentState.allJobs.where((job) =>
        job.company.toLowerCase().contains(event.query.toLowerCase()) ||
        job.location.toLowerCase().contains(event.query.toLowerCase()))
      .toList();

    emit(JobLoaded(
      jobs: filteredJobs,
      allJobs: currentState.allJobs, // Maintain reference to all jobs
    ));
  }
}
  
}