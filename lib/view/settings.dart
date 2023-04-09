import 'package:flutter/material.dart';
import 'package:testapp/component/right_drawer.dart';
import 'package:testapp/view/budget_page.dart';

class settingspage extends StatefulWidget {
  const settingspage({Key? key}) : super(key: key);

  @override
  State<settingspage> createState() => _settingspageState();
}

class _settingspageState extends State<settingspage> {
  // this is added for the drawer later on
  int _selectedIndex = 2;

  // list of currenvies
  String _selectedCurrency = "JD (JOD)";
  List<String> _currencies = [
    'JD (JOD) - Jordanian Dinar',
    '\$ (USD) - US Dollar',
    '€ (EUR) - Euro',
    '£ (GBP) - British Pound',
    '¥ (JPY) - Japanese Yen',
    '\$ (CAD) - Canadian Dollar',
    'Fr (CHF) - Swiss Franc',
    '\$ (AUD) - Australian Dollar',
    '¥ (CNY) - Chinese Yuan Renminbi',
    '\$ (NZD) - New Zealand Dollar',
    '\$ (HKD) - Hong Kong Dollar',
    'R (ZAR) - South African Rand',
    'kr (SEK) - Swedish Krona',
    '₩ (KRW) - South Korean Won',
    '\$ (SGD) - Singapore Dollar',
    '₹ (INR) - Indian Rupee',
    '\$ (MXN) - Mexican Peso',
    'BD (BHD) - Bahraini Dinar',
    '₽ (RUB) - Russian Ruble',
    'DH (AED) - United Arab Emirates Dirham',
    'R\$ (BRL) - Brazilian Real',
    'Kč (CZK) - Czech Koruna',
    'kr (DKK) - Danish Krone',
    'kn (HRK) - Croatian Kuna',
    'Ft (HUF) - Hungarian Forint',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SettingsPage(),
    );
  }

  Widget SettingsPage() {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(image: AssetImage("assets/images/background-cropped.jpg"),fit: BoxFit.fill,opacity: 0.5)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 20),
            child: IconButton(
                onPressed: () {
                      Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  size: 40,
                )),
          ),
          //SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 100, left: 50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Settings",
                  style: TextStyle(
                      fontSize: 50,
                      fontFamily: 'K2D',
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 50,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "User Prefernces",
                      style: TextStyle(fontSize: 20, fontFamily: 'K2D'),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),

                        color: Colors.white,
                      ),
                      width: 300,
                      height: 170,
                      child: Column(
                        children: [
                          SizedBox(height: 20,),
                          ListTile(
                            leading: Icon(Icons.attach_money, size: 30),
                            title: Text('Currency',style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'K2D',)),
                            trailing: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('${_selectedCurrency}', style: TextStyle(fontSize: 15,color: Colors.grey)), // Placeholder for selected value
                                    SizedBox(width: 10,),
                                    Icon(Icons.arrow_forward_ios,size: 20,),
                                  ]),
                            ),

                            // here when tapped on arrow currency dropsheet pops up
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                builder: (BuildContext context) {
                                  return Container(
                                    height: 400,
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    child: ListView.builder(
                                      itemCount: _currencies.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        final currencyParts = _currencies[index].split(' - ');
                                        final currencyCode = currencyParts[0];
                                        final currencyName = currencyParts[1];
                                        return Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 16),
                                          child: ListTile(
                                            title: Text(
                                              currencyCode,
                                              style: TextStyle(
                                                fontSize: 22,
                                              ),
                                            ),
                                            subtitle: Text(
                                              currencyName,
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                            trailing: _selectedCurrency == currencyCode
                                                ? Icon(Icons.check, color: Colors.green)
                                                : null,
                                            onTap: () {
                                              setState(() {
                                                _selectedCurrency = currencyCode;
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          ),

                          Divider(
                            height: 10,thickness: 1,indent: 30,endIndent: 30,
                          ),
                          ListTile(
                            leading: Icon(Icons.language, size: 30),
                            title: Text('Language',style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'K2D',)),
                            trailing: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('EN', style: TextStyle(fontSize: 15,color: Colors.grey)), // Placeholder for selected value
                                    SizedBox(width: 10,),
                                    Icon(Icons.arrow_forward_ios,size: 20,),
                                  ]),
                            ),
                            onTap: () {
                              // TODO: Navigate to the currency selection page.

                            },
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

}
