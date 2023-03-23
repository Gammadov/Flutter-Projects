import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'constants.dart' as Constants;

class HelloWorld extends StatelessWidget {
  const HelloWorld({super.key});

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Hello, world!"),
        ),
        body: Builder(builder: (context) {
          return SingleChildScrollView(
            child: Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                children: [
                  Picture(
                    onPressed: () =>
                        _launchInBrowser(Uri.parse(Constants.image_link)),
                  ),
                  SizedBox(height: 12),
                  Constants.caption(),
                  SizedBox(height: 16),
                  Constants.description(),
                  SizedBox(height: 16),
                  ReadFurtherButton(
                    onPressed: () => _launchInBrowser(Constants.wiki_article),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class Picture extends StatelessWidget {
  final VoidCallback? onPressed;
  const Picture({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => pictureInfo(context),
      child: Container(
        height: MediaQuery.of(context).size.width - 24 * 2,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.network(
          Constants.image_link,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  void pictureInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text(
            Constants.caption_text,
            style: TextStyle(fontSize: 18),
          ),
          children: [
            SimpleDialogOption(
              child: const Text('Image from ctftime.org:'),
            ),
            SimpleDialogOption(
              onPressed: onPressed,
              child: Text(
                Constants.image_link,
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ReadFurtherButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const ReadFurtherButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      child: Text('Read further on Wikipedia'),
    );
  }
}
