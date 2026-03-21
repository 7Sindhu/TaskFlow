import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/task.dart';
import '../models/board.dart';
import '../utils/app_theme.dart';
import '../widgets/task_form_dialog.dart';

class KanbanScreen extends StatefulWidget {
  const KanbanScreen({super.key});

  @override
  State<KanbanScreen> createState() => _KanbanScreenState();
}

class _KanbanScreenState extends State<KanbanScreen> {
  String? _selectedBoardId;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    if (_selectedBoardId == null && provider.boards.isNotEmpty) {
      _selectedBoardId = provider.boards.first.id;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kanban Boards', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showBoardDialog(context),
          ),
        ],
        bottom: provider.boards.isEmpty
            ? null
            : PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: SizedBox(
                  height: 48,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: provider.boards.length,
                    itemBuilder: (_, i) {
                      final board = provider.boards[i];
                      final selected = board.id == _selectedBoardId;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onLongPress: () => _showDeleteBoardDialog(context, board),
                          child: FilterChip(
                            label: Text(board.name),
                            selected: selected,
                            onSelected: (_) => setState(() => _selectedBoardId = board.id),
                            selectedColor: Color(board.color).withOpacity(0.2),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
      ),
      body: provider.boards.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.dashboard_outlined, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No boards yet'),
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    onPressed: () => _showBoardDialog(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Create Board'),
                  ),
                ],
              ),
            )
          : _selectedBoardId == null
              ? const SizedBox()
              : _KanbanBoard(boardId: _selectedBoardId!),
    );
  }

  void _showBoardDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    int selectedColor = 0xFF6366F1;
    final colors = [0xFF6366F1, 0xFF10B981, 0xFFEF4444, 0xFFF59E0B, 0xFF3B82F6, 0xFFEC4899];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          title: const Text('New Board'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Board Name'), autofocus: true),
              const SizedBox(height: 12),
              TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Description')),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: colors.map((c) => GestureDetector(
                  onTap: () => setS(() => selectedColor = c),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Color(c),
                      shape: BoxShape.circle,
                      border: selectedColor == c ? Border.all(color: Colors.black, width: 3) : null,
                    ),
                  ),
                )).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                if (nameCtrl.text.trim().isEmpty) return;
                final id = context.read<AppProvider>().createBoard(
                  name: nameCtrl.text.trim(),
                  description: descCtrl.text.trim(),
                  color: selectedColor,
                );
                setState(() => _selectedBoardId = id);
                Navigator.pop(ctx);
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteBoardDialog(BuildContext context, Board board) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Board'),
        content: Text('Delete "${board.name}" and all its tasks?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              context.read<AppProvider>().deleteBoard(board.id);
              setState(() => _selectedBoardId = null);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _KanbanBoard extends StatelessWidget {
  final String boardId;
  const _KanbanBoard({required this.boardId});

  static const _columns = [
    (TaskStatus.todo, 'To Do', Icons.radio_button_unchecked),
    (TaskStatus.inProgress, 'In Progress', Icons.timelapse),
    (TaskStatus.review, 'Review', Icons.rate_review),
    (TaskStatus.done, 'Done', Icons.check_circle),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(16),
      itemCount: _columns.length,
      itemBuilder: (_, i) {
        final (status, label, icon) = _columns[i];
        return _KanbanColumn(boardId: boardId, status: status, label: label, icon: icon);
      },
    );
  }
}

class _KanbanColumn extends StatelessWidget {
  final String boardId;
  final TaskStatus status;
  final String label;
  final IconData icon;

  const _KanbanColumn({
    required this.boardId,
    required this.status,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final tasks = provider.tasksForStatus(boardId, status);
    final color = AppTheme.statusColor(status.index);

    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 8),
                Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('${tasks.length}', style: TextStyle(color: color, fontSize: 12)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: DragTarget<String>(
              onAcceptWithDetails: (details) {
                provider.moveTask(details.data, status);
              },
              builder: (_, candidateData, __) => Container(
                decoration: BoxDecoration(
                  color: candidateData.isNotEmpty
                      ? color.withOpacity(0.05)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: candidateData.isNotEmpty
                      ? Border.all(color: color.withOpacity(0.3), style: BorderStyle.solid)
                      : null,
                ),
                child: ListView(
                  children: [
                    ...tasks.map((task) => Draggable<String>(
                          data: task.id,
                          feedback: Material(
                            elevation: 4,
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: 260,
                              child: _KanbanCard(task: task, boardId: boardId),
                            ),
                          ),
                          childWhenDragging: Opacity(
                            opacity: 0.3,
                            child: _KanbanCard(task: task, boardId: boardId),
                          ),
                          child: _KanbanCard(task: task, boardId: boardId),
                        )),
                    TextButton.icon(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (_) => TaskFormDialog(boardId: boardId, initialStatus: status),
                      ),
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Add task'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KanbanCard extends StatelessWidget {
  final Task task;
  final String boardId;
  const _KanbanCard({required this.task, required this.boardId});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<AppProvider>();
    final theme = Theme.of(context);
    final priorityColor = AppTheme.priorityColor(task.priority.index);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () => showDialog(
          context: context,
          builder: (_) => TaskFormDialog(task: task, boardId: boardId),
        ),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(color: priorityColor, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    task.priority.name.toUpperCase(),
                    style: TextStyle(fontSize: 10, color: priorityColor, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => provider.deleteTask(task.id),
                    child: Icon(Icons.close, size: 14, color: theme.colorScheme.outline),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(task.title, style: const TextStyle(fontWeight: FontWeight.w600)),
              if (task.description.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  task.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (task.dueDate != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}',
                      style: theme.textTheme.labelSmall,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
