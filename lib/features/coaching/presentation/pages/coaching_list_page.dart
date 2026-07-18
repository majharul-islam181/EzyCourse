import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/blocs/auth_session/auth_session_bloc.dart';
import '../../../../core/blocs/auth_session/auth_session_event.dart';
import '../../../../core/di/core_di.dart';
import '../../../../core/theme/theme_context.dart';
import '../bloc/coaching_program_list_bloc.dart';
import '../bloc/coaching_program_list_event.dart';
import '../bloc/coaching_program_list_state.dart';
import '../widgets/coaching_program_card.dart';

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
              title: const Text('My Coaching'),
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
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  context.spacing.pagePadding,
                  0,
                  context.spacing.pagePadding,
                  context.spacing.md,
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Search coaching programs',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.72,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            BlocBuilder<CoachingProgramListBloc, CoachingProgramListState>(
              builder:
                  (
                    final BuildContext context,
                    final CoachingProgramListState state,
                  ) {
                    if (state.isLoading || state.isInitial) {
                      return const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      );
                    }

                    if (state.isFailure && state.programs.isEmpty) {
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: _CoachingErrorView(
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
                        child: _CoachingEmptyView(),
                      );
                    }

                    return SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        context.spacing.pagePadding,
                        0,
                        context.spacing.pagePadding,
                        context.spacing.pagePadding,
                      ),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 250,
                              childAspectRatio: 0.80,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                        delegate: SliverChildBuilderDelegate((
                          final BuildContext context,
                          final int index,
                        ) {
                          final bool isBottomLoader = index == programs.length;

                          if (isBottomLoader) {
                            if (!state.isLoadingMore) {
                              return const SizedBox.shrink();
                            }
                            return const Center(
                              child: CircularProgressIndicator.adaptive(),
                            );
                          }

                          return CoachingProgramCard(program: programs[index]);
                        }, childCount: programs.length + 1),
                      ),
                    );
                  },
            ),
          ],
        ),
      ),
    );
  }
}

class _CoachingEmptyView extends StatelessWidget {
  const _CoachingEmptyView();

  @override
  Widget build(final BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.all(context.spacing.pagePadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school_outlined,
            size: 72,
            color: colorScheme.onSurfaceVariant,
          ),
          SizedBox(height: context.spacing.md),
          Text(
            'No coaching programs found',
            textAlign: TextAlign.center,
            style: context.text.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _CoachingErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _CoachingErrorView({required this.message, required this.onRetry});

  @override
  Widget build(final BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.all(context.spacing.pagePadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: colorScheme.error),
          SizedBox(height: context.spacing.md),
          Text(
            message,
            textAlign: TextAlign.center,
            style: context.text.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: context.spacing.md),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
