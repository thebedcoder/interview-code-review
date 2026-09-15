import 'package:fieldops/src/features/jobs/data/models/job_model.dart';
import 'package:fieldops/src/features/jobs/domain/entities/job.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps wire status values onto the domain enum', () {
    JobModel model(String status) => JobModel(
      id: 'job-1',
      title: 'Service call',
      customerName: 'Acme Ltd',
      address: '12 Bridge Street',
      status: status,
      notes: '',
      scheduledAt: 0,
      updatedAt: 0,
    );

    expect(model('scheduled').toEntity().status, JobStatus.scheduled);
    expect(model('in_progress').toEntity().status, JobStatus.inProgress);
    expect(model('completed').toEntity().status, JobStatus.completed);
    expect(model('something_else').toEntity().status, JobStatus.scheduled);
  });

  test('round-trips through a database row', () {
    final JobModel original = JobModel.fromJson(<String, dynamic>{
      'id': 'job-7',
      'title': 'Annual inspection',
      'customer_name': 'Northwind',
      'address': '4 Mill Lane',
      'status': 'scheduled',
      'notes': 'Gate code 4471',
      'scheduled_at': 1757923200000,
      'updated_at': 1757919600000,
    });

    final JobModel fromRow = JobModel.fromRow(original.toRow());

    expect(fromRow.toEntity(), original.toEntity());
  });
}
