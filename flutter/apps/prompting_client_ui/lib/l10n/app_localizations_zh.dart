// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get securityCenterInfo => '您随时可以在 <安全中心> 中更改这些权限';

  @override
  String promptAccessMoreOptionsTitle(String snap) {
    return '将授予 $snap 的权限应用于：';
  }

  @override
  String promptAccessTitle(String snap, String permission) {
    return '为 $snap 授予 $permission 权限：';
  }

  @override
  String get promptActionOptionAllow => '允许';

  @override
  String get promptActionOptionAllowAlways => '总是允许';

  @override
  String get promptActionOptionAllowOnce => '允许一次';

  @override
  String get promptActionOptionDeny => '拒绝';

  @override
  String get promptActionOptionDenyOnce => '拒绝一次';

  @override
  String get promptActionOptionAllowUntilLogout => 'Allow until logout';

  @override
  String get promptActionTitle => '动作';

  @override
  String get promptLifespanOptionForever => '始终';

  @override
  String get promptLifespanOptionSession => '直到注销';

  @override
  String get promptLifespanOptionSingle => '仅一次';

  @override
  String get promptLifespanTitle => '时效';

  @override
  String get promptSaveAndContinue => '保存并继续';

  @override
  String get promptTitle => '安全性通知';

  @override
  String get homePatternInfo => '<了解路径样式>';

  @override
  String get homePatternTypeCustomPath => '自定义路径';

  @override
  String get homePatternTypeRequestedDirectory => '仅请求的文件夹';

  @override
  String get homePatternTypeRequestedFile => '仅请求的文件';

  @override
  String homePatternTypeTopLevelDirectory(String topLevelDir) {
    return '$topLevelDir 文件夹内的所有内容';
  }

  @override
  String get homePatternTypeRequestedDirectoryContents => '文件夹内的所有内容';

  @override
  String get homePatternTypeContainingDirectory => '文件夹内的所有内容';

  @override
  String get homePatternTypeHomeDirectory => '主文件夹中的所有内容';

  @override
  String homePatternTypeMatchingFileExtension(String fileExtension) {
    return '所有 $fileExtension 文件';
  }

  @override
  String homePromptDefaultBody(String snap, String permissions, String path) {
    return '$snap 想获取对 $path 的 $permissions 权限';
  }

  @override
  String homePromptTopLevelDirBody(
      String snap, String permissions, String foldername) {
    return '$snap 想获取对 $foldername 的 $permissions 权限。';
  }

  @override
  String homePromptTopLevelDirFileBody(
      String snap, String permissions, String filename, String foldername) {
    return '$snap 想获取对 $foldername 文件夹中 $filename 的 $permissions 权限。';
  }

  @override
  String homePromptHomeDirBody(String snap, String permissions) {
    return '$snap 想获取对您主文件夹的 $permissions 访问权限。';
  }

  @override
  String homePromptHomeDirFileBody(
      String snap, String permissions, String filename) {
    return '$snap 想获取对您主文件夹中 $filename 的 $permissions 权限。';
  }

  @override
  String get homePromptMetaDataTitle => '关于此应用';

  @override
  String homePromptMetaDataPublishedBy(String publisher) {
    return '由 $publisher 发行';
  }

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return '最后更新日期为 $date';
  }

  @override
  String get homePromptMoreOptionsLabel => '更多选项…';

  @override
  String get homePromptMetaDataAppCenterLink => '访问应用中心页面';

  @override
  String homePromptSuggestedPermission(String permission) {
    return '同时授予 $permission 权限';
  }

  @override
  String get homePromptPermissionsTitle => '权限';

  @override
  String get homePromptPermissionsRead => '读取';

  @override
  String get homePromptPermissionsWrite => '写入';

  @override
  String get homePromptPermissionsExecute => '执行';

  @override
  String get homePromptErrorUnknownTitle => '出现了一些问题';

  @override
  String cameraPromptBody(String snapName) {
    return 'Allow $snapName to access your camera?';
  }

  @override
  String microphonePromptBody(String snapName) {
    return 'Allow $snapName to access your microphone?';
  }
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get securityCenterInfo => '您可以隨時在<安全中心>中變更這些權限';

  @override
  String promptAccessMoreOptionsTitle(String snap) {
    return '設定 $snap 的存取權限為：';
  }

  @override
  String promptAccessTitle(String snap, String permission) {
    return '允許 $snap $permission 權限存取：';
  }

  @override
  String get promptActionOptionAllow => '允許';

  @override
  String get promptActionOptionAllowAlways => '總是允許';

  @override
  String get promptActionOptionAllowOnce => '允許一次';

  @override
  String get promptActionOptionDeny => '拒絕';

  @override
  String get promptActionOptionDenyOnce => '拒絕一次';

  @override
  String get promptActionTitle => '動作';

  @override
  String get promptLifespanOptionForever => '總是';

  @override
  String get promptLifespanOptionSession => '直到登出';

  @override
  String get promptLifespanOptionSingle => '一次';

  @override
  String get promptLifespanTitle => '持續時間';

  @override
  String get promptSaveAndContinue => '儲存並繼續';

  @override
  String get promptTitle => '安全性通知';

  @override
  String get homePatternInfo => '<了解路徑樣式>';

  @override
  String get homePatternTypeCustomPath => '自訂路徑樣式';

  @override
  String get homePatternTypeRequestedDirectory => '僅請求的資料夾';

  @override
  String get homePatternTypeRequestedFile => '僅請求的檔案';

  @override
  String homePatternTypeTopLevelDirectory(String topLevelDir) {
    return '$topLevelDir 資料夾中的所有內容';
  }

  @override
  String get homePatternTypeRequestedDirectoryContents => '資料夾中的所有內容';

  @override
  String get homePatternTypeContainingDirectory => '資料夾中的所有內容';

  @override
  String get homePatternTypeHomeDirectory => '家目錄中的所有內容';

  @override
  String homePatternTypeMatchingFileExtension(String fileExtension) {
    return '所有 $fileExtension 檔案';
  }

  @override
  String homePromptDefaultBody(String snap, String permissions, String path) {
    return '$snap 想要取得對 $path 的 $permissions 存取權限';
  }

  @override
  String homePromptTopLevelDirBody(
      String snap, String permissions, String foldername) {
    return '$snap 想要取得 $foldername 資料夾的 $permissions 存取權限。';
  }

  @override
  String homePromptTopLevelDirFileBody(
      String snap, String permissions, String filename, String foldername) {
    return '$snap 想要取得 $foldername 資料夾中 $filename 的 $permissions 存取權限。';
  }

  @override
  String homePromptHomeDirBody(String snap, String permissions) {
    return '$snap 想要取得您「家目錄」的 $permissions 存取權限。';
  }

  @override
  String homePromptHomeDirFileBody(
      String snap, String permissions, String filename) {
    return '$snap 想要取得您家目錄中 $filename 的 $permissions 存取權限。';
  }

  @override
  String get homePromptMetaDataTitle => '關於此應用程式';

  @override
  String homePromptMetaDataPublishedBy(String publisher) {
    return '由 $publisher 發布';
  }

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return '最後更新日期為 $date';
  }

  @override
  String get homePromptMoreOptionsLabel => '更多選項...';

  @override
  String get homePromptMetaDataAppCenterLink => '造訪《應用中心》頁面';

  @override
  String homePromptSuggestedPermission(String permission) {
    return '同時給予$permission存取權限';
  }

  @override
  String get homePromptPermissionsTitle => '權限';

  @override
  String get homePromptPermissionsRead => '讀取';

  @override
  String get homePromptPermissionsWrite => '寫入';

  @override
  String get homePromptPermissionsExecute => '執行';

  @override
  String get homePromptErrorUnknownTitle => '發生一些問題';
}
