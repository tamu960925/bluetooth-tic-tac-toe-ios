# Bluetooth Tic-Tac-Toe iOS

Bluetooth経由でオフライン対戦できるiPhone向け三目並べアプリです。

## 🎮 特徴

- **オフライン対戦**: インターネット不要、Bluetooth経由で近距離対戦
- **簡単接続**: MultipeerConnectivityで自動デバイス検出
- **日本語対応**: 完全日本語UIでわかりやすい操作
- **リアルタイム**: 手番同期とゲーム状態共有
- **暇つぶし**: 電車や待ち時間に最適

## 📱 動作環境

- iOS 17.0以上
- iPhone/iPad対応
- Bluetooth対応デバイス

## 🚀 セットアップ

### 開発環境
- Xcode 15.0以上
- Swift 5.0以上
- iOS SDK 17.0以上

### ビルド方法
```bash
# プロジェクトをクローン
git clone https://github.com/yourusername/bluetooth-tic-tac-toe-ios.git
cd bluetooth-tic-tac-toe-ios

# Xcodeでプロジェクトを開く
open BluetoothTicTacToe.xcodeproj

# または、コマンドラインでビルド
xcodebuild -project BluetoothTicTacToe.xcodeproj -scheme BluetoothTicTacToe -destination 'platform=iOS Simulator,name=iPhone 15'
```

## 🎯 使い方

1. **ゲーム作成**: 「ゲームを作成」をタップしてホストになる
2. **ゲーム参加**: 「ゲームに参加」をタップして相手のゲームに参加
3. **対戦開始**: 自動接続後、交互に手番を進める
4. **再戦**: ゲーム終了後「もう一度プレイ」で連続対戦

## 🔧 技術仕様

### アーキテクチャ
- **SwiftUI**: モダンなUI構築
- **MultipeerConnectivity**: P2P通信
- **ObservableObject**: リアクティブな状態管理
- **MVVM**: 分離されたビジネスロジック

### 主要ファイル
- `MultipeerService.swift`: Bluetooth通信管理
- `GameLogic.swift`: 三目並べロジック
- `ContentView.swift`: メイン画面UI
- `GameView.swift`: ゲーム画面UI

## 🤖 CI/CD

GitHub Actionsによる自動ビルドを設定済み：

- **プッシュ/PR**: シミュレーター用自動ビルド
- **mainブランチ**: リリースビルド（要証明書設定）
- **テスト実行**: 自動テストとカバレッジ計測

詳細は [GitHub Actions セットアップガイド](.github/SETUP.md) を参照。

## 📦 依存関係

- **Foundation**: 標準ライブラリ
- **SwiftUI**: UI構築
- **MultipeerConnectivity**: P2P通信

外部ライブラリ不要で軽量な構成です。

## 🛠 開発

### ローカル開発
```bash
# Fastlaneを使用したビルド（オプション）
bundle install
bundle exec fastlane test

# シミュレーター用ビルド
bundle exec fastlane build_simulator
```

### デバッグ
- 実機2台でのテストを推奨
- シミュレーター同士では正常に動作しない場合があります

## 📄 ライセンス

このプロジェクトはMITライセンスの下で公開されています。

## 🤝 コントリビューション

1. このリポジトリをフォーク
2. 機能ブランチを作成 (`git checkout -b feature/amazing-feature`)
3. 変更をコミット (`git commit -m 'Add amazing feature'`)
4. ブランチにプッシュ (`git push origin feature/amazing-feature`)
5. プルリクエストを作成

## 📞 サポート

問題や質問がある場合は、[Issues](https://github.com/yourusername/bluetooth-tic-tac-toe-ios/issues)でお知らせください。

---

**Enjoy playing Bluetooth Tic-Tac-Toe! 🎉**