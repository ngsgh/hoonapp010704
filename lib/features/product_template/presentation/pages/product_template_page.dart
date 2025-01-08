import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../providers/product_template_provider.dart';
import '../../domain/models/product_template.dart';

class ProductTemplatePage extends StatelessWidget {
  const ProductTemplatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          '상품 템플릿',
          style: AppTypography.title.copyWith(
            color: AppColors.grey900,
          ),
        ),
      ),
      body: Consumer<ProductTemplateProvider>(
        builder: (context, provider, child) {
          if (provider.templates.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: AppColors.grey500,
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  Text(
                    '등록된 템플릿이 없습니다',
                    style: AppTypography.body.copyWith(
                      color: AppColors.grey700,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.medium),
            children: [
              _buildSection(
                '자주 사용하는 템플릿',
                provider.getMostUsedTemplates(),
                provider,
              ),
              const SizedBox(height: AppSpacing.medium),
              _buildSection(
                '최근 추가한 템플릿',
                provider.getRecentTemplates(),
                provider,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection(
    String title,
    List<ProductTemplate> templates,
    ProductTemplateProvider provider,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: AppSpacing.small),
          child: Text(
            title,
            style: AppTypography.title.copyWith(
              fontSize: 16,
              color: AppColors.grey900,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: templates.length,
          itemBuilder: (context, index) {
            final template = templates[index];
            return Card(
              margin: const EdgeInsets.only(bottom: AppSpacing.small),
              child: ListTile(
                leading: template.imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.file(
                          File(template.imageUrl!),
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 48,
                              height: 48,
                              color: AppColors.grey300,
                              child: const Icon(
                                Icons.error_outline,
                                color: AppColors.grey500,
                              ),
                            );
                          },
                        ),
                      )
                    : Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.grey300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          color: AppColors.grey500,
                        ),
                      ),
                title: Text(template.name),
                subtitle: Text(
                  template.category,
                  style: AppTypography.body.copyWith(
                    color: AppColors.grey700,
                    fontSize: 14,
                  ),
                ),
                trailing: Text(
                  '${template.useCount}회 사용',
                  style: AppTypography.body.copyWith(
                    color: AppColors.grey700,
                    fontSize: 12,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
