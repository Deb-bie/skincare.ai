import 'package:flutter/material.dart';

class Themes {

  /// Light Theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.teal[500],
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.teal[500],
      foregroundColor: Colors.white,
      elevation: 2,
      iconTheme: IconThemeData(color: Colors.white),
    ),

    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: Color(0xFF2C3E50),
        fontSize: 32,
        fontWeight: FontWeight.bold,
        fontFamily: "Poppins",
      ),
      displayMedium: TextStyle(
        color: Color(0xFF2C3E50),
        fontSize: 28,
        fontWeight: FontWeight.bold,
        fontFamily: "Poppins",
        letterSpacing: 1.5,
        height: 1.3,
      ),
      bodyLarge: TextStyle(
        color: Colors.black87,
        fontSize: 16,
        fontFamily: "Poppins",
      ),
      bodyMedium: TextStyle(
        color: Colors.black87,
        fontSize: 14,
        fontFamily: "Poppins",
      ),
    ),

    iconTheme: IconThemeData(color: Colors.black87),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal[500],
        foregroundColor: Colors.white,
        disabledBackgroundColor: Colors.grey[300],
        disabledForegroundColor: Colors.grey[500],
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 0,
        textStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          fontFamily: "Poppins",
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.teal[500],
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.teal[500],
        side: BorderSide(color: Colors.teal[500]!),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.teal[500]!, width: 2),
      ),
      labelStyle: TextStyle(color: Colors.black54),
      hintStyle: TextStyle(color: Colors.black38),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.teal[500],
      foregroundColor: Colors.white,
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      // backgroundColor: Colors.white,
      backgroundColor: const Color(0xFFF5F5F5),
      selectedItemColor: Colors.teal[500],
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
    ),

    drawerTheme: DrawerThemeData(
      backgroundColor: Colors.white,
    ),

    dialogTheme: DialogThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    dividerTheme: DividerThemeData(
      color: Colors.grey[300],
      thickness: 1,
    ),

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.teal[500];
        }
        return Colors.grey;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.teal[500]!.withValues(alpha: 0.5);
        }
        return Colors.grey.withValues(alpha: 0.3);
      }),
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.teal[500];
        }
        return Colors.transparent;
      }),
    ),

    listTileTheme: ListTileThemeData(
      textColor: Colors.black87,
      iconColor: Colors.black87,
    ),

    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    ),

    colorScheme: ColorScheme.light(
      primary: Colors.teal[500]!,
      secondary: Colors.teal[300]!,
      surface: Colors.white,
      background: const Color(0xFFF5F5F5),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFF2C3E50),
      onBackground: Color(0xFF2C3E50),
    ),
  );



  /// Dark Theme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.teal[400],
    scaffoldBackgroundColor: Color(0xFF121212),

    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
    ),

    cardTheme: CardThemeData(
      color: Color(0xFF1E1E1E),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: Colors.white,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        fontFamily: "Poppins",
      ),
      displayMedium: TextStyle(
        color: Colors.white,
        fontSize: 28,
        fontWeight: FontWeight.bold,
        fontFamily: "Poppins",
        letterSpacing: 1.5,
        height: 1.3,
      ),
      bodyLarge: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontFamily: "Poppins",
      ),
      bodyMedium: TextStyle(
        color: Colors.white70,
        fontSize: 14,
        fontFamily: "Poppins",
      ),
    ),

    iconTheme: IconThemeData(color: Colors.white70),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal[400]!.withValues(alpha: 0.20),
        foregroundColor: Colors.white70,
        disabledBackgroundColor: Colors.grey[800],
        disabledForegroundColor: Colors.grey[600],
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 0,
        textStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          fontFamily: "Poppins",
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.teal[300],
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.teal[300],
        side: BorderSide(color: Colors.teal[300]!),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF2C2C2C),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[700]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[700]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.teal[400]!, width: 2),
      ),
      labelStyle: TextStyle(color: Colors.white60),
      hintStyle: TextStyle(color: Colors.white38),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.teal[400],
      foregroundColor: Colors.white,
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1E1E1E),
      selectedItemColor: Colors.teal[300],
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
    ),

    drawerTheme: DrawerThemeData(
      backgroundColor: Color(0xFF1E1E1E),
    ),

    dialogTheme: DialogThemeData(
      backgroundColor: Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    dividerTheme: DividerThemeData(
      color: Colors.grey[800],
      thickness: 1,
    ),

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.teal[400];
        }
        return Colors.grey[600];
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.teal[400]!.withValues(alpha: 0.5);
        }
        return Colors.grey[700]!.withValues(alpha: 0.3);
      }),
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.teal[400];
        }
        return Colors.transparent;
      }),
    ),

    listTileTheme: ListTileThemeData(
      textColor: Colors.white70,
      iconColor: Colors.white70,
    ),

    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    ),

    colorScheme: ColorScheme.dark(
      primary: Colors.teal[400]!,
      secondary: Colors.teal[300]!,
      surface: Colors.grey.shade100,
      background: Color(0xFF121212),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.grey.shade100,
      onBackground: Colors.white,
    ),
  );
}