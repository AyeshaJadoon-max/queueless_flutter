import 'package:flutter/material.dart';
import 'package:queueless_flutter/widgets/confirm_join_sheet.dart';
import 'package:queueless_flutter/models/organization_model.dart';
import 'package:queueless_flutter/models/service_model.dart';
import 'package:queueless_flutter/services/firestore_service.dart';

class HospitalDetailsScreen extends StatelessWidget {
  final Organization organization;
  const HospitalDetailsScreen({super.key, required this.organization});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Header Container
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF1B233A),
            ),
            child: const Center(
              child: Icon(Icons.business, color: Colors.white24, size: 100),
            ),
          ),
          
          // App Bar Area (Float over header)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCircularButton(Icons.arrow_back_ios_new, () => Navigator.pop(context)),
                _buildCircularButton(Icons.favorite_border, () {}),
              ],
            ),
          ),
          
          // Details Sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.68,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                organization.name,
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1B233A),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.location_on, size: 16, color: theme.primaryColor),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      organization.address,
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: const Color(0xFF6B7280),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEDF4FF),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Text(
                                organization.rating.split(' ').first,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: theme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'RATING',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2A64F6),
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Info Cards
                    Row(
                      children: [
                        Expanded(child: _buildInfoCard('HOURS', '08:00 - 20:00', Icons.access_time, theme)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildInfoCard('STATUS', organization.isOpen ? 'Open Now' : 'Closed', Icons.check_circle_outline, theme)),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    Text(
                      'Available Services (Live from Firestore)',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1B233A),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Dynamic Stream of Services from Firestore
                    StreamBuilder<List<AppService>>(
                      stream: FirestoreService().streamServices(organization.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: Padding(
                            padding: EdgeInsets.all(24.0),
                            child: CircularProgressIndicator(),
                          ));
                        }
                        
                        final services = snapshot.data ?? [];
                        if (services.isEmpty) {
                          // Fallback default services if none added in sub-collection
                          return Column(
                            children: [
                              _buildServiceItem('General Consultation', Icons.medical_services_outlined, organization),
                              const SizedBox(height: 12),
                              _buildServiceItem('Lab Reports & Diagnostics', Icons.science_outlined, organization),
                              const SizedBox(height: 12),
                              _buildServiceItem('Radiology / X-Ray', Icons.monitor_heart_outlined, organization),
                            ],
                          );
                        }
                        
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: services.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final service = services[index];
                            return _buildServiceItem(service.name, Icons.medical_services_outlined, organization);
                          },
                        );
                      },
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

  Widget _buildCircularButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: theme.primaryColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(String title, IconData icon, Organization organization) {
    return Builder(
      builder: (context) {
        return InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => ConfirmJoinSheet(serviceName: title, organization: organization),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF3F4F6)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: const Color(0xFF4B5563)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF1B233A),
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF)),
              ],
            ),
          ),
        );
      }
    );
  }
}
