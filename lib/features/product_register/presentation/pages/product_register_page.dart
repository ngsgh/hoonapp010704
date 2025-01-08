import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/image_storage_util.dart';
import '../../../home/presentation/providers/product_provider.dart';
import '../../../home/domain/models/product.dart';
import '../../../product_template/domain/models/product_template.dart';
import '../../../product_template/presentation/providers/product_template_provider.dart';
import '../../../product_template/presentation/pages/product_template_page.dart';
import '../../../product_master/domain/models/product_master.dart';
import '../../../product_master/presentation/providers/product_master_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ProductRegisterPage extends StatefulWidget {
  final Product? product;
  final int? index;

  const ProductRegisterPage({
    super.key,
    this.product,
    this.index,
  });

  @override
  State<ProductRegisterPage> createState() => _ProductRegisterPageState();
}

class _ProductRegisterPageState extends State<ProductRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _searchController = TextEditingController();
  final _storeNameController = TextEditingController();
  final _purchaseUrlController = TextEditingController();
  String _selectedCategory = '유제품';
  DateTime _expiryDate = DateTime.now();
  String? _imageUrl;
  bool _saveAsTemplate = false;
  bool _isSearching = false;
  String? _selectedMasterId;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _locationController.text = widget.product!.location;
      _selectedCategory = widget.product!.category;
      _expiryDate = widget.product!.expiryDate;
      _imageUrl = widget.product!.imageUrl;
      _selectedMasterId = widget.product!.masterId;
      _storeNameController.text = widget.product!.storeName ?? '';
      _purchaseUrlController.text = widget.product!.purchaseUrl ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _searchController.dispose();
    _storeNameController.dispose();
    _purchaseUrlController.dispose();
    super.dispose();
  }

  void _selectMasterProduct(ProductMaster master) {
    setState(() {
      _nameController.text = master.name;
      _selectedCategory = master.category;
      _imageUrl = master.imageUrl;
      _selectedMasterId = master.key?.toString();
      _storeNameController.text = master.storeName ?? '';
      _purchaseUrlController.text = master.purchaseUrl ?? '';
      _isSearching = false;
      _searchController.clear();
    });
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
          widget.product != null ? '상품 수정' : '상품 등록',
          style: AppTypography.title.copyWith(
            color: AppColors.grey900,
          ),
        ),
        actions: [
          if (widget.product == null)
            IconButton(
              icon: const Icon(
                Icons.inventory_2_outlined,
                color: AppColors.primary,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductTemplatePage(),
                  ),
                );
              },
            ),
        ],
      ),
      body: Consumer3<ProductProvider, ProductTemplateProvider,
          ProductMasterProvider>(
        builder: (context, productProvider, templateProvider, masterProvider,
            child) {
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
                      hintText: '상품명을 입력하세요',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _isSearching = value.isNotEmpty;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '상품명을 입력해주세요';
                      }
                      return null;
                    },
                  ),
                  if (_isSearching) ...[
                    const SizedBox(height: AppSpacing.small),
                    Container(
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: Card(
                        child: Consumer<ProductMasterProvider>(
                          builder: (context, provider, child) {
                            final products =
                                provider.searchProducts(_nameController.text);
                            if (products.isEmpty) {
                              return const ListTile(
                                title: Text('새로운 상품으로 등록됩니다'),
                                subtitle: Text('아래 정보를 입력해주세요'),
                              );
                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                final master = products[index];
                                return ListTile(
                                  leading: master.imageUrl != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          child: FutureBuilder<String>(
                                            future:
                                                ImageStorageUtil.getFullPath(
                                              master.imageUrl!.contains(
                                                      'product_images/')
                                                  ? master.imageUrl!.substring(
                                                      master.imageUrl!.indexOf(
                                                          'product_images/'))
                                                  : master.imageUrl!,
                                            ),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return Image.file(
                                                  File(snapshot.data!),
                                                  width: 40,
                                                  height: 40,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Container(
                                                      width: 40,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            AppColors.grey300,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                      ),
                                                      child: const Icon(
                                                        Icons
                                                            .image_not_supported_outlined,
                                                        color:
                                                            AppColors.grey500,
                                                        size: 24,
                                                      ),
                                                    );
                                                  },
                                                );
                                              }
                                              return const SizedBox(
                                                width: 40,
                                                height: 40,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      : Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: AppColors.grey300,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: const Icon(
                                            Icons.image_not_supported_outlined,
                                            color: AppColors.grey500,
                                          ),
                                        ),
                                  title: Text(master.name),
                                  subtitle: Text(master.category),
                                  onTap: () {
                                    setState(() {
                                      _nameController.text = master.name;
                                      _selectedCategory = master.category;
                                      _imageUrl = master.imageUrl;
                                      _selectedMasterId =
                                          master.key?.toString();
                                      _storeNameController.text =
                                          master.storeName ?? '';
                                      _purchaseUrlController.text =
                                          master.purchaseUrl ?? '';
                                      _isSearching = false;
                                    });
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.medium),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: '카테고리',
                    ),
                    items: productProvider.categories
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
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: '보관 위치',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '보관 위치를 입력해주세요';
                      }
                      return null;
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: _expiryDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now()
                                  .add(const Duration(days: 365 * 2)),
                            );
                            if (date != null) {
                              setState(() {
                                _expiryDate = date;
                              });
                            }
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: '유통기한',
                            ),
                            child: Text(
                              DateFormat('yyyy년 MM월 dd일').format(_expiryDate),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.medium),
                      Column(
                        children: [
                          const Text(
                            '상품 이미지',
                            style: TextStyle(
                              color: AppColors.grey700,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () async {
                              final picker = ImagePicker();
                              final image = await picker.pickImage(
                                  source: ImageSource.gallery);
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
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: AppColors.grey300,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: _imageUrl != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: FutureBuilder<String>(
                                        future: ImageStorageUtil.getFullPath(
                                            _imageUrl!
                                                    .contains('product_images/')
                                                ? _imageUrl!.substring(
                                                    _imageUrl!.indexOf(
                                                        'product_images/'))
                                                : _imageUrl!),
                                        builder: (context, pathSnapshot) {
                                          if (pathSnapshot.hasData) {
                                            return Image.file(
                                              File(pathSnapshot.data!),
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return const Icon(
                                                  Icons.error_outline,
                                                  color: AppColors.grey500,
                                                  size: 32,
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
                                      size: 32,
                                      color: AppColors.grey500,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (widget.product == null) ...[
                    const SizedBox(height: AppSpacing.medium),
                    SwitchListTile(
                      title: const Text('템플릿으로 저장'),
                      subtitle: const Text('자주 사용하는 상품으로 저장합니다'),
                      value: _saveAsTemplate,
                      onChanged: (value) {
                        setState(() {
                          _saveAsTemplate = value;
                        });
                      },
                      activeColor: AppColors.primary,
                    ),
                  ],
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
                if (_selectedMasterId == null) {
                  final master = ProductMaster(
                    name: _nameController.text,
                    category: _selectedCategory,
                    imageUrl: _imageUrl,
                    storeName: _storeNameController.text,
                    purchaseUrl: _purchaseUrlController.text,
                  );
                  final masterProvider = context.read<ProductMasterProvider>();
                  await masterProvider.addProduct(master);

                  // 방금 추가한 마스터 상품의 ID를 찾습니다
                  final products =
                      masterProvider.searchProducts(_nameController.text);
                  if (products.isNotEmpty) {
                    final savedMaster = products.first;
                    _selectedMasterId = savedMaster.key.toString();
                  }
                }

                final product = Product(
                  name: _nameController.text,
                  category: _selectedCategory,
                  location: _locationController.text,
                  expiryDate: _expiryDate,
                  imageUrl: _imageUrl,
                  masterId: _selectedMasterId,
                  storeName: _storeNameController.text,
                  purchaseUrl: _purchaseUrlController.text,
                );

                if (widget.product != null && widget.index != null) {
                  await context
                      .read<ProductProvider>()
                      .updateProduct(widget.index!, product);
                } else {
                  await context.read<ProductProvider>().addProduct(product);

                  if (_saveAsTemplate) {
                    final template = ProductTemplate(
                      name: _nameController.text,
                      category: _selectedCategory,
                      imageUrl: _imageUrl,
                    );
                    await context
                        .read<ProductTemplateProvider>()
                        .addTemplate(template);
                  }
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
              widget.product != null ? '수정하기' : '등록하기',
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
