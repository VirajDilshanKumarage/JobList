import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:job_list/core/theme/app_theme.dart';
import 'package:job_list/data/datasources/job_remote_data_source_implementation.dart';
import 'package:job_list/data/models/job_model.dart';
import 'package:job_list/data/repositories/job_repository_implementation.dart';
import 'package:job_list/domain/usecases/get_jobs.dart';
import 'package:job_list/presentation/bloc/favorite_jobs/favorite_bloc.dart';
import 'package:job_list/presentation/bloc/job/job_bloc.dart';
import 'package:job_list/presentation/bloc/theme/theme_bloc.dart';
import 'package:job_list/presentation/screens/favorite_jobs.dart';
import 'package:job_list/presentation/screens/job_list_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(JobModelAdapter());
  final favoritesBox = await Hive.openBox<JobModel>('favorites');
  runApp(MyApp(favoritesBox: favoritesBox));
}

class MyApp extends StatelessWidget {
  final Box<JobModel> favoritesBox;

  const MyApp({super.key, required this.favoritesBox});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeBloc()),
        BlocProvider(
          create:
              (context) => JobBloc(
                getJobs: GetJobs(
                  repository: JobRepositoryImpl(
                    remoteDataSource: JobRemoteDataSourceImpl(dio: Dio()),
                  ),
                ),
              )..add(FetchJobs()),
        ),
        BlocProvider(
          create: (context) => FavoriteBloc(favoritesBox: favoritesBox),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'Job Listing App',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeState.themeMode, 
            home: const JobListPage(),
            debugShowCheckedModeBanner: false,
            routes: {'/favorites': (context) => const FavoritesPage()},
          );
        },
      ),
    );
  }
}
