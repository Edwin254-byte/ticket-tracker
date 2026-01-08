import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/storage/local_storage_service.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';
import 'data/datasources/auth_datasource.dart';
import 'data/datasources/ticket_datasource.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/ticket_repository.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/bloc/auth_event.dart';
import 'features/tickets/bloc/tickets_bloc.dart';
import 'features/theme/bloc/theme_bloc.dart';
import 'features/theme/bloc/theme_event.dart';
import 'features/theme/bloc/theme_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local storage
  final storageService = await LocalStorageService.create();

  // Initialize data sources
  final authDataSource = AuthDataSource(storageService);
  final ticketDataSource = TicketDataSource();

  // Initialize repositories
  final authRepository = AuthRepository(authDataSource);
  final ticketRepository = TicketRepository(
    dataSource: ticketDataSource,
    storageService: storageService,
  );

  // Initialize router
  final appRouter = AppRouter(authRepository: authRepository);

  runApp(
    MyApp(
      storageService: storageService,
      authRepository: authRepository,
      ticketRepository: ticketRepository,
      appRouter: appRouter,
    ),
  );
}

class MyApp extends StatelessWidget {
  final LocalStorageService storageService;
  final AuthRepository authRepository;
  final TicketRepository ticketRepository;
  final AppRouter appRouter;

  const MyApp({
    super.key,
    required this.storageService,
    required this.authRepository,
    required this.ticketRepository,
    required this.appRouter,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              AuthBloc(authRepository: authRepository)
                ..add(const AuthCheckStatus()),
        ),
        BlocProvider(
          create: (context) => TicketsBloc(ticketRepository: ticketRepository),
        ),
        BlocProvider(
          create: (context) =>
              ThemeBloc(storageService: storageService)
                ..add(const ThemeLoadRequested()),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp.router(
            title: 'Ticket Resolution',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme(),
            darkTheme: AppTheme.darkTheme(),
            themeMode: themeState.themeMode,
            routerConfig: appRouter.router,
          );
        },
      ),
    );
  }
}
