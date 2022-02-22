class NetworkConf {
  bool _active;
  bool _logged;
  String _name;
  String _id;

  NetworkConf(this._name, this._id, this._active, this._logged);

  void changeActive() {
    if (this._logged)
      this._active = !this._active;
  }

  void changeLogged() {
    if (!this._logged)
      this._logged = !this._logged;
  }

  void setLogged(bool logged) {
    this._logged = logged;
  }

  bool getActive() {
    return this._active;
  }

  bool getLogged() {
    return this._logged;
  }

  String getName() {
    return this._name;
  }

  String getId() {
    return this._id;
  }
}