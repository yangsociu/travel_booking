import 'dart:io';

void main() async {
  final List<String> files = [
    // BLoC
    'lib/blocs/auth/auth_bloc.dart',
    'lib/blocs/auth/auth_event.dart',
    'lib/blocs/auth/auth_state.dart',
    'lib/blocs/flight/flight_bloc.dart',
    'lib/blocs/flight/flight_event.dart',
    'lib/blocs/flight/flight_state.dart',
    'lib/blocs/booking/booking_bloc.dart',
    'lib/blocs/booking/booking_event.dart',
    'lib/blocs/booking/booking_state.dart',
    'lib/blocs/payment/payment_bloc.dart',
    'lib/blocs/payment/payment_event.dart',
    'lib/blocs/payment/payment_state.dart',
    'lib/blocs/admin/admin_flight_bloc.dart',
    'lib/blocs/admin/admin_flight_event.dart',
    'lib/blocs/admin/admin_flight_state.dart',
    'lib/blocs/admin/admin_booking_bloc.dart',
    'lib/blocs/admin/admin_booking_event.dart',
    'lib/blocs/admin/admin_booking_state.dart',

    // Models
    'lib/models/user_model.dart',
    'lib/models/flight_model.dart',
    'lib/models/booking_model.dart',
    'lib/models/payment_model.dart',
    'lib/models/seat_model.dart',

    // Screens
    'lib/screens/auth/login_screen.dart',
    'lib/screens/auth/register_screen.dart',
    'lib/screens/home/home_screen.dart',
    'lib/screens/flight_selection/date_selection_screen.dart',
    'lib/screens/flight_selection/flight_selection_screen.dart',
    'lib/screens/seat_selection/seat_selection_screen.dart',
    'lib/screens/payment/payment_screen.dart',
    'lib/screens/payment/payment_success_screen.dart',
    'lib/screens/admin/admin_login_screen.dart',
    'lib/screens/admin/admin_flight_management_screen.dart',
    'lib/screens/admin/admin_booking_management_screen.dart',

    // Widgets
    'lib/widgets/auth/login_form.dart',
    'lib/widgets/auth/register_form.dart',
    'lib/widgets/flight/flight_card.dart',
    'lib/widgets/flight/date_picker.dart',
    'lib/widgets/seat/seat_grid.dart',
    'lib/widgets/payment/payment_form.dart',
    'lib/widgets/payment/payment_success_card.dart',
    'lib/widgets/admin/flight_management_form.dart',
    'lib/widgets/admin/booking_management_list.dart',
    'lib/widgets/common/custom_button.dart',
    'lib/widgets/common/custom_text_field.dart',
    'lib/widgets/common/loading_indicator.dart',

    // Services
    'lib/services/auth_service.dart',
    'lib/services/flight_service.dart',
    'lib/services/booking_service.dart',
    'lib/services/payment_service.dart',

    // Utils
    'lib/utils/constants.dart',
    'lib/utils/app_colors.dart',
    'lib/utils/app_styles.dart',
    'lib/utils/formatters.dart',

    // Routes
    'lib/routes/app_router.dart',
    'lib/routes/app_routes.dart',

    // Localization
    'lib/l10n/app_en.arb',
    'lib/l10n/app_vi.arb',

    // Main
    'lib/main.dart',
  ];

  for (final path in files) {
    final file = File(path);
    final dir = file.parent;

    if (!(await dir.exists())) {
      await dir.create(recursive: true);
      print('📁 Created directory: ${dir.path}');
    }

    if (!(await file.exists())) {
      await file.writeAsString('// ${file.uri.pathSegments.last}');
      print('📄 Created file: ${file.path}');
    }
  }

  print('\n✅ Tạo cấu trúc thư mục + file hoàn tất!');
}
