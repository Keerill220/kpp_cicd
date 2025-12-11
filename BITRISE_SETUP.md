# 🚀 Bitrise CI/CD Setup Guide for Water Tracker

## 📋 Огляд

Цей документ описує налаштування CI/CD pipeline через Bitrise для Flutter застосунку Water Tracker з деплоєм на Firebase App Distribution.

## 🔧 Необхідні кроки налаштування

### 1. Створити репозиторій на GitHub

```bash
cd c:\Users\Admin\Documents\laby\5\kpp\projects\water_tracker

# Ініціалізувати git (якщо ще не зроблено)
git init

# Додати файли
git add .

# Створити перший коміт
git commit -m "Initial commit: Water Tracker app with Firebase integration"

# Додати remote (замініть на свій репозиторій)
git remote add origin https://github.com/YOUR_USERNAME/water-tracker.git

# Push
git push -u origin main
```

### 2. Зареєструватись на Bitrise

1. Перейдіть на [bitrise.io](https://bitrise.io)
2. Зареєструйтесь через GitHub
3. Натисніть **"Add new app"**
4. Виберіть ваш репозиторій `water-tracker`
5. Виберіть branch `main`
6. Bitrise автоматично визначить Flutter проект

### 3. Налаштувати Secrets у Bitrise

Перейдіть у **Workflow Editor** → **Secrets** і додайте:

| Secret Key | Опис | Як отримати |
|------------|------|-------------|
| `FIREBASE_APP_ID_ANDROID` | ID Android додатку в Firebase | Firebase Console → Project Settings → Your apps → App ID |
| `FIREBASE_TOKEN` | Токен для Firebase CLI | Виконайте `firebase login:ci` локально |

#### Отримання Firebase Token:

```bash
# Встановіть Firebase CLI
npm install -g firebase-tools

# Авторизуйтесь і отримайте токен
firebase login:ci

# Скопіюйте отриманий токен у Bitrise Secrets
```

#### Ваші значення:

- **FIREBASE_APP_ID_ANDROID**: `1:269504686011:android:db266de0e21cf61aff869e`
- **Project ID**: `water-tracker-3d22f3`

### 4. Створити групу тестерів у Firebase

1. Перейдіть у [Firebase Console](https://console.firebase.google.com)
2. Виберіть проект `water-tracker-3d22f3`
3. **App Distribution** → **Testers & Groups**
4. Створіть групу з назвою `testers`
5. Додайте email адреси тестерів

### 5. Завантажити bitrise.yml

Файл `bitrise.yml` вже створено в проекті. Він буде автоматично використаний Bitrise.

## 📊 Workflow Structure

```
android_firebase workflow:
│
├── 1. activate-ssh-key     - Активація SSH для Git
├── 2. git-clone            - Клонування репозиторію
├── 3. flutter-installer    - Встановлення Flutter SDK
├── 4. restore-dart-cache   - Відновлення кешу пакетів
├── 5. flutter pub get      - Встановлення залежностей
├── 6. flutter analyze      - Аналіз коду (linting)
├── 7. flutter test         - Запуск unit тестів
├── 8. save-dart-cache      - Збереження кешу
├── 9. flutter build apk    - Build Release APK
├── 10. verify firebase     - Перевірка конфігурації
├── 11. firebase distribute - Upload на Firebase App Distribution
├── 12. create instructions - Інструкція встановлення
└── 13. deploy-to-bitrise   - Збереження артефактів
```

## 🔄 Triggers (Автоматичний запуск)

| Подія | Branch | Workflow |
|-------|--------|----------|
| Push | `main` | `android_firebase` |
| Pull Request | `*` (будь-який) | `android_firebase` |

## 📱 Firebase App Distribution

Після успішного build:

1. Тестери отримають email з посиланням
2. APK доступний у Firebase Console → App Distribution
3. Артефакти збережені у Bitrise → Artifacts

## ⚠️ Важливо

### Файли, які НЕ повинні бути в Git:

- `android/local.properties` - локальні шляхи
- `*.jks`, `*.keystore` - ключі підпису
- `.env` файли - секрети
- `firebase-debug.log` - логи

### Файли, які ПОВИННІ бути в Git:

- `android/app/google-services.json` - Firebase конфіг для Android
- `lib/firebase_options.dart` - Flutter Firebase опції
- `bitrise.yml` - CI/CD конфігурація
- `pubspec.yaml` - залежності

## 🧪 Локальне тестування

```bash
# Перевірка коду
flutter analyze

# Запуск тестів
flutter test

# Build APK
flutter build apk --release
```

## 📞 Troubleshooting

### Build fails on "flutter pub get"
- Перевірте `pubspec.yaml` на синтаксичні помилки
- Видаліть `pubspec.lock` і спробуйте знову

### Firebase upload fails
- Перевірте `FIREBASE_TOKEN` (можливо закінчився термін)
- Перевірте `FIREBASE_APP_ID_ANDROID`
- Переконайтесь, що група `testers` існує

### APK not found
- Перевірте шлях `build/app/outputs/flutter-apk/app-release.apk`
- Переконайтесь, що build пройшов успішно

## 📎 Корисні посилання

- [Bitrise Documentation](https://devcenter.bitrise.io/)
- [Firebase App Distribution](https://firebase.google.com/docs/app-distribution)
- [Flutter CI/CD](https://docs.flutter.dev/deployment/cd)
