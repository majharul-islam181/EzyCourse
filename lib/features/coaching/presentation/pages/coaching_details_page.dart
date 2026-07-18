import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../../core/di/core_di.dart';
import '../../domain/entities/coaching_details_with_sessions.dart';
import '../../domain/entities/coaching_session.dart';
import '../bloc/coaching_details_bloc.dart';
import '../bloc/coaching_details_event.dart';
import '../bloc/coaching_details_state.dart';
import '../bloc/coaching_feed_bloc.dart';
import '../bloc/coaching_feed_event.dart';
import '../widgets/coaching_details_infographic.dart';
import '../widgets/coaching_error_view.dart';
import '../widgets/coaching_feed_list.dart';
import '../widgets/coaching_notes_bottom_sheet.dart';
import '../widgets/session_selector_drawer.dart';

class CoachingDetailsPage extends StatelessWidget {
  final int programId;
  final String userZone;

  const CoachingDetailsPage({
    required this.programId,
    this.userZone = 'Asia/Dhaka',
    super.key,
  });

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CoachingDetailsBloc>(
          create: (_) => sl<CoachingDetailsBloc>()
            ..add(
              LoadCoachingDetails(programId: programId, userZone: userZone),
            ),
        ),
        BlocProvider<CoachingFeedBloc>(create: (_) => sl<CoachingFeedBloc>()),
      ],
      child: _CoachingDetailsView(programId: programId, userZone: userZone),
    );
  }
}

class _CoachingDetailsView extends StatelessWidget {
  final int programId;
  final String userZone;

  const _CoachingDetailsView({required this.programId, required this.userZone});

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<CoachingDetailsBloc, CoachingDetailsState>(
      builder: (final BuildContext context, final CoachingDetailsState state) {
        if (state.isLoading || state.isInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator.adaptive()),
          );
        }

        if (state.isFailure) {
          return Scaffold(
            body: CoachingErrorView(
              message: state.errorMessage ?? 'Unable to load coaching details.',
              onRetry: () => _reload(context),
            ),
          );
        }

        return _CoachingDetailsScaffold(
          details: state.detailsWithSessions!,
          selectedSessionId: state.selectedSession?.id,
          onRefresh: () => _reload(context),
        );
      },
    );
  }

  Future<void> _reload(final BuildContext context) async {
    context.read<CoachingDetailsBloc>().add(
      LoadCoachingDetails(programId: programId, userZone: userZone),
    );
  }
}

class _CoachingDetailsScaffold extends StatefulWidget {
  final CoachingDetailsWithSessions details;
  final int? selectedSessionId;
  final Future<void> Function() onRefresh;

  const _CoachingDetailsScaffold({
    required this.details,
    required this.selectedSessionId,
    required this.onRefresh,
  });

  @override
  State<_CoachingDetailsScaffold> createState() =>
      _CoachingDetailsScaffoldState();
}

class _CoachingDetailsScaffoldState extends State<_CoachingDetailsScaffold> {
  final ScrollController _scrollController = ScrollController();
  late final Set<int> _expandedParentIds;
  late int? _selectedSessionId;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _selectedSessionId = widget.selectedSessionId;
    final CoachingSession? selectedSession = widget.details.selectedSession;
    final int? currentParentId =
        selectedSession?.parentId ??
        widget.details.currentSession.currentSessionParentId;
    _expandedParentIds = {?currentParentId};
    _loadFeedsForSelectedSession();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        width: MediaQuery.sizeOf(context).width * 0.8,
        child: SessionSelectorDrawer(
          details: widget.details,
          expandedParentIds: _expandedParentIds,
          selectedSessionId: _selectedSessionId,
          onToggleParent: _toggleParent,
          onSelectSession: _selectSession,
        ),
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: _onRefresh,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              pinned: true,
              centerTitle: true,
              title: Text(widget.details.details.title),
              leading: Builder(
                builder: (final BuildContext context) {
                  return IconButton(
                    tooltip: 'Sessions',
                    icon: const Icon(Icons.menu),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  );
                },
              ),
              actions: [
                IconButton(
                  tooltip: 'Notes',
                  icon: const Icon(Icons.note_alt_outlined),
                  onPressed: () => _openNotesSheet(context),
                ),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList.list(
                children: [
                  CoachingDetailsInfographic(details: widget.details),
                  if (_hasDescription) ...[
                    const SizedBox(height: 12),
                    _ProgramDescription(description: _description),
                  ],
                ],
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              sliver: CoachingFeedList(),
            ),
          ],
        ),
      ),
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final double triggerOffset =
        _scrollController.position.maxScrollExtent - 240;

    if (_scrollController.offset >= triggerOffset) {
      context.read<CoachingFeedBloc>().add(const LoadMoreCoachingFeeds());
    }
  }

  void _toggleParent(final int parentId) {
    setState(() {
      if (_expandedParentIds.contains(parentId)) {
        _expandedParentIds.remove(parentId);
        return;
      }

      _expandedParentIds.add(parentId);
    });
  }

  void _selectSession(final CoachingSession session) {
    setState(() => _selectedSessionId = session.id);
    _loadFeedsForSelectedSession();
    Navigator.of(context).pop();
  }

  void _loadFeedsForSelectedSession() {
    final int? selectedSessionId = _selectedSessionId;
    if (selectedSessionId == null) {
      return;
    }

    context.read<CoachingFeedBloc>().add(
      LoadCoachingFeeds(
        programId: widget.details.details.id,
        sessionId: selectedSessionId,
      ),
    );
  }

  Future<void> _onRefresh() async {
    await widget.onRefresh();
    _loadFeedsForSelectedSession();
  }

  void _openNotesSheet(final BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (final BuildContext context) {
        return const CoachingNotesBottomSheet(notes: []);
      },
    );
  }

  bool get _hasDescription => _description.isNotEmpty;

  String get _description => widget.details.details.description?.trim() ?? '';
}

class _ProgramDescription extends StatelessWidget {
  final String description;

  const _ProgramDescription({required this.description});

  @override
  Widget build(final BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Html(data: description),
      ),
    );
  }
}
