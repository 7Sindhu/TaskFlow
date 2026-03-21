import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'utils/app_theme.dart';
import 'screens/dashboard_screen.dart';
import 'screens/kanban_screen.dart';
import 'screens/todo_screen.dart';
import 'screens/journal_screen.dart';
import 'screens/habits_screen.dart';
import 'screens/calendar_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: const TaskManagementApp(),
    ),
  );
}

class TaskManagementApp extends StatelessWidget {
  const TaskManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<AppProvider>().isDarkMode;
    return MaterialApp(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  static const _screens = [
    DashboardScreen(),
    KanbanScreen(),
    TodoScreen(),
    CalendarScreen(),
    JournalScreen(),
    HabitsScreen(),
  ];

  static const _navItems = [
    (Icons.dashboard_outlined, Icons.dashboard, 'Dashboard'),
    (Icons.view_kanban_outlined, Icons.view_kanban, 'Kanban'),
    (Icons.checklist_outlined, Icons.checklist, 'To-Do'),
    (Icons.calendar_month_outlined, Icons.calendar_month, 'Calendar'),
    (Icons.book_outlined, Icons.book, 'Journal'),
    (Icons.repeat_outlined, Icons.repeat, 'Habits'),
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 720;
    final theme = Theme.of(context);

    if (isWide) {
      return Scaffold(
        body: Row(
          children: [
            Container(
              width: 220,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  right: BorderSide(
                      color: theme.colorScheme.outlineVariant.withOpacity(0.3)),
                ),
              ),
              child: Column(
                children: [
                  SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  theme.colorScheme.primary,
                                  theme.colorScheme.tertiary,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.task_alt,
                                color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'TaskFlow',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      itemCount: _navItems.length,
                      itemBuilder: (_, i) {
                        final (outIcon, selIcon, label) = _navItems[i];
                        final selected = _currentIndex == i;
                        return GestureDetector(
                          onTap: () => setState(() => _currentIndex = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(vertical: 3),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: selected
                                  ? theme.colorScheme.primaryContainer
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  selected ? selIcon : outIcon,
                                  size: 20,
                                  color: selected
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.onSurface
                                          .withOpacity(0.6),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  label,
                                  style: TextStyle(
                                    fontWeight: selected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: selected
                                        ? theme.colorScheme.primary
                                        : theme.colorScheme.onSurface
                                            .withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: _screens[_currentIndex]),
          ],
        ),
      );
    }

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (i) => setState(() => _currentIndex = i),
          elevation: 0,
          height: 64,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: _navItems
              .map((item) => NavigationDestination(
                    icon: Icon(item.$1),
                    selectedIcon: Icon(item.$2),
                    label: item.$3,
                  ))
              .toList(),
        ),
      ),
    );
  }
}
