enum StorageLocation {
  mainFridge1('주 냉장 1'),
  mainFridge2('주 냉장 2'),
  subFridge1('보조 냉장 1'),
  subFridge2('보조 냉장 2'),
  freezer('냉동실');

  final String label;
  const StorageLocation(this.label);
}
