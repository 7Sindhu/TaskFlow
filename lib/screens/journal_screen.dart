import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../models/journal_entry.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final entries = provider.journalEntries;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 160,
            backgroundColor: const Color(0xFF8B5CF6),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
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
                          'Daily Journal',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          entries.isEmpty
                              ? 'Start writing your story'
                              : '${entries.length} entr${entries.length == 1 ? 'y' : 'ies'}',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 13),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          DateFormat('EEEE, MMMM d').format(DateTime.now()),
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          entries.isEmpty
              ? SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFF8B5CF6).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.book_outlined,
                              size: 36, color: Color(0xFF8B5CF6)),
                        ),
                        const SizedBox(height: 16),
                        const Text('Your journal is empty',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 6),
                        Text(
                          'Write your first entry today',
                          style: TextStyle(
                              color: theme.colorScheme.onSurface.withOpacity(0.5),
                              fontSize: 13),
                        ),
                        const SizedBox(height: 20),
                        FilledButton.icon(
                          onPressed: () => _openEditor(context, null),
                          icon: const Icon(Icons.edit),
                          label: const Text('Write Entry'),
                          style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF8B5CF6)),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => _JournalCard(
                        entry: entries[i],
                        index: i,
                        onTap: () => _openEditor(context, entries[i]),
                        onDelete: () =>
                            provider.deleteJournalEntry(entries[i].id),
                      ),
                      childCount: entries.length,
                    ),
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(context, null),
        icon: const Icon(Icons.edit),
        label: const Text('New Entry'),
        backgroundColor: const Color(0xFF8B5CF6),
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    );
  }

  void _openEditor(BuildContext context, JournalEntry? entry) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => JournalEditorScreen(entry: entry)),
    );
  }
}

class _JournalCard extends StatelessWidget {
  final JournalEntry entry;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _JournalCard(
      {required this.entry,
      required this.index,
      required this.onTap,
      required this.onDelete});

  static const _gradients = [
    [Color(0xFF8B5CF6), Color(0xFFEC4899)],
    [Color(0xFF3B82F6), Color(0xFF06B6D4)],
    [Color(0xFF10B981), Color(0xFF3B82F6)],
    [Color(0xFFF59E0B), Color(0xFFEF4444)],
    [Color(0xFFEC4899), Color(0xFF8B5CF6)],
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradient = _gradients[index % _gradients.length];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: theme.colorScheme.outlineVariant.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    gradient[0].withOpacity(0.15),
                    gradient[1].withOpacity(0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(entry.mood,
                          style: const TextStyle(fontSize: 24)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          DateFormat('EEEE, MMM d · h:mm a').format(entry.date),
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_outline,
                        size: 18,
                        color: theme.colorScheme.error.withOpacity(0.6)),
                    onPressed: onDelete,
                  ),
                ],
              ),
            ),
            if (entry.content.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Text(
                  entry.content,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: theme.colorScheme.onSurface.withOpacity(0.65),
                  ),
                ),
              ),
            if (entry.tags.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
                child: Wrap(
                  spacing: 6,
                  children: entry.tags
                      .map((tag) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: gradient[0].withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: gradient[0].withOpacity(0.3)),
                            ),
                            child: Text(
                              '#$tag',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: gradient[0],
                                  fontWeight: FontWeight.w600),
                            ),
                          ))
                      .toList(),
                ),
              ),
            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}

class JournalEditorScreen extends StatefulWidget {
  final JournalEntry? entry;
  const JournalEditorScreen({super.key, this.entry});

  @override
  State<JournalEditorScreen> createState() => _JournalEditorScreenState();
}

class _JournalEditorScreenState extends State<JournalEditorScreen> {
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  final _tagCtrl = TextEditingController();
  String _mood = '😊';
  List<String> _tags = [];

  static const _moods = [
    '😊', '😄', '😐', '😔', '😤', '😴', '🤔', '🥳', '😰', '❤️'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.entry != null) {
      _titleCtrl.text = widget.entry!.title;
      _contentCtrl.text = widget.entry!.content;
      _mood = widget.entry!.mood;
      _tags = List.from(widget.entry!.tags);
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    _tagCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.entry != null;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Entry' : 'New Entry',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton(
              onPressed: _save,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Save'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('How are you feeling?',
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _moods
                  .map((m) => GestureDetector(
                        onTap: () => setState(() => _mood = m),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: _mood == m
                                ? const Color(0xFF8B5CF6).withOpacity(0.15)
                                : theme.colorScheme.surfaceContainerHighest
                                    .withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _mood == m
                                  ? const Color(0xFF8B5CF6)
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Text(m,
                              style: const TextStyle(fontSize: 26)),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleCtrl,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _contentCtrl,
              decoration: InputDecoration(
                labelText: 'Write your thoughts...',
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              maxLines: 12,
              minLines: 6,
              style: const TextStyle(height: 1.6),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tagCtrl,
                    decoration: InputDecoration(
                      labelText: 'Add tag',
                      isDense: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onSubmitted: _addTag,
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () => _addTag(_tagCtrl.text),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF8B5CF6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            if (_tags.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _tags
                    .map((tag) => Chip(
                          label: Text('#$tag'),
                          onDeleted: () =>
                              setState(() => _tags.remove(tag)),
                          backgroundColor: const Color(0xFF8B5CF6)
                              .withOpacity(0.1),
                          side: BorderSide(
                              color: const Color(0xFF8B5CF6).withOpacity(0.3)),
                          labelStyle: const TextStyle(
                              color: Color(0xFF8B5CF6),
                              fontWeight: FontWeight.w600),
                        ))
                    .toList(),
              ),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _addTag(String value) {
    final tag = value.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagCtrl.clear();
      });
    }
  }

  void _save() {
    if (_titleCtrl.text.trim().isEmpty) return;
    final provider = context.read<AppProvider>();
    if (widget.entry != null) {
      widget.entry!.title = _titleCtrl.text.trim();
      widget.entry!.content = _contentCtrl.text.trim();
      widget.entry!.mood = _mood;
      widget.entry!.tags = _tags;
      provider.updateJournalEntry(widget.entry!);
    } else {
      provider.createJournalEntry(
        title: _titleCtrl.text.trim(),
        content: _contentCtrl.text.trim(),
        mood: _mood,
        tags: _tags,
      );
    }
    Navigator.pop(context);
  }
}
