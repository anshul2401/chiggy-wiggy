import 'package:flutter/cupertino.dart';

class SortModel {
  int sortColumnIndex;
  String sortColumnName;
  bool sortAscending;
  SortModel({
    this.sortColumnIndex,
    this.sortColumnName,
    this.sortAscending,
  });
}

class SearchBarProvider with ChangeNotifier {
  SortModel _sortModel;
  SortModel get sortModel => _sortModel;
  SearchBarProvider() {
    _sortModel = new SortModel();
    _sortModel.sortColumnIndex = 0;
    _sortModel.sortAscending = true;
  }
  setSort(int columnIndex, String sortColumnName, bool ascending) {
    _sortModel.sortAscending = ascending;
    _sortModel.sortColumnIndex = columnIndex;
    _sortModel.sortColumnName = sortColumnName;
  }
}
