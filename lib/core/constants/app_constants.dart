class AppConstants {
  // API URLs
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const String ticketsEndpoint = '/posts';
  
  // Route names
  static const String loginRoute = '/login';
  static const String ticketsRoute = '/tickets';
  static const String ticketDetailsRoute = '/tickets/:id';
  static const String profileRoute = '/profile';
  
  // Validation
  static const String emailPattern = 
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const int minPasswordLength = 6;
  
  // Messages
  static const String loginSuccessMessage = 'Login successful!';
  static const String loginErrorMessage = 'Invalid email or password';
  static const String logoutSuccessMessage = 'Logged out successfully';
  static const String ticketResolvedMessage = 'Ticket marked as resolved';
  static const String ticketsFetchErrorMessage = 'Failed to fetch tickets';
  
  // Animation durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
}
