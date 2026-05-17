import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/constants/hive_box_names.dart';
import 'core/theme/app_theme.dart';
import 'data/models/driver_model.dart';
import 'data/models/labour_model.dart';
import 'data/models/place_model.dart';
import 'data/models/settings_model.dart';
import 'data/models/tractor_model.dart';
import 'data/models/work_model.dart';

import 'data/datasources/driver_local_datasource.dart';
import 'data/datasources/labour_local_datasource.dart';
import 'data/datasources/place_local_datasource.dart';
import 'data/datasources/tractor_local_datasource.dart';
import 'data/datasources/work_local_datasource.dart';

import 'data/repositories/driver_repository_impl.dart';
import 'data/repositories/labour_repository_impl.dart';
import 'data/repositories/place_repository_impl.dart';
import 'data/repositories/tractor_repository_impl.dart';
import 'data/repositories/work_repository_impl.dart';

import 'domain/repositories/driver_repository.dart';
import 'domain/repositories/labour_repository.dart';
import 'domain/repositories/place_repository.dart';
import 'domain/repositories/tractor_repository.dart';
import 'domain/repositories/work_repository.dart';
import 'domain/repositories/settings_repository.dart';

import 'data/repositories/settings_repository_impl.dart';

import 'domain/usecases/driver_usecases.dart';
import 'domain/usecases/settings_usecases.dart';
import 'domain/usecases/labour_usecases.dart';
import 'domain/usecases/place_usecases.dart';
import 'domain/usecases/report_usecases.dart';
import 'domain/usecases/tractor_usecases.dart';
import 'domain/usecases/work_usecases.dart';

import 'presentation/blocs/driver/driver_bloc.dart';
import 'presentation/blocs/labour/labour_bloc.dart';
import 'presentation/blocs/place/place_bloc.dart';
import 'presentation/blocs/reports/reports_bloc.dart';
import 'presentation/blocs/settings/settings_bloc.dart';
import 'presentation/blocs/tractor/tractor_bloc.dart';
import 'presentation/blocs/work/work_bloc.dart';

import 'presentation/screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  await Hive.initFlutter();

  // Register Adapters
  Hive.registerAdapter(WorkModelAdapter());
  Hive.registerAdapter(LabourModelAdapter());
  Hive.registerAdapter(DriverModelAdapter());
  Hive.registerAdapter(TractorModelAdapter());
  Hive.registerAdapter(PlaceModelAdapter());
  Hive.registerAdapter(SettingsModelAdapter());

  // Open Boxes
  await Hive.openBox<WorkModel>(HiveBoxNames.works);
  await Hive.openBox<LabourModel>(HiveBoxNames.labours);
  await Hive.openBox<DriverModel>(HiveBoxNames.drivers);
  await Hive.openBox<TractorModel>(HiveBoxNames.tractors);
  await Hive.openBox<PlaceModel>(HiveBoxNames.places);
  await Hive.openBox<SettingsModel>(HiveBoxNames.settings);

  runApp(const LabourPartyApp());
}

class LabourPartyApp extends StatelessWidget {
  const LabourPartyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<WorkRepository>(
          create: (context) => WorkRepositoryImpl(WorkLocalDatasource()),
        ),
        RepositoryProvider<LabourRepository>(
          create: (context) => LabourRepositoryImpl(LabourLocalDatasource()),
        ),
        RepositoryProvider<DriverRepository>(
          create: (context) => DriverRepositoryImpl(DriverLocalDatasource()),
        ),
        RepositoryProvider<TractorRepository>(
          create: (context) => TractorRepositoryImpl(TractorLocalDatasource()),
        ),
        RepositoryProvider<PlaceRepository>(
          create: (context) => PlaceRepositoryImpl(PlaceLocalDatasource()),
        ),
        RepositoryProvider<SettingsRepository>(
          create: (context) => SettingsRepositoryImpl(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SettingsBloc>(
            create: (context) => SettingsBloc(
              getSettings: GetSettingsUseCase(context.read<SettingsRepository>()),
              saveSettings: SaveSettingsUseCase(context.read<SettingsRepository>()),
              clearAllData: ClearAllDataUseCase(context.read<SettingsRepository>()),
            )..add(LoadSettingsEvent()),
          ),
          BlocProvider<WorkBloc>(
            create: (context) => WorkBloc(
              getAllWorks: GetAllWorksUseCase(context.read<WorkRepository>()),
              addWork: AddWorkUseCase(context.read<WorkRepository>()),
              updateWork: UpdateWorkUseCase(context.read<WorkRepository>()),
              deleteWork: DeleteWorkUseCase(context.read<WorkRepository>()),
              getAllLabours: GetAllLaboursUseCase(context.read<LabourRepository>()),
            ),
          ),
          BlocProvider<LabourBloc>(
            create: (context) => LabourBloc(
              getLaboursWithStats: GetLaboursWithStatsUseCase(
                context.read<LabourRepository>(),
                context.read<WorkRepository>(),
              ),
              addLabour: AddLabourUseCase(context.read<LabourRepository>()),
              updateLabour: UpdateLabourUseCase(context.read<LabourRepository>()),
              deleteLabour: DeleteLabourUseCase(context.read<LabourRepository>()),
            ),
          ),
          BlocProvider<DriverBloc>(
            create: (context) => DriverBloc(
              getDriversWithStats: GetDriversWithStatsUseCase(
                context.read<DriverRepository>(),
                context.read<WorkRepository>(),
              ),
              addDriver: AddDriverUseCase(context.read<DriverRepository>()),
              updateDriver: UpdateDriverUseCase(context.read<DriverRepository>()),
              deleteDriver: DeleteDriverUseCase(context.read<DriverRepository>()),
            ),
          ),
          BlocProvider<TractorBloc>(
            create: (context) => TractorBloc(
              getTractorsWithStats: GetTractorsWithStatsUseCase(
                context.read<TractorRepository>(),
                context.read<WorkRepository>(),
              ),
              addTractor: AddTractorUseCase(context.read<TractorRepository>()),
              updateTractor: UpdateTractorUseCase(context.read<TractorRepository>()),
              deleteTractor: DeleteTractorUseCase(context.read<TractorRepository>()),
            ),
          ),
          BlocProvider<PlaceBloc>(
            create: (context) => PlaceBloc(
              getPlacesWithStats: GetPlacesWithStatsUseCase(
                context.read<PlaceRepository>(),
                context.read<WorkRepository>(),
              ),
              addPlace: AddPlaceUseCase(context.read<PlaceRepository>()),
              updatePlace: UpdatePlaceUseCase(context.read<PlaceRepository>()),
              deletePlace: DeletePlaceUseCase(context.read<PlaceRepository>()),
              getAllWorks: GetAllWorksUseCase(context.read<WorkRepository>()),
            ),
          ),
          BlocProvider<ReportsBloc>(
            create: (context) => ReportsBloc(
              getReportData: GetReportDataUseCase(context.read<WorkRepository>()),
              workRepository: context.read<WorkRepository>(),
            ),
          ),
        ],
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            bool isDarkMode = true;
            if (state is SettingsLoadedState) {
              isDarkMode = state.isDarkMode;
            }

            return MaterialApp(
              title: 'Labour Party',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
              home: const SplashScreen(),
            );
          },
        ),
      ),
    );
  }
}
