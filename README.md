# VPN Test Application

## Архитектура
- State Management: Provider
- Адаптивность: Sizer package
- Локальное хранилище: SharedPreferences
- Аналитика: Firebase Analytics
- VPN Сервис: VPNService (mock implementation)
- Структура: Feature-based

## Решения
1. Использован Provider как простой и эффективный state manager
2. Добавлен VPNService для имитации подключения к VPN
3. Добавлена анимация подключения через CircularProgressIndicator
4. Реализована локальная история подключений с лимитом в 5 записей
5. Использован StreamBuilder для real-time обновления таймера
6. Обработка ошибок подключения с уведомлением пользователя

## Установка
1. flutter pub get
2. Настроить Firebase в проекте
3. flutter run

## Примечания
VPNService реализован как mock-сервис. Для реального подключения потребуется:
1. Интеграция с нативными платформенными каналами
2. Конфигурация реального VPN-сервера
3. Обработка системных разрешений

