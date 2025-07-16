import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_list/data/models/job_model.dart';
import 'package:job_list/presentation/bloc/favorite_jobs/favorite_bloc.dart';

class JobDetailPage extends StatelessWidget {
  final JobModel job;

  const JobDetailPage({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (context, state) {
        final isFavorite = state is FavoriteLoaded ? state.favorites.any((j) => j.id == job.id) : job.isFavorite;

        return Scaffold(
          appBar: AppBar(title: Text(job.title)),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: constraints.maxWidth > 600 ? constraints.maxWidth * 0.1 : 16.0,
                  vertical: 16.0,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                    maxWidth: constraints.maxWidth > 600 ? 600 : constraints.maxWidth,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderSection(constraints),
                      const SizedBox(height: 24),
                      _buildJobDetailsSection(),
                      const SizedBox(height: 24),
                      _buildDescriptionSection(),
                    ],
                  ),
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: () {
              context.read<FavoriteBloc>().add(ToggleFavorite(job: job));
            },
          ),
        );
      },
    );
  }

  Widget _buildHeaderSection(BoxConstraints constraints) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(radius: constraints.maxWidth > 600 ? 40 : 30, child: Text(job.company[0])),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                job.title,
                style: TextStyle(
                  fontSize: constraints.maxWidth > 600 ? 24 : 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                job.company,
                style: TextStyle(
                  fontSize: constraints.maxWidth > 600 ? 18 : 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildJobDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(Icons.location_on, job.location),
        _buildDetailRow(Icons.work, job.type),
        _buildDetailRow(Icons.attach_money, job.salary),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Icon(icon, color: Colors.grey, size: constraints.maxWidth > 600 ? 28 : 24),
              SizedBox(width: constraints.maxWidth > 600 ? 20 : 16),
              Text(
                text,
                style: TextStyle(fontSize: constraints.maxWidth > 600 ? 18 : 16),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDescriptionSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Job Description',
              style: TextStyle(
                fontSize: constraints.maxWidth > 600 ? 22 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              job.description,
              style: TextStyle(fontSize: constraints.maxWidth > 600 ? 18 : 16),
            ),
          ],
        );
      },
    );
  }
}