import 'package:fieldops/src/features/jobs/domain/entities/job.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JobTile extends StatelessWidget {
  const JobTile({required this.job, required this.onComplete, super.key});

  final Job job;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat.MMMd().add_jm();
    return ListTile(
      title: Text(job.title),
      subtitle: Text(
        '${job.customerName} - ${formatter.format(job.scheduledAt)}',
      ),
      trailing: job.status == JobStatus.completed
          ? const Icon(Icons.check_circle, color: Colors.green)
          : TextButton(onPressed: onComplete, child: const Text('Complete')),
    );
  }
}
