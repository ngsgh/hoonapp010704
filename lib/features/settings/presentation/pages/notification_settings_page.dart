import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../providers/notification_settings_provider.dart';

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.grey900,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '알림 설정',
          style: AppTypography.title.copyWith(
            color: AppColors.grey900,
          ),
        ),
      ),
      body: Consumer<NotificationSettingsProvider>(
        builder: (context, provider, child) {
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.medium),
            children: [
              _buildSection(
                '알림',
                [
                  SwitchListTile(
                    title: const Text('유통기한 알림'),
                    subtitle: const Text('유통기한 임박 상품 알림을 받습니다'),
                    value: provider.isEnabled,
                    onChanged: (value) => provider.setEnabled(value),
                    activeColor: AppColors.primary,
                  ),
                ],
              ),
              if (provider.isEnabled) ...[
                const SizedBox(height: AppSpacing.medium),
                _buildSection(
                  '알림 설정',
                  [
                    ListTile(
                      title: const Text('알림 시간'),
                      subtitle: Text(
                        '${provider.notificationTime.hour.toString().padLeft(2, '0')}:${provider.notificationTime.minute.toString().padLeft(2, '0')}',
                      ),
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: provider.notificationTime,
                        );
                        if (time != null) {
                          provider.setNotificationTime(time);
                        }
                      },
                    ),
                    ListTile(
                      title: const Text('알림 시점'),
                      subtitle: Text('유통기한 ${provider.daysBeforeExpiry}일 전'),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('알림 시점 설정'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RadioListTile<int>(
                                  title: const Text('3일 전'),
                                  value: 3,
                                  groupValue: provider.daysBeforeExpiry,
                                  onChanged: (value) {
                                    provider.setDaysBeforeExpiry(value!);
                                    Navigator.pop(context);
                                  },
                                ),
                                RadioListTile<int>(
                                  title: const Text('5일 전'),
                                  value: 5,
                                  groupValue: provider.daysBeforeExpiry,
                                  onChanged: (value) {
                                    provider.setDaysBeforeExpiry(value!);
                                    Navigator.pop(context);
                                  },
                                ),
                                RadioListTile<int>(
                                  title: const Text('7일 전'),
                                  value: 7,
                                  groupValue: provider.daysBeforeExpiry,
                                  onChanged: (value) {
                                    provider.setDaysBeforeExpiry(value!);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.medium),
            child: Text(
              title,
              style: AppTypography.title.copyWith(
                fontSize: 16,
                color: AppColors.grey900,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}
