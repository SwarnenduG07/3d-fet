# GrowMe – Full App Design Extension (Japanese UI)

Extend the existing GrowMe Figma design. Keep all existing screens but convert text to Japanese. Add all new screens below using the same design system.

---

## Design System (same as existing)
- Colors: Blue #4A90E2, Green #7ED321, Orange #FF9500, BG #F5F7FA, Text #1A1A2E / #6B7280, Gold #FFD700, Dark #1A1A2E
- Corners: 12/16/20px | Spacing: 8/12/16/20/24/32px | Shadow: 0 2px 10px rgba(0,0,0,0.05)
- Buttons: Primary 56px blue, Secondary outlined blue, Accent orange | Inputs: White, 12px radius, icon prefix, blue focus border

---

## New Screens

### 1. Splash Screen
White full screen. Centered: App logo (96px blue gradient circle, fitness icon) + "GrowMe" (36px bold) + "育てよう、理想のカラダ。" (16px gray). Bottom: blue spinner.

### 2. Auth Landing Screen
Top 60%: Hero illustration area with light blue gradient, avatar silhouette. "GrowMe" (32px bold) + "エクササイズで成長する、あなただけのアバター" (16px gray).
Bottom 40%: White card (top radius 24px) with 2 stacked buttons:
- "Googleでログイン" (white, #1A1A2E border 1px, 56px height, 16px radius, Google "G" color icon + text)
- "ゲストとして始める" (blue #4A90E2, white text, 56px height, 16px radius, person icon + text)
Terms text at bottom: "続行することで、利用規約とプライバシーポリシーに同意したものとみなされます。" (11px gray, centered).

### 3. Profile / Settings Screen
Top bar: ← "プロフィール" + edit icon.
**Header card:** Avatar circle (64px) + nickname + "Lv.12" badge. Three stats row: 累計XP / レベル / ステージ.
**体の情報 section:** White card with rows: 性別, 身長, 現在の体重, 目標体重, 目標タイプ, 目標期間 (each with value + chevron).
**アカウント section:** "Googleアカウント連携" row (green badge "連携済み" if linked, or "連携する" blue text button if guest).
**設定 section:** プッシュ通知 (toggle), 言語 → 日本語, プライバシーポリシー, 利用規約, アプリバージョン → 1.0.0.
**Bottom:** "ログアウト" (red outlined) + "アカウントを削除" (red text).

### 4. Edit Profile Screen
Top bar: ← "プロフィール編集" + "保存". Avatar (80px) with camera badge + "写真を変更". Inputs: ニックネーム, 身長, 現在の体重, 目標体重. Goal chips: 筋力アップ / ダイエット / 体型維持. "変更を保存" button.

### 5. Workout History Screen
Top bar: ← "ワークアウト履歴".
**Summary card:** "今月のまとめ" — 合計回数 12回 / 合計時間 180分 / 獲得XP 1,800.
**Week calendar:** 月火水木金土日 circles (blue filled = done, border = today).
**Workout list:** Cards with fitness icon + "エクササイズ" + date + duration/XP/protein.
**Empty state:** Dumbbell icon + "まだワークアウトがありません" + "エクササイズを始める" button.

### 6. Workout Detail Screen
Top bar: ← "ワークアウト詳細". Date + time range. Stats card: large duration (25分) + 獲得XP (+250) + 獲得プロテイン (+125). Timeline card: start → end → XP → protein with connected dots.

### 7. Notification Center
Top bar: ← "通知" + "すべて既読". Grouped by "今日" / "今週". Cards with colored icon circles:
- Gold: "レベルアップ！" + level reached
- Blue: "ワークアウト完了" + XP earned
- Green: "体が変化しました！" + stage name
- Orange: "エクササイズリマインダー"
Unread: blue dot. **Empty:** "通知はまだありません".

### 8. Logout Dialog
Modal: Warning icon (orange). "ログアウト" title. "本当にログアウトしますか？". Buttons: キャンセル / ログアウト (red).

### 9. Delete Account Dialog
Modal: Red warning triangle. "アカウント削除" (red title). "この操作は取り消せません。すべてのデータが完全に削除されます。" Confirmation input: type "削除". Buttons: キャンセル / 完全に削除 (red, disabled until match).

### 10. Loading States
**Skeleton:** Gray shimmer rectangles matching Home layout (pills, cards, avatar area, buttons).
**Overlay:** Semi-transparent white + blue spinner + "読み込み中..."

### 11. Error States
**Network:** Wifi-off icon + "接続エラー" + "インターネット接続を確認してください" + "再試行" button.
**General dialog:** Red "!" icon + "エラーが発生しました" + message + "OK" button.

### 12. Notification Permission Dialog
Modal: Bell+sparkle icon (64px blue). "通知を許可してください" + description about level-up/body-change alerts. Mini notification previews. "通知をオンにする" (blue) + "あとで" (gray text).

---

## Bottom Navigation Bar (Add to Home Screen)
White bar, top border. 4 tabs: **ホーム** (home icon) | **履歴** (clock) | **通知** (bell, red badge when unread) | **マイページ** (person). Active = blue, Inactive = gray.

---

## Navigation Flow
```
Splash → Auth Landing
  ├→ Googleでログイン → Home (or Onboarding if new user)
  └→ ゲストとして始める → Onboarding → Home

New users: Auth → Onboarding (4 steps) → Notification Permission → Home

Home (ホーム tab)
  ├→ Exercise → In Progress → Complete → (Level Up?) → Home
  ├→ Mirror → (Body Transform?) → Mirror
  └→ Debug Panel

履歴 tab → Workout Detail
通知 tab → Notifications
マイページ tab → Edit Profile / Google連携 / Logout / Delete Account
```

---

## New Components
- **Bottom Nav:** 64px + safe area, 4 tabs, badge dot
- **Notification Card:** Icon circle + title/desc/time + unread dot
- **Workout Card:** Icon + name/date + duration/XP/protein
- **Toggle Switch:** 48×28px, blue ON / gray OFF
- **Settings Row:** 56px, icon + label + value + chevron
- **Skeleton Loader:** Gray shimmer rectangles
- **Empty State:** Large icon + title + description + optional button

---

## Total: 25 screens/states (12 existing updated to Japanese + 13 new)
Auth: Google + Anonymous login only (no email/password screens). All text in Japanese. Mobile portrait 375×812 / 360×800. Min touch target 44×44px. Safe areas respected.
