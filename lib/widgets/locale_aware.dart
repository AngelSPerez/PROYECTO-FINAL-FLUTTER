import 'package:flutter/material.dart';
import '../l10n/app_locale.dart';

mixin LocaleAwareState<T extends StatefulWidget> on State<T> {
  late final VoidCallback _localeListener;

  @override
  void initState() {
    super.initState();
    _localeListener = () {
      if (mounted) setState(() {});
    };
    AppLocale.language.addListener(_localeListener);
  }

  @override
  void dispose() {
    AppLocale.language.removeListener(_localeListener);
    super.dispose();
  }
}
