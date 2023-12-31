import 'package:adjeminpay_flutter_sdk/adjeminpay_flutter_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "lib/.env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: Colors.green,
            secondary: Colors.blue[500]
        ),
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  var uuid = const Uuid();
  
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async {

          final String merchantTransId = uuid.v4().split('-').last;
          print("merchantTransId => $merchantTransId");

          final GatewayTransaction? result = await Navigator.push(context,
              MaterialPageRoute(builder: (context)=> OperatorPickerWidget(
                clientId: dotenv.env['CLIENT_ID']!,
                clientSecret: dotenv.env['CLIENT_SECRET']!,
                title: 'Payer une commande',
                description: 'Paiement Facture',
                amount: 100,
                currencyCode: "XOF",
                merchantTransactionId: merchantTransId,
                webhookUrl:"https://your-webhook-url/v1/customers/payments/callback",
                returnUrl:"https://your-return-url",
                cancelUrl:"https://your-cancel-url",
                isPayIn: true,
                countryCode: Country.CI,
                customer: const Customer(
                    firstName: "Paul",
                    lastName: "Koffi",
                    dialCode: "225",
                    phoneNumber: "0500000000",
                    email: "paulkoffi@gmail.com"
                ),
              ))
          );

          if(result != null){

            print("Payment result =>>  $result");

            displayErrorMessage(context, "${result.merchantTransId} ${result.status}", (){

            });

          }else{

          }
        },
        child: const Icon(Icons.add),

      ),
    );
  }

  displayErrorMessage(BuildContext context, String message, Function() action){
    showModalBottomSheet(context: context, builder: (ctext){
      return Container(
        padding: const EdgeInsets.all(16.0),
        height: 200,
        color: Colors.white,
        child: Column(
          children: [

            Container(
              child: Text("Message",style: Theme.of(context).textTheme.headline6),
            ),
            const SizedBox(height: 20,),
            Container(
              child: Text(message,style: Theme.of(context).textTheme.bodyText1),
            ),
            const SizedBox(height: 20,),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: ElevatedButton(
                onPressed: (){
                  Navigator.of(ctext).pop();
                  action();
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondary),
                    textStyle: MaterialStateProperty.all(Theme.of(context).textTheme.button?.copyWith(
                        color: Colors.white,
                        fontSize: 19
                    ))
                ),
                child:const Text("D'accord",) ,
              ),
            ),

          ],
        ),
      );
    });
  }
}

