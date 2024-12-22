// 1. Events
abstract class ShoppingEvent {}

class LoadShoppingItems extends ShoppingEvent {}

class AddShoppingItem extends ShoppingEvent {
  final Map<String, dynamic> item;
  AddShoppingItem(this.item);
}

class UpdateShoppingItem extends ShoppingEvent {
  final String id;
  final Map<String, dynamic> item;
  UpdateShoppingItem(this.id, this.item);
}

class DeleteShoppingItem extends ShoppingEvent {
  final String id;
  DeleteShoppingItem(this.id);
}

class SearchShoppingItems extends ShoppingEvent {
  final String query;
  SearchShoppingItems(this.query);
}

class FilterShoppingItems extends ShoppingEvent {
  final String category;
  FilterShoppingItems(this.category);
}
