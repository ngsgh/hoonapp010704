import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/common/detail_app_bar.dart';
import '../../domain/constants/product_categories.dart';
import '../../domain/constants/storage_locations.dart';
import 'package:provider/provider.dart';
import '../../../home/presentation/providers/product_provider.dart';
import '../../../home/domain/models/product.dart';
import '../widgets/image_picker_bottom_sheet.dart';

class ProductRegisterPage extends StatefulWidget {
  const ProductRegisterPage({super.key});

  @override
  State<ProductRegisterPage> createState() => _ProductRegisterPageState();
}

class _ProductRegisterPageState extends State<ProductRegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _productNameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _locationController = TextEditingController();
  File? _selectedImage; // 선택된 이미지 저장
  final _imagePicker = ImagePicker(); // ImagePicker 인스턴스

  // 카테고리 목록
  final List<String> _categories = [
    '육류',
    '채소',
    '과일',
    '유제품',
    '음료',
    '간식',
    '기타',
  ];

  // 상품 위치 목록
  final List<String> _locations = [
    '주 냉장 1번',
    '주 냉장 2번',
    '주 냉장 3번',
    '김치 냉장고',
    '냉동실',
    '실온',
  ];

  Future<void> _showSelectionDialog({
    required String title,
    required List<String> items,
    required TextEditingController controller,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: AppTypography.title.copyWith(color: AppColors.grey900),
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: items
                .map(
                  (item) => ListTile(
                    title: Text(
                      item,
                      style:
                          AppTypography.body.copyWith(color: AppColors.grey900),
                    ),
                    onTap: () {
                      controller.text = item;
                      Navigator.pop(context);
                    },
                  ),
                )
                .toList(),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // 이미지 선택 bottom sheet 표시
  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ImagePickerBottomSheet(
        onCameraTap: () => _pickImage(ImageSource.camera),
        onGalleryTap: () => _pickImage(ImageSource.gallery),
      ),
    );
  }

  // 이미지 선택 함수
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 80, // 이미지 품질 설정
      );
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      // TODO: 에러 처리
      print('이미지 선택 실패: $e');
    }
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _categoryController.dispose();
    _expiryDateController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: DetailAppBar(
        title: '의견',
        rightButtonText: '등록',
        onRightButtonTap: () {
          if (_formKey.currentState?.validate() ?? false) {
            // 새 상품 생성
            final product = Product(
              name: _productNameController.text,
              category: _categoryController.text,
              location: _locationController.text,
              expiryDate: DateTime.parse(
                  _expiryDateController.text.replaceAll('. ', '-')),
              imageUrl: _selectedImage?.path, // 이미지 경로 추가
            );

            // Provider를 통해 상품 추가
            context.read<ProductProvider>().addProduct(product);

            Navigator.pop(context);
          }
        },
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.large,
            vertical: AppSpacing.medium,
          ),
          children: [
            // 이미지 선택 영역
            GestureDetector(
              onTap: _showImagePicker,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(12),
                  image: _selectedImage != null
                      ? DecorationImage(
                          image: FileImage(_selectedImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: _selectedImage == null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.camera_alt,
                              color: AppColors.grey500,
                              size: 32,
                            ),
                            const SizedBox(height: AppSpacing.small),
                            Text(
                              '사진 추가',
                              style: AppTypography.body.copyWith(
                                color: AppColors.grey500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: AppSpacing.large),
            _buildInputField(
              label: '상품명',
              controller: _productNameController,
              hintText: '월간과자 미니어팩',
            ),
            _buildInputField(
              label: '카테고리',
              controller: _categoryController,
              hintText: '카테고리를 선택해주세요',
              readOnly: true,
              onTap: () => _showSelectionDialog(
                title: '카테고리 선택',
                items: _categories,
                controller: _categoryController,
              ),
              suffixIcon:
                  const Icon(Icons.arrow_drop_down, color: AppColors.grey500),
            ),
            _buildInputField(
              label: '유통기한',
              controller: _expiryDateController,
              hintText: 'YYYY-MM-DD',
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
                );
                if (date != null) {
                  setState(() {
                    _expiryDateController.text =
                        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                  });
                }
              },
              suffixIcon:
                  const Icon(Icons.calendar_today, color: AppColors.grey500),
            ),
            _buildInputField(
              label: '상품위치',
              controller: _locationController,
              hintText: '상품 위치를 선택해주세요',
              readOnly: true,
              onTap: () => _showSelectionDialog(
                title: '상품 위치 선택',
                items: _locations,
                controller: _locationController,
              ),
              suffixIcon:
                  const Icon(Icons.arrow_drop_down, color: AppColors.grey500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.label.copyWith(
            color: AppColors.grey700,
          ),
        ),
        const SizedBox(height: AppSpacing.small),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          style: AppTypography.body.copyWith(
            color: AppColors.grey900,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTypography.body.copyWith(
              color: AppColors.grey500,
            ),
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            border: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.grey300),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.grey300),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$label을(를) 입력해주세요';
            }
            return null;
          },
        ),
        const SizedBox(height: AppSpacing.large),
      ],
    );
  }
}
