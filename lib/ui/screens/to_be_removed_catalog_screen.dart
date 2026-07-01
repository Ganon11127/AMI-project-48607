import 'package:flutter/material.dart';
import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:precached_network_image/precached_network_image.dart';
import '../../data/services/api/local_data_service.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  late Future<List<dynamic>> _cardsFuture;
  final LocalDataService _dataService = LocalDataService();

  // start pre‑caching once
  @override
  void initState() {
    super.initState();
    _loadCards();
    PrecachedNetworkImageManager.instance.precacheNetworkImages(isLog: true);
  }

  void _loadCards() {
    _cardsFuture = _dataService.loadCards(languageCode: ''); 
    PrecachedNetworkImageManager.instance.precacheNetworkImages(isLog: true);// English
  }

  Future<void> _refreshCards() async {
    final updated = await _dataService.updateLocalDb();
    if (updated) {
      _loadCards();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalog (testing)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _refreshCards(),
            tooltip: 'Check for updates',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshCards,
        child: FutureBuilder<List<dynamic>>(
          future: _cardsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No cards found'));
            }

            final cards = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: cards.length,
              itemBuilder: (context, index) {
                final card = cards[index];
                final imageUrl = card['card_images'][0]['image_url'] as String;
                final cardName = card['name'] as String;

                return Card(
                  elevation: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          memCacheWidth: 200,
                          memCacheHeight: 280,
                          placeholder: (_, _) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorBuilder: (_, _, _) => const Icon(
                            Icons.broken_image,
                            size: 50,
                          ),
                          fit: BoxFit.contain,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          cardName,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}