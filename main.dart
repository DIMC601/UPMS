import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

// Custom Colors from the Technical Specification
const Color primaryGreen = Color(0xFF10B981); // Primary: Green (#10B981)
const Color secondaryBlue = Color(0xFF2563EB); // Secondary: Blue-600 (#2563EB)
const Color surfaceSlate = Color(0xFF1E293B); // Surface: Slate-800 (#1E293B)
const Color accentTeal = Color(0xFF0D9488); // Accent: Teal-600 (#0D9488)
const Color highlightGold = Color(0xFFF59E0B); // Highlight: Gold (#F59E0B)

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Define a custom dark color scheme based on the spec
    final ColorScheme customColorScheme = ColorScheme.dark(
      primary: primaryGreen,
      onPrimary: Colors.white,
      secondary: secondaryBlue,
      onSecondary: Colors.white,
      surface: surfaceSlate,
      onSurface: Colors.white70,
      background: surfaceSlate,
      onBackground: Colors.white70,
      error: Colors.red.shade700,
      onError: Colors.white,
      brightness: Brightness.dark,
      // Custom tones, using specified colors
      tertiary: accentTeal, // Using accent as tertiary for now
      inversePrimary: highlightGold, // Using highlight for inversePrimary
      // For more specific Material 3 roles, we can further customize
      // For example, if we had a specific color for 'outline', 'shadow', etc.
    );

    return MaterialApp.router(
      title: 'UPMS',
      theme: ThemeData.from(
        colorScheme: customColorScheme,
        useMaterial3: true,
      ).copyWith(
        // Further customize specific widget themes if needed
        appBarTheme: AppBarTheme(
          backgroundColor: surfaceSlate,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
        ),
        // Example for text theme, adjust as needed
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: Colors.white70,
          displayColor: Colors.white,
        ),
      ),
      routerConfig: _router,
    );
  }
}

// Provider for Voter Registration state
class VoterRegistrationProvider with ChangeNotifier {
  int _currentStep = 0;
  final int _totalSteps = 4; // As per spec: Country/University, Reg Number, Status, Account Creation

  int get currentStep => _currentStep;
  int get totalSteps => _totalSteps;

  bool get isFirstStep => _currentStep == 0;
  bool get isLastStep => _currentStep == _totalSteps - 1;

  void nextStep() {
    if (_currentStep < _totalSteps - 1) {
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  // Placeholder for registration data
  Map<String, dynamic> registrationData = {};

  void resetRegistration() {
    _currentStep = 0;
    registrationData = {};
    notifyListeners();
  }
}

// Placeholder for the Voter Registration Screen
class VoterRegistrationScreen extends StatelessWidget {
  const VoterRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VoterRegistrationProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Voter Registration'),
          backgroundColor: Theme.of(context).colorScheme.surface,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.go('/login'); // Go back to login if registration is cancelled
            },
          ),
        ),
        body: Consumer<VoterRegistrationProvider>(
          builder: (context, provider, child) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Step ${provider.currentStep + 1} of ${provider.totalSteps}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: _buildStepContent(provider.currentStep),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: provider.isFirstStep ? null : provider.previousStep,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.secondary,
                          foregroundColor: Theme.of(context).colorScheme.onSecondary,
                        ),
                        child: const Text('Back'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (provider.isLastStep) {
                            // Simulate final registration step
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Registration Complete!')),
                            );
                            provider.resetRegistration(); // Reset provider state
                            context.go('/home'); // Navigate to home after registration
                          } else {
                            provider.nextStep();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        ),
                        child: Text(provider.isLastStep ? 'Complete' : 'Next'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStepContent(int step) {
    switch (step) {
      case 0:
        return const Text('Step 1: Country/University Selection (Placeholder)');
      case 1:
        return const Text('Step 2: Registration Number Verification (Placeholder)');
      case 2:
        return const Text('Step 3: Status Display (Placeholder)');
      case 3:
        return const Text('Step 4: Account Creation & Dashboard Redirect (Placeholder)');
      default:
        return const Text('Unknown Step');
    }
  }
}

// GoRouter configuration
final GoRouter _router = GoRouter(
  initialLocation: '/login', // Set initial route to login
  routes: <RouteBase>[
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: '/register',
      builder: (BuildContext context, GoRouterState state) {
        return const VoterRegistrationScreen();
      },
    ),
    // Add more routes as the application grows
  ],
);


// Placeholder for the Login Screen
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UPMS - Login'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to UPMS!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 20),
            Text(
              'Unified Login Screen',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Simulate successful login
                context.go('/home'); // Navigate to home
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Theme.of(context).colorScheme.onSecondary,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text('Login (Placeholder)'),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Handle forgot password or registration
                context.go('/register'); // Navigate to registration
              },
              child: Text(
                'Register Now',
                style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Handle forgot password
              },
              child: Text(
                'Forgot Password?',
                style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder for the Home Screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UPMS - Home'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.go('/login'); // Simulate logout
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome Home, User!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 20),
            Text(
              'This is your main dashboard.',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Placeholder for navigating to E-Voting
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Navigate to E-Voting (Coming Soon!)')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              child: const Text('Go to E-Voting'),
            ),
          ],
        ),
      ),
    );
  }
}