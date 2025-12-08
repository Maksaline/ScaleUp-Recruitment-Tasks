import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_2/pages/products_page.dart';

import 'cubits/products_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color textDark = Colors.black;
  static const Color textMedium = Colors.black54;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductsCubit(),
      child: MaterialApp(
        title: 'Products',
        theme: ThemeData(
          colorScheme: ColorScheme(
            brightness: Brightness.light,
            primary: Color(0xFF4F46E5),
            onPrimary: Colors.black,
            secondary: Colors.white,
            onSecondary: Color(0xFFF6F6F6),
            error: Color(0xFF797979),
            onError: Colors.black54,
            surface: Color(0xFFF8FAFC),
            onSurface: Colors.black87,
          ),
          useMaterial3: true,
          textTheme: TextTheme(
            displayLarge: GoogleFonts.poppins(
              color: textDark,
              fontWeight: FontWeight.bold,
            ),
            displayMedium: GoogleFonts.poppins(
              color: textDark,
              fontWeight: FontWeight.bold,
            ),
            displaySmall: GoogleFonts.poppins(
              color: textDark,
              fontWeight: FontWeight.bold,
            ),
            headlineLarge: GoogleFonts.poppins(
              color: textDark,
              fontWeight: FontWeight.w600,
            ),
            headlineMedium: GoogleFonts.poppins(
              color: textDark,
              fontWeight: FontWeight.bold,
            ),
            headlineSmall: GoogleFonts.poppins(color: textDark),
            titleLarge: GoogleFonts.poppins(
              color: textDark,
              fontWeight: FontWeight.w600,
            ),
            titleMedium: GoogleFonts.poppins(color: textDark),
            titleSmall: GoogleFonts.poppins(color: textDark),
            bodyLarge: GoogleFonts.poppins(color: textDark),
            bodyMedium: GoogleFonts.poppins(color: textMedium),
            bodySmall: GoogleFonts.poppins(color: textMedium),
            labelLarge: GoogleFonts.poppins(
              color: textDark,
              fontWeight: FontWeight.w500,
            ),
            labelMedium: GoogleFonts.poppins(
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
            labelSmall: GoogleFonts.poppins(color: textMedium),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: ProductsPage(),
      ),
    );
  }
}
