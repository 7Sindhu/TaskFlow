import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/task.dart';
import '../utils/app_theme.dart';
import '../widgets/task_form_dialog.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _search = '';
  Priority? _filterPriority;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final theme = Theme.of(context);

    final allTodo = provider.todoTasks.where((t) {
      final matchSearch = _search.isEmpty ||
          t.title.toLowerCase().contains(_search.toLowerCase());
      final matchPriority =
          _filterPriority == null || t.priority == _filterPriority;
      return matchSearch && matchPriority;
    }).toList();

    final completed =
        provider.completedTasks.where((t) => t.boardId == null).toList();

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            pinned: true,
            expandedHeight: 130,
            backgroundColor: theme.colorScheme.primary,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.secondary,
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
                        const Text(
                          'To-Do List',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${allTodo.length} active · ${completed.length} completed',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: Container(
                color: theme.colorScheme.primary,
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  indicatorWeight: 3,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white.withOpacity(0.6),
                  tabs: [
                    Tab(text: 'Active (${allTodo.length})'),
                    Tab(text: 'Done (${completed.length})'),
                  ],
                ),
              ),
            ),
          ),
        ],
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              color: theme.colorScheme.surface,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search tasks...',
                          prefixIcon: Icon(Icons.search,
                              color: theme.colorScheme.onSurface.withOpacity(0.4)),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          isDense: true,
                        ),
                        onChanged: (v) => setState(() => _search = v),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  PopupMenuButton<Priority?>(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _filterPriority != null
                            ? theme.colorScheme.primaryContainer
                            : theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.filter_list,
                        color: _filterPriority != null
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface.withOpacity(0.5),
                        size: 20,
                      ),
                    ),
                    onSelected: (v) => setState(() => _filterPriority = v),
                    itemBuilder: (_) => [
                      const PopupMenuItem(value: null, child: Text('All priorities')),
                      PopupMenuItem(
                        value: Priority.high,
                        child: Row(children: [
                          Container(width: 10, height: 10,
                              decoration: BoxDecoration(color: AppTheme.priorityColor(2), shape: BoxShape.circle)),
                          const SizedBox(width: 8), const Text('High'),
                        ]),
                      ),
                      PopupMenuItem(
                        value: Priority.medium,
                        child: Row(children: [
                          Container(width: 10, height: 10,
                              decoration: BoxDecoration(color: AppTheme.priorityColor(1), shape: BoxShape.circle)),
                          const SizedBox(width: 8), const Text('Medium'),
                        ]),
                      ),
                      PopupMenuItem(
                        value: Priority.low,
                        child: Row(children: [
                          Container(width: 10, height: 10,
                              decoration: BoxDecoration(color: AppTheme.priorityColor(0), shape: BoxShape.circle)),
                          const SizedBox(width: 8), const Text('Low'),
                        ]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _TaskList(tasks: allTodo, isDone: false),
                  _TaskList(tasks: completed, isDone: true),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => const TaskFormDialog(),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
        elevation: 4,
      ),
    );
  }
}

class _TaskList extends StatelessWidget {
  final List<Task> tasks;
  final bool isDone;
  const _TaskList({required this.tasks, required this.isDone});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<AppProvider>();
    final theme = Theme.of(context);

    if (tasks.isEmpty) {
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
                isDone ? Icons.celebration_outlined : Icons.check_circle_outline,
                size: 36,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isDone ? 'Nothing completed yet' : 'All done! 🎉',
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              isDone ? 'Complete tasks to see them here' : 'Add a new task to get started',
              style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                  fontSize: 13),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      itemCount: tasks.length,
      itemBuilder: (_, i) {
        final task = tasks[i];
        final color = AppTheme.priorityColor(task.priority.index);
        final isOverdue = task.dueDate != null &&
            task.dueDate!.isBefore(DateTime.now()) &&
            !task.isCompleted;

        return Dismissible(
          key: Key(task.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.red.shade400,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.delete_outline, color: Colors.white),
          ),
          onDismissed: (_) => provider.deleteTask(task.id),
          child: GestureDetector(
            onTap: () => showDialog(
              context: context,
              builder: (_) => TaskFormDialog(task: task),
            ),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: theme.colorScheme.outlineVariant.withOpacity(0.4)),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 5,
                    height: 72,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  GestureDetector(
                    onTap: () => provider.toggleTaskComplete(task.id),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: task.isCompleted ? color : Colors.transparent,
                        border: Border.all(color: color, width: 2),
                      ),
                      child: task.isCompleted
                          ? const Icon(Icons.check, size: 14, color: Colors.white)
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
                          if (task.dueDate != null) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.schedule,
                                  size: 11,
                                  color: isOverdue
                                      ? Colors.red
                                      : theme.colorScheme.onSurface.withOpacity(0.4),
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  '${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isOverdue
                                        ? Colors.red
                                        : theme.colorScheme.onSurface.withOpacity(0.4),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        task.priority.name,
                        style: TextStyle(
                            fontSize: 10,
                            color: color,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
