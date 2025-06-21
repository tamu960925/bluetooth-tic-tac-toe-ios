# GitHub Actions セットアップガイド

このプロジェクトはGitHub Actionsを使用してiOSアプリの自動ビルドをサポートしています。

## 基本ビルド（シミュレーター用）

証明書なしでシミュレーター用のビルドを実行できます。プッシュまたはプルリクエスト時に自動実行されます。

## リリースビルド（実機用）

実機用のビルドを行うには、以下のSecrets設定が必要です：

### 必要なSecrets

GitHubリポジトリの Settings > Secrets and variables > Actions で以下を設定：

1. **BUILD_CERTIFICATE_BASE64**
   - Apple Developer Certificateの.p12ファイルをBase64エンコードした値
   - 作成方法：`base64 -i certificate.p12 | pbcopy`

2. **P12_PASSWORD**
   - .p12ファイルのパスワード

3. **BUILD_PROVISION_PROFILE_BASE64**
   - Provisioning Profileの.mobileprovisionファイルをBase64エンコードした値
   - 作成方法：`base64 -i profile.mobileprovision | pbcopy`

4. **KEYCHAIN_PASSWORD**
   - CI用キーチェーンのパスワード（任意の文字列）

### 証明書とプロビジョニングプロファイルの準備

1. **Apple Developer Certificate**
   - Apple Developer Programに登録
   - Xcode > Preferences > Accounts でチーム追加
   - 開発用証明書をキーチェーンからエクスポート

2. **Provisioning Profile**
   - Apple Developer Portalでプロビジョニングプロファイル作成
   - Bundle Identifier: `com.example.BluetoothTicTacToe`
   - 必要なCapabilities: Local Networking

3. **ExportOptions.plist の更新**
   - `TEAM_ID_PLACEHOLDER` を実際のTeam IDに置換

### 設定例

```bash
# 証明書をBase64エンコード
base64 -i Certificates.p12 | pbcopy

# プロビジョニングプロファイルをBase64エンコード  
base64 -i BluetoothTicTacToe_Development.mobileprovision | pbcopy
```

## ワークフロー

- **プッシュ/PR**: シミュレーター用ビルドとテスト実行
- **mainブランチ**: リリースビルド（署名付き）
- **アーティファクト**: ビルド結果を30-90日間保存

## トラブルシューティング

### よくある問題

1. **Code signing error**
   - 証明書とプロビジョニングプロファイルの設定を確認
   - Team IDが正しく設定されているか確認

2. **Build failed**
   - Xcode versionが最新かチェック
   - プロジェクト設定でiOS deployment targetを確認

3. **Test failures**  
   - シミュレーターでのテスト実行に失敗する場合がある
   - 必要に応じてテストを無効化またはスキップ

### ログ確認

GitHub Actions > Actions タブでビルドログを確認できます。