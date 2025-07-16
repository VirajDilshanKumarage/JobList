import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:job_list/data/models/job_model.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final Box<JobModel> favoritesBox;

  FavoriteBloc({required this.favoritesBox}) : super(FavoriteInitial()) {
    on<ToggleFavorite>(_onToggleFavorite);
    on<LoadFavorites>(_onLoadFavorites);
    on<RemoveFavorite>(_onRemoveFavorite);
    on<ClearAllFavorites>(_onClearAllFavorites);
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<FavoriteState> emit,
  ) async {
    try {
      final job = event.job;
      job.isFavorite = !job.isFavorite;

      if (job.isFavorite) {
        await favoritesBox.put(job.id, job);
      } else {
        await favoritesBox.delete(job.id);
      }

      emit(FavoriteLoaded(favorites: favoritesBox.values.toList()));
    } catch (e) {
      emit(FavoriteError(message: 'Failed to toggle favorite: $e'));
    }
  }

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoriteState> emit,
  ) async {
    emit(FavoriteLoading());
    try {
      emit(FavoriteLoaded(favorites: favoritesBox.values.toList()));
    } catch (e) {
      emit(FavoriteError(message: 'Failed to load favorites: $e'));
    }
  }

  Future<void> _onRemoveFavorite(
    RemoveFavorite event,
    Emitter<FavoriteState> emit,
  ) async {
    try {
      final job = event.job..isFavorite = false;
      await favoritesBox.delete(job.id);
      emit(FavoriteLoaded(favorites: favoritesBox.values.toList()));
    } catch (e) {
      emit(FavoriteError(message: 'Failed to remove favorite: $e'));
    }
  }

  Future<void> _onClearAllFavorites(
    ClearAllFavorites event,
    Emitter<FavoriteState> emit,
  ) async {
    try {
      await favoritesBox.clear();
      emit(FavoriteLoaded(favorites: []));
    } catch (e) {
      emit(FavoriteError(message: 'Failed to clear favorites: $e'));
    }
  }
}
