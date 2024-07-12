import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path_provider/path_provider.dart';

// References: https://betterprogramming.pub/the-minimum-guide-for-using-google-drive-api-with-flutter-9207e4cb05ba
class GoogleDriveService {
  GoogleSignInAccount? account;
  final String _folderName = "pocketkeeper_backup";
  final String _fileName = "pocketkeeper_backup.json";

  GoogleDriveService();

  Future<bool> uploadFile(File file) async {
    final googleSignIn =
        GoogleSignIn.standard(scopes: [drive.DriveApi.driveScope]);
    account = await googleSignIn.signIn();

    if (account == null) {
      log("User account is null");
      return false;
    }

    // Authenticate
    final authHeaders = await account!.authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders);
    final driveApi = drive.DriveApi(authenticateClient);

    // Check if folder exists
    String? folderId = await _getFolderId(driveApi, _folderName);

    // If folder doesn't exist, create it
    folderId ??= await _createFolder(driveApi, _folderName);

    // Create media for upload
    var driveFile = drive.File();

    // Check if file already exists
    driveFile.name = _fileName;
    String? existingFileId = await _findExistingFileId(
      driveApi,
      driveFile.name!,
      folderId,
    );

    driveFile.mimeType = "application/json";
    driveFile.description = "PocketKeeper backup";

    final drive.Media media = convertFileToMedia(file);

    // Upload
    drive.File result;

    if (existingFileId != null) {
      // Update existing file
      result = await driveApi.files.update(
        driveFile,
        existingFileId,
        uploadMedia: media,
        addParents: folderId,
      );
      log('File updated. ID: ${result.id}');
    } else {
      // Create new file
      driveFile.parents = [folderId];
      result = await driveApi.files.create(driveFile, uploadMedia: media);
      log('New file created. ID: ${result.id}');
    }

    return true;
  }

  Future<String?> _getFolderId(
      drive.DriveApi driveApi, String folderName) async {
    final response = await driveApi.files.list(
      q: "mimeType='application/vnd.google-apps.folder' and name='$folderName' and trashed=false",
      spaces: 'drive',
    );

    if (response.files!.isNotEmpty) {
      return response.files!.first.id;
    }
    return null;
  }

  Future<String> _createFolder(
      drive.DriveApi driveApi, String folderName) async {
    var folder = drive.File();
    folder.name = folderName;
    folder.mimeType = 'application/vnd.google-apps.folder';
    final result = await driveApi.files.create(folder);
    return result.id!;
  }

  drive.Media convertFileToMedia(File file) {
    return drive.Media(file.openRead(), file.lengthSync());
  }

  Future<String?> _findExistingFileId(
      drive.DriveApi driveApi, String fileName, String folderId) async {
    final response = await driveApi.files.list(
      q: "name='$fileName' and '$folderId' in parents and trashed=false",
      spaces: 'drive',
      $fields: 'files(id, name)',
    );

    if (response.files != null && response.files!.isNotEmpty) {
      return response.files!.first.id;
    }
    return null;
  }

  Future<String?> downloadFile() async {
    final googleSignIn =
        GoogleSignIn.standard(scopes: [drive.DriveApi.driveScope]);
    account = await googleSignIn.signIn();

    if (account == null) {
      log("User account is null");
      return null;
    }

    // Authenticate
    final authHeaders = await account!.authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders);
    final driveApi = drive.DriveApi(authenticateClient);

    // Check if folder exists
    String? folderId = await _getFolderId(driveApi, _folderName);

    if (folderId == null) {
      log("Folder not found");
      return null;
    }

    // Check if file exists
    String? fileId = await _findExistingFileId(driveApi, _fileName, folderId);

    if (fileId == null) {
      log("File not found");
      return null;
    }

    // Download file
    final drive.Media file = (await driveApi.files.get(
      fileId,
      downloadOptions: drive.DownloadOptions.fullMedia,
    )) as drive.Media;

    // Save file to temporary directory
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/$_fileName';
    final fileStream = File(filePath).openWrite();

    int totalBytes = 0;
    await for (final chunk in file.stream) {
      fileStream.add(chunk);
      totalBytes += chunk.length;

      // Progress indication
      log('Downloaded $totalBytes bytes');
    }

    await fileStream.flush();
    await fileStream.close();
    log('File downloaded to: $filePath');

    // Read file
    final fileContent = await File(filePath).readAsString();
    // log('File content: $fileContent');

    // Delete the temporary file
    await File(filePath).delete();

    return fileContent;
  }
}

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;

  final http.Client _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}
