import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../models/task.dart';
import '../utils/app_theme.dart';
import '../widgets/task_form_dialog.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with SingleTickerProviderStateMixin {
  DateTime _focusedMonth = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  void _changeMonth(int delta) {
    _animCtrl.reverse().then((_) {
      setState(() {
        _focusedMonth = DateTime(
            _focusedMonth.year, _focusedMonth.month + delta);
      });
      _animCtrl.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final theme = Theme.of(context);
    final tasksOnDay = provider.tasks.where((t) {
      if (t.dueDate == null) return false;
      return t.dueDate!.year == _selectedDay.year &&
          t.dueDate!.month == _selectedDay.month &&
          t.dueDate!.day == _selectedDay.day;
    }).toList();

    final allMonthTasks = provider.tasks
        .where((t) =>
            t.dueDate != null &&
            t.dueDate!.year == _focusedMonth.year &&
            t.dueDate!.month == _focusedMonth.month)
        .length;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Column(
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.tertiary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left,
                              color: Colors.white, size: 28),
                          onPressed: () => _changeMonth(-1),
                        ),
                        Expanded(
                          child: FadeTransition(
                            opacity: _fadeAnim,
                            child: Column(
                              children: [
                                Text(
                                  DateFormat('MMMM').format(_focusedMonth),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  DateFormat('yyyy').format(_focusedMonth),
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.75),
                                    fontSize: 13,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right,
                              color: Colors.white, size: 28),
                          onPressed: () => _changeMonth(1),
                        ),
                      ],
                    ),
                  ),
                  if (allMonthTasks > 0)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '$allMonthTasks task${allMonthTasks > 1 ? 's' : ''} this month',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12),
                      ),
                    ),
                  const SizedBox(height: 8),
                  // Weekday labels
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                          .map((d) => Expanded(
                                child: Center(
                                  child: Text(
                                    d,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Calendar grid
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: _CalendarGrid(
                      focusedMonth: _focusedMonth,
                      selectedDay: _selectedDay,
                      tasks: provider.tasks,
                      onDaySelected: (day) =>
                          setState(() => _selectedDay = day),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Selected day tasks
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          DateFormat('EEE, MMM d').format(_selectedDay),
                          style: TextStyle(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (tasksOnDay.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${tasksOnDay.length} task${tasksOnDay.length > 1 ? 's' : ''}',
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: tasksOnDay.isEmpty
                      ? _EmptyDayState(
                          selectedDay: _selectedDay,
                          onAdd: () => showDialog(
                            context: context,
                            builder: (_) => const TaskFormDialog(),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                          itemCount: tasksOnDay.length,
                          itemBuilder: (_, i) => _CalendarTaskTile(
                            task: tasksOnDay[i],
                            onToggle: () =>
                                provider.toggleTaskComplete(tasksOnDay[i].id),
                            onTap: () => showDialog(
                              context: context,
                              builder: (_) =>
                                  TaskFormDialog(task: tasksOnDay[i]),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            showDialog(context: context, builder: (_) => const TaskFormDialog()),
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
        elevation: 4,
      ),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  final DateTime focusedMonth;
  final DateTime selectedDay;
  final List<Task> tasks;
  final ValueChanged<DateTime> onDaySelected;

  const _CalendarGrid({
    required this.focusedMonth,
    required this.selectedDay,
    required this.tasks,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(focusedMonth.year, focusedMonth.month, 1);
    final daysInMonth =
        DateTime(focusedMonth.year, focusedMonth.month + 1, 0).day;
    final startWeekday = firstDay.weekday % 7;
    final today = DateTime.now();
    final totalCells = startWeekday + daysInMonth;
    final rows = (totalCells / 7).ceil();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: List.generate(rows, (row) {
          return Row(
            children: List.generate(7, (col) {
              final index = row * 7 + col;
              if (index < startWeekday || index >= startWeekday + daysInMonth) {
                return const Expanded(child: SizedBox(height: 44));
              }
              final dayNum = index - startWeekday + 1;
              final day =
                  DateTime(focusedMonth.year, focusedMonth.month, dayNum);
              final isSelected = day.day == selectedDay.day &&
                  day.month == selectedDay.month &&
                  day.year == selectedDay.year;
              final isToday = day.day == today.day &&
                  day.month == today.month &&
                  day.year == today.year;

              // Count tasks for dot indicators
              final dayTasks = tasks
                  .where((t) =>
                      t.dueDate != null &&
                      t.dueDate!.day == day.day &&
                      t.dueDate!.month == day.month &&
                      t.dueDate!.year == day.year)
                  .toList();
              final hasOverdue = dayTasks.any((t) =>
                  !t.isCompleted && day.isBefore(DateTime.now()));
              final hasDone = dayTasks.any((t) => t.isCompleted);
              final hasPending = dayTasks.any((t) => !t.isCompleted);

              return Expanded(
                child: GestureDetector(
                  onTap: () => onDaySelected(day),
                  child: Container(
                    height: 44,
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? Colors.white
                          : isToday
                              ? Colors.white.withOpacity(0.2)
                              : Colors.transparent,
                      border: isToday && !isSelected
                          ? Border.all(color: Colors.white, width: 1.5)
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$dayNum',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected || isToday
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? const Color(0xFF6366F1)
                                : Colors.white,
                          ),
                        ),
                        if (dayTasks.isNotEmpty)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (hasPending && !hasDone)
                                _dot(hasOverdue
                                    ? Colors.red.shade300
                                    : Colors.amber.shade300, isSelected),
                              if (hasDone)
                                _dot(Colors.green.shade300, isSelected),
                              if (hasPending && hasDone)
                                _dot(Colors.amber.shade300, isSelected),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        }),
      ),
    );
  }

  Widget _dot(Color color, bool isSelected) => Container(
        width: 5,
        height: 5,
        margin: const EdgeInsets.symmetric(horizontal: 1),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? color : color,
        ),
      );
}

class _CalendarTaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onTap;

  const _CalendarTaskTile(
      {required this.task, required this.onToggle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final priorityColor = AppTheme.priorityColor(task.priority.index);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 5,
              height: 64,
              decoration: BoxDecoration(
                color: priorityColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: onToggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: task.isCompleted ? priorityColor : Colors.transparent,
                  border: Border.all(color: priorityColor, width: 2),
                ),
                child: task.isCompleted
                    ? const Icon(Icons.check, size: 13, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.isCompleted
                            ? theme.colorScheme.onSurface.withOpacity(0.4)
                            : null,
                      ),
                    ),
                    if (task.description.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        task.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 12),
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: priorityColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                task.priority.name,
                style: TextStyle(
                    fontSize: 10,
                    color: priorityColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyDayState extends StatelessWidget {
  final DateTime selectedDay;
  final VoidCallback onAdd;

  const _EmptyDayState({required this.selectedDay, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isToday = selectedDay.day == DateTime.now().day &&
        selectedDay.month == DateTime.now().month &&
        selectedDay.year == DateTime.now().year;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isToday ? Icons.wb_sunny_outlined : Icons.event_available_outlined,
              size: 36,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isToday ? 'Free day today! 🎉' : 'No tasks scheduled',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Tap + to add a task for this day',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Add Task'),
          ),
        ],
      ),
    );
  }
}
