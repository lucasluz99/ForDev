import 'package:flutter/material.dart';

import '../survey_viewmodel.dart';

class SurveyItem extends StatelessWidget {
  final SurveyViewModel viewModel;

  SurveyItem(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: viewModel.didAnswer
              ? Theme.of(context).secondaryHeaderColor
              : Theme.of(context).primaryColorDark,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            viewModel.date,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(
            height: 8,
          ),
          Text(viewModel.question,
              style: TextStyle(color: Colors.white, fontSize: 22)),
        ],
      ),
    );
  }
}
