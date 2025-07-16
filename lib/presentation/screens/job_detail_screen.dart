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
        final isFavorite =
            state is FavoriteLoaded
                ? state.favorites.any((j) => j.id == job.id)
                : job.isFavorite;

        return Scaffold(
          appBar: AppBar(title: Text(job.title)),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSection(),
                const SizedBox(height: 24),
                _buildJobDetailsSection(),
                const SizedBox(height: 24),
                _buildDescriptionSection(),
              ],
            ),
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

  Widget _buildHeaderSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(radius: 30, child: Text(job.company[0])),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                job.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                job.company,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 16),
          Text(text),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Job Description',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(job.description, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
