import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../models/task.dart';
import '../utils/app_theme.dart';
import '../widgets/task_form_dialog.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final stats = provider.taskStats;
    final theme = Theme.of(context);
    final now = DateTime.now();
    final greeting = now.hour < 12
        ? 'Good morning'
        : now.hour < 17
            ? 'Good afternoon'
            : 'Good evening';

    final upcoming = provider.tasks
        .where((t) => !t.isCompleted && t.dueDate != null)
        .toList()
      ..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: theme.colorScheme.primary,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.tertiary,
                    ],
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
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    greeting + ' 👋',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.85),
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'Task Manager',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _ThemeToggle(),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          DateFormat('EEEE, MMMM d').format(now),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.75),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -20),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _StatsGrid(stats: stats),
                      const SizedBox(height: 24),
                      _SectionHeader(
                        title: "Today's Tasks",
                        subtitle: '${provider.todoTasks.length} pending',
                        onAdd: () => showDialog(
                          context: context,
                          builder: (_) => const TaskFormDialog(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (provider.todoTasks.isEmpty)
                        _EmptyCard(
                          icon: Icons.task_alt,
                          message: 'All caught up! No tasks today.',
                          color: const Color(0xFF10B981),
                        )
                      else
                        ...provider.todoTasks
                            .take(5)
                            .map((task) => _DashTaskTile(
                                  task: task,
                                  onToggle: () =>
                                      provider.toggleTaskComplete(task.id),
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (_) => TaskFormDialog(task: task),
                                  ),
                                )),
                      if (upcoming.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        _SectionHeader(
                          title: 'Upcoming Deadlines',
                          subtitle: '${upcoming.length} tasks',
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 110,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: upcoming.take(6).length,
                            itemBuilder: (_, i) =>
                                _DeadlineCard(task: upcoming[i]),
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      _SectionHeader(
                        title: 'Habit Progress',
                        subtitle: 'Today',
                      ),
                      const SizedBox(height: 12),
                      if (provider.habits.isEmpty)
                        _EmptyCard(
                          icon: Icons.repeat,
                          message: 'No habits yet. Start building one!',
                          color: const Color(0xFF6366F1),
                        )
                      else
                        ...provider.habits.take(3).map((habit) => Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: theme.colorScheme.outlineVariant
                                        .withOpacity(0.4)),
                                boxShadow: [
                                  BoxShadow(
                                    color: theme.colorScheme.shadow
                                        .withOpacity(0.04),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: Color(habit.color).withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Text(habit.icon,
                                          style:
                                              const TextStyle(fontSize: 22)),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(habit.name,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600)),
                                        Row(
                                          children: [
                                            Icon(Icons.local_fire_department,
                                                size: 13,
                                                color: Colors.orange),
                                            const SizedBox(width: 3),
                                            Text(
                                              '${habit.currentStreak} day streak',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: theme
                                                    .colorScheme.onSurface
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () =>
                                        provider.toggleHabitToday(habit.id),
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: habit.isCompletedToday()
                                            ? Color(habit.color)
                                            : Colors.transparent,
                                        border: Border.all(
                                            color: Color(habit.color),
                                            width: 2),
                                      ),
                                      child: habit.isCompletedToday()
                                          ? const Icon(Icons.check,
                                              size: 18, color: Colors.white)
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => const TaskFormDialog(),
        ),
        icon: const Icon(Icons.add),
        label: const Text('New Task'),
        elevation: 4,
      ),
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    return GestureDetector(
      onTap: provider.toggleTheme,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          provider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final Map<String, int> stats;
  const _StatsGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatCard(
            label: 'Total',
            value: stats['total']!,
            icon: Icons.list_alt,
            color: const Color(0xFF6366F1)),
        const SizedBox(width: 10),
        _StatCard(
            label: 'Done',
            value: stats['completed']!,
            icon: Icons.check_circle_outline,
            color: const Color(0xFF10B981)),
        const SizedBox(width: 10),
        _StatCard(
            label: 'Active',
            value: stats['inProgress']!,
            icon: Icons.timelapse,
            color: const Color(0xFF3B82F6)),
        const SizedBox(width: 10),
        _StatCard(
            label: 'Overdue',
            value: stats['overdue']!,
            icon: Icons.warning_amber_outlined,
            color: const Color(0xFFEF4444)),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  final Color color;
  const _StatCard(
      {required this.label,
      required this.value,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(
              '$value',
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: color),
            ),
            Text(
              label,
              style: TextStyle(
                  fontSize: 10,
                  color: theme.colorScheme.onSurface.withOpacity(0.6)),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onAdd;
  const _SectionHeader({required this.title, this.subtitle, this.onAdd});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            if (subtitle != null)
              Text(subtitle!,
                  style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withOpacity(0.5))),
          ],
        ),
        const Spacer(),
        if (onAdd != null)
          GestureDetector(
            onTap: onAdd,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(Icons.add,
                      size: 14,
                      color: theme.colorScheme.onPrimaryContainer),
                  const SizedBox(width: 4),
                  Text('Add',
                      style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _DashTaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onTap;
  const _DashTaskTile(
      {required this.task, required this.onToggle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = AppTheme.priorityColor(task.priority.index);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: theme.colorScheme.outlineVariant.withOpacity(0.4)),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: onToggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: task.isCompleted ? color : Colors.transparent,
                  border: Border.all(color: color, width: 2),
                ),
                child: task.isCompleted
                    ? const Icon(Icons.check, size: 13, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                task.title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  decoration:
                      task.isCompleted ? TextDecoration.lineThrough : null,
                  color: task.isCompleted
                      ? theme.colorScheme.onSurface.withOpacity(0.4)
                      : null,
                ),
              ),
            ),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeadlineCard extends StatelessWidget {
  final Task task;
  const _DeadlineCard({required this.task});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = AppTheme.priorityColor(task.priority.index);
    final daysLeft = task.dueDate!.difference(DateTime.now()).inDays;
    final isOverdue = daysLeft < 0;

    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: isOverdue ? Colors.red.withOpacity(0.15) : color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isOverdue
                  ? '${daysLeft.abs()}d overdue'
                  : daysLeft == 0
                      ? 'Today'
                      : '${daysLeft}d left',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isOverdue ? Colors.red : color,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            task.title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Text(
            DateFormat('MMM d').format(task.dueDate!),
            style: TextStyle(
              fontSize: 11,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final IconData icon;
  final String message;
  final Color color;
  const _EmptyCard(
      {required this.icon, required this.message, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.6)),
            ),
          ),
        ],
      ),
    );
  }
}
