import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_list/data/models/job_model.dart';
import 'package:job_list/presentation/bloc/favorite_jobs/favorite_bloc.dart';
import 'package:job_list/presentation/widgets/job_card.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    context.read<FavoriteBloc>().add(LoadFavorites());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Jobs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Clear all favorites',
            onPressed: () => _showClearAllDialog(context),
          ),
        ],
      ),
      body: BlocConsumer<FavoriteBloc, FavoriteState>(
        listener: (context, state) {
          if (state is FavoriteError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is FavoriteLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FavoriteError) {
            return Center(child: Text(state.message));
          }

          if (state is FavoriteLoaded) {
            if (state.favorites.isEmpty) {
              return _buildEmptyState();
            }
            return _buildFavoritesList(state.favorites);
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.favorite_border, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'No favorite jobs yet',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the heart icon on jobs to add them here',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList(List<JobModel> favorites) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<FavoriteBloc>().add(LoadFavorites());
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final job = favorites[index];
          return Dismissible(
            key: Key(job.id),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            direction: DismissDirection.endToStart,
            confirmDismiss: (direction) async {
              return await _showDeleteConfirmation(context, job);
            },
            onDismissed: (direction) {
              context.read<FavoriteBloc>().add(RemoveFavorite(job: job));
              _showUndoSnackbar(context, job);
            },
            child: JobCard(job: job),
          );
        },
      ),
    );
  }

  Future<bool> _showDeleteConfirmation(
    BuildContext context,
    JobModel job,
  ) async {
    return await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Remove Favorite'),
                content: Text('Remove ${job.title} from favorites?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Remove'),
                  ),
                ],
              ),
        ) ??
        false;
  }

  void _showUndoSnackbar(BuildContext context, JobModel job) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Removed ${job.title} from favorites'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            context.read<FavoriteBloc>().add(ToggleFavorite(job: job));
          },
        ),
      ),
    );
  }

  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Clear All Favorites'),
            content: const Text(
              'Are you sure you want to remove all favorite jobs?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  context.read<FavoriteBloc>().add(ClearAllFavorites());
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cleared all favorites')),
                  );
                },
                child: const Text('Clear All'),
              ),
            ],
          ),
    );
  }
}
