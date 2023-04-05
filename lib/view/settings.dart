import 'package:flutter/material.dart';

class settingspage extends StatefulWidget {
  const settingspage({Key? key}) : super(key: key);

  @override
  State<settingspage> createState() => _settingspageState();
}

class _settingspageState extends State<settingspage> {
  // this is added for the drawer later on
  int _selectedIndex = 2;

  // list of currenvies
  String _selectedCurrency = "\$ (USD)";
  List<String> _currencies = [
    '\$ (USD) - US Dollar',
    '€ (EUR) - Euro',
    '£ (GBP) - British Pound',
    '¥ (JPY) - Japanese Yen',
    '\$ (CAD) - Canadian Dollar',
    '\$ (AUD) - Australian Dollar',
    'Fr (CHF) - Swiss Franc',
    '¥ (CNY) - Chinese Yuan Renminbi',
    'лв (BGN) - Bulgarian Lev',
    'R\$ (BRL) - Brazilian Real',
    'Kč (CZK) - Czech Koruna',
    'kr (DKK) - Danish Krone',
    '\$ (HKD) - Hong Kong Dollar',
    'kn (HRK) - Croatian Kuna',
    'Ft (HUF) - Hungarian Forint',
    '₹ (INR) - Indian Rupee',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SettingsPage(),
    );
  }

  Widget SettingsPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // IconButton(
        // icon: Icon(Icons.arrow_back),
        // onPressed: () {
        // Navigator.pop(context);
        // },

        Padding(
          padding: const EdgeInsets.only(top: 50, left: 20),
          child: IconButton(
              onPressed: () => Navigator.pop(context),
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
                            // TODO: Navigate to the currency selection page.
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
    );
  }


  //TODO:Use this instead of repeating code! waiting for db
  ListTile CardBuilder(Icon settingsicon, String Title,MaterialPageRoute newpage){
    return ListTile(
      leading: settingsicon,
      title: Text("${Title}",style: TextStyle(
        fontSize: 20,
        fontFamily: 'K2D',)),
      trailing: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              //TODO:set current selected value
              Text('EN', style: TextStyle(fontSize: 15,color: Colors.grey)), // Placeholder for selected value
              SizedBox(width: 10,),
              Icon(Icons.arrow_forward_ios,size: 20,),
            ]),
      ),
      onTap: () {
        // TODO: Navigate to the currency selection page.
      },
    );
  }

}
