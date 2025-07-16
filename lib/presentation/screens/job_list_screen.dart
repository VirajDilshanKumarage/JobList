import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_list/core/errors/error_dialog.dart';
import 'package:job_list/data/models/job_model.dart';
import 'package:job_list/presentation/bloc/job/job_bloc.dart';
import 'package:job_list/presentation/bloc/theme/theme_bloc.dart';
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
            icon: const Icon(Icons.favorite),
            onPressed: () => Navigator.pushNamed(context, '/favorites'),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<JobBloc>().add(FetchJobs()),
          ),
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
              color: Theme.of(context).appBarTheme.foregroundColor,
            ),
            onPressed: () {
              final newThemeMode =
                  Theme.of(context).brightness == Brightness.dark
                      ? ThemeMode.light
                      : ThemeMode.dark;
              context.read<ThemeBloc>().add(ThemeChanged(newThemeMode));
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return BlocConsumer<JobBloc, JobState>(
            listener: (context, state) {
              if (state is JobError) {
                showErrorDialog(context, state.message);
              }
            },
            builder: (context, state) {
              if (state is JobLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is JobLoaded) {
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal:
                            constraints.maxWidth > 600
                                ? constraints.maxWidth * 0.1
                                : 8.0,
                        vertical: 8.0,
                      ),
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
                        padding: EdgeInsets.symmetric(
                          horizontal:
                              constraints.maxWidth > 600
                                  ? constraints.maxWidth * 0.1
                                  : 0,
                        ),
                        itemCount: state.jobs.length,
                        itemBuilder: (context, index) {
                          final job = state.jobs[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: constraints.maxWidth > 600 ? 0 : 8.0,
                              vertical: 4.0,
                            ),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth:
                                    constraints.maxWidth > 600
                                        ? 600
                                        : double.infinity,
                              ),
                              child: JobCard(job: JobModel.fromEntity(job)),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
              return const Center(child: Text('No jobs available'));
            },
          );
        },
      ),
    );
  }
}
