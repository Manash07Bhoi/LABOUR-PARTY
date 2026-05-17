import '../work/add_work_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../blocs/work/work_bloc.dart';
import '../dashboard/dashboard_screen.dart';
import '../work/work_records_screen.dart';

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const WorkRecordsScreen(),
    const Center(child: Text('Reports - TODO')),      // ReportsScreen
  ];

  @override
  void initState() {
    super.initState();
    // Load initial data for dashboard and works
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WorkBloc>().add(LoadDashboardDataEvent());
    });
  }

  void _onTabTapped(int index) {
    if (_currentIndex == index) return;
    
    setState(() {
      _currentIndex = index;
    });

    if (index == 0) {
      context.read<WorkBloc>().add(LoadDashboardDataEvent());
    } else if (index == 1) {
      context.read<WorkBloc>().add(LoadAllWorksEvent());
    } else if (index == 2) {
      // Load reports data
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundCard,
        elevation: 0,
        title: Text(
          _currentIndex == 0 ? 'Dashboard' : _currentIndex == 1 ? 'Work Records' : 'Reports',
          style: AppTypography.headlineMedium,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: AppColors.cardGradient,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(
                    'assets/images/app_logo.png',
                    width: 48,
                    height: 48,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.build, size: 48, color: AppColors.accentCyanLight),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Labour Party',
                    style: AppTypography.headlineMedium,
                  ),
                  Text(
                    'Operations Manager',
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.accentCyanLight),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(Icons.people_outline, 'Labours', () {}),
            _buildDrawerItem(Icons.local_shipping_outlined, 'Drivers', () {}),
            _buildDrawerItem(Icons.agriculture_outlined, 'Tractors', () {}),
            _buildDrawerItem(Icons.place_outlined, 'Places', () {}),
            const Divider(color: AppColors.textDisabled),
            _buildDrawerItem(Icons.settings_outlined, 'Settings', () {}),
            _buildDrawerItem(Icons.info_outline, 'About', () {}),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onTabTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: AppColors.accentCyan),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(Icons.list_alt, color: AppColors.accentCyan),
            label: 'Works',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics, color: AppColors.accentCyan),
            label: 'Reports',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddWorkScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary),
      title: Text(title, style: AppTypography.bodyLarge),
      onTap: () {
        Navigator.pop(context); // Close drawer
        onTap();
      },
    );
  }
}
