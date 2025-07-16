part of 'favorite_bloc.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object> get props => [];
}

class ToggleFavorite extends FavoriteEvent {
  final JobModel job;
  const ToggleFavorite({required this.job});

  @override
  List<Object> get props => [job];
}

class LoadFavorites extends FavoriteEvent {}

class RemoveFavorite extends FavoriteEvent {
  final JobModel job;
  const RemoveFavorite({required this.job});

  @override
  List<Object> get props => [job];
}

class ClearAllFavorites extends FavoriteEvent {}
