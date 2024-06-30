import 'package:flutter/material.dart';
import 'package:myvb/core/datatypes/banking_group.dart';
import 'package:myvb/core/datatypes/model.dart';
import 'package:myvb/core/datatypes/transaction_token.dart';
import 'package:myvb/core/extensions/auth_state.dart';
import 'package:myvb/core/functions/go_to.dart';
import 'package:myvb/core/widgets/app_scaffold.dart';
import 'package:myvb/core/widgets/not_null_future_renderer.dart';
import 'package:myvb/core/widgets/null_future_renderer.dart';
import 'package:myvb/pages/transaction_token.dart';

class TransactionTokensPage extends StatefulWidget {
  static const routeName = "/transaction-tokens-page";
  const TransactionTokensPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TransactionTokensPage();
  }
}

class _TransactionTokensPage extends AuthState<TransactionTokensPage> {
  Future<List<TransactionToken>> transactionTokensFuture = Future.value([]);

  @override
  Widget build(BuildContext context) {
    return userWidget((luser) {
      transactionTokensFuture = TransactionToken()
          .getObjects(QueryBuilder().where("userId", luser.id));
      return AppScaffold(
        title: "Transaction Tokens",
        onRefresh: () {
          setState(() {
            transactionTokensFuture = TransactionToken()
                .getObjects(QueryBuilder().where("userId", luser.id));
          });
        },
        children: [
          NotNullFutureRenderer(
            future: transactionTokensFuture,
            futureRenderer: (transactionTokens) {
              return Column(
                children: transactionTokens
                    .map((e) => ListTile(
                          title: Text(e.amount.toString()),
                          subtitle: NullFutureRenderer(
                            future: VBGroup().getObject(
                                QueryBuilder().where("id", e.bankingGroupId)),
                            futureRenderer: (vbGroup) {
                              return Text(vbGroup.name);
                            },
                          ),
                          trailing: const Icon(Icons.arrow_forward),
                          tileColor: Theme.of(context).colorScheme.background,
                          onTap: () {
                            goTo(
                              context: context,
                              routeName: TransactionTokenPage.routeName,
                              permanent: false,
                              arguments:
                                  TransactionTokenPageArguments(tokenId: e.id!),
                            );
                          },
                        ))
                    .toList(),
              );
            },
          ),
        ],
      );
    });
  }
}
