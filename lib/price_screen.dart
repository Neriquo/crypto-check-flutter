import 'package:bitcoin_ticker/coin_data.dart'; // Importe notre classe de données pour l'API
import 'package:flutter/material.dart';

// Widget avec état pour l'écran principal des prix des crypto-monnaies
class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  // --------- VARIABLES D'ÉTAT ---------

  // Devise sélectionnée par défaut
  String selectedCurrency = 'USD';

  // Index de la devise sélectionnée dans la liste
  int selectedCurrencyIndex = currenciesList.indexOf('USD');

  // Map pour stocker les prix des crypto-monnaies (clé: symbole crypto, valeur: prix formaté)
  Map<String, String> cryptoPrices = {};

  // Indicateur de chargement des données
  bool isLoading = false;

  // Contrôleur pour le PageView (carousel de devises)
  final PageController _pageController = PageController(
    // Commence à l'index de USD dans la liste des devises
    initialPage: currenciesList.indexOf('USD'),
    // Taille de viewport pour permettre de voir les devises adjacentes
    viewportFraction: 0.3,
  );

  // --------- MÉTHODES DE CYCLE DE VIE ---------

  @override
  void initState() {
    super.initState();
    // Récupère les données dès le chargement de l'écran
    getData();
  }

  @override
  void dispose() {
    // Libère le contrôleur lors de la destruction du widget
    _pageController.dispose();
    super.dispose();
  }

  // --------- RÉCUPÉRATION DES DONNÉES ---------

  // Méthode pour récupérer les données de l'API
  void getData() async {
    // Active l'indicateur de chargement
    setState(() {
      isLoading = true;
    });

    try {
      // Crée une instance de CoinData (notre classe qui gère l'API)
      CoinData coinData = CoinData();

      // Récupère les taux de change pour toutes les crypto-monnaies
      Map<String, double> rates = await coinData.getAllCoinRates(selectedCurrency);

      // Met à jour l'état avec les nouveaux prix formatés à 2 décimales
      setState(() {
        cryptoPrices = rates.map((crypto, rate) =>
            MapEntry(crypto, rate.toStringAsFixed(2))
        );
      });
    } catch (e) {
      // Affiche les erreurs dans la console
      print('Erreur: $e');
      // Ici, on pourrait ajouter une gestion d'erreur plus sophistiquée
      // comme afficher un message à l'utilisateur
    } finally {
      // Désactive l'indicateur de chargement quoi qu'il arrive
      setState(() {
        isLoading = false;
      });
    }
  }

  // --------- WIDGETS DE L'INTERFACE ---------

  // Widget pour créer la roulette de sélection de devise
  Widget currencyCarousel() {
    return Container(
      height: 80.0,
      child: PageView.builder(
        controller: _pageController,
        // Calcul du nombre d'éléments dans la liste
        itemCount: currenciesList.length,
        // Callback pour la sélection d'une nouvelle devise
        onPageChanged: (index) {
          setState(() {
            selectedCurrencyIndex = index;
            selectedCurrency = currenciesList[index];
            // Récupère de nouvelles données après changement de devise
            getData();
          });
        },
        // Construction de chaque élément de la roulette
        itemBuilder: (context, index) {
          // Vérification si la devise est celle sélectionnée
          bool isSelected = index == selectedCurrencyIndex;

          // Container animé qui change d'apparence selon la sélection
          return AnimatedContainer(
            // Durée de l'animation de transition
            duration: Duration(milliseconds: 200),
            // Style du conteneur
            decoration: BoxDecoration(
              // Couleur de fond différente pour l'élément sélectionné
              color: isSelected ? Colors.blue : Colors.transparent,
              // Bordure arrondie
              borderRadius: BorderRadius.circular(15),
            ),
            // Espacement autour du conteneur
            margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
            // Centrage du texte
            child: Center(
              child: Text(
                currenciesList[index],
                style: TextStyle(
                  // Taille du texte plus grande pour l'élément sélectionné
                  fontSize: isSelected ? 25.0 : 20.0,
                  // Texte en gras pour l'élément sélectionné
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  // Couleur du texte plus vive pour l'élément sélectionné
                  color: isSelected ? Colors.white : Colors.white70,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Méthode pour créer des cartes de prix pour chaque crypto-monnaie
  List<Widget> getCryptoCards() {
    // Liste qui contiendra les widgets de cartes
    List<Widget> cryptoCards = [];

    // Couleurs spécifiques pour chaque crypto-monnaie
    Map<String, Color> cryptoColors = {
      'BTC': Colors.orange,  // Orange pour Bitcoin
      'ETH': Colors.blue,    // Bleu pour Ethereum
      'LTC': Colors.grey,    // Gris pour Litecoin
    };

    // Crée une carte pour chaque crypto-monnaie dans la liste
    for (String crypto in cryptoList) {
      cryptoCards.add(
          Padding(
            // Espace autour de la carte
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              // Couleur de fond spécifique à la crypto, ou bleu par défaut
              color: cryptoColors[crypto] ?? Colors.blue,
              // Ombre de la carte
              elevation: 5.0,
              // Forme de la carte avec coins arrondis
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                // Espace à l'intérieur de la carte
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 28.0),
                // Disposition horizontale avec espace entre les éléments
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Symbole de la crypto-monnaie
                    Text(
                      crypto,
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    // Prix avec la devise sélectionnée
                    Text(
                      // Affiche "?" si le prix n'est pas disponible
                      '${cryptoPrices[crypto] ?? '?'} $selectedCurrency',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
      );
    }
    return cryptoCards;
  }

  // --------- CONSTRUCTION DE L'INTERFACE PRINCIPALE ---------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barre d'application en haut de l'écran
      appBar: AppBar(
        title: Text('Bitcoin Ticker'),
        actions: [
          // Bouton de rafraîchissement dans la barre d'app
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: getData, // Récupère les données lors du clic
          ),
        ],
      ),
      // Corps principal de l'application
      body: Column(
        // Répartition verticale des éléments
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // Étire les éléments sur toute la largeur
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Titre de la section
          Padding(
            padding: EdgeInsets.all(18.0),
            child: Text(
              'Cours du marché',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Zone principale : indicateur de chargement OU liste des crypto-monnaies
          isLoading
              ? Expanded(
            // Affiche un indicateur de chargement centré
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
              : Expanded(
            // Affiche la liste des cartes de crypto-monnaies
            child: ListView(
              children: getCryptoCards(),
            ),
          ),

          // Sélecteur de devise en bas de l'écran
          Container(
            height: 100.0,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 10.0),
            // Fond bleu semi-transparent
            color: Colors.blue.withOpacity(0.8),
            // Carousel de sélection des devises
            child: currencyCarousel(),
          ),
        ],
      ),
    );
  }
}