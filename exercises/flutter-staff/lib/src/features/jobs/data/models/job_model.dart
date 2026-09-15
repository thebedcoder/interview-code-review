import 'package:fieldops/src/features/jobs/domain/entities/job.dart';

/// Wire and row format for a job. Confined to the data layer.
class JobModel {
  const JobModel({
    required this.id,
    required this.title,
    required this.customerName,
    required this.address,
    required this.status,
    required this.notes,
    required this.scheduledAt,
    required this.updatedAt,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'] as String,
      title: json['title'] as String,
      customerName: json['customer_name'] as String,
      address: json['address'] as String,
      status: json['status'] as String,
      notes: (json['notes'] as String?) ?? '',
      scheduledAt: json['scheduled_at'] as int,
      updatedAt: json['updated_at'] as int,
    );
  }

  factory JobModel.fromRow(Map<String, Object?> row) {
    return JobModel(
      id: row['id']! as String,
      title: row['title']! as String,
      customerName: row['customer_name']! as String,
      address: row['address']! as String,
      status: row['status']! as String,
      notes: row['notes']! as String,
      scheduledAt: row['scheduled_at']! as int,
      updatedAt: row['updated_at']! as int,
    );
  }

  final String id;
  final String title;
  final String customerName;
  final String address;
  final String status;
  final String notes;
  final int scheduledAt;
  final int updatedAt;

  Map<String, Object?> toRow() {
    return <String, Object?>{
      'id': id,
      'title': title,
      'customer_name': customerName,
      'address': address,
      'status': status,
      'notes': notes,
      'scheduled_at': scheduledAt,
      'updated_at': updatedAt,
    };
  }

  Job toEntity() {
    return Job(
      id: id,
      title: title,
      customerName: customerName,
      address: address,
      status: _statusFromWire(status),
      notes: notes,
      scheduledAt: DateTime.fromMillisecondsSinceEpoch(scheduledAt),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAt),
    );
  }

  static JobStatus _statusFromWire(String value) {
    return switch (value) {
      'in_progress' => JobStatus.inProgress,
      'completed' => JobStatus.completed,
      _ => JobStatus.scheduled,
    };
  }
}
