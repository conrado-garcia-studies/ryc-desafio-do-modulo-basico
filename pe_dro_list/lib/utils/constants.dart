import 'package:humanize_duration/humanize_duration.dart';
import 'package:shop/models/facts.dart';
import 'package:shop/models/level.dart';
import 'package:shop/models/life_package.dart';
import 'package:shop/models/shop_item.dart';

class Constants {
  static const bool autoStartAudio = true;
  static const List<String> completionMessages = <String>[
    'Congrats on completing the task! 🙌',
    'You completed a task! Keep it up! 💪',
    'Great job completing the task! 🎉'
  ];
  static const String datePattern = 'MM/dd/yyyy';
  static const bool devMode = true;
  static const Duration durationFromNowToDueLastDate =
      Duration(days: 375 + 44725);
  static const List<String> errorImageAssetNames = <String>[
    'assets/images/errors/1.png',
    'assets/images/errors/2.png',
    'assets/images/errors/3.png',
    'assets/images/errors/4.png',
    'assets/images/errors/5.png',
  ];
  static const Facts facts = Facts(
    imageAssetNames: <String>[
      'assets/images/facts/1.png',
      'assets/images/facts/2.png',
      'assets/images/facts/3.png',
      'assets/images/facts/4.png',
      'assets/images/facts/5.png',
      'assets/images/facts/6.png',
      'assets/images/facts/7.png',
      'assets/images/facts/8.png',
      'assets/images/facts/9.png',
      'assets/images/facts/10.png',
      'assets/images/facts/11.png',
      'assets/images/facts/12.png',
      'assets/images/facts/13.png',
      'assets/images/facts/14.png',
      'assets/images/facts/15.png',
      'assets/images/facts/16.png',
    ],
    messages: <String>[
      'The first post of the meme by @fleksa30 actually didn\'t have the' +
          ' iconic "Pedro" song. It was “Kak Dela” by MZLFF & Lida instead!',
      'There are more than one place with the name Santa Fe, but the song' +
          ' refers to the province in Argentina.',
      'Raffaella Carrà, in addition to being a successful singer, also had a' +
          ' successful career on television. She was often referred to as' +
          ' "the lady of Italian television".',
    ],
  );
  static const String firebaseHost = 'pe-dro-list-default-rtdb.firebaseio.com';
  static const HumanizeOptions humanReadableDurationOptions = HumanizeOptions(
    units: <Units>[
      Units.day,
      Units.hour,
      Units.minute,
    ],
  );
  static const String identityTookKitHost = 'identitytoolkit.googleapis.com';
  static const int initialCoinsCount = 0;
  static const int initialLivesCount = 5;
  static const List<Level> levels = <Level>[
    Level(
      minLivesCount: 2,
      maxLivesCount: 5,
      title: 'Doing great! 🙌',
      imageAssetNames: <String>[
        'assets/images/levels/doing_great/1.png',
        'assets/images/levels/doing_great/2.png',
        'assets/images/levels/doing_great/3.png',
        'assets/images/levels/doing_great/4.png',
        'assets/images/levels/doing_great/5.png',
      ],
      message: '🎉 🙌 🎊',
    ),
    Level(
      minLivesCount: 6,
      maxLivesCount: 249,
      title: 'Ambitious 🤸‍♂️',
      imageAssetNames: <String>[
        'assets/images/levels/ambitious/1.png',
        'assets/images/levels/ambitious/2.png',
        'assets/images/levels/ambitious/3.png',
        'assets/images/levels/ambitious/4.png',
        'assets/images/levels/ambitious/5.png',
        'assets/images/levels/ambitious/6.png',
        'assets/images/levels/ambitious/7.png',
        'assets/images/levels/ambitious/8.png',
        'assets/images/levels/ambitious/9.png',
        'assets/images/levels/ambitious/10.png',
        'assets/images/levels/ambitious/11.png',
        'assets/images/levels/ambitious/12.png',
      ],
      message: 'You are curious to see what\'s there after five fuel points!',
    ),
    Level(
      minLivesCount: 1,
      maxLivesCount: 1,
      title: 'Keep it up! 👍',
      imageAssetNames: <String>[
        'assets/images/levels/keep_it_up/1.png',
        'assets/images/levels/keep_it_up/2.png',
        'assets/images/levels/keep_it_up/3.png',
      ],
      message: 'Keep in mind that if the fuel points reach zero, Pedro will' +
          ' no longer appear! 😱',
    ),
    Level(
      minLivesCount: 0,
      maxLivesCount: 0,
      title: 'Pretty much there! 🏁',
      imageAssetNames: <String>[
        'assets/images/levels/pretty_much_there/1.png',
        'assets/images/levels/pretty_much_there/2.png',
        'assets/images/levels/pretty_much_there/3.png',
      ],
      message: 'Reach one fuel point to call Pedro back! 🦝',
    ),
    Level(
      minLivesCount: -5,
      maxLivesCount: -1,
      title: 'Almost there! 🚶🏻',
      imageAssetNames: <String>[
        'assets/images/levels/almost_there/1.png',
        'assets/images/levels/almost_there/2.png',
        'assets/images/levels/almost_there/3.png',
      ],
      message: 'Yes, there are negative fuel points, but don\'t worry! Reach' +
          ' one fuel point to call Pedro back! 🦝',
    ),
    Level(
      minLivesCount: -19,
      maxLivesCount: -6,
      title: 'On it! 🏃',
      imageAssetNames: <String>[
        'assets/images/levels/on_it/1.png',
        'assets/images/levels/on_it/2.png',
        'assets/images/levels/on_it/3.png',
      ],
      message: 'Reach one fuel point to call Pedro back! 🦝',
    ),
    Level(
      minLivesCount: 250,
      maxLivesCount: 499,
      title: 'Determined 💪',
      imageAssetNames: <String>[
        'assets/images/levels/determined/1.png',
        'assets/images/levels/determined/2.png',
        'assets/images/levels/determined/3.png',
        'assets/images/levels/determined/4.png',
        'assets/images/levels/determined/5.png',
        'assets/images/levels/determined/6.png',
      ],
      message: '',
    ),
    Level(
      minLivesCount: 500,
      maxLivesCount: 749,
      title: 'Pretty much THE BEST in SANTA FE! 🦝',
      imageAssetNames: <String>[
        'assets/images/levels/pretty_much_the_best_in_santa_fe/1.png',
        'assets/images/levels/pretty_much_the_best_in_santa_fe/2.png',
        'assets/images/levels/pretty_much_the_best_in_santa_fe/3.png',
        'assets/images/levels/pretty_much_the_best_in_santa_fe/4.png',
        'assets/images/levels/pretty_much_the_best_in_santa_fe/5.png',
        'assets/images/levels/pretty_much_the_best_in_santa_fe/6.png',
        'assets/images/levels/pretty_much_the_best_in_santa_fe/7.png',
        'assets/images/levels/pretty_much_the_best_in_santa_fe/8.png',
      ],
      message: '🎶 Pedro, Pedro, Pedro, Pedro, Pè' +
          '\nPraticamente il meglio di Santa Fè' +
          '\nPedro, Pedro, Pedro, Pedro, Pè' +
          '\nFidati di me 🎶',
    ),
    Level(
      minLivesCount: 750,
      maxLivesCount: 999,
      title: 'THE BEST in SANTA FE! 🦝',
      imageAssetNames: <String>[
        'assets/images/levels/the_best_in_santa_fe/1.png',
        'assets/images/levels/the_best_in_santa_fe/2.png',
        'assets/images/levels/the_best_in_santa_fe/3.png',
        'assets/images/levels/the_best_in_santa_fe/4.png',
        'assets/images/levels/the_best_in_santa_fe/5.png',
        'assets/images/levels/the_best_in_santa_fe/6.png',
        'assets/images/levels/the_best_in_santa_fe/7.png',
        'assets/images/levels/the_best_in_santa_fe/8.png',
        'assets/images/levels/the_best_in_santa_fe/9.png',
        'assets/images/levels/the_best_in_santa_fe/10.png',
        'assets/images/levels/the_best_in_santa_fe/11.png',
        'assets/images/levels/the_best_in_santa_fe/12.png',
        'assets/images/levels/the_best_in_santa_fe/13.png',
        'assets/images/levels/the_best_in_santa_fe/14.png',
        'assets/images/levels/the_best_in_santa_fe/15.png',
        'assets/images/levels/the_best_in_santa_fe/16.png',
        'assets/images/levels/the_best_in_santa_fe/17.png',
        'assets/images/levels/the_best_in_santa_fe/18.png',
        'assets/images/levels/the_best_in_santa_fe/19.png',
      ],
      message: 'No words needed! 🛵',
    ),
    Level(
      minLivesCount: 1000,
      maxLivesCount: 1499,
      title: 'Secret agent 🥃',
      imageAssetNames: <String>[
        'assets/images/levels/secret_agent/1.png',
        'assets/images/levels/secret_agent/2.png',
        'assets/images/levels/secret_agent/3.png',
        'assets/images/levels/secret_agent/4.png',
        'assets/images/levels/secret_agent/5.png',
        'assets/images/levels/secret_agent/6.png',
        'assets/images/levels/secret_agent/7.png',
        'assets/images/levels/secret_agent/8.png',
      ],
      message: '*Takes a sip of whiskey.*',
    ),
    Level(
      minLivesCount: 1500,
      maxLivesCount: 7999,
      title: 'Ninja 🥷',
      imageAssetNames: <String>[
        'assets/images/levels/ninja/1.png',
        'assets/images/levels/ninja/2.png',
        'assets/images/levels/ninja/3.png',
        'assets/images/levels/ninja/4.png',
        'assets/images/levels/ninja/5.png',
        'assets/images/levels/ninja/6.png',
        'assets/images/levels/ninja/7.png',
      ],
      message: 'Failing doesn\'t give you a reason to give up, as long as' +
          ' you believe.',
    ),
    Level(
      minLivesCount: 9000,
      maxLivesCount: maxInteger - 1,
      title: 'Super Saiyajin 🐉',
      imageAssetNames: <String>[
        'assets/images/levels/super_saiyajin/1.png',
        'assets/images/levels/super_saiyajin/2.png',
        'assets/images/levels/super_saiyajin/3.png',
        'assets/images/levels/super_saiyajin/4.png',
        'assets/images/levels/super_saiyajin/5.png',
        'assets/images/levels/super_saiyajin/6.png',
      ],
      message: 'It\'s over 9000!!!',
    ),
    Level(
      minLivesCount: -99,
      maxLivesCount: -20,
      title: 'Tenacious ✊',
      imageAssetNames: <String>[
        'assets/images/levels/tenacious/1.png',
        'assets/images/levels/tenacious/2.png',
        'assets/images/levels/tenacious/3.png',
      ],
      message: 'Giving up doesn\'t cross your mind!',
    ),
    Level(
      minLivesCount: -999,
      maxLivesCount: -100,
      title: 'Perseverant 🧗🏻‍♂️',
      imageAssetNames: <String>[
        'assets/images/levels/perseverant/1.png',
        'assets/images/levels/perseverant/2.png',
        'assets/images/levels/perseverant/3.png',
        'assets/images/levels/perseverant/4.png',
        'assets/images/levels/perseverant/5.png',
        'assets/images/levels/perseverant/6.png',
        'assets/images/levels/perseverant/7.png',
      ],
      message: 'It may be a long way, but you won\'t give up! 💪',
    ),
    Level(
      minLivesCount: 1 + minInteger,
      maxLivesCount: -1000,
      title: 'JEDI that turned to the DARK SIDE 👤',
      imageAssetNames: <String>[
        'assets/images/levels/jedi_that_turned_to_the_dark_side/1.png',
        'assets/images/levels/jedi_that_turned_to_the_dark_side/2.png',
        'assets/images/levels/jedi_that_turned_to_the_dark_side/3.png',
        'assets/images/levels/jedi_that_turned_to_the_dark_side/4.png',
        'assets/images/levels/jedi_that_turned_to_the_dark_side/5.png',
        'assets/images/levels/jedi_that_turned_to_the_dark_side/6.png',
      ],
      message: 'Be careful not to choke on your aspirations.',
    ),
    Level(
      minLivesCount: maxInteger,
      maxLivesCount: maxInteger,
      title: 'HACKER 👨‍💻',
      imageAssetNames: <String>[
        'assets/images/levels/hacker/1.png',
        'assets/images/levels/hacker/2.png',
      ],
      message: 'Thanks, you are one fuel point away from cracking this app!',
    ),
    Level(
      minLivesCount: minInteger,
      maxLivesCount: minInteger,
      title: 'HIPSTER HACKER 🧔‍♀️',
      imageAssetNames: <String>[
        'assets/images/levels/hipster_hacker/1.png',
        'assets/images/levels/hipster_hacker/2.png',
        'assets/images/levels/hipster_hacker/3.png',
      ],
      message: 'What the...',
    ),
  ];
  static const List<String> livesCountIncreaseMessages = <String>[
    'You got more fuel points! 🛵',
    'Your fuel points have increased! 🔥',
    'Add oil! You got more fuel points! ⛽',
  ];
  static const int lostLivesCountPerOverdueTask = 1;
  static const int maxInteger = 0x7FFFFFFFFFFFFFFF;
  static const int maxLifeIconsCount = 5;
  static const int maxTaskDescriptionLength = 4000;
  static const int maxTaskTitleLength = 35;
  static const int minInteger = -0x8000000000000000;
  static const int minLivesCountForPedroToAppear = 1;
  static const int minPasswordLength = 5;
  static const List<String> newTaskMessages = <String>[
    'Go for it! 🙌',
    'Dedicate yourself to the task and reap the results in the future. 🌱',
    'Remember to be true to yourself regarding the completion of the task. 💪',
    'Don\'t let anything hold you back! 👊',
  ];
  static const int prizePerCompletedTaskInCoins = 5;
  static const List<ShopItem> shopItems = <ShopItem>[
    LifePackage(
      imageAssetName: 'assets/images/shop_items/fuel_bottle.webp',
      title: 'Fuel Bottle',
      description: 'Add one fuel point!',
      priceInCoins: 5,
      livesCount: 1,
    ),
    LifePackage(
      imageAssetName: 'assets/images/shop_items/fuel_tank.webp',
      title: 'Fuel Tank',
      description: 'Add five fuel points!',
      priceInCoins: 23,
      livesCount: 5,
    ),
  ];
  static const Duration toastDuration = Duration(seconds: 5);
  static const webApiKey = 'AIzaSyDd9oZlIWI35UShSsIQkyCwY2cJJJczBQg';
}
