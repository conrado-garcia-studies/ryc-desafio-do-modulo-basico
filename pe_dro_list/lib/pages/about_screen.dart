import 'package:bulleted_list/bulleted_list.dart';
import 'package:flutter/material.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/utils/text_styles.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: Container(
            color: Theme.of(context).colorScheme.tertiary,
            height: 3,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              _createHeader('Contacts', TextStyles.h1),
              const BulletedList(
                listItems: <String>[
                  'pe.dro.list.app@gmail.com',
                ],
                listOrder: ListOrder.unordered,
              ),
              _createHeader(
                'Credits',
                TextStyles.h1,
              ),
              _createHeader(
                'Music',
                TextStyles.h2,
              ),
              const BulletedList(
                listItems: <String>[
                  'Raffaella Carrà, Franco Bracardi, Gianni Boncompagni and' +
                      ' Paolo Ormi (original song, which was not used here)',
                  'Jaxomy, Agatino Romero, Steffen Harning and Reinhart ' +
                      ' Raith (remix song on Creative Commons lic.)',
                  'This app was made only for study and entertainment' +
                      ' purposes, no copyr. infrigement is intended!',
                ],
                listOrder: ListOrder.unordered,
              ),
              _createHeader(
                'AI Generated Images',
                TextStyles.h2,
              ),
              const BulletedList(
                listItems: <String>[
                  'Canva',
                ],
                listOrder: ListOrder.unordered,
              ),
              _createHeader(
                'Raccoon Dancing in a Circle Meme',
                TextStyles.h2,
              ),
              const BulletedList(
                listItems: <String>[
                  '@fleksa30 (first upload of the video of the spinning' +
                      ' raccoon)',
                  'Blage (spreading of the video)',
                  '@malykha2114 (first upload of the video that had the' +
                      ' "Pedro" song)',
                  'Any other person who may be involved in the creation,' +
                      ' spreading or improvement of the meme',
                ],
                listOrder: ListOrder.unordered,
              ),
              _createHeader(
                'Font',
                TextStyles.h2,
              ),
              const BulletedList(
                listItems: <String>[
                  'Swen Pels (2023 free version of The Bold Font)',
                ],
                listOrder: ListOrder.unordered,
              ),
              _createHeader(
                'Concept',
                TextStyles.h2,
              ),
              const BulletedList(
                listItems: <String>[
                  'RYC Flutter team (general idea, which didn\'t include the' +
                      ' use of the meme)',
                ],
                listOrder: ListOrder.unordered,
              ),
              _createHeader('Author', TextStyles.h1),
              const BulletedList(
                listItems: <String>[
                  'Conrado Garcia (conrado-garcia-studies)',
                ],
                listOrder: ListOrder.unordered,
              ),
            ],
          ),
        ),
      ),
      drawer: const AppDrawer(),
    );
  }

  SizedBox _createHeader(final String text, final TextStyle style) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Text(
          text,
          style: style,
        ),
      ),
    );
  }
}
