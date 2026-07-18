import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../core/blocs/auth_session/auth_session_bloc.dart';
import '../../../../core/blocs/auth_session/auth_session_event.dart';
import '../../../../core/di/core_di.dart';
import '../../domain/entities/coaching_program.dart';
import '../bloc/coaching_program_list_bloc.dart';
import '../bloc/coaching_program_list_event.dart';
import '../bloc/coaching_program_list_state.dart';
import '../widgets/coaching_empty_view.dart';
import '../widgets/coaching_error_view.dart';
import '../widgets/coaching_program_grid.dart';
import '../widgets/coaching_program_skeleton_card.dart';
import '../widgets/coaching_search_bar.dart';

class CoachingListPage extends StatelessWidget {
  const CoachingListPage({super.key});

  @override
  Widget build(final BuildContext context) {
    return BlocProvider<CoachingProgramListBloc>(
      create: (_) =>
          sl<CoachingProgramListBloc>()..add(const LoadCoachingPrograms()),
      child: const _CoachingListView(),
    );
  }
}

class _CoachingListView extends StatefulWidget {
  const _CoachingListView();

  @override
  State<_CoachingListView> createState() => _CoachingListViewState();
}

class _CoachingListViewState extends State<_CoachingListView> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  Timer? _searchDebounce;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final double triggerOffset =
        _scrollController.position.maxScrollExtent - 240;

    if (_scrollController.offset >= triggerOffset) {
      context.read<CoachingProgramListBloc>().add(
        const LoadMoreCoachingPrograms(),
      );
    }
  }

  void _onSearchChanged(final String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 800), () {
      if (!mounted) {
        return;
      }

      final String query = value.trim();
      _searchQuery = query;
      context.read<CoachingProgramListBloc>().add(
        LoadCoachingPrograms(search: query.isEmpty ? null : query),
      );
    });
  }

  Future<void> _onRefresh() async {
    final CoachingProgramListBloc bloc = context
        .read<CoachingProgramListBloc>();
    bloc.add(
      LoadCoachingPrograms(search: _searchQuery.isEmpty ? null : _searchQuery),
    );
    await bloc.stream.firstWhere((final state) => !state.isLoading);
  }

  @override
  Widget build(final BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: RefreshIndicator.adaptive(
        onRefresh: _onRefresh,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar.medium(
              centerTitle: true,
              title: const Center(child: Text('My Coaching')),
              actions: [
                IconButton(
                  tooltip: 'Logout',
                  onPressed: () {
                    context.read<AuthSessionBloc>().add(
                      const AuthSessionLogoutRequested(),
                    );
                  },
                  icon: const Icon(Icons.logout),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: CoachingSearchBar(
                controller: _searchController,
                onChanged: _onSearchChanged,
              ),
            ),
            BlocBuilder<CoachingProgramListBloc, CoachingProgramListState>(
              builder:
                  (
                    final BuildContext context,
                    final CoachingProgramListState state,
                  ) {
                    if (state.isLoading || state.isInitial) {
                      return const _CoachingProgramGridShimmer();
                    }

                    if (state.isFailure && state.programs.isEmpty) {
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: CoachingErrorView(
                          message:
                              state.errorMessage ??
                              'Unable to load coaching programs.',
                          onRetry: () {
                            context.read<CoachingProgramListBloc>().add(
                              LoadCoachingPrograms(
                                search: _searchQuery.isEmpty
                                    ? null
                                    : _searchQuery,
                              ),
                            );
                          },
                        ),
                      );
                    }

                    final programs = state.programs;

                    if (programs.isEmpty) {
                      return const SliverFillRemaining(
                        hasScrollBody: false,
                        child: CoachingEmptyView(),
                      );
                    }

                    return CoachingProgramGrid(
                      programs: programs,
                      isLoadingMore: state.isLoadingMore,
                      onProgramTap: _openCoachingDetails,
                    );
                  },
            ),
          ],
        ),
      ),
    );
  }

  void _openCoachingDetails(final CoachingProgram program) {
    context.push(AppRoutes.coachingDetailsPath(program.id));
  }
}

class _CoachingProgramGridShimmer extends StatelessWidget {
  const _CoachingProgramGridShimmer();

  @override
  Widget build(final BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color baseColor = colorScheme.surfaceContainerHighest;
    final Color highlightColor = colorScheme.surfaceContainerLow;

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 250,
          childAspectRatio: 0.80,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate((
          final BuildContext context,
          final int index,
        ) {
          return Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: const CoachingProgramSkeletonCard(),
          );
        }, childCount: 6),
      ),
    );
  }
}
