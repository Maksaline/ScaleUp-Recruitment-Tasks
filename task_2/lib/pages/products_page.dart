import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:task_2/pages/widgets/products_card.dart';

import '../cubits/products_cubit.dart';
import '../models/product.dart';
import 'product_detail_page.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {

  int selectedIndex = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    context.read<ProductsCubit>().fetchProducts();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<ProductsCubit>().fetchProducts();
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 120.0,
                toolbarHeight: 60,
                pinned: true,
                backgroundColor: Theme.of(context).colorScheme.surface,
                elevation: 0,
                surfaceTintColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: 16, bottom: 4),
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Discover',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        'Find the best products for you',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                  background: Container(
                    color: Theme.of(context).colorScheme.surface,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.menu,
                              size: 32,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            onPressed: () {},
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.shopping_cart_outlined,
                                  size: 32,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(color: Colors.grey.withAlpha(60), blurRadius: 5, offset: const Offset(0, 2))
                          ]
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                            fillColor: Theme.of(context).colorScheme.secondary,
                            filled: true,
                            isDense: true,
                            hintText: 'Search clothes, jewelry...',
                            hintStyle: Theme.of(context).textTheme.labelSmall,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Theme.of(context).colorScheme.onError,
                            ),
                          ),
                          style: Theme.of(context).textTheme.labelSmall,
                          onChanged: (value) {
                            context.read<ProductsCubit>().searchProducts(value);
                          },
                        ),
                      ),
                      BlocBuilder<ProductsCubit, ProductsState>(
                        builder: (context, state) {

                          final bool isLoading = state is ProductsLoading;
                          final bool isError = state is ProductsError;

                          if (isError) {
                            return Center(
                              child: Text((state).message),
                            );
                          }

                          final List<String> categories = state is ProductsLoaded ? state.categories : [];
                          final List<Product> products = state is ProductsLoaded ? state.products : [];

                          return Skeletonizer(
                            enabled: isLoading,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 12),
                                SizedBox(
                                  height: 40,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: isLoading ? 6 : categories.length,
                                    itemBuilder: (context, index) {
                                      final String categoryName = isLoading ? 'Category' : categories[index];
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 8),
                                        child: GestureDetector(
                                          onTap: isLoading ? null : () {
                                            setState(() => selectedIndex = index);
                                            context.read<ProductsCubit>().filterProducts(categories[index]);
                                          },
                                          child: Chip(
                                            label: Text(
                                              categoryName,
                                              style: TextStyle(
                                                color: selectedIndex == index
                                                    ? Theme.of(context).colorScheme.secondary
                                                    : Theme.of(context).colorScheme.onSurface,
                                              ),
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            backgroundColor: selectedIndex == index
                                                ? Theme.of(context).colorScheme.primary
                                                : Theme.of(context).colorScheme.secondary,
                                            side: BorderSide(
                                              color: Colors.grey,
                                              width: 0.2
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 6),
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.7,
                                    crossAxisSpacing: 12,
                                  ),
                                  itemCount: isLoading ? 6 : products.length,
                                  itemBuilder: (context, index) {
                                    final dummyProduct = Product(
                                      id: index,
                                      title: 'Product Title Loading...',
                                      price: 99.99,
                                      image: '',
                                      rating: 4.5,
                                      count: 128,
                                      category: 'electronics',
                                      description: '',
                                    );

                                    final product = isLoading ? dummyProduct : products[index];

                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ProductDetailPage(product: product),
                                          ),
                                        );
                                      },
                                      child: ProductCard(
                                        product: product,
                                        isLoading: isLoading,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // SliverFillRemaining()
            ],
          ),
        ),
      ),
    );
  }
}
