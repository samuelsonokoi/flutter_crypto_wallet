import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_wallet/net/api_methods.dart';
import 'package:crypto_wallet/net/flutterfire.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'add_view.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Stream<QuerySnapshot> _coinsStream = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('coins')
      .snapshots(includeMetadataChanges: true);

  // define defaults for currencies
  double bitcoin = 0.0;
  String bitcoinImg =
      'https://assets.coingecko.com/coins/images/5/thumb/dogecoin.png?1547792256';
  double ethereum = 0.0;
  String ethereumImg = '';
  double tether = 0.0;
  String tetherImg = '';
  double dogecoin = 0.0;
  String dogecoinImg = '';

  @override
  void initState() {
    getValues();
    getImages();
  }

  getValues() async {
    bitcoin = await getPrice('bitcoin');
    ethereum = await getPrice('ethereum');
    tether = await getPrice('tether');
    dogecoin = await getPrice('dogecoin');
    setState(() {});
  }

  getImages() async {
    bitcoinImg = await getImage('bitcoin');
    ethereumImg = await getImage('ethereum');
    tetherImg = await getImage('tether');
    dogecoinImg = await getImage('dogecoin');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getValue(String id, double amount) {
      if (id == 'bitcoin') {
        return bitcoin * amount;
      } else if (id == 'ethereum') {
        return ethereum * amount;
      } else if (id == 'tether') {
        return tether * amount;
      } else if (id == 'dogecoin') {
        return dogecoin * amount;
      }
    }

    getCoinImage(String id) {
      if (id == 'bitcoin') {
        return bitcoinImg;
      } else if (id == 'ethereum') {
        return ethereumImg;
      } else if (id == 'tether') {
        return tetherImg;
      } else if (id == 'dogecoin') {
        return dogecoinImg;
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: StreamBuilder<QuerySnapshot>(
              // get coins from user collections
              stream: _coinsStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                // display error
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                // show a spinner if the data is not available
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return new ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot doc) {
                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;
                    return new ListTile(
                      title: new Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 15.0,
                            height: MediaQuery.of(context).size.height / 35.0,
                            child: Image.network(
                              getCoinImage(doc.id).toString(),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Coin: ${doc.id}"),
                          IconButton(
                            onPressed: () async {
                              await removeCoin(doc.id);
                            },
                            icon: Icon(
                              Icons.remove_circle_outline_sharp,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      subtitle: new Text(
                        "Amount Owned: \₦${getValue(doc.id, data['amount'])!.toStringAsFixed(2)}",
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddView(),
            ),
          ),
        },
        label: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
