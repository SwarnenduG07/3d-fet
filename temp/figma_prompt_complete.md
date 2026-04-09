# GrowMe – Complete App Design Extension Prompt (Japanese)

## IMPORTANT: This prompt EXTENDS the existing GrowMe UI design. Do NOT recreate already-designed screens. Only ADD the new screens listed below and UPDATE all existing screens to use Japanese text.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## GLOBAL UPDATE: Convert ALL Existing Screens to Japanese

Apply these text replacements across ALL existing and new screens:

### Onboarding Flow Updates
- "Welcome to GrowMe!" → "GrowMeへようこそ！"
- "Select your gender" → "性別を選んでください"
- "Male" → "男性"
- "Female" → "女性"
- "Next" → "次へ"
- "Your Body" → "あなたの体"
- "Enter your measurements" → "体の情報を入力してください"
- "Height (cm)" → "身長（cm）"
- "Current Weight (kg)" → "現在の体重（kg）"
- "Target Weight (kg)" → "目標体重（kg）"
- "Your Goal" → "あなたの目標"
- "What do you want to achieve?" → "どんな目標を達成したいですか？"
- "Muscle Gain" → "筋力アップ"
- "Build strength and muscle mass" → "筋力と筋肉量を増やす"
- "Weight Loss" → "ダイエット"
- "Burn fat and get lean" → "脂肪を燃焼してスリムに"
- "Maintenance" → "体型維持"
- "Stay healthy and active" → "健康的でアクティブに"
- "Timeframe" → "期間設定"
- "Set your target period" → "目標期間を設定してください"
- "30 Days" → "30日間"
- "60 Days" → "60日間"
- "90 Days" → "90日間"
- "[X] Days Challenge" → "[X]日間チャレンジ"
- "Your avatar will grow with you!" → "アバターがあなたと一緒に成長します！"
- "Start Your Journey" → "旅を始めよう"

### Home Screen Updates
- "XP" → "XP"
- "Protein" → "プロテイン"
- "Start Exercise" → "エクササイズ開始"
- "Look in the Mirror" → "鏡を見る"
- "3D Avatar Display Area" → "3Dアバター表示エリア"
- "Slim" → "スリム"
- "Toned" → "引き締め"
- "Muscular" → "マッチョ"
- "Athletic" → "アスリート"
- "Ideal Form" → "理想体型"

### Exercise Dialog Updates
- "Ready to Exercise?" → "エクササイズを始めますか？"
- "Tap start when you begin your workout. You'll earn XP and Protein!" → "ワークアウトを開始するときにスタートをタップ。XPとプロテインを獲得できます！"
- "Cancel" → "キャンセル"
- "Start" → "スタート"
- "Exercising..." → "エクササイズ中..."
- "Keep going! Every second counts." → "その調子！1秒1秒が大切です。"
- "End Exercise" → "エクササイズ終了"

### Workout Complete Dialog Updates
- "Workout Complete!" → "ワークアウト完了！"
- "Duration: X min" → "運動時間：X分"
- "Awesome!" → "お疲れ様！"

### Level Up Overlay Updates
- "LEVEL UP!" → "レベルアップ！"
- "Tap to continue" → "タップして続ける"

### Mirror Screen Updates
- "Mirror" → "ミラー"
- "Stage:" → "ステージ："
- "Level:" → "レベル："
- "Total XP:" → "累計XP："

### Body Transformation Overlay Updates
- "Body Transformation!" → "体が変化しました！"
- "You've reached Stage X: [Name]!" → "ステージX：[Name]に到達しました！"
- "Tap to continue" → "タップして続ける"

### Debug Panel Updates
- "Debug Test Panel" → "デバッグパネル"
- "Level" → "レベル"
- "Body Stage" → "ボディステージ"
- "Apply" → "適用"
- "Cancel" → "キャンセル"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## NEW SCREENS TO ADD

Use the same design system as existing screens:
- Primary: #4A90E2 (Blue)
- Accent: #7ED321 (Green)
- Secondary Accent: #FF9500 (Orange)
- Background: #F5F7FA
- Text Primary: #1A1A2E
- Text Secondary: #6B7280
- XP Gold: #FFD700
- Dark Background: #1A1A2E
- Rounded corners: 12px (small), 16px (medium), 20px (large)
- Consistent 8/12/16/20/24/32px spacing
- Shadow: 0px 2px 10px rgba(0,0,0,0.05)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### Screen 0: Splash Screen

