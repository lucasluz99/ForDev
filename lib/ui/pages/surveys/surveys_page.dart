import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../components/components.dart';
import './components/components.dart';
import './surveys_presenter.dart';
import './survey_viewmodel.dart';

class SurveysPage extends StatelessWidget {
  final SurveysPresenter presenter;

  SurveysPage(this.presenter);
  @override
  Widget build(BuildContext context) {
    presenter.loadData();
    return Scaffold(
      appBar: AppBar(
        title: Text('Enquetes'),
      ),
      body: Builder(builder: (context) {
        presenter.isLoadingStream.listen((isLoading) {
          if (isLoading == true) {
            showLoading(context);
          } else {
            hideLoading(context);
          }
        });

        return StreamBuilder<List<SurveyViewModel>>(
            stream: presenter.surveysStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        snapshot.error,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 17),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        child: RaisedButton(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Recarregar'),
                              SizedBox(width: 5,),
                              Icon(Icons.replay,size: 20,)
                            ],
                          ),
                          onPressed: presenter.loadData,
                        ),
                      )
                    ],
                  ),
                );
              }
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: CarouselSlider(
                    options: CarouselOptions(
                        enlargeCenterPage: true, aspectRatio: 1),
                    items: snapshot.data
                        .map((surveyViewModel) => SurveyItem(surveyViewModel))
                        .toList(),
                  ),
                );
              }
              return Container();
            });
      }),
    );
  }
}
