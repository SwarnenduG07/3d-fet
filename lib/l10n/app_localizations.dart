import 'package:flutter/widgets.dart';

class AppLocalizations {
  final Locale locale;

  const AppLocalizations(this.locale);

  static const supportedLocales = [Locale('ja'), Locale('en')];

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  bool get isEnglish => locale.languageCode == 'en';

  static const Map<String, Map<String, String>> _values = {
    'en': {
      'appTitle': 'GrowMe',
      'homeTitle': 'Home',
      'historyTitle': 'History',
      'notificationsTitle': 'Notifications',
      'profileTitle': 'Profile',
      'userLabel': 'User',
      'totalXpLabel': 'Total XP',
      'genderLabel': 'Gender',
      'heightLabel': 'Height',
      'currentWeightLabel': 'Current Weight',
      'targetWeightLabel': 'Target Weight',
      'goalTypeLabel': 'Goal Type',
      'targetPeriodLabel': 'Target Period',
      'daysUnit': 'days',
      'startTraining': 'Start Training',
      'viewMirror': 'View Mirror',
      'settingsTitle': 'Settings',
      'bodyInfoTitle': 'Body Info',
      'pushNotifications': 'Push Notifications',
      'language': 'Language',
      'privacyPolicy': 'Privacy Policy',
      'termsOfUse': 'Terms of Use',
      'appVersion': 'App Version',
      'logout': 'Log out',
      'cancel': 'Cancel',
      'save': 'Save',
      'profileEditTitle': 'Edit Profile',
      'male': 'Male',
      'female': 'Female',
      'selectLanguage': 'Select Language',
      'japanese': 'Japanese',
      'english': 'English',
      'languageChangedToEnglish': 'Language changed to English',
      'languageChangedToJapanese': 'Language changed to Japanese',
      'noNotifications': 'No notifications yet',
      'signInToViewNotifications': 'Sign in to view notifications',
      'workoutComplete': 'Workout complete',
      'levelUp': 'Level up!',
      'xp': 'XP',
      'protein': 'Protein',
      'stage': 'Stage',
      'level': 'Level',
      'totalXp': 'Total XP',
      'mirrorTitle': 'Mirror',
      'bodyChangeTitle': 'Body change!',
      'tapToContinue': 'Tap to continue',
      'trainingCompleteTitle': 'Training complete!',
      'trainingReadyTitle': 'Training ready',
      'trainingInProgressTitle': 'Training in progress...',
      'trainingReadyMessage': 'Tap Start after you begin training. You will earn XP and protein!',
      'trainingInProgressMessage': 'Keep going! Every second counts.',
      'trainingCompleteSummary': 'Workout completed',
      'greatJob': 'Great job!',
      'start': 'Start',
      'finishTraining': 'Finish training',
      'minutesUnit': 'min',
      'workoutHistoryTitle': 'Workout history',
      'thisMonthSummary': 'This month',
      'totalCountLabel': 'Total sessions',
      'totalTimeLabel': 'Total time',
      'monthXpLabel': 'XP this month',
      'exerciseLabel': 'Exercise',
      'timesUnit': 'times',
      'noWorkoutsYet': 'No workouts yet',
      'startToGrowAvatar': 'Start exercising to grow your avatar!',
      'deleteHistoryTitle': 'Delete workout',
      'deleteHistoryMessage': 'Delete this workout?',
      'deleteAllHistoryTitle': 'Delete all history',
      'deleteAllHistoryMessage': 'Delete all workout history? This cannot be undone.',
      'delete': 'Delete',
      'deleteAll': 'Delete all',
      'markAllRead': 'Mark all read',
      'notificationsSubtitle': 'Complete a workout and notifications will appear here',
      'justNow': 'Just now',
      'minutesAgo': 'm ago',
      'hoursAgo': 'h ago',
      'today': 'Today',
      'yesterday': 'Yesterday',
      'stageReachedTitle': 'Body change!',
      'stageReachedMessage': '{stage} reached!',
      'close': 'Close',
      'logoutConfirmTitle': 'Log out',
      'logoutConfirmMessage': 'Are you sure you want to log out?',
      'invalidNumberInput': 'Please enter valid numbers.',
      'profileUpdated': 'Profile updated.',
      'goalTypeMuscleGain': 'Muscle Gain',
      'goalTypeWeightLoss': 'Weight Loss',
      'goalTypeMaintenance': 'Maintenance',
      'targetPeriodDaysLabel': 'Target Period (days)',
    },
    'ja': {
      'appTitle': 'GrowMe',
      'homeTitle': 'ホーム',
      'historyTitle': '履歴',
      'notificationsTitle': '通知',
      'profileTitle': 'プロフィール',
      'userLabel': 'ユーザー',
      'totalXpLabel': '累計XP',
      'genderLabel': '性別',
      'heightLabel': '身長',
      'currentWeightLabel': '現在の体重',
      'targetWeightLabel': '目標体重',
      'goalTypeLabel': '目標タイプ',
      'targetPeriodLabel': '目標期間',
      'daysUnit': '日間',
      'startTraining': 'トレーニング開始',
      'viewMirror': '鏡を見る',
      'settingsTitle': '設定',
      'bodyInfoTitle': '体の情報',
      'pushNotifications': 'プッシュ通知',
      'language': '言語',
      'privacyPolicy': 'プライバシーポリシー',
      'termsOfUse': '利用規約',
      'appVersion': 'アプリバージョン',
      'logout': 'ログアウト',
      'cancel': 'キャンセル',
      'save': '保存',
      'profileEditTitle': 'プロフィール編集',
      'male': '男性',
      'female': '女性',
      'selectLanguage': '言語を選択',
      'japanese': '日本語',
      'english': 'English',
      'languageChangedToEnglish': '言語を英語に変更しました',
      'languageChangedToJapanese': '言語を日本語に変更しました',
      'noNotifications': '通知はまだありません',
      'signInToViewNotifications': 'ログイン後に通知を確認できます',
      'workoutComplete': 'ワークアウト完了',
      'levelUp': 'レベルアップ！',
      'xp': 'XP',
      'protein': 'プロテイン',
      'stage': 'ステージ',
      'level': 'レベル',
      'totalXp': '総XP',
      'mirrorTitle': '鏡',
      'bodyChangeTitle': '体の変化！',
      'tapToContinue': 'タップして続ける',
      'trainingCompleteTitle': 'トレーニング完了！',
      'trainingReadyTitle': 'トレーニング準備完了',
      'trainingInProgressTitle': 'トレーニング中...',
      'trainingReadyMessage': 'トレーニングを開始したらスタートをタップしてください。XPとプロテインを獲得できます！',
      'trainingInProgressMessage': '頑張って！1秒1秒が大切です。',
      'trainingCompleteSummary': 'ワークアウト完了',
      'greatJob': '素晴らしい！',
      'start': 'スタート',
      'finishTraining': 'トレーニング終了',
      'minutesUnit': '分',
      'workoutHistoryTitle': 'ワークアウト履歴',
      'thisMonthSummary': '今月のまとめ',
      'totalCountLabel': '合計回数',
      'totalTimeLabel': '合計時間',
      'monthXpLabel': '今月XP',
      'exerciseLabel': 'エクササイズ',
      'timesUnit': '回',
      'noWorkoutsYet': 'まだワークアウトがありません',
      'startToGrowAvatar': 'エクササイズを始めて、\nアバターを成長させましょう！',
      'deleteHistoryTitle': '履歴を削除',
      'deleteHistoryMessage': 'この履歴を削除しますか？',
      'deleteAllHistoryTitle': '全履歴を削除',
      'deleteAllHistoryMessage': 'すべての履歴を削除しますか？この操作は取り消せません。',
      'delete': '削除',
      'deleteAll': '全削除',
      'markAllRead': 'すべて既読',
      'notificationsSubtitle': 'ワークアウトを完了すると、\nここに通知が届きます',
      'justNow': 'たった今',
      'minutesAgo': '分前',
      'hoursAgo': '時間前',
      'today': '今日',
      'yesterday': '昨日',
      'stageReachedTitle': '体の変化！',
      'stageReachedMessage': '{stage}に到達しました！',
      'close': '閉じる',
      'logoutConfirmTitle': 'ログアウト',
      'logoutConfirmMessage': '本当にログアウトしますか？',
      'invalidNumberInput': '数値を正しく入力してください。',
      'profileUpdated': 'プロフィールを更新しました',
      'goalTypeMuscleGain': '筋肉増強',
      'goalTypeWeightLoss': '減量',
      'goalTypeMaintenance': '維持',
      'targetPeriodDaysLabel': '目標期間 (日)',
    },
  };

