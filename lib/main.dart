import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:job_list/data/datasources/job_remote_data_source_implementation.dart';
import 'package:job_list/data/repositories/job_repository_implementation.dart';
import 'package:job_list/domain/usecases/get_jobs.dart';
import 'package:job_list/presentation/bloc/job/job_bloc.dart';
import 'package:job_list/presentation/screens/job_list_screen.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => JobBloc(
            getJobs: GetJobs(
              repository: JobRepositoryImpl(
                remoteDataSource: JobRemoteDataSourceImpl(dio: Dio()),
              ),
            ),
          )..add(FetchJobs()),
        ),
      ], 
      child: MaterialApp(
        title: 'Job List App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const JobListPage(), 
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}