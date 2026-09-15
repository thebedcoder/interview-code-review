import 'package:equatable/equatable.dart';

enum JobStatus { scheduled, inProgress, completed }

class Job extends Equatable {
  const Job({
    required this.id,
    required this.title,
    required this.customerName,
    required this.address,
    required this.status,
    required this.notes,
    required this.scheduledAt,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final String customerName;
  final String address;
  final JobStatus status;
  final String notes;
  final DateTime scheduledAt;
  final DateTime updatedAt;

  Job copyWith({JobStatus? status, String? notes, DateTime? updatedAt}) {
    return Job(
      id: id,
      title: title,
      customerName: customerName,
      address: address,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      scheduledAt: scheduledAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    id,
    title,
    customerName,
    address,
    status,
    notes,
    scheduledAt,
    updatedAt,
  ];
}
