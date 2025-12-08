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
  int selectedIndex = 0;

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
                        onChanged: (value) {
                          context.read<ProductsCubit>().searchProducts(value);
                        },
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
                          categories = state.categories;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 12),
                              SizedBox(
                                height: 30,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: state.categories.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedIndex = index;
                                        });
                                        context.read<ProductsCubit>().filterProducts(state.categories[index]);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(right: 5),
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: selectedIndex == index ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: selectedIndex == index ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onError,
                                            width: 0.2
                                          )
                                        ),
                                        child: Center(
                                          child: Text(
                                            state.categories[index],
                                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                              color: selectedIndex == index ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.onSurface,
                                            )
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: 6),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.7,
                                  crossAxisSpacing: 10,
                                ),
                                itemCount: state.products.length,
                                itemBuilder: (context, index) {
                                  return Stack(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(top: 10),
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withAlpha(60),
                                              spreadRadius: 0.1,
                                              blurRadius: 0.2,
                                              offset: Offset(0, 2),
                                            )
                                          ],
                                          color: Theme.of(context).colorScheme.secondary,
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Image.network(
                                                state.products[index].image,
                                                width: double.infinity,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              state.products[index].title,
                                              style: Theme.of(context).textTheme.labelMedium,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 5),
                                            Row(
                                              children: [
                                                Icon(Icons.star, color: Colors.amber, size: 16),
                                                SizedBox(width: 5),
                                                Text(state.products[index].rating.toString(), style: Theme.of(context).textTheme.labelSmall),
                                                SizedBox(width: 5,),
                                                Text('(${state.products[index].count})', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey),)
                                              ],
                                            ),
                                            SizedBox(height: 5),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text('\$${state.products[index].price}', style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold)),
                                                Container(
                                                  padding: EdgeInsets.all(5),
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context).colorScheme.primary.withAlpha(25),
                                                    shape: BoxShape.circle
                                                  ),
                                                  child: Icon(
                                                    Icons.shopping_bag_outlined, color: Theme.of(context).colorScheme.primary, size: 15,
                                                  ),
                                                )
                                              ],
                                            )
                                          ]
                                        ),
                                      ),
                                      Positioned(
                                        top: 15,
                                        right: 5,
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.surface.withAlpha(250),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(state.products[index].category, style: Theme.of(context).textTheme.labelSmall),
                                        )
                                      )
                                    ],
                                  );
                                }
                              ),
                            ],
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
