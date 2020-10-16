
import 'package:ForDev/main/factories/pages/surveys/surveys_presenter_factory.dart';
import 'package:flutter/material.dart';

import '../../../../ui/pages/pages.dart';


Widget makeSurveysPage() => SurveysPage(makeGetxSurveysPresenter());
