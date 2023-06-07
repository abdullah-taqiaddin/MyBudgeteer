// ignore_for_file: prefer_final_fields, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapp/view/budget_page.dart';
import 'package:testapp/main.dart';
import 'package:testapp/viewmodel/language_provider.dart';

import 'package:testapp/viewmodel/localization.dart';
import 'package:testapp/viewmodel/theme_provider.dart';


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
  String _selectedLanguage = "en";


  List<String> _languages = [
  'en - English',
  'ar - Arabic',
  ];

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

  bool isDarkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    isDarkModeEnabled = Provider.of<ThemeProvider>(context).isDark;
    _selectedLanguage = Provider.of<LanguageProvider>(context).language;

    return Scaffold(
      body: SettingsPage(),
    );
  }

  Widget SettingsPage() {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: isDark?Color.fromRGBO(43, 40, 57, 1):Colors.white,
        image: DecorationImage(image: isDark?AssetImage("assets/images/background-cropped-dark.jpg"):AssetImage("assets/images/background-cropped.jpg"),fit: BoxFit.fill,opacity: 0.3)
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
                  color: isDark?Colors.white:Colors.black,
                )),
          ),
          //SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 100, left: 50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${translation(context).settings}",
                  style: TextStyle(
                      color: isDark?Colors.white:Colors.black,
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
                      "${translation(context).userPreferences}",
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'K2D',
                          color: isDark?Colors.white:Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),

                        color: isDark?Color.fromRGBO(43, 40, 57, 1):Colors.white,
                      ),
                      width: 300,
                      height: 270,
                      child: Column(
                        children: [
                          SizedBox(height: 20,),
                          ListTile(
                            leading: Icon(Icons.attach_money, size: 30, color: isDark?Colors.white:Colors.blueGrey,),
                            title: Text('${translation(context).currency}',style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'K2D',
                                color: isDark?Colors.white:Colors.black,
                            )),
                            trailing: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('${_selectedCurrency}', style: TextStyle(fontSize: 15,color: Colors.grey)), // Placeholder for selected value
                                    SizedBox(width: 10,),
                                    Icon(Icons.arrow_forward_ios,size: 20,color: isDark?Colors.white:Colors.black,),
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
                                    color: isDark?Color.fromRGBO(43, 40, 57, 1):Colors.white,
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
                                                color: isDark?Colors.white:Colors.black,
                                              ),
                                            ),
                                            subtitle: Text(
                                              currencyName,
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: isDark?Colors.white:Colors.black,
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
                            leading: Icon(Icons.language, size: 30,color: isDark?Colors.white:Colors.blueGrey,),
                            title: Text('${translation(context).language}',style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'K2D',
                              color: isDark?Colors.white:Colors.black,
                            )),
                            trailing: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('${_selectedLanguage.toUpperCase()}', style: TextStyle(fontSize: 15,color: Colors.grey)), // Placeholder for selected value
                                    SizedBox(width: 10,),
                                    Icon(Icons.arrow_forward_ios,size: 20,color: isDark?Colors.white:Colors.black,),
                                  ]),
                            ),
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
                                    color: isDark?Color.fromRGBO(43, 40, 57, 1):Colors.white,
                                    height: 400,
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    child: ListView.builder(
                                      itemCount: _languages.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        final languageParts = _languages[index].split(' - ');
                                        final languageCode = languageParts[0];
                                        final languageName = languageParts[1];
                                        return Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 16),
                                          child: ListTile(
                                            title: Text(
                                              languageCode.toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 22,
                                                color: isDark?Colors.white:Colors.black,
                                              ),
                                            ),
                                            subtitle: Text(
                                              languageName,
                                              style: TextStyle(
                                                color: isDark?Colors.white:Colors.black,
                                                fontSize: 18,
                                              ),
                                            ),
                                            trailing: _selectedLanguage == languageCode
                                                ? Icon(Icons.check, color: Colors.green)
                                                : null,
                                            onTap: () {
                                              setState(() {
                                                _selectedLanguage = languageCode;
                                                if(_selectedLanguage != null){
                                                  Provider.of<LanguageProvider>(context, listen: false).setLanguage(_selectedLanguage);
                                                  MyApp.setLocale(context, Locale(_selectedLanguage));
                                                }
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
                        leading: Icon(Icons.dark_mode_sharp, size: 30, color: isDark?Colors.white:Colors.blueGrey,),
                        title: Text('${translation(context).darkMode}',style: TextStyle(
                          color: isDark?Colors.white:Colors.black,
                          fontSize: 20,
                          fontFamily: 'K2D',)),
                        trailing: Switch(
                          value: isDarkModeEnabled,
                          onChanged: (bool value) {
                            setState(() {
                              isDarkModeEnabled = !isDarkModeEnabled;
                              Provider.of<ThemeProvider>(context, listen: false).setTheme(isDarkModeEnabled);
                              MyApp.setTheme(context, isDarkModeEnabled);
                            });
                          },
                        ),
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
