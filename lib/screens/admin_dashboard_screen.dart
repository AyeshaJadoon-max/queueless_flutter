import 'package:flutter/material.dart';
import 'package:queueless_flutter/screens/home_screen.dart'; // Just to have a backward link if needed

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 280,
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.history, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'QueueLess',
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildSidebarItem('Dashboard', Icons.analytics, true, theme),
                      _buildSidebarItem('Queue Management', Icons.people_outline, false, theme),
                      _buildSidebarItem('Services', Icons.list_alt, false, theme),
                      _buildSidebarItem('Settings', Icons.settings_outlined, false, theme),
                    ],
                  ),
                ),
                
                // Pro Plan Box
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B233A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'PRO PLAN',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'City General Hospital',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.primaryColor,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Upgrade'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Main Content
          Expanded(
            child: Column(
              children: [
                // Header
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Dashboard Overview',
                        style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF10B981),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'LIVE STATUS',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          const CircleAvatar(
                            backgroundColor: Color(0xFFE5E7EB),
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Dashboard Body
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        // Row 1: KPI Cards
                        Row(
                          children: [
                            Expanded(child: _buildMetricCard('TOTAL WAITING', '42', '12% vs last hour', true, theme)),
                            const SizedBox(width: 24),
                            Expanded(child: _buildMetricCard('AVG. WAIT TIME', '18m', 'Optimal range', null, theme, isBlue: true)),
                            const SizedBox(width: 24),
                            Expanded(child: _buildMetricCard('TOKENS TODAY', '156', 'New record!', true, theme)),
                            const SizedBox(width: 24),
                            Expanded(child: _buildNowServingCard(theme)),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // Row 2: Charts
                        Row(
                          children: [
                            Expanded(child: _buildChartBox('Hourly Traffic', Icons.show_chart, theme)),
                            const SizedBox(width: 24),
                            Expanded(child: _buildChartBox('Service Popularity', Icons.pie_chart, theme, isPie: true)),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // Row 3: Live Queue List
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: const Color(0xFFF3F4F6)),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Live Queue Management',
                                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text('View Full List', style: TextStyle(color: theme.primaryColor)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  Expanded(child: Text('TOKEN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF9CA3AF)))),
                                  Expanded(flex: 2, child: Text('CUSTOMER', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF9CA3AF)))),
                                  Expanded(flex: 2, child: Text('SERVICE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF9CA3AF)))),
                                  Expanded(child: Text('STATUS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF9CA3AF)))),
                                  Text('ACTIONS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF9CA3AF))),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildListRow('A-20', 'Michael Smith', 'General Consultation', 'Waiting'),
                              const Divider(color: Color(0xFFF3F4F6), height: 32),
                              _buildListRow('A-21', 'Sarah Miller', 'Lab Reports', 'Waiting'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSidebarItem(String title, IconData icon, bool isActive, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFEDF4FF) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: isActive ? theme.primaryColor : const Color(0xFF6B7280)),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? theme.primaryColor : const Color(0xFF6B7280),
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        onTap: () {},
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, String subtitle, bool? isPositive, ThemeData theme, {bool isBlue = false}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF9CA3AF), letterSpacing: 1)),
          const SizedBox(height: 16),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isBlue ? theme.primaryColor : const Color(0xFF1B233A),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              if (isPositive != null) ...[
                Icon(isPositive ? Icons.arrow_upward : Icons.arrow_downward, size: 14, color: const Color(0xFF10B981)),
                const SizedBox(width: 4),
              ],
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: isPositive == true ? const Color(0xFF10B981) : const Color(0xFF9CA3AF),
                  fontWeight: isPositive == true ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNowServingCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1B233A),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('NOW SERVING', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white70, letterSpacing: 1)),
          const SizedBox(height: 12),
          const Text(
            'A-19',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Call Next'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartBox(String title, IconData icon, ThemeData theme, {bool isPie = false}) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          Expanded(
            child: Center(
              child: Icon(icon, size: 100, color: const Color(0xFFE5E7EB)),
              // In reality, use fl_chart or similar to match the mock exactly.
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListRow(String token, String name, String service, String status) {
    return Row(
      children: [
        Expanded(child: Text(token, style: const TextStyle(fontWeight: FontWeight.bold))),
        Expanded(flex: 2, child: Text(name)),
        Expanded(flex: 2, child: Text(service, style: const TextStyle(color: Color(0xFF6B7280)))),
        Expanded(
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(color: Color(0xFFF59E0B), shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(status, style: const TextStyle(color: Color(0xFFF59E0B), fontSize: 12)),
            ],
          ),
        ),
        const Icon(Icons.more_horiz, color: Color(0xFF9CA3AF)),
      ],
    );
  }
}
