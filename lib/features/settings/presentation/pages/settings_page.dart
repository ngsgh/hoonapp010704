import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import 'notification_settings_page.dart';
import '../providers/backup_provider.dart';
import 'package:intl/intl.dart';
import '../../../product_master/presentation/pages/product_master_list_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          '설정',
          style: AppTypography.title.copyWith(
            color: AppColors.grey900,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.medium),
        children: [
          _buildSection(
            '알림',
            [
              ListTile(
                leading: const Icon(Icons.notifications_outlined),
                title: const Text('알림 설정'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationSettingsPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.inventory_2_outlined),
                title: const Text('상품 마스터 관리'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProductMasterListPage(),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),
          Consumer<BackupProvider>(
            builder: (context, provider, child) {
              return _buildSection(
                '백업',
                [
                  SwitchListTile(
                    title: const Text('iCloud 백업'),
                    subtitle: Text(
                      provider.lastBackupDate != null
                          ? '마지막 백업: ${DateFormat('yyyy.MM.dd HH:mm').format(provider.lastBackupDate!)}'
                          : '백업 데이터 없음',
                    ),
                    value: provider.isBackupEnabled,
                    onChanged: (value) => provider.setBackupEnabled(value),
                    activeColor: AppColors.primary,
                  ),
                  if (provider.isBackupEnabled) ...[
                    ListTile(
                      title: const Text('지금 백업하기'),
                      onTap: () async {
                        try {
                          await provider.backup();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('백업이 완료되었습니다')),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('백업 실패: $e')),
                            );
                          }
                        }
                      },
                    ),
                    ListTile(
                      title: const Text('백업에서 복원하기'),
                      onTap: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('백업에서 복원'),
                            content: const Text(
                              '현재 데이터가 모두 삭제되고 백업 데이터로 복원됩니다.\n계속하시겠습니까?',
                            ),
                            actions: [
                              TextButton(
                                child: const Text('취소'),
                                onPressed: () => Navigator.pop(context, false),
                              ),
                              TextButton(
                                child: const Text('복원'),
                                onPressed: () => Navigator.pop(context, true),
                              ),
                            ],
                          ),
                        );

                        if (confirmed == true && context.mounted) {
                          try {
                            await provider.restore();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('복원이 완료되었습니다')),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('복원 실패: $e')),
                              );
                            }
                          }
                        }
                      },
                    ),
                  ],
                ],
              );
            },
          ),
        ],
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
