import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:queueless_flutter/models/organization_model.dart';
import 'package:queueless_flutter/services/queue_service.dart';
import 'package:queueless_flutter/screens/your_token_screen.dart';

class ConfirmJoinSheet extends StatefulWidget {
  final String serviceName;
  final Organization organization;
  
  const ConfirmJoinSheet({super.key, required this.serviceName, required this.organization});

  @override
  State<ConfirmJoinSheet> createState() => _ConfirmJoinSheetState();
}

class _ConfirmJoinSheetState extends State<ConfirmJoinSheet> {
  bool _priorityQueue = false;
  bool _isLoading = false;
  final QueueService _queueService = QueueService();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Text(
                'Confirm Join',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1B233A),
                ),
              ),
              const SizedBox(width: 48), // Balance for centering
            ],
          ),
          const SizedBox(height: 32),
          
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Main Info Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFF3F4F6)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: const Color(0xFF4AC4CA), // Distinctive teal color
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(Icons.apartment, color: Colors.white, size: 32),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.organization.name,
                                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.organization.address,
                                    style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFF6B7280)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildDetailRow('Service', widget.serviceName, isBold: true),
                        const SizedBox(height: 16),
                        const Divider(color: Color(0xFFF3F4F6)),
                        const SizedBox(height: 16),
                        _buildDetailRow('Provider', 'Dr. Sarah Miller', isBold: true),
                        const SizedBox(height: 16),
                        const Divider(color: Color(0xFFF3F4F6)),
                        const SizedBox(height: 16),
                        _buildDetailRow('Wait Time', '~35 min', isHighlight: true, theme: theme),
                        const SizedBox(height: 16),
                        const Divider(color: Color(0xFFF3F4F6)),
                        const SizedBox(height: 16),
                        _buildDetailRow('People Ahead', '12 People', isBold: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Priority Queue Toggle
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFF3F4F6)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF7EB),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.star, color: Colors.orangeAccent),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Priority Queue',
                                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Subject to verification',
                                style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFF9CA3AF)),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _priorityQueue,
                          onChanged: (val) {
                            setState(() {
                              _priorityQueue = val;
                            });
                          },
                          activeColor: theme.primaryColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Info Box
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC), // Very light blue
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      '"By joining, you will receive a digital token. We\'ll notify you when 5 people are remaining."',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: theme.primaryColor,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          ElevatedButton(
            onPressed: _isLoading ? null : () async {
              setState(() { _isLoading = true; });
              try {
                final userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest_user';
                final token = await _queueService.joinQueue(
                  userId: userId,
                  organizationId: widget.organization.id,
                  serviceId: widget.serviceName,
                );
                if (mounted) {
                  Navigator.pop(context); // Close sheet
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => YourTokenScreen(token: token, organization: widget.organization),
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error joining queue')));
                }
              } finally {
                if (mounted) setState(() { _isLoading = false; });
              }
            },
            child: _isLoading 
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('Confirm & Join Queue'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false, bool isHighlight = false, ThemeData? theme}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFF6B7280)),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold || isHighlight ? FontWeight.bold : FontWeight.normal,
            color: isHighlight ? theme?.primaryColor : const Color(0xFF1B233A),
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
