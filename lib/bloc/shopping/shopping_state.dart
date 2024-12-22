// 2. States
abstract class ShoppingState {}

class ShoppingInitial extends ShoppingState {}

class ShoppingLoading extends ShoppingState {}

class ShoppingLoaded extends ShoppingState {
  final List<Map<String, dynamic>> items;
  final DateTime selectedDate;
  final String selectedCategory;
  final String searchQuery;

  ShoppingLoaded({
    required this.items,
    required this.selectedDate,
    this.selectedCategory = 'Tất cả',
    this.searchQuery = '',
  });
}

class ShoppingError extends ShoppingState {
  final String message;
  ShoppingError(this.message);
}
