# myvb

A village banking app

## Features
- Register
- Login, Logout
- Create banking group
- Join banking group
- List user banking groups
- Invest in banking group
- Request loan

### To Do
- research on calendar
- investment cycle
- joined banking groups not loading
- cannot view banking group member account
* get loan
* group member loans
* loan penalty
* curl -X POST https://secure.3gdirectpay.com/API/v6/ -H "Content-Type: application/xml" -H "Accept: application/xml" -d "<?xml version='1.0' encoding='utf-8'?><API3G><CompanyToken>57466282-EBD7-4ED5-B699-8659330A6996</CompanyToken><Request>createToken</Request><Transaction><PaymentAmount>450.00</PaymentAmount><PaymentCurrency>USD</PaymentCurrency><CompanyRef>49FKEOA</CompanyRef><RedirectURL>http://www.domain.com/payurl.php</RedirectURL><BackURL>http://www.domain.com/backurl.php </BackURL><CompanyRefUnique>0</CompanyRefUnique><PTL>5</PTL></Transaction><Services><Service><ServiceType>45</ServiceType><ServiceDescription>Flight from Nairobi to Diani</ServiceDescription><ServiceDate>2013/12/20 19:00</ServiceDate></Service></Services></API3G>"
* verify payment
<?xml version="1.0" encoding="utf-8"?>
<API3G>
  <CompanyToken>57466282-EBD7-4ED5-B699-8659330A6996</CompanyToken>
  <Request>verifyToken</Request>
  <TransactionToken>72983CAC-5DB1-4C7F-BD88-352066B71592</TransactionToken>
</API3G>