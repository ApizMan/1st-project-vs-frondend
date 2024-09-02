// state_pbt_mapping.dart
import 'package:project/constant.dart';

final Map<String, String> stateFlagMap = {
  'Pahang': pahangImg,
  'Kelantan': kelantanImg,
  'Terengganu': terengganuImg,
};

final List<String> statesList = ['Pahang', 'Kelantan', 'Terengganu'];

final Map<String, List<Map<String, dynamic>>> statePbtMap = {
  'Pahang': [
    {
      'name': 'Majlis Bandaraya Kuantan',
      'logo': kuantanLogo,
      'color': kPrimaryColor.value,
    },
  ],
  'Kelantan': [
    {
      'name': 'Majlis Daerah Machang',
      'logo': machangLogo,
      'color': kYellow.value,
    },
  ],
  'Terengganu': [
    {
      'name': 'Majlis Bandaraya Kuala Terengganu',
      'logo': terengganuLogo,
      'color': kOrange.value,
    },
  ],
};
