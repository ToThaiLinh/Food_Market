import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food/bloc/shopping/shopping_event.dart';
import 'package:food/bloc/shopping/shopping_state.dart';

import '../../services/shopping_api_service.dart';

class ShoppingBloc extends Bloc<ShoppingEvent, ShoppingState> {
  final ShoppingApiService _apiService;

  ShoppingBloc(this._apiService) : super(ShoppingInitial()) {
    on<LoadShoppingItems>(_onLoadShoppingItems);
    on<AddShoppingItem>(_onAddShoppingItem);
    on<UpdateShoppingItem>(_onUpdateShoppingItem);
    // on<DeleteShoppingItem>(_onDeleteShoppingItem);
    on<SearchShoppingItems>(_onSearchShoppingItems);
    on<FilterShoppingItems>(_onFilterShoppingItems);
  }

  Future<void> _onLoadShoppingItems(
      LoadShoppingItems event,
      Emitter<ShoppingState> emit,
      ) async {
    emit(ShoppingLoading());
    try {
      final items = await _apiService.getAllFoods();
      if (items != null) {
        emit(ShoppingLoaded(
          items: items,
          selectedDate: DateTime.now(),
        ));
      } else {
        emit(ShoppingError('Failed to load items'));
      }
    } catch (e) {
      emit(ShoppingError(e.toString()));
    }
  }

  Future<void> _onAddShoppingItem(
      AddShoppingItem event,
      Emitter<ShoppingState> emit,
      ) async {
    final currentState = state;
    if (currentState is ShoppingLoaded) {
      try {
        final result = await _apiService.updateFood(
          name: event.item['name'],
          category: event.item['category'],
          unit: event.item['unit'],
          id: event.item['id'],
          userIdCreate: '',
        );

        if (result != null) {
          final newItems = List<Map<String, dynamic>>.from(currentState.items)
            ..add(event.item);
          emit(ShoppingLoaded(
            items: newItems,
            selectedDate: currentState.selectedDate,
            selectedCategory: currentState.selectedCategory,
            searchQuery: currentState.searchQuery,
          ));
        }
      } catch (e) {
        emit(ShoppingError(e.toString()));
      }
    }
  }

  Future<void> _onUpdateShoppingItem(
      UpdateShoppingItem event,
      Emitter<ShoppingState> emit,
      ) async {
    final currentState = state;
    if (currentState is ShoppingLoaded) {
      try {
        final result = await _apiService.updateFood(
          id: event.id,
          name: event.item['name'],
          category: event.item['category'],
          unit: event.item['unit'],
          userIdCreate: '',
        );

        if (result != null) {
          final newItems = List<Map<String, dynamic>>.from(currentState.items);
          final index = newItems.indexWhere((item) => item['id'] == event.id);
          if (index != -1) {
            newItems[index] = {
              ...event.item,
              'id': event.id,
            };
          }

          emit(ShoppingLoaded(
            items: newItems,
            selectedDate: currentState.selectedDate,
            selectedCategory: currentState.selectedCategory,
            searchQuery: currentState.searchQuery,
          ));
        }
      } catch (e) {
        emit(ShoppingError(e.toString()));
      }
    }
  }


  Future<void> _onSearchShoppingItems(
      SearchShoppingItems event,
      Emitter<ShoppingState> emit,
      ) async {
    final currentState = state;
    if (currentState is ShoppingLoaded) {
      final filteredItems = currentState.items
          .where((item) => item['name']
          .toString()
          .toLowerCase()
          .contains(event.query.toLowerCase()))
          .toList();

      emit(ShoppingLoaded(
        items: filteredItems,
        selectedDate: currentState.selectedDate,
        selectedCategory: currentState.selectedCategory,
        searchQuery: event.query,
      ));
    }
  }

  Future<void> _onFilterShoppingItems(
      FilterShoppingItems event,
      Emitter<ShoppingState> emit,
      ) async {
    final currentState = state;
    if (currentState is ShoppingLoaded) {
      List<Map<String, dynamic>> filteredItems = currentState.items;

      if (event.category != 'Tất cả') {
        filteredItems = currentState.items
            .where((item) => item['category'] == event.category)
            .toList();
      }

      emit(ShoppingLoaded(
        items: filteredItems,
        selectedDate: currentState.selectedDate,
        selectedCategory: event.category,
        searchQuery: currentState.searchQuery,
      ));
    }
  }
}
