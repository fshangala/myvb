import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myvb/core/datatypes/model.dart';
import 'package:myvb/core/datatypes/transaction_token.dart';
import 'package:xml/xml.dart';

class Dpogroup {
  bool test = true;
  String companyToken = "8D3DA73D-9D7F-4E09-96D4-3D44E7A83EA3";
  String redirectUrl = "";
  String backUrl = "";
  Uri url = Uri.parse('https://secure.3gdirectpay.com/API/v6/');
  Map<String, String> headersList = {
    'Accept': 'application/xml',
    'Content-Type': 'application/xml'
  };

  Future<XmlDocument?> getResponse(http.StreamedResponse res) async {
    if (res.statusCode >= 200 && res.statusCode < 300) {
      var responseText = await res.stream.bytesToString();
      return XmlDocument.parse(responseText);
    } else {
      return null;
    }
  }

  Future<TransactionToken?> createToken({
    required String bankingGroupId,
    required String userId,
    required double amount,
    required String email,
    required String type,
  }) async {
    if (test) {
      var transactionToken = TransactionToken().create(
        TransactionTokenModelArguments(
          bankingGroupId: bankingGroupId,
          userId: userId,
          email: email,
          type: type,
          token: UniqueKey().toString(),
          amount: amount,
          issuedAt: DateTime.now(),
          timestamp: DateTime.now(),
        ),
      );
      return await transactionToken.save();
    }

    var body = '''<?xml version="1.0" encoding="utf-8"?>
    <API3G>
        <CompanyToken>$companyToken</CompanyToken>
        <Request>createToken</Request>
        <Transaction>
            <PaymentAmount>$amount</PaymentAmount>
            <PaymentCurrency>ZMW</PaymentCurrency>
            <CompanyRef>49FKEOA</CompanyRef>
            <RedirectURL>$redirectUrl</RedirectURL>
            <BackURL>$backUrl</BackURL>
            <CompanyRefUnique>0</CompanyRefUnique>
            <PTL>5</PTL>
            <customerEmail>$email</customerEmail>
            <EmailTransaction>1</EmailTransaction>
        </Transaction>
        <Services>
            <Service>
                <ServiceType>5525</ServiceType>
                <ServiceDescription>Flight from Nairobi to Diani</ServiceDescription>
                <ServiceDate>2013/12/20 19:00</ServiceDate>
            </Service>
        </Services>
    </API3G>''';

    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = body;

    var res = await req.send();
    var responseDocument = await getResponse(res);
    if (responseDocument == null) {
      return null;
    } else {
      var transactionToken = TransactionToken().create(
        TransactionTokenModelArguments(
          bankingGroupId: bankingGroupId,
          userId: userId,
          email: email,
          type: type,
          token:
              responseDocument.findAllElements("TransToken").single.innerText,
          amount: amount,
          issuedAt: DateTime.now(),
          timestamp: DateTime.now(),
        ),
      );
      return await transactionToken.save();
    }
  }

  Future<XmlDocument?> chargeTokenMobile({
    required String token,
    required String phoneNumber,
    required String mobileNumberOperator,
  }) async {
    if (test) {
      var response = '''<?xml version="1.0" encoding="utf-8"?>
<API3G>
  <StatusCode>130</StatusCode>
  <ResultExplanation>New invoice</ResultExplanation>
  <RedirectOption>0</RedirectOption>
</API3G>''';
      return XmlDocument.parse(response);
    }

    var headersList = {
      'Accept': 'application/xml',
      'Content-Type': 'application/xml'
    };
    var url = Uri.parse('https://secure.3gdirectpay.com/API/v6/');

    var body = '''<?xml version="1.0" encoding="UTF-8"?>
    <API3G>
      <CompanyToken>$companyToken</CompanyToken>
      <Request>ChargeTokenMobile</Request>
      <TransactionToken>$token</TransactionToken>
      <PhoneNumber>$phoneNumber</PhoneNumber>
      <MNO>$mobileNumberOperator</MNO>
      <MNOcountry>Zambia</MNOcountry>
    </API3G>''';

    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = body;

    var res = await req.send();
    return await getResponse(res);
  }

  Future<XmlDocument?> verifyTransactionToken({
    required String token,
  }) async {
    var transactionToken = await TransactionToken()
        .getObject(QueryBuilder().where("token", token));
    if (test && transactionToken != null) {
      transactionToken.paid = true;
      await transactionToken.save();
      var response = '''<?xml version="1.0" encoding="utf-8"?>
<API3G>
  <Result>000</Result>
  <ResultExplanation>Transaction paid</ResultExplanation>
  <CustomerName >John Doe</CustomerName >
  <CustomerCredit>4432</CustomerCredit>
  <TransactionApproval>938204312</TransactionApproval>
  <TransactionCurrency>ZMW</TransactionCurrency>
  <TransactionAmount>${transactionToken.amount.toString()}</TransactionAmount>
  <FraudAlert>000</FraudAlert>
  <FraudExplnation>No Fraud detected</FraudExplnation>
  <TransactionNetAmount>${(transactionToken.amount - 5).toString()}</TransactionNetAmount>
  <TransactionSettlementDate>${DateTime.now()}</TransactionSettlementDate>
  <TransactionRollingReserveAmount>5</TransactionRollingReserveAmount>
  <TransactionRollingReserveDate>${DateTime.now()}</TransactionRollingReserveDate>
  <CustomerPhone>254123456789</CustomerPhone>
  <CustomerCountry>ZM</CustomerCountry>
  <CustomerAddress>Stranfe blvd.</CustomerAddress>
  <CustomerCity>Nairobi</CustomerCity>
  <CustomerZip>AH1</CustomerZip>
  <MobilePaymentRequest>Sent</MobilePaymentRequest>
  <AccRef>ABC123REF</AccRef>
</API3G>''';
      return XmlDocument.parse(response);
    }

    var headersList = {
      'Accept': 'application/xml',
      'Content-Type': 'application/xml'
    };
    var url = Uri.parse('https://secure.3gdirectpay.com/API/v6/');

    var body = '''<?xml version="1.0" encoding="utf-8"?>
    <API3G>
      <CompanyToken>$companyToken</CompanyToken>
      <Request>verifyToken</Request>
      <TransactionToken>$token</TransactionToken>
    </API3G>''';

    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = body;

    var res = await req.send();
    var document = await getResponse(res);
    if (document == null) {
      return null;
    } else {
      var resResult = document.findAllElements("Result").single.innerText;
      if (resResult == "000") {
        transactionToken!.paid = true;
        await transactionToken.save();
      }
      return document;
    }
  }
}
