/// Sample Indian hierarchical location dataset.
/// State -> District -> Taluka -> City / Village
class LocationsData {
  LocationsData._();

  static const Map<String, Map<String, Map<String, List<String>>>> hierarchy = {
    'Gujarat': {
      'Ahmedabad': {
        'Daskroi': ['Bopal', 'Ghuma', 'Aslali', 'Bareja', 'Kanbha'],
        'Sanand': ['Sanand Town', 'Changodar', 'Moraiya', 'Nidharad', 'Vasna'],
        'Dholka': ['Dholka Rural', 'Koth', 'Rupgadh', 'Bavla Border', 'Saroda'],
        'Viramgam': ['Viramgam City', 'Hansalpur', 'Sachana', 'Jakhwada'],
      },
      'Surat': {
        'Chorasi': ['Dumas', 'Hajira', 'Bhimrad', 'Magdalla'],
        'Kamrej': ['Kamrej Village', 'Kholwad', 'Pasodara', 'Navagam'],
        'Bardoli': ['Bardoli Town', 'Babla', 'Afwa', 'Madhi'],
        'Olpad': ['Olpad Town', 'Sayan', 'Karanj', 'Kim'],
      },
      'Vadodara': {
        'Vadodara Rural': ['Vemali', 'Koyali', 'Padra Road', 'Sevasi'],
        'Waghodia': ['Waghodia Town', 'Piparia', 'Jarod', 'Limda'],
        'Padra': ['Padra City', 'Dabhasa', 'Mobha', 'Samiyala'],
        'Karjan': ['Karjan Town', 'Miyagam', 'Kandari', 'Dhamnod'],
      },
      'Rajkot': {
        'Rajkot Taluka': ['Kotharia', 'Metoda', 'Kuvadva', 'Kasturbadham'],
        'Gondal': ['Gondal City', 'Bhojpara', 'Gomta', 'Bandhiya'],
        'Jetpur': ['Jetpur Town', 'Navagadh', 'Pithadiya', 'Dhoraji Gate'],
        'Lodhika': ['Lodhika Village', 'Metoda GIDC', 'Vajdi', 'Und'],
      },
      'Gandhinagar': {
        'Gandhinagar Taluka': ['Pethapur', 'Koba', 'Chiloda', 'Vavol'],
        'Kalol': ['Kalol Town', 'Chhatral', 'Pansar', 'Vansjada'],
        'Dehgam': ['Dehgam Town', 'Bahiyal', 'Jindva', 'Sampa'],
        'Mansa': ['Mansa Town', 'Lodra', 'Itadara', 'Samou'],
      },
    },
    'Maharashtra': {
      'Pune': {
        'Haveli': [
          'Wagholi',
          'Uruli Kanchan',
          'Hadapsar Rural',
          'Loni Kalbhor',
        ],
        'Baramati': ['Baramati Town', 'Malegaon', 'Songaon', 'Katewadi'],
        'Shirur': ['Shirur Town', 'Sanaswadi', 'Ranjangaon', 'Shikrapur'],
        'Khed': ['Chakan', 'Rajgurunagar', 'Alandi Rural', 'Mahalunge'],
      },
      'Nashik': {
        'Nashik Taluka': ['Deolali Rural', 'Eklahare', 'Pathardi', 'Gangapur'],
        'Niphad': ['Niphad Town', 'Pimpalgaon Baswant', 'Lasalgaon', 'Ozar'],
        'Sinnar': ['Sinnar City', 'Musalgaon', 'Wavi', 'Gonde'],
        'Dindori': ['Dindori Town', 'Vani', 'Janori', 'Khedgaon'],
      },
      'Nagpur': {
        'Nagpur Rural': ['Wadi', 'Besa', 'Pipla', 'Kamptee Rural'],
        'Hingna': ['Hingna Town', 'Butibori', 'Mohgaon', 'Takalghat'],
        'Katol': ['Katol Town', 'Kondhali', 'Paradsinga', 'Metpanjra'],
        'Umred': ['Umred Town', 'Sirsi', 'Bhiwapur Border', 'Heeti'],
      },
      'Satara': {
        'Satara Taluka': ['Koregaon Border', 'Shendre', 'Varye', 'Mahuli'],
        'Karad': ['Karad City', 'Ond', 'Shenoli', 'Umbraj'],
        'Wai': ['Wai Town', 'Panchgani Rural', 'Bhuinj', 'Kenjal'],
        'Phaltan': ['Phaltan Town', 'Taradgaon', 'Barad', 'Nimbhore'],
      },
    },
    'Karnataka': {
      'Bengaluru Urban': {
        'Bengaluru North': [
          'Yelahanka Rural',
          'Hesaraghatta',
          'Dasanapura',
          'Jala',
        ],
        'Bengaluru South': [
          'Begur',
          'Kengeri Rural',
          'Uttarahalli',
          'Tavarekere',
        ],
        'Bengaluru East': [
          'Varthur',
          'Bidarahalli',
          'Kadugodi Rural',
          'Avalahalli',
        ],
        'Anekal': ['Anekal Town', 'Attibele', 'Sarjapura', 'Chandapura'],
      },
      'Mysuru': {
        'Mysuru Taluka': ['Varuna', 'Ilavala', 'Jayapura', 'Kadakola'],
        'Nanjangud': ['Nanjangud Town', 'Hullahalli', 'Debur', 'Kowlande'],
        'Hunsur': ['Hunsur Town', 'Bilikere', 'Gavadagere', 'Hanagod'],
        'T Narasipura': ['T Narasipura Town', 'Bannur', 'Muguru', 'Sosale'],
      },
      'Belagavi': {
        'Belagavi Taluka': ['Peeranwadi', 'Kakati', 'Desur', 'Halaga'],
        'Gokak': ['Gokak City', 'Konnur', 'Ghataprabha', 'Koujalgi'],
        'Chikkodi': ['Chikkodi Town', 'Nipani Rural', 'Examba', 'Sadashivgad'],
        'Bailhongal': ['Bailhongal Town', 'Nesargi', 'Sampgaon', 'Murgod'],
      },
    },
    'Rajasthan': {
      'Jaipur': {
        'Jaipur Taluka': ['Sanganer Rural', 'Amer Rural', 'Jagatpura', 'Bassi'],
        'Chomu': ['Chomu City', 'Morija', 'Kherwadi', 'Govindgarh'],
        'Kotputli': ['Kotputli Town', 'Paniyala', 'Kalyanpura', 'Gordhanpura'],
        'Chaksu': ['Chaksu Town', 'Kothun', 'Sheodaspura', 'Titariya'],
      },
      'Jodhpur': {
        'Jodhpur Taluka': ['Mandore Rural', 'Salawas', 'Pal Rural', 'Kudi'],
        'Luni': ['Luni Town', 'Rohat Border', 'Doli', 'Shikarpura'],
        'Osian': ['Osian Town', 'Tiwari', 'Balesar', 'Khetasar'],
        'Bilara': ['Bilara Town', 'Pipar City', 'Bhavi', 'Ransigaon'],
      },
      'Udaipur': {
        'Girwa': ['Bedla', 'Bhuwana', 'Sukher', 'Titardi'],
        'Mavli': ['Mavli Town', 'Fatehnagar', 'Sanwar', 'Ghasa'],
        'Vallabhnagar': ['Vallabhnagar Town', 'Bhindar', 'Menar', 'Kanor'],
        'Salumber': ['Salumber Town', 'Gingla', 'Idana', 'Jhallara'],
      },
    },
    'Madhya Pradesh': {
      'Indore': {
        'Indore Taluka': ['Rau', 'Palda', 'Manglia', 'Bangarda'],
        'Sanwer': ['Sanwer Town', 'Dharampuri', 'Kshipra', 'Ajnod'],
        'Depalpur': ['Depalpur Town', 'Betma', 'Gautampura', 'Bhatkhedi'],
        'Mhow': ['Mhow Cantonment Rural', 'Manpur', 'Hasalpur', 'Choral'],
      },
      'Bhopal': {
        'Huzur': ['Bairagarh Rural', 'Ratibad', 'Misrod', 'Bhadbhada'],
        'Berasia': [
          'Berasia Town',
          'Runaha',
          'Narsinghgarh Border',
          'Lalariya',
        ],
      },
      'Ujjain': {
        'Ujjain Taluka': ['Tajpur', 'Lekoda', 'Panthpiplai', 'Ghattia'],
        'Nagda': ['Nagda City', 'Mandi Rural', 'Rupeta', 'Birlagram'],
        'Badnagar': ['Badnagar Town', 'Runija', 'Ingoria', 'Moulana'],
      },
    },
  };

  static List<String> get states => hierarchy.keys.toList()..sort();

  static List<String> getDistricts(String? state) {
    if (state == null || !hierarchy.containsKey(state)) return const [];
    return hierarchy[state]!.keys.toList()..sort();
  }

  static List<String> getTalukas(String? state, String? district) {
    if (state == null || district == null) return const [];
    final stateMap = hierarchy[state];
    if (stateMap == null || !stateMap.containsKey(district)) return const [];
    return stateMap[district]!.keys.toList()..sort();
  }

  static List<String> getCities(
    String? state,
    String? district,
    String? taluka,
  ) {
    if (state == null || district == null || taluka == null) return const [];
    final stateMap = hierarchy[state];
    if (stateMap == null || !stateMap.containsKey(district)) return const [];
    final distMap = stateMap[district];
    if (distMap == null || !distMap.containsKey(taluka)) return const [];
    return List<String>.from(distMap[taluka]!)..sort();
  }
}
