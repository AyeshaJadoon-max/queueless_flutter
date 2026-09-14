import 'package:flutter/material.dart';
import 'package:queueless_flutter/screens/home_screen.dart';
import 'dart:async';
import 'package:queueless_flutter/models/token_model.dart';
import 'package:queueless_flutter/models/organization_model.dart';
import 'package:queueless_flutter/services/queue_service.dart';
import 'package:queueless_flutter/models/queue_model.dart';

class LiveQueueScreen extends StatefulWidget {
  final QueueToken token;
  final Organization organization;
  
  const LiveQueueScreen({super.key, required this.token, required this.organization});

  @override
  State<LiveQueueScreen> createState() => _LiveQueueScreenState();
}

class _LiveQueueScreenState extends State<LiveQueueScreen> {
  bool _smartNotifications = true;
  QueueData? _queueData;
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _sub = QueueService().streamQueueData(widget.token.serviceId).listen((data) {
      if (mounted) setState(() { _queueData = data; });
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentServing = _queueData?.currentToken ?? 0;
    final userTokenNum = widget.token.tokenNumber;
    final ahead = (userTokenNum - currentServing);
    final peopleAhead = ahead > 0 ? ahead : 0;
    final estTime = peopleAhead * 5;
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: Text(
          'Live Queue',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1B233A),
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Content
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                const Divider(color: Color(0xFFE5E7EB), height: 1),
                const SizedBox(height: 24),
                
                // Now Serving Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFF3F4F6)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'NOW SERVING',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF9CA3AF),
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'A-$currentServing',
                        style: const TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF10B981),
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.token.serviceId,
                        style: theme.textTheme.bodyMedium?.copyWith(color: const Color(0xFF6B7280)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Progress Card
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('CURRENT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF9CA3AF))),
                              Text('A-$currentServing', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('YOURS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF9CA3AF))),
                              Text('A-$userTokenNum', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.primaryColor)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Progress Bar Mock
                      Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Container(
                            height: 8,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          Container(
                            height: 8,
                            width: MediaQuery.of(context).size.width * 0.45,
                            decoration: BoxDecoration(
                              color: theme.primaryColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          Positioned(
                            left: MediaQuery.of(context).size.width * 0.45 - 12,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: theme.primaryColor, width: 4),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4F7FF),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  const Text('AHEAD OF YOU', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF2A64F6))),
                                  const SizedBox(height: 4),
                                  Text('$peopleAhead People', style: theme.textTheme.titleMedium?.copyWith(color: theme.primaryColor, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4F7FF),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  const Text('EST. TIME', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF2A64F6))),
                                  const SizedBox(height: 4),
                                  Text('~$estTime min', style: theme.textTheme.titleMedium?.copyWith(color: theme.primaryColor, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Next in Line Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B233A),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Next in Line',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text('Real-time update', style: TextStyle(color: Colors.white70, fontSize: 10)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildNextInLineRow('A-20', 'Processing...', isGray: true),
                      const SizedBox(height: 16),
                      _buildNextInLineRow('A-21', 'Up Next', isHighlight: true),
                      const SizedBox(height: 16),
                      _buildNextInLineRow('A-22', 'Estimated 3m', isGray: true),
                      const SizedBox(height: 16),
                      _buildNextInLineRow('A-23', 'Estimated 7m', isGray: true),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Smart Notifications
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.notifications_active, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Smart Notifications',
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const Text(
                              'Alert at 5 people remaining',
                              style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _smartNotifications,
                        onChanged: (val) {
                          setState(() {
                            _smartNotifications = val;
                          });
                        },
                        activeColor: const Color(0xFF10B981),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 120), // Bottom padding for floating bar
              ],
            ),
          ),
          
          // Bottom Bar (Leave Queue)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -10)),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDF4FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(Icons.confirmation_number, color: theme.primaryColor),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('YOUR TOKEN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF9CA3AF))),
                      Text('A-$userTokenNum', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Spacer(),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                          (route) => false,
                        );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                      side: const BorderSide(color: Color(0xFFFFEBEE)),
                      backgroundColor: const Color(0xFFFFF5F5),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                    child: const Text('Leave Queue', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextInLineRow(String token, String status, {bool isHighlight = false, bool isGray = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          token,
          style: TextStyle(
            color: isHighlight ? Colors.white : (isGray ? Colors.white70 : Colors.white),
            fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
            fontSize: 16,
          ),
        ),
        Text(
          status,
          style: TextStyle(
            color: isHighlight ? const Color(0xFF4AC4CA) : Colors.white54,
            fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
