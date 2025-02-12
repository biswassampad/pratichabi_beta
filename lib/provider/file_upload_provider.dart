import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:senger/enum/view_state.dart';


class FileUploadProvider with ChangeNotifier{

  ViewState _viewState = ViewState.IDLE;
  ViewState get getViewState => _viewState;

  void setToLoading(){
    print('activating loading state');
    _viewState = ViewState.LOADING;
    notifyListeners();
  }

  void setToIdle(){
    print('deactivating loading state');
    _viewState = ViewState.IDLE;
  }
}