  String _t(String key) => _values[locale.languageCode]?[key] ?? _values['ja']![key] ?? key;

  String get appTitle => _t('appTitle');
  String get homeTitle => _t('homeTitle');
  String get historyTitle => _t('historyTitle');
  String get notificationsTitle => _t('notificationsTitle');
  String get profileTitle => _t('profileTitle');
  String get userLabel => _t('userLabel');
  String get totalXpLabel => _t('totalXpLabel');
  String get genderLabel => _t('genderLabel');
  String get heightLabel => _t('heightLabel');
  String get currentWeightLabel => _t('currentWeightLabel');
  String get targetWeightLabel => _t('targetWeightLabel');
  String get goalTypeLabel => _t('goalTypeLabel');
  String get targetPeriodLabel => _t('targetPeriodLabel');
  String get daysUnit => _t('daysUnit');
  String get startTraining => _t('startTraining');
  String get viewMirror => _t('viewMirror');
  String get settingsTitle => _t('settingsTitle');
  String get bodyInfoTitle => _t('bodyInfoTitle');
  String get pushNotifications => _t('pushNotifications');
  String get language => _t('language');
  String get privacyPolicy => _t('privacyPolicy');
  String get termsOfUse => _t('termsOfUse');
  String get appVersion => _t('appVersion');
  String get logout => _t('logout');
  String get cancel => _t('cancel');
  String get save => _t('save');
  String get profileEditTitle => _t('profileEditTitle');
  String get male => _t('male');
  String get female => _t('female');
  String get selectLanguage => _t('selectLanguage');
  String get japanese => _t('japanese');
  String get english => _t('english');
  String get languageChangedToEnglish => _t('languageChangedToEnglish');
  String get languageChangedToJapanese => _t('languageChangedToJapanese');
  String get noNotifications => _t('noNotifications');
  String get signInToViewNotifications => _t('signInToViewNotifications');
  String get workoutComplete => _t('workoutComplete');
  String get levelUp => _t('levelUp');
  String get xp => _t('xp');
  String get protein => _t('protein');
  String get stage => _t('stage');
  String get level => _t('level');
  String get totalXp => _t('totalXp');
  String get mirrorTitle => _t('mirrorTitle');
  String get bodyChangeTitle => _t('bodyChangeTitle');
  String get tapToContinue => _t('tapToContinue');
  String get trainingCompleteTitle => _t('trainingCompleteTitle');
  String get trainingReadyTitle => _t('trainingReadyTitle');
  String get trainingInProgressTitle => _t('trainingInProgressTitle');
  String get trainingReadyMessage => _t('trainingReadyMessage');
  String get trainingInProgressMessage => _t('trainingInProgressMessage');
  String get trainingCompleteSummary => _t('trainingCompleteSummary');
  String get greatJob => _t('greatJob');
  String get start => _t('start');
  String get finishTraining => _t('finishTraining');
  String get minutesUnit => _t('minutesUnit');
  String get workoutHistoryTitle => _t('workoutHistoryTitle');
  String get thisMonthSummary => _t('thisMonthSummary');
  String get totalCountLabel => _t('totalCountLabel');
  String get totalTimeLabel => _t('totalTimeLabel');
  String get monthXpLabel => _t('monthXpLabel');
  String get exerciseLabel => _t('exerciseLabel');
  String get timesUnit => _t('timesUnit');
  String get noWorkoutsYet => _t('noWorkoutsYet');
  String get startToGrowAvatar => _t('startToGrowAvatar');
  String get deleteHistoryTitle => _t('deleteHistoryTitle');
  String get deleteHistoryMessage => _t('deleteHistoryMessage');
  String get deleteAllHistoryTitle => _t('deleteAllHistoryTitle');
  String get deleteAllHistoryMessage => _t('deleteAllHistoryMessage');
  String get delete => _t('delete');
  String get deleteAll => _t('deleteAll');
  String get markAllRead => _t('markAllRead');
  String get notificationsSubtitle => _t('notificationsSubtitle');
  String get justNow => _t('justNow');
  String get minutesAgo => _t('minutesAgo');
  String get hoursAgo => _t('hoursAgo');
  String get today => _t('today');
  String get yesterday => _t('yesterday');
  String get stageReachedTitle => _t('stageReachedTitle');
  String get close => _t('close');
  String get logoutConfirmTitle => _t('logoutConfirmTitle');
  String get logoutConfirmMessage => _t('logoutConfirmMessage');
  String get invalidNumberInput => _t('invalidNumberInput');
  String get profileUpdated => _t('profileUpdated');
  String get goalTypeMuscleGain => _t('goalTypeMuscleGain');
  String get goalTypeWeightLoss => _t('goalTypeWeightLoss');
  String get goalTypeMaintenance => _t('goalTypeMaintenance');
  String get targetPeriodDaysLabel => _t('targetPeriodDaysLabel');
  String stageReachedMessage(String stage) => _t('stageReachedMessage').replaceAll('{stage}', stage);

  String bodyStageLabel(int stage) {
    switch (stage) {
      case 1:
        return isEnglish ? 'Slim' : 'スリム';
      case 2:
        return isEnglish ? 'Tone' : 'トーン';
      case 3:
        return isEnglish ? 'Muscle' : 'マッスル';
      case 4:
        return isEnglish ? 'Athlete' : 'アスリート';
      case 5:
        return isEnglish ? 'Ideal body' : '理想の体型';
      default:
        return isEnglish ? 'Slim' : 'スリム';
    }
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales.any((supported) => supported.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}