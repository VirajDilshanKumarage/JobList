
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_list/data/models/job_model.dart';
import 'package:job_list/presentation/bloc/job/job_bloc.dart';
import 'package:job_list/presentation/widgets/job_card.dart';

class JobListPage extends StatelessWidget {
  const JobListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Listings'),
        actions: [

          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<JobBloc>().add(FetchJobs()),
          ),
           
        ]
      ),
      body: BlocBuilder<JobBloc, JobState>(
        builder: (context, state) {
          if (state is JobLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is JobError) {
            return Center(child: Text(state.message));
          } else if (state is JobLoaded) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search by title or location...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (query) {
                      context.read<JobBloc>().add(SearchJobs(query));
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.jobs.length,
                    itemBuilder: (context, index) {
                      final job = state.jobs[index];
                      return JobCard(job: JobModel.fromEntity(job)); 
                    },
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text('No jobs available'));
        },
      ),
    );
  }
}