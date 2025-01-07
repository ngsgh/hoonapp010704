import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
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
import '../../../../core/utils/image_storage_util.dart';

class ProductRegisterPage extends StatefulWidget {
  final Product? product; // 수정할 상품
  final int? index; // 수정할 상품의 인덱스

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
  final _productNameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _locationController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _imagePicker = ImagePicker();
  File? _selectedImage;
  DateTime? _selectedDate;
  String? _savedImagePath;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _productNameController.text = widget.product!.name;
      _categoryController.text = widget.product!.category;
      _locationController.text = widget.product!.location;
      _selectedDate = widget.product!.expiryDate;
      _expiryDateController.text = _formatDate(widget.product!.expiryDate);

      // 기존 이미지가 있다면 파일 존재 여부 확인
      if (widget.product!.imageUrl != null) {
        final file = File(widget.product!.imageUrl!);
        file.exists().then((exists) {
          if (exists) {
            setState(() {
              _selectedImage = file;
            });
          } else {
            debugPrint('기존 이미지 파일을 찾을 수 없음: ${widget.product!.imageUrl}');
          }
        });
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}. ${date.month}. ${date.day}';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _expiryDateController.text = _formatDate(picked);
      });
    }
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _categoryController.dispose();
    _locationController.dispose();
    _expiryDateController.dispose();
    super.dispose();
  }

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
      final pickedFile = await _imagePicker.pickImage(source: source);
      if (pickedFile != null) {
        debugPrint('선택된 이미지: ${pickedFile.path}');

        // 임시 파일을 앱 디렉토리에 복사
        final savedPath =
            await ImageStorageUtil.saveImage(File(pickedFile.path));
        debugPrint('저장된 이미지 상대 경로: $savedPath');

        // 저장된 이미지 파일 가져오기
        final fullPath = await ImageStorageUtil.getFullPath(savedPath);
        debugPrint('저장된 이미지 전체 경로: $fullPath');

        setState(() {
          _selectedImage = File(fullPath); // 저장된 파일로 설정
          _savedImagePath = savedPath; // 상대 경로 저장
        });
      }
    } catch (e, stack) {
      debugPrint('이미지 선택/저장 오류: $e');
      debugPrint(stack.toString());
    }
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      // 상대 경로를 사용하여 Product 생성
      final product = Product(
        name: _productNameController.text,
        category: _categoryController.text,
        location: _locationController.text,
        expiryDate: _selectedDate ?? DateTime.now(),
        imageUrl: _savedImagePath, // 이미 상대 경로
      );

      final provider = context.read<ProductProvider>();

      if (widget.product != null && widget.index != null) {
        if (widget.product!.imageUrl != null &&
            widget.product!.imageUrl != _savedImagePath) {
          await ImageStorageUtil.deleteImage(widget.product!.imageUrl);
        }
        await provider.updateProduct(widget.index!, product);
      } else {
        await provider.addProduct(product);
      }

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: DetailAppBar(
        title: '상품등록',
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
