import 'package:flutter/material.dart';
import 'package:job_list/data/models/job_model.dart';

class JobCard extends StatelessWidget {
  final JobModel job;

  const JobCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: Theme.of(context).dividerColor, width: 1.0),
      ),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: CircleAvatar(child: Text(job.company[0])),
        title: Text(job.title, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(job.company),
            Text(job.location),
            Text(job.type),
            Text('\$${job.salary}'),
          ],
        ),
      ),
    );
  }
}
