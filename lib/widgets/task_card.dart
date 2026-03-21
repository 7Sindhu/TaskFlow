import 'package:flutter/material.dart';
import '../models/task.dart';
import '../utils/app_theme.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onToggle;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onDelete,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOverdue = task.dueDate != null &&
        task.dueDate!.isBefore(DateTime.now()) &&
        !task.isCompleted;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              if (onToggle != null)
                GestureDetector(
                  onTap: onToggle,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: task.isCompleted
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline,
                        width: 2,
                      ),
                      color: task.isCompleted
                          ? theme.colorScheme.primary
                          : Colors.transparent,
                    ),
                    child: task.isCompleted
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : null,
                  ),
                ),
              if (onToggle != null) const SizedBox(width: 12),
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.priorityColor(task.priority.index),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.isCompleted
                            ? theme.colorScheme.onSurface.withOpacity(0.5)
                            : null,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (task.description.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        task.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
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
                            size: 12,
                            color: isOverdue ? Colors.red : theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: isOverdue ? Colors.red : theme.colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              if (onDelete != null)
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18),
                  onPressed: onDelete,
                  color: theme.colorScheme.error,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
