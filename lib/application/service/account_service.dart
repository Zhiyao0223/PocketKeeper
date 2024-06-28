import 'package:pocketkeeper/application/member_cache.dart';
import 'package:pocketkeeper/application/model/money_account.dart';
import 'package:pocketkeeper/application/service/objectbox_service.dart';

class AccountService extends ObjectboxService<Accounts> {
  AccountService() : super(MemberCache.objectBox!.store, Accounts);

  List<Accounts> getAllActiveAccounts() {
    final List<Accounts> accounts = getAll();
    return accounts.where((Accounts account) => account.status == 0).toList();
  }
}
