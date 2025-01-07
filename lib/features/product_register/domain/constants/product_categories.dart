enum ProductCategory {
  meat('육류'),
  vegetable('채소'),
  fruit('과일'),
  seafood('해산물'),
  dairy('유제품'),
  beverage('음료'),
  sauce('소스/양념'),
  snack('과자/간식'),
  frozen('냉동식품'),
  other('기타');

  final String label;
  const ProductCategory(this.label);
}
