import 'package:equatable/equatable.dart';

class Job extends Equatable{
  final String id;
  final String title;
  final String company;
  final String location;
  final String type;
  final String description;
  final String salary;
  final bool isFavorite;



  const Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.type,
    required this.description,
    required this.salary,
    this.isFavorite = false,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        company,
        location,
        type,
        description,
        salary,
      ];

}