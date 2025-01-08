import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/image_storage_util.dart';
import '../../domain/models/product_master.dart';
import '../providers/product_master_provider.dart';
import 'package:image_picker/image_picker.dart';

class ProductMasterEditPage extends StatefulWidget {
  final ProductMaster? product;

  const ProductMasterEditPage({
    super.key,
    this.product,
  });

  @override
  State<ProductMasterEditPage> createState() => _ProductMasterEditPageState();
}

class _ProductMasterEditPageState extends State<ProductMasterEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _storeNameController = TextEditingController();
  final _purchaseUrlController = TextEditingController();
  String _selectedCategory = '유제품';
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _selectedCategory = widget.product!.category;
      _imageUrl = widget.product!.imageUrl;
      _storeNameController.text = widget.product!.storeName ?? '';
      _purchaseUrlController.text = widget.product!.purchaseUrl ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _storeNameController.dispose();
    _purchaseUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.grey900,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.product != null ? '상품 마스터 수정' : '상품 마스터 추가',
          style: AppTypography.title.copyWith(
            color: AppColors.grey900,
          ),
        ),
        actions: [
          if (widget.product != null)
            IconButton(
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.red,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('상품 마스터 삭제'),
                    content: const Text('이 상품 마스터를 삭제하시겠습니까?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('취소'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await context
                              .read<ProductMasterProvider>()
                              .deleteProduct(widget.product!);
                          if (context.mounted) {
                            Navigator.pop(context); // 다이얼로그 닫기
                            Navigator.pop(context); // 수정 화면 닫기
                          }
                        },
                        child: const Text(
                          '삭제',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: Consumer<ProductMasterProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.medium),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: '상품명',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '상품명을 입력해주세요';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: '카테고리',
                    ),
                    items: provider.categories
                        .where((category) => category != '전체')
                        .map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  TextFormField(
                    controller: _storeNameController,
                    decoration: const InputDecoration(
                      labelText: '구매처',
                      hintText: '예: 이마트, 쿠팡 등',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  TextFormField(
                    controller: _purchaseUrlController,
                    decoration: const InputDecoration(
                      labelText: '구매 URL',
                      hintText: '상품 구매 페이지 주소',
                    ),
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  Center(
                    child: InkWell(
                      onTap: () async {
                        final picker = ImagePicker();
                        final image =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          final savedImagePath =
                              await ImageStorageUtil.saveImage(
                                  File(image.path));
                          setState(() {
                            _imageUrl = savedImagePath;
                          });
                        }
                      },
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.grey300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _imageUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: FutureBuilder<String>(
                                  future: ImageStorageUtil.getFullPath(
                                      _imageUrl!.contains('product_images/')
                                          ? _imageUrl!.substring(_imageUrl!
                                              .indexOf('product_images/'))
                                          : _imageUrl!),
                                  builder: (context, pathSnapshot) {
                                    if (pathSnapshot.hasData) {
                                      return Image.file(
                                        File(pathSnapshot.data!),
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          debugPrint('이미지 로드 에러: $error');
                                          debugPrint(
                                              '시도한 경로: ${pathSnapshot.data}');
                                          return const Icon(
                                            Icons.error_outline,
                                            color: AppColors.grey500,
                                            size: 48,
                                          );
                                        },
                                      );
                                    }
                                    return const CircularProgressIndicator();
                                  },
                                ),
                              )
                            : const Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 48,
                                color: AppColors.grey500,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.medium),
          child: ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final product = ProductMaster(
                  name: _nameController.text,
                  category: _selectedCategory,
                  imageUrl: _imageUrl,
                  useCount: widget.product?.useCount ?? 0,
                  storeName: _storeNameController.text,
                  purchaseUrl: _purchaseUrlController.text,
                );

                if (widget.product != null) {
                  await context
                      .read<ProductMasterProvider>()
                      .updateProduct(widget.product!, product);
                } else {
                  await context
                      .read<ProductMasterProvider>()
                      .addProduct(product);
                }

                if (context.mounted) {
                  Navigator.pop(context);
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size.fromHeight(48),
            ),
            child: Text(
              widget.product != null ? '수정하기' : '추가하기',
              style: AppTypography.button.copyWith(
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
