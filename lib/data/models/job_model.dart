import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:job_list/domain/entities/job.dart';

part 'job_model.g.dart';

@HiveType(typeId: 0)
class JobModel extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String company;
  @HiveField(3)
  final String location;
  @HiveField(4)
  final String type;
  @HiveField(5)
  final String description;
  @HiveField(6)
  final String salary;
  @HiveField(7)
  bool isFavorite;

  Job toEntity() {
    return Job(
      id: id,
      title: title,
      company: company,
      location: location,
      type: type,
      description: description,
      salary: salary,
      isFavorite: isFavorite,
    );
  }

  JobModel({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.type,
    required this.description,
    required this.salary,
    this.isFavorite = false,
  });

  JobModel copyWith({
    String? id,
    String? title,
    String? company,
    String? location,
    String? type,
    String? description,
    String? salary,
    bool? isFavorite,
  }) {
    return JobModel(
      id: id ?? this.id,
      title: title ?? this.title,
      company: company ?? this.company,
      location: location ?? this.location,
      type: type ?? this.type,
      description: description ?? this.description,
      salary: salary ?? this.salary,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      company: json['company'] ?? '',
      location: json['location'] ?? '',
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      salary: json['salary'] ?? 'Not specified',
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  factory JobModel.fromEntity(Job job) {
    return JobModel(
      id: job.id,
      title: job.title,
      company: job.company,
      location: job.location,
      type: job.type,
      description: job.description,
      salary: job.salary,
      isFavorite: job.isFavorite,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'company': company,
    'location': location,
    'type': type,
    'description': description,
    'salary': salary,
    'isFavorite': isFavorite,
  };

  @override
  List<Object?> get props => [
    id,
    title,
    company,
    location,
    type,
    description,
    salary,
    isFavorite,
  ];
}
