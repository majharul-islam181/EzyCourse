import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/core_di.dart';
import '../../domain/entities/coaching_details_with_sessions.dart';
import '../../domain/entities/coaching_session.dart';
import '../bloc/coaching_details_bloc.dart';
import '../bloc/coaching_details_event.dart';
import '../bloc/coaching_details_state.dart';
import '../widgets/coaching_details_infographic.dart';
import '../widgets/coaching_error_view.dart';
import '../widgets/coaching_feed_placeholder.dart';
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
    return BlocProvider<CoachingDetailsBloc>(
      create: (_) => sl<CoachingDetailsBloc>()
        ..add(LoadCoachingDetails(programId: programId, userZone: userZone)),
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
  late final Set<int> _expandedParentIds;
  late int? _selectedSessionId;

  @override
  void initState() {
    super.initState();
    _selectedSessionId = widget.selectedSessionId;
    final int? currentParentId =
        widget.details.currentSession.currentSessionParentId;
    _expandedParentIds = {?currentParentId};
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
        onRefresh: widget.onRefresh,
        child: CustomScrollView(
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
              sliver: SliverList.separated(
                itemBuilder: (final BuildContext context, final int index) {
                  if (index == 0) {
                    return CoachingDetailsInfographic(details: widget.details);
                  }

                  return CoachingFeedPlaceholder(details: widget.details);
                },
                separatorBuilder:
                    (final BuildContext context, final int index) =>
                        const SizedBox(height: 8),
                itemCount: 2,
              ),
            ),
          ],
        ),
      ),
    );
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
  }

  void _openNotesSheet(final BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (final BuildContext context) {
        final ColorScheme colorScheme = Theme.of(context).colorScheme;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Notes', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                'Notes access is ready for this coaching program.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
