class LocationData {
  // UPSI KSAS 
  static const List<String> ksasArea = [
    'Kolej Za\'ba',
    'Kolej Aminuddin Baki',
    'Kolej Harun Aminurrashid',
    'Kolej Ungku Omar',
    'Kolej Awang Had Salleh',
    'Scholar Suites UPSI',
    'Dewan Tuanku Canselor UPSI',
    'Panggung Percubaan',
    'Kompleks Akademik',
    'Stadium Sukan UPSI',
    'Pusat Kesihatan UPSI',
    'Dewan Kuliah Pusat',
    'Fakulti Sains & Matematik',
    'Fakulti Pembangunan Manusia',
    'Fakulti Pengurusan dan Ekonomi',
    'Fakulti Sains Sukan & Kejurulatihan',
    'Proton City',
  ];

  // UPSI KSAJS 
  static const List<String> ksajsArea = [
    'Pintu Timur',
    'Fakulti Bahasa & Komunikasi',
    'Fakulti Komputeran & Meta-Teknologi',
    'Perpustakaan Tuanku Bainun',
    'Dewan Kuliah',
    'Bangunan E-Learning',
    'Bangunan IKL',
    'Fakulti Muzik & Seni Persembahan',
    'Fakulti Teknikal & Vokasional',
    'Fakulti Sains Kemanusiaan',
    'Dewan SITC',
    'Dewan Sri Tanjung',
    'Auditorium',
    'Gymnasium',
  ];

  // LUAR KAMPUS
  static const List<String> offCampusArea = [
    'Pekan Tanjung Malim',
    'Stesen Bas Tanjung Malim',
    'Stesen KTM Tanjung Malim',
    'Klinik Tanjung Malim',
    'Taman Bahtera',
    'Taman Bernam',
    'Taman Malim',
    'Bangunan Akasia',
    'Taman Universiti',
  ];

  static List<String> get allLocations => [
        ...ksasArea,
        ...ksajsArea,
        ...offCampusArea,
      ];

  // helper functions

  static bool isKSAS(String location) {
    return ksasArea.contains(location);
  }

  static bool isKSAJS(String location) {
    return ksajsArea.contains(location);
  }

  static bool isOffCampus(String location) {
    return offCampusArea.contains(location);
  }

  /// KSAS → KSAS
  static bool isKSASToKSAS(String pickup, String destination) {
    return isKSAS(pickup) && isKSAS(destination);
  }

  /// KSAS ↔ KSAJS
  static bool isCrossCampus(String pickup, String destination) {
    return (isKSAS(pickup) && isKSAJS(destination)) ||
        (isKSAJS(pickup) && isKSAS(destination));
  }

  /// Any → Off Campus
  static bool isOffCampusTrip(String pickup, String destination) {
    return isOffCampus(pickup) || isOffCampus(destination);
  }
}
