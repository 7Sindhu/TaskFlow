import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/app_provider.dart';
import '../utils/app_theme.dart';

class TaskFormDialog extends StatefulWidget {
  final Task? task;
  final String? boardId;
  final TaskStatus? initialStatus;

  const TaskFormDialog({super.key, this.task, this.boardId, this.initialStatus});

  @override
  State<TaskFormDialog> createState() => _TaskFormDialogState();
}

class _TaskFormDialogState extends State<TaskFormDialog> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  Priority _priority = Priority.medium;
  TaskStatus _status = TaskStatus.todo;
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleCtrl.text = widget.task!.title;
      _descCtrl.text = widget.task!.description;
      _priority = widget.task!.priority;
      _status = widget.task!.status;
      _dueDate = widget.task!.dueDate;
    } else {
      _status = widget.initialStatus ?? TaskStatus.todo;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.task != null;
    return AlertDialog(
      title: Text(isEdit ? 'Edit Task' : 'New Task'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: 'Title'),
              autofocus: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descCtrl,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<Priority>(
              initialValue: _priority,
              decoration: const InputDecoration(labelText: 'Priority'),
              items: Priority.values
                  .map((p) => DropdownMenuItem(
                        value: p,
                        child: Row(children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: AppTheme.priorityColor(p.index),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(p.name.toUpperCase()),
                        ]),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => _priority = v!),
            ),
            if (widget.boardId != null) ...[
              const SizedBox(height: 12),
              DropdownButtonFormField<TaskStatus>(
                initialValue: _status,
                decoration: const InputDecoration(labelText: 'Status'),
                items: TaskStatus.values
                    .map((s) => DropdownMenuItem(
                          value: s,
                          child: Text(_statusLabel(s)),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _status = v!),
              ),
            ],
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(_dueDate == null
                  ? 'No due date'
                  : 'Due: ${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _dueDate ?? DateTime.now(),
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                );
                if (date != null) setState(() => _dueDate = date);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            if (_titleCtrl.text.trim().isEmpty) return;
            final provider = context.read<AppProvider>();
            if (isEdit) {
              provider.updateTask(widget.task!.copyWith(
                title: _titleCtrl.text.trim(),
                description: _descCtrl.text.trim(),
                priority: _priority,
                status: _status,
                dueDate: _dueDate,
              ));
            } else {
              provider.createTask(
                title: _titleCtrl.text.trim(),
                description: _descCtrl.text.trim(),
                priority: _priority,
                status: _status,
                dueDate: _dueDate,
                boardId: widget.boardId,
              );
            }
            Navigator.pop(context);
          },
          child: Text(isEdit ? 'Save' : 'Create'),
        ),
      ],
    );
  }

  String _statusLabel(TaskStatus s) {
    switch (s) {
      case TaskStatus.todo: return 'To Do';
      case TaskStatus.inProgress: return 'In Progress';
      case TaskStatus.review: return 'Review';
      case TaskStatus.done: return 'Done';
    }
  }
}
