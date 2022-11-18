class UpdateUI {
  var time;

  String asset_id_base;
  String asset_id_quote;
  var btcValue;
  var ethValue;
  var ltcValue;

  void updateUi(var btcData, var ethData, var ltcData) {
    if (btcData == null || ethData == null || ltcData == null) {
      time = '';
      asset_id_base = 'Error';
      asset_id_quote = 'Error';
      btcValue = 0;
      ethValue = 0;
      ltcValue = 0;

      return;
    }
    time = btcData['time'];
    asset_id_base = btcData['asset_id_base'];
    asset_id_quote = btcData['asset_id_quote'];

    btcValue = btcData['rate'];

    ethValue = ethData['rate'];

    ltcValue = ltcData['rate'];
  }
}
