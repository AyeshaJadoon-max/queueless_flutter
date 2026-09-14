import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:queueless_flutter/models/organization_model.dart';
import 'package:queueless_flutter/models/token_model.dart';
import 'package:queueless_flutter/models/queue_model.dart';
import 'package:queueless_flutter/services/queue_service.dart';
import 'package:queueless_flutter/screens/hospitals_nearby_screen.dart';
import 'package:queueless_flutter/screens/home_screen.dart';
import 'package:queueless_flutter/screens/history_screen.dart';
import 'package:queueless_flutter/screens/profile_screen.dart';
import 'package:queueless_flutter/screens/live_queue_screen.dart';

class MyQueuesScreen extends StatelessWidget {
  const MyQueuesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentUser = FirebaseAuth.instance.currentUser;
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'My Queues',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1B233A),
          ),
        ),
      ),
      body: currentUser == null
          ? const Center(child: Text("Please sign in to view your active queues."))
          : StreamBuilder<QueueToken?>(
              stream: QueueService().streamActiveToken(currentUser.uid),
              builder: (context, tokenSnapshot) {
                if (tokenSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final token = tokenSnapshot.data;
                if (token == null) {
                  return _buildEmptyState(context, theme);
                }

                return StreamBuilder<QueueData?>(
                  stream: QueueService().streamQueueData(token.serviceId),
                  builder: (context, queueSnapshot) {
                    final queueData = queueSnapshot.data;
                    final currentServing = queueData?.currentToken ?? 0;
                    final ahead = token.tokenNumber - currentServing;
                    final peopleAhead = ahead > 0 ? ahead : 0;
                    final estTime = peopleAhead * 5;

                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: const Color(0xFFF3F4F6)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.02),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: theme.primaryColor,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(24),
                                      topRight: Radius.circular(24),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Queue Token',
                                            style: TextStyle(color: Colors.white70, fontSize: 12),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Token #${token.tokenNumber}',
                                            style: theme.textTheme.titleMedium?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'A-${token.tokenNumber}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.people, color: theme.primaryColor, size: 20),
                                              const SizedBox(width: 8),
                                              const Text('People Ahead', style: TextStyle(color: Color(0xFF4B5563))),
                                            ],
                                          ),
                                          Text('$peopleAhead', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.access_time, color: theme.primaryColor, size: 20),
                                              const SizedBox(width: 8),
                                              const Text('Est. Wait Time', style: TextStyle(color: Color(0xFF4B5563))),
                                            ],
                                          ),
                                          Text(
                                            '~$estTime min',
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: theme.primaryColor),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 24),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => LiveQueueScreen(
                                                  token: token,
                                                  organization: Organization(
                                                    id: token.organizationId,
                                                    name: 'General Hospital',
                                                    description: 'Medical Center',
                                                    address: 'Main Street',
                                                    type: 'Hospital',
                                                    rating: '4.8',
                                                    isOpen: true,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFFF4F7FF),
                                            foregroundColor: theme.primaryColor,
                                            elevation: 0,
                                          ),
                                          child: const Text('View Live Tracking'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFF3F4F6)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.info_outline, color: Color(0xFF6B7280)),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Status updates automatically in real-time as your position advances.',
                                    style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFF6B7280)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: theme.primaryColor,
        unselectedItemColor: const Color(0xFF9CA3AF),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 1) return;
          Widget targetScreen;
          switch (index) {
            case 0:
              targetScreen = const HomeScreen();
              break;
            case 2:
              targetScreen = const HistoryScreen();
              break;
            case 3:
              targetScreen = const ProfileScreen();
              break;
            default:
              targetScreen = const HomeScreen();
          }
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => targetScreen),
          );
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.confirmation_number_outlined), label: 'My Queues'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFFF4F7FF),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.confirmation_number_outlined,
                size: 64,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Active Queues',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1B233A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You currently have no active tokens. Explore nearby services to join a queue.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HospitalsNearbyScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Join a Queue'),
            ),
          ],
        ),
      ),
    );
  }
}