Layout:
- Full screen, white background (#FFFFFF)
- Centered vertically:
  - App icon/logo: Large circular badge (96px), blue gradient (#4A90E2 → #6BA3E8), white dumbbell/fitness icon inside
  - App name: "GrowMe" (36px, bold, #1A1A2E) below icon, 16px gap
  - Tagline: "育てよう、理想のカラダ。" (16px, #6B7280) below app name, 8px gap
- Bottom: Loading indicator (small circular spinner, blue, 24px) centered, 80px from bottom
- Subtle fade-in animation indicated

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### Screen 1: Welcome / Auth Landing Screen

Layout:
- Full screen, background: #F5F7FA
- Top section (60% of screen):
  - Large hero illustration area (rounded rectangle, 300px height):
    - Light blue gradient background (#E8F0FE → #F5F7FA)
    - Centered fitness avatar silhouette illustration (placeholder)
    - Motivational visual: Upward progress arrows, sparkle effects
  - Below illustration:
    - App name: "GrowMe" (32px, bold, #1A1A2E), centered
    - Subtitle: "エクササイズで成長する、あなただけのアバター" (16px, #6B7280), centered
    - (Translation: "Your own avatar that grows through exercise")
- Bottom section (40% of screen), white card with top radius 24px:
  - Padding: 24px horizontal, 32px top
  - **ログイン（メールアドレス）** button:
    - Full-width, blue (#4A90E2), white text, 56px height, 16px radius
    - Mail icon (20px) + "メールアドレスでログイン" text (16px, bold)
  - 16px gap
  - **Googleでログイン** button:
    - Full-width, white background, #1A1A2E border (1px), 56px height, 16px radius
    - Google "G" color icon (20px) + "Googleでログイン" text (16px, medium, #1A1A2E)
  - 16px gap
  - **Appleでサインイン** button:
    - Full-width, black (#1A1A2E) background, white text, 56px height, 16px radius
    - Apple icon (20px) + "Appleでサインイン" text (16px, medium)
  - 24px gap
  - Divider line with centered text: "━━━ または ━━━" (12px, #6B7280)
  - 16px gap
  - **新規登録** text button:
    - Centered text: "アカウントをお持ちでない方は" (14px, #6B7280) + "新規登録" (14px, bold, #4A90E2, underlined)
  - 16px gap
  - Terms text (bottom):
    - "続行することで、利用規約とプライバシーポリシーに同意したものとみなされます。" (11px, #6B7280, centered)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### Screen 2: Email Login Screen

Layout:
- Background: #F5F7FA
- Top bar:
  - Back arrow (left, #1A1A2E, 24px)
  - Title: "ログイン" (20px, bold, #1A1A2E, centered)
- Content area (centered, 24px horizontal padding):
  - 32px from top bar
  - Small icon: Mail icon in blue circle (48px), centered
  - 16px gap
  - Heading: "おかえりなさい！" (24px, bold, #1A1A2E, centered)
  - Subheading: "メールアドレスとパスワードを入力してください" (14px, #6B7280, centered)
  - 32px gap
  - **メールアドレス** input field:
    - Label above: "メールアドレス" (14px, medium, #1A1A2E)
    - Input: White background, rounded (12px), mail icon prefix, placeholder "example@email.com"
    - Blue focus border (2px)
  - 16px gap
  - **パスワード** input field:
    - Label above: "パスワード" (14px, medium, #1A1A2E)
    - Input: White background, rounded (12px), lock icon prefix, eye toggle suffix
    - Placeholder: "パスワードを入力"
    - Blue focus border (2px)
  - 12px gap
  - Forgot password link (right-aligned):
    - "パスワードをお忘れですか？" (13px, #4A90E2)
  - 32px gap
  - **ログイン** button:
    - Full-width, blue (#4A90E2), white text "ログイン", 56px height, 16px radius
  - 16px gap
  - Error state (shown when login fails):
    - Red (#FF3B30) container, rounded (12px), 12px padding
    - Warning icon + "メールアドレスまたはパスワードが正しくありません" (13px, #FF3B30)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### Screen 3: Sign Up Screen

Layout:
- Background: #F5F7FA
- Top bar:
  - Back arrow (left, #1A1A2E, 24px)
  - Title: "新規登録" (20px, bold, #1A1A2E, centered)
- Content area (scrollable, 24px horizontal padding):
  - 32px from top bar
  - Small icon: Person-add icon in blue circle (48px), centered
  - 16px gap
  - Heading: "アカウントを作成" (24px, bold, #1A1A2E, centered)
  - Subheading: "GrowMeを始めましょう！" (14px, #6B7280, centered)
  - 32px gap
  - **ニックネーム** input field:
    - Label: "ニックネーム" (14px, medium)
    - Input: White, rounded (12px), person icon prefix, placeholder "ニックネームを入力"
  - 16px gap
  - **メールアドレス** input field:
    - Label: "メールアドレス" (14px, medium)
    - Input: White, rounded (12px), mail icon prefix, placeholder "example@email.com"
  - 16px gap
  - **パスワード** input field:
    - Label: "パスワード" (14px, medium)
    - Input: White, rounded (12px), lock icon prefix, eye toggle, placeholder "8文字以上で入力"
  - 8px gap
  - Password strength indicator:
    - 4 small bars (horizontal), colored by strength:
      - Weak: 1 bar red (#FF3B30)
      - Medium: 2 bars orange (#FF9500)
      - Strong: 3 bars green (#7ED321)
      - Very Strong: 4 bars green (#7ED321)
    - Label: "パスワード強度：強い" (11px, #6B7280)
  - 16px gap
  - **パスワード確認** input field:
    - Label: "パスワード（確認）" (14px, medium)
    - Input: White, rounded (12px), lock icon prefix, placeholder "パスワードを再入力"
  - 24px gap
  - Terms checkbox:
    - Checkbox (24px, blue when checked) + "利用規約とプライバシーポリシーに同意します" (13px, #1A1A2E)
    - "利用規約" and "プライバシーポリシー" in blue (#4A90E2), underlined
  - 24px gap
  - **アカウントを作成** button:
    - Full-width, blue (#4A90E2), white text, 56px height, 16px radius
    - Disabled state: #B0C4DE background when terms not checked
  - 16px gap
  - Bottom text:
    - "すでにアカウントをお持ちの方は" (14px, #6B7280) + "ログイン" (14px, bold, #4A90E2)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### Screen 4: Forgot Password Screen

Layout:
- Background: #F5F7FA
- Top bar:
  - Back arrow (left, #1A1A2E)
  - Title: "パスワードリセット" (20px, bold, centered)
- Content (centered, 24px horizontal padding):
  - 48px from top bar
  - Large mail icon in blue circle (64px), centered
  - 16px gap
  - Heading: "パスワードをリセット" (24px, bold, #1A1A2E, centered)
  - 8px gap
  - Description: "登録済みのメールアドレスを入力してください。パスワードリセットのリンクをお送りします。" (14px, #6B7280, centered, max 280px width)
  - 32px gap
  - **メールアドレス** input field:
    - Label: "メールアドレス" (14px, medium)
    - Input: White, rounded (12px), mail icon prefix
  - 24px gap
  - **リセットメールを送信** button:
    - Full-width, blue, white text, 56px height, 16px radius

#### Variant: Email Sent Confirmation
- Same layout but content changes to:
  - Green checkmark in circle (64px, #7ED321), centered
  - "メール送信完了！" (24px, bold, #1A1A2E)
  - "パスワードリセットのメールを送信しました。メールを確認してください。" (14px, #6B7280, centered)
  - 32px gap
  - **ログイン画面に戻る** button (full-width, blue)
  - 16px gap
  - "メールが届かない場合は" (13px, #6B7280) + "再送信" (13px, bold, #4A90E2)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### Screen 5: Email Verification Screen

Layout:
- Background: #F5F7FA
- Content (centered vertically, 24px horizontal padding):
  - Mail-open icon in blue circle (64px), centered
  - 16px gap
  - Heading: "メール認証" (24px, bold, centered)
  - 8px gap
  - Description: "確認メールを送信しました。メール内のリンクをクリックして認証を完了してください。" (14px, #6B7280, centered)
  - 8px gap
  - Email display: "example@email.com" (16px, medium, #4A90E2, centered)
  - 32px gap
  - **認証メールを再送信** button:
    - Full-width, outlined (blue border 2px), blue text, 56px height, 16px radius
  - 16px gap
  - **認証完了・ログインへ** button:
    - Full-width, blue, white text, 56px height, 16px radius
  - 32px gap
  - "メールが届きませんか？迷惑メールフォルダもご確認ください。" (12px, #6B7280, centered)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### Screen 6: Profile / Settings Screen

Layout:
- Background: #F5F7FA
- Top bar:
  - Back arrow (left, #1A1A2E)
  - Title: "プロフィール" (20px, bold, centered)
  - Edit icon (right, #4A90E2)

#### Profile Header Card
- White card, rounded (20px), shadow, 24px padding
- Left: User avatar circle (64px, blue gradient, person icon or initials)
- Right of avatar:
  - Nickname: "ユーザー名" (18px, bold, #1A1A2E)
  - Email: "user@email.com" (13px, #6B7280)
  - Level badge pill: "Lv.12" (12px, bold, white text, blue gradient background)
- Below (inside card):
  - Three stat columns in row:
    - "累計XP" label (11px, #6B7280), "12,500" value (18px, bold, #FFD700)
    - Divider
    - "レベル" label, "12" value (18px, bold, #4A90E2)
    - Divider
    - "ステージ" label, "引き締め" value (18px, bold, #7ED321)

#### Body Info Section
- Section header: "体の情報" (16px, bold, #1A1A2E), 24px top margin
- White card, rounded (16px):
  - Row: "性別" → "男性" (or 女性), right-aligned, chevron icon
  - Divider (#E5E7EB)
  - Row: "身長" → "175 cm", right-aligned, chevron icon
  - Divider
  - Row: "現在の体重" → "70 kg", right-aligned, chevron icon
  - Divider
  - Row: "目標体重" → "65 kg", right-aligned, chevron icon
  - Divider
  - Row: "目標タイプ" → "筋力アップ", right-aligned, chevron icon
  - Divider
  - Row: "目標期間" → "30日間", right-aligned, chevron icon
- Row style: 56px height, 16px horizontal padding, text left (14px, #1A1A2E), value right (14px, #6B7280)

#### Settings Section
- Section header: "設定" (16px, bold, #1A1A2E), 24px top margin
- White card, rounded (16px):
  - Row: Bell icon + "プッシュ通知" → Toggle switch (blue when ON)
  - Divider
  - Row: Globe icon + "言語" → "日本語", chevron
  - Divider
  - Row: Shield icon + "プライバシーポリシー" → chevron
  - Divider
  - Row: Document icon + "利用規約" → chevron
  - Divider
  - Row: Info icon + "アプリバージョン" → "1.0.0" (gray text, no chevron)

#### Danger Zone
- 24px top margin
- **ログアウト** button:
  - Full-width, outlined (red border #FF3B30, 1px), red text, 48px height, 16px radius
  - Logout icon + "ログアウト"
- 12px gap
- **アカウント削除** text button:
  - Centered, "アカウントを削除" (14px, #FF3B30)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### Screen 7: Edit Profile Screen

Layout:
- Background: #F5F7FA
- Top bar:
  - Back arrow (left, #1A1A2E)
  - Title: "プロフィール編集" (20px, bold, centered)
  - "保存" text button (right, #4A90E2, 16px, bold)
- Content (scrollable, 24px horizontal padding):
  - 24px from top bar
  - User avatar circle (80px, centered) with camera overlay badge (24px, blue circle, camera icon, bottom-right of avatar)
  - "写真を変更" text button (14px, #4A90E2, centered)
  - 24px gap
  - **ニックネーム** input:
    - Label: "ニックネーム"
    - Input with person icon
  - 16px gap
  - **身長** input:
    - Label: "身長（cm）"
    - Input with ruler icon, numeric keyboard
  - 16px gap
  - **現在の体重** input:
    - Label: "現在の体重（kg）"
    - Input with scale icon, numeric keyboard
  - 16px gap
  - **目標体重** input:
    - Label: "目標体重（kg）"
    - Input with flag icon, numeric keyboard
  - 24px gap
  - **目標タイプ** selection:
    - Label: "目標タイプ" (14px, medium)
    - Three horizontal chips: "筋力アップ" / "ダイエット" / "体型維持"
    - Selected chip: Blue filled, white text
    - Unselected: White, #E5E7EB border
  - 24px gap
  - **保存** button:
    - Full-width, blue, white text "変更を保存", 56px height, 16px radius

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### Screen 8: Workout History Screen

Layout:
- Background: #F5F7FA
- Top bar:
  - Back arrow (left, #1A1A2E)
  - Title: "ワークアウト履歴" (20px, bold, centered)

#### Summary Card (Top)
- White card, rounded (16px), shadow, 20px padding
- Title: "今月のまとめ" (14px, medium, #6B7280)
- Three stat columns:
  - Fire icon (orange) + "合計回数" label (11px) + "12回" value (20px, bold)
  - Clock icon (blue) + "合計時間" label + "180分" value (20px, bold)
  - Lightning icon (gold) + "獲得XP" label + "1,800" value (20px, bold, #FFD700)

#### Calendar Week View
- Horizontal row of 7 day indicators:
  - Day labels: "月 火 水 木 金 土 日" (12px, #6B7280)
  - Below each: Circle (32px)
    - Workout done: Blue filled (#4A90E2), white checkmark
    - No workout: #E5E7EB border only
    - Today: Blue border (2px), current date number inside
- Week navigation: Left/right arrows on sides

#### Workout List (Scrollable)
- Section header: "最近のワークアウト" (16px, bold, #1A1A2E)
- List of workout cards (white, rounded 12px, 16px padding, 12px gap between):
  - Each card:
    - Left: Blue circle (40px) with fitness icon
    - Middle:
      - "エクササイズ" (15px, medium, #1A1A2E)
      - Date: "2026年2月28日 14:30" (12px, #6B7280)
    - Right column:
      - "25分" duration (14px, bold, #1A1A2E)
      - "+250 XP" (12px, bold, #FFD700)
      - "+125 プロテイン" (12px, bold, #7ED321)

#### Empty State (when no workouts)
- Centered illustration: Dumbbell icon (64px, #E5E7EB)
- "まだワークアウトがありません" (18px, medium, #6B7280)
- "エクササイズを始めて、アバターを成長させましょう！" (14px, #6B7280)
- "エクササイズを始める" button (blue, outlined, 48px height)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### Screen 9: Workout Detail Screen

Layout:
- Background: #F5F7FA
- Top bar:
  - Back arrow (left)
  - Title: "ワークアウト詳細" (20px, bold, centered)
- Content (24px horizontal padding):
  - 24px top
  - Date header: "2026年2月28日（土）" (14px, #6B7280, centered)
  - 8px gap
  - Time: "14:30 ~ 14:55" (20px, bold, #1A1A2E, centered)

  #### Main Stats Card
  - White card, rounded (20px), shadow, 24px padding
  - Large duration display:
    - Clock icon (32px, blue)
    - "25" (48px, bold, #1A1A2E) + "分" (20px, #6B7280)
  - 16px gap
  - Divider
  - 16px gap
  - Two stat rows:
    - Lightning icon (gold) + "獲得XP" (14px, #6B7280) → "+250 XP" (18px, bold, #FFD700) right-aligned
    - Fork icon (green) + "獲得プロテイン" (14px, #6B7280) → "+125" (18px, bold, #7ED321) right-aligned

  #### Timeline Card
  - White card, rounded (16px), 20px padding
  - Title: "タイムライン" (14px, bold, #1A1A2E)
  - 12px gap
  - Timeline items (vertical line connecting dots):
    - Green dot + "エクササイズ開始" + "14:30" (right, gray)
    - Blue dot + "エクササイズ終了" + "14:55" (right, gray)
    - Gold dot + "+250 XP 獲得" + "14:55"
    - Green dot + "+125 プロテイン獲得" + "14:55"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### Screen 10: Notification Center Screen

Layout:
- Background: #F5F7FA
- Top bar:
  - Back arrow (left)
  - Title: "通知" (20px, bold, centered)
  - "すべて既読" text button (right, 13px, #4A90E2)
- Content (scrollable):
  - Section: "今日" (14px, bold, #6B7280, 20px horizontal padding)
  - Notification cards (white, rounded 12px, 16px padding, 8px gap):
    - **Level Up notification**:
      - Left: Gold circle (40px), upward arrow icon
      - Middle:
        - "レベルアップ！" (15px, bold, #1A1A2E)
        - "おめでとうございます！レベル12に到達しました！" (13px, #6B7280)
        - "2時間前" (11px, #6B7280)
      - Right: Blue dot (8px) if unread
    - **Workout notification**:
      - Left: Blue circle (40px), fitness icon
      - Middle:
        - "ワークアウト完了" (15px, bold)
        - "25分のエクササイズを完了しました。+250 XP" (13px, #6B7280)
        - "3時間前"
    - **Body change notification**:
      - Left: Green circle (40px), sparkle icon
      - Middle:
        - "体が変化しました！" (15px, bold)
        - "ステージ2「引き締め」に進化しました！" (13px, #6B7280)
        - "昨日"
    - **Reminder notification**:
      - Left: Orange circle (40px), bell icon
      - Middle:
        - "エクササイズリマインダー" (15px, bold)
        - "今日のワークアウトはまだですか？アバターが待っています！" (13px, #6B7280)
        - "昨日"

  - Section: "今週" (14px, bold, #6B7280) — more notification items

  #### Empty State
  - Bell-off icon (64px, #E5E7EB), centered
  - "通知はまだありません" (18px, medium, #6B7280)
  - "ワークアウトを完了すると、ここに通知が届きます" (14px, #6B7280)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### Screen 11: Logout Confirmation Dialog

Modal Dialog:
- Rounded (20px), white background, centered
- Warning icon (48px, orange #FF9500), centered
- Title: "ログアウト" (20px, bold, centered)
- Description: "本当にログアウトしますか？" (14px, #6B7280, centered)
- 24px gap
- Two buttons side-by-side:
  - "キャンセル" (text button, left, #6B7280)
  - "ログアウト" (elevated button, red #FF3B30, white text, right)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### Screen 12: Delete Account Confirmation Dialog

Modal Dialog:
- Rounded (20px), white background, centered
- Red warning triangle icon (48px, #FF3B30), centered
- Title: "アカウント削除" (20px, bold, #FF3B30, centered)
- Description: "この操作は取り消せません。すべてのデータが完全に削除されます。" (14px, #6B7280, centered)
- 16px gap
- Confirmation input:
  - Label: "確認のため「削除」と入力してください" (13px, #6B7280)
  - Input field, rounded (12px), red focus border
- 24px gap
- Two buttons:
  - "キャンセル" (text button, left)
  - "完全に削除" (elevated button, red, white text, disabled until text matches)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### Screen 13: Loading / Skeleton States

Design skeleton loading states for:

#### Home Screen Skeleton
- Top bar: Two gray pill placeholders (shimmer animation)
- Stats: Two cards with gray rectangle placeholders (shimmer)
- Avatar area: Large gray rounded rectangle (shimmer)
- Buttons: Two gray rounded rectangle placeholders

#### General Loading Overlay
- Semi-transparent white (80% opacity)
- Centered: Blue circular spinner (40px)
- Below spinner: "読み込み中..." (14px, #6B7280)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### Screen 14: Error States

#### Network Error Screen
- Centered content:
  - Wifi-off icon (64px, #E5E7EB)
  - "接続エラー" (20px, bold, #1A1A2E)
  - "インターネット接続を確認してください" (14px, #6B7280)
  - 24px gap
  - "再試行" button (blue, outlined, 48px height)

#### General Error Dialog
- Modal, rounded (20px):
  - Red circle with "!" icon (48px)
  - "エラーが発生しました" (20px, bold)
  - Error message text (14px, #6B7280)
  - "OK" button (blue)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### Screen 15: Notification Permission Dialog (OS-style)

Custom pre-permission dialog:
- Modal, rounded (20px), white:
  - Bell icon with sparkle (64px, blue), centered
  - Title: "通知を許可してください" (20px, bold, centered)
  - Description: "レベルアップやボディ変化などの大切なお知らせを受け取りましょう！" (14px, #6B7280, centered)
  - 24px gap
  - Illustration: Three mini notification previews stacked:
    - Small rounded cards showing sample notifications (scaled down)
  - 24px gap
  - "通知をオンにする" button (blue, full-width, 56px)
  - 12px gap
  - "あとで" text button (#6B7280, centered)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Updated Home Screen with Navigation

Add to the existing Home Screen design:

#### Bottom Navigation Bar (if not already present)
- White background, top border (#E5E7EB, 1px)
- 4 tabs, evenly spaced:
  - **ホーム**: Home icon, "ホーム" label (10px)
    - Active: Blue icon + text (#4A90E2)
    - Inactive: Gray icon + text (#6B7280)
  - **履歴**: Clock icon, "履歴" label
  - **通知**: Bell icon, "通知" label
    - Red badge dot (8px) when unread notifications exist
  - **マイページ**: Person icon, "マイページ" label

#### Top Bar Update (Home Screen)
- Add notification bell icon (right side, before body stage label)
- Red badge (8px) on bell when unread notifications

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Complete Navigation Flow

Design the prototype flow connecting all screens:

```
Splash Screen
  ↓
Auth Landing Screen
  ├→ Email Login → (success) → Home Screen
  ├→ Google Login → (success) → Home Screen (or Onboarding if new)
  ├→ Apple Login → (success) → Home Screen (or Onboarding if new)
  ├→ Sign Up → Email Verification → Login → Home Screen
  └→ Forgot Password → Reset Email Sent → Login
  
First-time users after auth:
  Auth → Onboarding (Gender → Body → Goal → Timeframe) → Notification Permission → Home Screen

Home Screen (Tab: ホーム)
  ├→ Start Exercise → Exercise Dialog → Exercise In Progress → Workout Complete
  │   └→ (if level up) → Level Up Overlay → Home
  ├→ Look in Mirror → Mirror Screen
  │   └→ (if body change) → Body Transformation Overlay → Mirror
  └→ Debug icon → Debug Panel

Workout History (Tab: 履歴)
  └→ Tap workout → Workout Detail

Notifications (Tab: 通知)

Profile (Tab: マイページ)
  ├→ Edit Profile
  ├→ Privacy Policy (WebView)
  ├→ Terms of Service (WebView)
  ├→ Logout → Confirmation → Auth Landing
  └→ Delete Account → Confirmation → Auth Landing
```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Component Library Additions

### New Components to Add

#### Bottom Navigation Bar
- Height: 64px + safe area
- White background, top border
- 4 items, evenly spaced
- Active state: Blue icon + text
- Inactive state: Gray icon + text
- Badge: Red dot (8px), positioned top-right of icon

#### Notification Card
- White, rounded (12px), 16px padding
- Left icon circle (40px), colored by type
- Title + description + timestamp
- Unread indicator: Blue dot (8px)

#### Workout History Card
- White, rounded (12px), 16px padding
- Left icon circle (40px, blue)
- Right: Duration + XP + Protein

#### Toggle Switch
- Width: 48px, Height: 28px
- ON: Blue (#4A90E2) track, white knob
- OFF: #E5E7EB track, white knob
- Transition animation indicated

#### Settings Row
- Height: 56px
- Left: Icon (24px) + Label (14px)
- Right: Value text (14px, gray) + Chevron (16px)
- Divider below

#### Skeleton Loader
- Gray (#E5E7EB) rounded rectangles
- Shimmer animation (left to right gradient sweep)

#### Badge / Pill
- Rounded (30px), 8px vertical padding, 12px horizontal
- Variants: Blue (level), Green (stage), Red (alert), Gold (XP)

#### Empty State
- Centered layout
- Large icon (64px, light gray)
- Title (18px, medium)
- Description (14px, gray)
- Optional action button

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Summary of All Screens (Total: 23+ screens/states)

### Existing (Update text to Japanese only):
1. Onboarding - Gender Selection
2. Onboarding - Body Measurements
3. Onboarding - Goal Selection
4. Onboarding - Timeframe
5. Home Screen
6. Exercise Ready Dialog
7. Exercise In Progress Dialog
8. Workout Complete Dialog
9. Level Up Overlay
10. Mirror Screen
11. Body Transformation Overlay
12. Debug Test Panel

### NEW Screens:
13. Splash Screen
14. Auth Landing Screen
15. Email Login Screen
16. Sign Up Screen
17. Forgot Password Screen
18. Email Verification Screen
19. Profile / Settings Screen
20. Edit Profile Screen
21. Workout History Screen
22. Workout Detail Screen
23. Notification Center Screen
24. Logout Confirmation Dialog
25. Delete Account Confirmation Dialog
26. Loading / Skeleton States
27. Error States (Network + General)
28. Notification Permission Dialog
29. Bottom Navigation Bar (component + integration)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Final Notes

- ALL text must be in Japanese as specified above
- Maintain exact same design system, colors, shadows, and spacing
- Ensure all new screens feel like natural extensions of existing design
- Mobile portrait only: 375x812 (iPhone) and 360x800 (Android)
- Include both light and dark variants for Mirror screen (already dark)
- All interactive elements need 44x44px minimum touch targets
- Include proper safe area handling on all screens
