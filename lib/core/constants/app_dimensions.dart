class AppDimensions {
  // Espaciados
  static const double smallPadding = 8.0;
  static const double mediumPadding = 10.0;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 32.0;
  
  // Bordes redondeados
  static const double smallRadius = 5.0;
  static const double mediumRadius = 10.0;
  static const double largeRadius = 20.0;
  
  // Tamaños de widgets
  static const double taskItemMinHeight = 75.0;
  static const double iconButtonSize = 30.0;
  static const double addButtonHeight = 60.0;
  
  // Breakpoints responsivos
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 900.0;
  static const double desktopBreakpoint = 1200.0;
  
  // Tamaños máximos para contenedores
  static const double maxContainerWidth = 600.0;
  static const double maxMainContainerWidth = 800.0;
  
  // Espaciados específicos
  static const double taskItemPadding = 16.0;
  static const double taskItemMargin = 8.0;
  
  // Elevaciones
  static const double lowElevation = 2.0;
  static const double mediumElevation = 4.0;
  static const double highElevation = 8.0;
  
  // Métodos para obtener dimensiones responsivas
  static double getContainerWidth(double screenWidth) {
    if (screenWidth <= mobileBreakpoint) {
      return screenWidth - (mediumPadding * 2);
    } else if (screenWidth <= tabletBreakpoint) {
      return screenWidth * 0.8;
    } else {
      return maxContainerWidth;
    }
  }
  
  static double getMainContainerWidth(double screenWidth) {
    if (screenWidth <= mobileBreakpoint) {
      return screenWidth - (largePadding * 2);
    } else if (screenWidth <= tabletBreakpoint) {
      return screenWidth * 0.75;
    } else {
      return maxMainContainerWidth;
    }
  }
  
  static double getHorizontalPadding(double screenWidth) {
    if (screenWidth <= mobileBreakpoint) {
      return mediumPadding;
    } else if (screenWidth <= tabletBreakpoint) {
      return largePadding;
    } else {
      return extraLargePadding;
    }
  }
  
  static int getTaskTitleMaxLines(double screenWidth) {
    return screenWidth <= mobileBreakpoint ? 1 : 2;
  }
  
  static int getTaskDescriptionMaxLines(double screenWidth) {
    return screenWidth <= mobileBreakpoint ? 1 : 2;
  }
}
