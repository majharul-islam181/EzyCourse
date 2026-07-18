import 'package:flutter/material.dart';

import '../../../../core/theme/theme_context.dart';
import '../../domain/entities/coaching_program.dart';
import 'coaching_program_card.dart';

class CoachingProgramGrid extends StatelessWidget {
  final List<CoachingProgram> programs;
  final bool isLoadingMore;
  final ValueChanged<CoachingProgram> onProgramTap;

  const CoachingProgramGrid({
    required this.programs,
    required this.isLoadingMore,
    required this.onProgramTap,
    super.key,
  });

  @override
  Widget build(final BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
        context.spacing.pagePadding,
        0,
        context.spacing.pagePadding,
        context.spacing.pagePadding,
      ),
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
          final bool isBottomLoader = index == programs.length;

          if (isBottomLoader) {
            if (!isLoadingMore) {
              return const SizedBox.shrink();
            }
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          final CoachingProgram program = programs[index];

          return CoachingProgramCard(
            program: program,
            onTap: () => onProgramTap(program),
          );
        }, childCount: programs.length + 1),
      ),
    );
  }
}
