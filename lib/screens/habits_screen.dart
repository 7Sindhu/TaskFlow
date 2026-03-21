import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/habit.dart';

class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final habits = provider.habits;
    final theme = Theme.of(context);
    final doneToday = habits.where((h) => h.isCompletedToday()).length;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 160,
            backgroundColor: const Color(0xFF10B981),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF059669)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Habit Tracker',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          habits.isEmpty
                              ? 'Build better habits'
                              : '$doneToday of ${habits.length} done today',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 13),
                        ),
                        if (habits.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: habits.isEmpty
                                  ? 0
                                  : doneToday / habits.length,
                              backgroundColor: Colors.white.withOpacity(0.3),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                              minHeight: 6,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          habits.isEmpty
              ? SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.repeat,
                              size: 36, color: Color(0xFF10B981)),
                        ),
                        const SizedBox(height: 16),
                        const Text('No habits yet',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 6),
                        Text(
                          'Start building better habits today',
                          style: TextStyle(
                              color: theme.colorScheme.onSurface.withOpacity(0.5),
                              fontSize: 13),
                        ),
                        const SizedBox(height: 20),
                        FilledButton.icon(
                          onPressed: () => _showAddHabitDialog(context),
                          icon: const Icon(Icons.add),
                          label: const Text('Add Habit'),
                          style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF10B981)),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => _HabitCard(habit: habits[i]),
                      childCount: habits.length,
                    ),
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddHabitDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('New Habit'),
        backgroundColor: const Color(0xFF10B981),
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    );
  }

  void _showAddHabitDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    String selectedIcon = '⭐';
    int selectedColor = 0xFF10B981;

    final icons = ['⭐', '💪', '📚', '🏃', '💧', '🧘', '🎯', '🍎', '😴', '✍️', '🎵', '🌿'];
    final colors = [
      0xFF10B981, 0xFF6366F1, 0xFFEF4444,
      0xFFF59E0B, 0xFF3B82F6, 0xFFEC4899,
      0xFF8B5CF6, 0xFF06B6D4,
    ];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('New Habit', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Habit Name'),
                  autofocus: true,
                ),
                const SizedBox(height: 16),
                const Text('Icon', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: icons.map((icon) => GestureDetector(
                    onTap: () => setS(() => selectedIcon = icon),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: selectedIcon == icon
                            ? Theme.of(ctx).colorScheme.primaryContainer
                            : Theme.of(ctx).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: selectedIcon == icon
                              ? Theme.of(ctx).colorScheme.primary
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Text(icon, style: const TextStyle(fontSize: 22)),
                    ),
                  )).toList(),
                ),
                const SizedBox(height: 16),
                const Text('Color', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  children: colors.map((c) => GestureDetector(
                    onTap: () => setS(() => selectedColor = c),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Color(c),
                        shape: BoxShape.circle,
                        border: selectedColor == c
                            ? Border.all(color: Colors.black.withOpacity(0.3), width: 3)
                            : null,
                        boxShadow: selectedColor == c
                            ? [BoxShadow(color: Color(c).withOpacity(0.4), blurRadius: 8)]
                            : null,
                      ),
                      child: selectedColor == c
                          ? const Icon(Icons.check, size: 16, color: Colors.white)
                          : null,
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                if (nameCtrl.text.trim().isEmpty) return;
                context.read<AppProvider>().createHabit(
                  name: nameCtrl.text.trim(),
                  icon: selectedIcon,
                  color: selectedColor,
                );
                Navigator.pop(ctx);
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HabitCard extends StatelessWidget {
  final Habit habit;
  const _HabitCard({required this.habit});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<AppProvider>();
    final theme = Theme.of(context);
    final color = Color(habit.color);
    final isDone = habit.isCompletedToday();
    final now = DateTime.now();
    final last7 = List.generate(7, (i) => now.subtract(Duration(days: 6 - i)));

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: isDone
                ? color.withOpacity(0.3)
                : theme.colorScheme.outlineVariant.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: isDone
                ? color.withOpacity(0.08)
                : theme.colorScheme.shadow.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                      child: Text(habit.icon,
                          style: const TextStyle(fontSize: 26))),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(habit.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          const Icon(Icons.local_fire_department,
                              size: 14, color: Colors.orange),
                          const SizedBox(width: 3),
                          Text(
                            '${habit.currentStreak} day streak',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () => provider.toggleHabitToday(habit.id),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDone ? color : Colors.transparent,
                          border: Border.all(
                              color: isDone
                                  ? color
                                  : theme.colorScheme.outline.withOpacity(0.4),
                              width: 2),
                          boxShadow: isDone
                              ? [
                                  BoxShadow(
                                      color: color.withOpacity(0.3),
                                      blurRadius: 10)
                                ]
                              : null,
                        ),
                        child: isDone
                            ? const Icon(Icons.check,
                                color: Colors.white, size: 22)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isDone ? 'Done!' : 'Mark',
                      style: TextStyle(
                          fontSize: 10,
                          color: isDone
                              ? color
                              : theme.colorScheme.onSurface.withOpacity(0.4),
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: Icon(Icons.delete_outline,
                      size: 18,
                      color: theme.colorScheme.error.withOpacity(0.6)),
                  onPressed: () => provider.deleteHabit(habit.id),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: last7.map((day) {
                final done = habit.completedDates.any((d) =>
                    d.year == day.year &&
                    d.month == day.month &&
                    d.day == day.day);
                final isToday = day.day == now.day &&
                    day.month == now.month &&
                    day.year == now.year;
                final dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

                return Column(
                  children: [
                    Text(
                      dayLabels[day.weekday - 1],
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                        color: isToday
                            ? color
                            : theme.colorScheme.onSurface.withOpacity(0.4),
                      ),
                    ),
                    const SizedBox(height: 5),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: done ? color : color.withOpacity(0.08),
                        border: isToday
                            ? Border.all(color: color, width: 2)
                            : null,
                        boxShadow: done
                            ? [
                                BoxShadow(
                                    color: color.withOpacity(0.25),
                                    blurRadius: 6)
                              ]
                            : null,
                      ),
                      child: done
                          ? const Icon(Icons.check,
                              size: 15, color: Colors.white)
                          : null,
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
