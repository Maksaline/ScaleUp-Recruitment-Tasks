import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/products_cubit.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {

  List<String> categories = [];

  @override
  void initState() {
    super.initState();
    context.read<ProductsCubit>().fetchProducts();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                                Icons.refresh,
                                size: 32,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              onPressed: () {
                                context.read<ProductsCubit>().fetchProducts();
                              },
                            ),
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
                          BoxShadow(
                            color: Colors.grey.withAlpha(60),
                            spreadRadius: 0.1,
                            blurRadius: 0.2,
                            offset: Offset(0, 2),
                          )
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
                      ),
                    ),
                    BlocBuilder<ProductsCubit, ProductsState>(
                      builder: (context, state) {
                        if (state is ProductsLoading) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        else if (state is ProductsLoaded) {
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.7,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: state.products.length,
                            itemBuilder: (context, index) {
                              return Container(
                                height: 50,
                                child: Text(state.products[index].title),
                              );
                            }
                          );
                        }
                        else {
                          return Text('Error');
                        }
                      }
                    )
                  ],
                ),
              ),
            ),
            // SliverFillRemaining()
          ],
        ),
      ),
    );
  }
}
