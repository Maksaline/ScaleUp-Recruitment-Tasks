import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../models/product.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(): super(ProductsInitial());

  final dio = Dio();
  List<Product> allProducts = [];
  List<String> categories = [];

  void fetchProducts() async {
    emit(ProductsLoading());
    try {
      final response = await dio.get('https://fakestoreapi.com/products');

      if (response.statusCode == 200) {
        allProducts = (response.data as List).map((json) => Product.fromJson(json)).toList();
        categories = allProducts.map((product) => product.category).toSet().toList();
        categories.insert(0, 'All');

        emit(ProductsLoaded(allProducts, categories));
      } else {
        emit(ProductsError("Error fetching products: ${response.statusCode}"));
      }
    } catch (e) {
      emit(ProductsError("Failed to load products: ${e.toString()}"));
    }
  }

  void filterProducts(String category) {
    if (category == 'All') {
      emit(ProductsLoaded(allProducts, categories));
    } else {
      final filteredProducts = allProducts.where((product) => product.category == category).toList();
      emit(ProductsLoaded(filteredProducts, categories));
    }
  }

  void searchProducts(String query) {
    if (query.isEmpty) {
      emit(ProductsLoaded(allProducts, categories));
    } else {
      final filteredProducts = allProducts.where((product) => product.title.toLowerCase().contains(query.toLowerCase())).toList();
      emit(ProductsLoaded(filteredProducts, categories));
    }
  }
}



