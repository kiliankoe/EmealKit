enum MockData: String {
    case canteens = #"""
    [
      {
        "id": 6,
        "name": "Mensa Matrix",
        "city": "Dresden",
        "address": "Reichenbachstr. 1, 01069 Dresden",
        "coordinates": [
          51.034283226863565,
          13.734020590782166
        ],
        "url": "https://www.studentenwerk-dresden.de/mensen/details-mensa-matrix.html",
        "menu": "https://www.studentenwerk-dresden.de/mensen/speiseplan/mensa-matrix.html"
      },
      {
        "id": 35,
        "name": "Zeltschlösschen",
        "city": "Dresden",
        "address": "Nürnberger Straße 55, 01187 Dresden",
        "coordinates": [
          51.031614756984816,
          13.728645443916323
        ],
        "url": "https://www.studentenwerk-dresden.de/mensen/details-zeltschloesschen.html",
        "menu": "https://www.studentenwerk-dresden.de/mensen/speiseplan/zeltschloesschen.html"
      },
      {
        "id": 4,
        "name": "Alte Mensa",
        "city": "Dresden",
        "address": "Mommsenstr. 13, 01069 Dresden",
        "coordinates": [
          51.02696733929933,
          13.726491630077364
        ],
        "url": "https://www.studentenwerk-dresden.de/mensen/details-alte-mensa.html",
        "menu": "https://www.studentenwerk-dresden.de/mensen/speiseplan/alte-mensa.html"
      },
      {
        "id": 8,
        "name": "Mensologie",
        "city": "Dresden",
        "address": "Blasewitzer Str. 84, 01307 Dresden",
        "coordinates": [
          51.052705307014044,
          13.784312009811401
        ],
        "url": "https://www.studentenwerk-dresden.de/mensen/details-mensologie.html",
        "menu": "https://www.studentenwerk-dresden.de/mensen/speiseplan/mensologie.html"
      },
      {
        "id": 9,
        "name": "Mensa Siedepunkt",
        "city": "Dresden",
        "address": "Zellescher Weg 17, 01069 Dresden",
        "coordinates": [
          51.02946063983054,
          13.738727867603302
        ],
        "url": "https://www.studentenwerk-dresden.de/mensen/details-mensa-siedepunkt.html",
        "menu": "https://www.studentenwerk-dresden.de/mensen/speiseplan/mensa-siedepunkt.html"
      },
      {
        "id": 32,
        "name": "Mensa Johanna",
        "city": "Dresden",
        "address": "Marschnerstraße 38, 01307 Dresden",
        "coordinates": [
          51.053120073616405,
          13.760884255170824
        ],
        "url": "https://www.studentenwerk-dresden.de/mensen/details-mensa-johanna.html",
        "menu": "https://www.studentenwerk-dresden.de/mensen/speiseplan/mensa-johanna.html"
      },
      {
        "id": 10,
        "name": "Mensa TellerRandt",
        "city": "Tharandt",
        "address": "Pienner Straße 15, 01737 Tharandt",
        "coordinates": [
          50.98060093483648,
          13.581464588642122
        ],
        "url": "https://www.studentenwerk-dresden.de/mensen/details-mensa-tellerrandt.html",
        "menu": "https://www.studentenwerk-dresden.de/mensen/speiseplan/mensa-tellerrandt.html"
      },
      {
        "id": 29,
        "name": "Mensa U-Boot",
        "city": "Dresden",
        "address": "Mensa U-Boot im Potthoffbau Untergeschoss, George-Bähr-Straße/Hettnerstraße 3, 01069 Dresden",
        "coordinates": [
          51.03030323712326,
          13.72934550046921
        ],
        "url": "https://www.studentenwerk-dresden.de/mensen/details-u-boot.html",
        "menu": "https://www.studentenwerk-dresden.de/mensen/speiseplan/u-boot.html"
      },
      {
        "id": 11,
        "name": "Mensa Palucca Hochschule",
        "city": "Dresden",
        "address": "Basteiplatz 4, 01277 Dresden",
        "coordinates": [
          51.02895,
          13.770829
        ],
        "url": "https://www.studentenwerk-dresden.de/mensen/details-mensa-palucca-hochschule.html",
        "menu": "https://www.studentenwerk-dresden.de/mensen/speiseplan/mensa-palucca-hochschule.html"
      },
      {
        "id": 33,
        "name": "Mensa WUeins",
        "city": "Dresden",
        "address": "Wundtstraße 1, 01217 Dresden",
        "coordinates": [
          51.02990429156573,
          13.748951107263567
        ],
        "url": "https://www.studentenwerk-dresden.de/mensen/details-mensa-wueins.html",
        "menu": "https://www.studentenwerk-dresden.de/mensen/speiseplan/mensa-wueins.html"
      },
      {
        "id": 34,
        "name": "Mensa Brühl",
        "city": "Dresden",
        "address": "Brühlsche Terrasse 1, 01067 DresdenZugang über den Innenhof der HfBK",
        "coordinates": [
          51.052948,
          13.741935
        ],
        "url": "https://www.studentenwerk-dresden.de/mensen/details-mensa-bruehl.html",
        "menu": "https://www.studentenwerk-dresden.de/mensen/speiseplan/mensa-bruehl.html"
      },
      {
        "id": 13,
        "name": "Mensa Stimm-Gabel",
        "city": "Dresden",
        "address": "Wettiner Platz 13, 01067 Dresden",
        "coordinates": [
          51.053722,
          13.724652
        ],
        "url": "https://www.studentenwerk-dresden.de/mensen/details-mensa-stimm-gabel.html",
        "menu": "https://www.studentenwerk-dresden.de/mensen/speiseplan/mensa-stimm-gabel.html"
      },
      {
        "id": 24,
        "name": "Mensa Kraatschn",
        "city": "Zittau",
        "address": "Hochwaldstr. 12, 02763 Zittau",
        "coordinates": [
          50.89042611030397,
          14.804495573043825
        ],
        "url": "https://www.studentenwerk-dresden.de/mensen/details-mensa-kraatschn.html",
        "menu": "https://www.studentenwerk-dresden.de/mensen/speiseplan/mensa-kraatschn.html"
      },
      {
        "id": 25,
        "name": "Mensa Mahlwerk",
        "city": "Zittau",
        "address": "Schwenninger Weg 1, 02763 Zittau",
        "coordinates": [
          50.88397255787832,
          14.801915287971497
        ],
        "url": "https://www.studentenwerk-dresden.de/mensen/details-mensa-mahlwerk.html",
        "menu": "https://www.studentenwerk-dresden.de/mensen/speiseplan/mensa-mahlwerk.html"
      },
      {
        "id": 28,
        "name": "MiO - Mensa im Osten",
        "city": "Görlitz",
        "address": "Furtstraße 1a, 02826 Görlitz",
        "coordinates": [
          51.14924302208328,
          14.998609721660616
        ],
        "url": "https://www.studentenwerk-dresden.de/mensen/details-mio-mensa-im-osten.html",
        "menu": "https://www.studentenwerk-dresden.de/mensen/speiseplan/mio-mensa-im-osten.html"
      },
      {
        "id": 36,
        "name": "Grill Cube",
        "city": "Dresden",
        "address": "George-Bähr-Straße 1A-E, 01069 Dresden",
        "coordinates": [
          51.0285205,
          13.7287076
        ],
        "url": "https://www.studentenwerk-dresden.de/mensen/details-grill-cube.html",
        "menu": "https://www.studentenwerk-dresden.de/mensen/speiseplan/grill-cube.html"
      }
    ]
    """#

    case meals = #"""
    [
      {
        "id": 310965,
        "name": "Hähnchenbrustfilet Piccata (A, A1, G) mit Zitrone, dazu Pommes frites und Salat (J)",
        "notes": [
          "Glutenhaltiges Getreide (A)",
          "Weizen (A1)",
          "Milch/Milchzucker (Laktose) (G)",
          "Senf (J)"
        ],
        "prices": {
          "Studierende": 3.91,
          "Bedienstete": 7.1
        },
        "category": "fertig 1",
        "image": "//static.studentenwerk-dresden.de/bilder/mensen/studentenwerk-dresden-lieber-mensen-gehen.jpg",
        "url": "https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310965.html"
      },
      {
        "id": 310969,
        "name": "Nuggets aus Gemüse und Jackfrucht (A, A1), dazu Kräuter-Dip (F, J) und Gemüsebratkartoffeln und Salat (J)",
        "notes": [
          "Menü ist vegan",
          "mit Antioxydationsmittel (3)",
          "Glutenhaltiges Getreide (A)",
          "Weizen (A1)",
          "Soja (F)",
          "Senf (J)"
        ],
        "prices": {
          "Studierende": 3.8,
          "Bedienstete": 6.9
        },
        "category": "fertig 2",
        "image": "//static.studentenwerk-dresden.de/bilder/mensen/studentenwerk-dresden-lieber-mensen-gehen.jpg",
        "url": "https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310969.html"
      },
      {
        "id": 310958,
        "name": "Bunter Gemüsetopf mit Pilzen und getrockneten Tomaten (A, A1,G)",
        "notes": [
          "Menü ist vegan",
          "mit Antioxydationsmittel (3)",
          "Soja (F)"
        ],
        "prices": {
          "Studierende": 2.18,
          "Bedienstete": 3.97
        },
        "category": "Terrine",
        "image": "//bilderspeiseplan.studentenwerk-dresden.de/m18/202411/310958.jpg",
        "url": "https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310958.html"
      },
      {
        "id": 308943,
        "name": "Hausgemachte Pasta (A, A1) mit Basilikumpesto (H, H1) und veganem Schmelz oder mit Carbonara (C, G) und geraspeltem Hartkäse (G) - dann weder vegan noch vegetarisch -",
        "notes": [
          "Menü ist vegan",
          "mit tierischem Lab",
          "enthält Schweinefleisch",
          "enthält Knoblauch",
          "mit Farbstoff (1)",
          "mit Konservierungsstoff (2)",
          "mit Antioxydationsmittel (3)",
          "mit Phosphat (8)",
          "Glutenhaltiges Getreide (A)",
          "Weizen (A1)",
          "Eier (C)",
          "Milch/Milchzucker (Laktose) (G)",
          "Schalenfrüchte (Nüsse) (H)",
          "Mandeln (H1)"
        ],
        "prices": {
          "Studierende": 2.35,
          "Bedienstete": 4.9
        },
        "category": "Pastaria & Co.",
        "image": "//bilderspeiseplan.studentenwerk-dresden.de/m18/202411/308943.jpg",
        "url": "https://www.studentenwerk-dresden.de/mensen/speiseplan/details-308943.html"
      }
    ]
    """#

    case rssFeed = #"""
    <?xml version="1.0" encoding="UTF-8"?>
    <rss version="2.0">
    <channel>
    <title>Studentenwerk Dresden - Mensa Speiseplan von heute</title>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/</link>
    <description>Der Speiseplan der Mensen des Studentenwerks Dresden</description>
    <language>de-de</language>
    <pubDate>Fri, 15 Nov 2024 18:16:37 +0100</pubDate>
    <item>
    <title>MilchgrieÃŸ (A, A1, G) mit Kirschkompott, zerlassende Butter und Zucker / Zimt, auch als Dessertportion mÃ¶glich (2.80 EUR / 5.10 EUR)</title>
    <description>MilchgrieÃŸ (A, A1, G) mit Kirschkompott, zerlassende Butter und Zucker / Zimt, auch als Dessertportion mÃ¶glich (Studierende: 2.80 EUR / Bedienstete: 5.10 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-309125.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-309125.html</link>
    <author>Mensa Matrix</author>
    </item>
    <item>
    <title>Suppenstation: Feine Reissuppe mit GemÃ¼se (A, A1, F) (2.18 EUR / 3.97 EUR)</title>
    <description>Suppenstation: Feine Reissuppe mit GemÃ¼se (A, A1, F) (Studierende: 2.18 EUR / Bedienstete: 3.97 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310365.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310365.html</link>
    <author>Mensa Matrix</author>
    </item>
    <item>
    <title>RÃ¤uchertofuwÃ¼rfel mit Ananas, Pfirsich und Chili (A, A1, F), dazu Nudeln gebraten mediterran (2.35 EUR / 4.90 EUR)</title>
    <description>RÃ¤uchertofuwÃ¼rfel mit Ananas, Pfirsich und Chili (A, A1, F), dazu Nudeln gebraten mediterran (Studierende: 2.35 EUR / Bedienstete: 4.90 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310916.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310916.html</link>
    <author>Mensa Matrix</author>
    </item>
    <item>
    <title>Dessertportion: MilchgrieÃŸ (A, A1, G) mit Kirschkompott, zerlassende Butter und Zucker/Zimt (1.68 EUR / 3.06 EUR)</title>
    <description>Dessertportion: MilchgrieÃŸ (A, A1, G) mit Kirschkompott, zerlassende Butter und Zucker/Zimt (Studierende: 1.68 EUR / Bedienstete: 3.06 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310952.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310952.html</link>
    <author>Mensa Matrix</author>
    </item>
    <item>
    <title>HÃ¤hnchenschnitzel Cordon bleu (A, A1, G) mit GeflÃ¼gelsoÃŸe (I) und KarottengemÃ¼se, dazu Kartoffelkroketten (A, A1) (4.43 EUR / 8.05 EUR)</title>
    <description>HÃ¤hnchenschnitzel Cordon bleu (A, A1, G) mit GeflÃ¼gelsoÃŸe (I) und KarottengemÃ¼se, dazu Kartoffelkroketten (A, A1) (Studierende: 4.43 EUR / Bedienstete: 8.05 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310970.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310970.html</link>
    <author>Mensa Matrix</author>
    </item>
    <item>
    <title>Kohlroulade mit deftiger SchmorkrautsoÃŸe (A, A1, I) und Petersilienkartoffeln (3.65 EUR / 6.64 EUR)</title>
    <description>Kohlroulade mit deftiger SchmorkrautsoÃŸe (A, A1, I) und Petersilienkartoffeln (Studierende: 3.65 EUR / Bedienstete: 6.64 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310539.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310539.html</link>
    <author>ZeltschlÃ¶sschen</author>
    </item>
    <item>
    <title>Green Oats Burger mit Pesto-Dip (F), Eisbergsalat, Bruschetta und Pommes frites (4.45 EUR / 8.10 EUR)</title>
    <description>Green Oats Burger mit Pesto-Dip (F), Eisbergsalat, Bruschetta und Pommes frites (Studierende: 4.45 EUR / Bedienstete: 8.10 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310540.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310540.html</link>
    <author>ZeltschlÃ¶sschen</author>
    </item>
    <item>
    <title>Chicken Piccata Burger (A, A1, G) mit Pesto-Dip (G, H, H4), Eisbergsalat, Bruschetta und Pommes frites (ausverkauft)</title>
    <description>Chicken Piccata Burger (A, A1, G) mit Pesto-Dip (G, H, H4), Eisbergsalat, Bruschetta und Pommes frites (ausverkauft)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310541.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310541.html</link>
    <author>ZeltschlÃ¶sschen</author>
    </item>
    <item>
    <title>Blumenkohl-Broccoli-Kartoffelauflauf in SahnesoÃŸe mit Gouda gratiniert (A, A1, G), dazu Salat (J) (ausverkauft)</title>
    <description>Blumenkohl-Broccoli-Kartoffelauflauf in SahnesoÃŸe mit Gouda gratiniert (A, A1, G), dazu Salat (J) (ausverkauft)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310542.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310542.html</link>
    <author>ZeltschlÃ¶sschen</author>
    </item>
    <item>
    <title>Nudelauflauf mit Blumenkohl in KÃ¤sesoÃŸe und RÃ¶stzwiebeln (A, A1, C, G), dazu Salat (J) (ausverkauft)</title>
    <description>Nudelauflauf mit Blumenkohl in KÃ¤sesoÃŸe und RÃ¶stzwiebeln (A, A1, C, G), dazu Salat (J) (ausverkauft)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310959.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310959.html</link>
    <author>ZeltschlÃ¶sschen</author>
    </item>
    <item>
    <title>Hamburger oder Cheeseburger (4.10 EUR / 4.41 EUR)</title>
    <description>Hamburger oder Cheeseburger (Studierende: 4.10 EUR / Bedienstete: 4.41 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-285627.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-285627.html</link>
    <author>Grill Cube</author>
    </item>
    <item>
    <title>Valess Burger (4.50 EUR / 4.84 EUR)</title>
    <description>Valess Burger (Studierende: 4.50 EUR / Bedienstete: 4.84 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-285628.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-285628.html</link>
    <author>Grill Cube</author>
    </item>
    <item>
    <title>Italian Burger mit Rind, Tomate, Mozzarella und Rucola (4.50 EUR / 4.84 EUR)</title>
    <description>Italian Burger mit Rind, Tomate, Mozzarella und Rucola (Studierende: 4.50 EUR / Bedienstete: 4.84 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-285629.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-285629.html</link>
    <author>Grill Cube</author>
    </item>
    <item>
    <title>Currywurst mit milder oder scharfer SoÃŸe, dazu Pommes frites (Currywurst mit BrÃ¶tchen 3,26â‚¬/3,51â‚¬) (4.20 EUR / 4.52 EUR)</title>
    <description>Currywurst mit milder oder scharfer SoÃŸe, dazu Pommes frites (Currywurst mit BrÃ¶tchen 3,26â‚¬/3,51â‚¬) (Studierende: 4.20 EUR / Bedienstete: 4.52 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-285630.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-285630.html</link>
    <author>Grill Cube</author>
    </item>
    <item>
    <title>Double-Hamburger oder Double-Cheeseburger (6.70 EUR / 7.20 EUR)</title>
    <description>Double-Hamburger oder Double-Cheeseburger (Studierende: 6.70 EUR / Bedienstete: 7.20 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-285631.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-285631.html</link>
    <author>Grill Cube</author>
    </item>
    <item>
    <title>Unser veganes Angebot: Falafel Burger (4.10 EUR / 4.41 EUR)</title>
    <description>Unser veganes Angebot: Falafel Burger (Studierende: 4.10 EUR / Bedienstete: 4.41 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-285632.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-285632.html</link>
    <author>Grill Cube</author>
    </item>
    <item>
    <title>Vegane Currywurst mit milder oder scharfer SoÃŸe, dazu Pommes frites (mit BrÃ¶tchen 3,26â‚¬/3,51â‚¬) (4.20 EUR / 4.52 EUR)</title>
    <description>Vegane Currywurst mit milder oder scharfer SoÃŸe, dazu Pommes frites (mit BrÃ¶tchen 3,26â‚¬/3,51â‚¬) (Studierende: 4.20 EUR / Bedienstete: 4.52 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-301772.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-301772.html</link>
    <author>Grill Cube</author>
    </item>
    <item>
    <title>Hausgemachte Pasta (A, A1) mit Basilikumpesto (H, H1) und veganem Schmelz oder mit Carbonara (C, G) und geraspeltem HartkÃ¤se (G) - dann weder vegan noch vegetarisch - (2.35 EUR / 4.90 EUR)</title>
    <description>Hausgemachte Pasta (A, A1) mit Basilikumpesto (H, H1) und veganem Schmelz oder mit Carbonara (C, G) und geraspeltem HartkÃ¤se (G) - dann weder vegan noch vegetarisch - (Studierende: 2.35 EUR / Bedienstete: 4.90 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-308943.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-308943.html</link>
    <author>Alte Mensa</author>
    </item>
    <item>
    <title>Terrine: Bunter GemÃ¼setopf mit Pilzen und getrockneten Tomaten (A, A1,G) (ausverkauft)</title>
    <description>Terrine: Bunter GemÃ¼setopf mit Pilzen und getrockneten Tomaten (A, A1,G) (ausverkauft)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310958.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310958.html</link>
    <author>Alte Mensa</author>
    </item>
    <item>
    <title>HÃ¤hnchenbrustfilet Piccata (A, A1, G) mit Zitrone, dazu Pommes frites und Salat (J) (ausverkauft)</title>
    <description>HÃ¤hnchenbrustfilet Piccata (A, A1, G) mit Zitrone, dazu Pommes frites und Salat (J) (ausverkauft)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310965.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310965.html</link>
    <author>Alte Mensa</author>
    </item>
    <item>
    <title>Nuggets aus GemÃ¼se und Jackfrucht (A, A1), dazu KrÃ¤uter-Dip (F, J) und GemÃ¼sebratkartoffeln und Salat (J) (3.80 EUR / 6.90 EUR)</title>
    <description>Nuggets aus GemÃ¼se und Jackfrucht (A, A1), dazu KrÃ¤uter-Dip (F, J) und GemÃ¼sebratkartoffeln und Salat (J) (Studierende: 3.80 EUR / Bedienstete: 6.90 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310969.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310969.html</link>
    <author>Alte Mensa</author>
    </item>
    <item>
    <title>Hausgemachte Kartoffelpuffer mit WurzelgemÃ¼se (A, A1, C, I), dazu KrÃ¤uter-Quark-Dip (A, A1, C, G, I) (2.35 EUR / 4.90 EUR)</title>
    <description>Hausgemachte Kartoffelpuffer mit WurzelgemÃ¼se (A, A1, C, I), dazu KrÃ¤uter-Quark-Dip (A, A1, C, G, I) (Studierende: 2.35 EUR / Bedienstete: 4.90 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310280.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310280.html</link>
    <author>Mensologie</author>
    </item>
    <item>
    <title>JÃ¤gerschnitzel (panierte Jagdwurst) (A, A1, C, G, J), dazu TomatensoÃŸe und Makkaroni (A, A1) (ausverkauft)</title>
    <description>JÃ¤gerschnitzel (panierte Jagdwurst) (A, A1, C, G, J), dazu TomatensoÃŸe und Makkaroni (A, A1) (ausverkauft)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310281.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310281.html</link>
    <author>Mensologie</author>
    </item>
    <item>
    <title>Kichererbsen-Bohnen Burger (A, A1, A4, F, J), dazu Pommes frites (I) und Ketchup (4.26 EUR / 7.75 EUR)</title>
    <description>Kichererbsen-Bohnen Burger (A, A1, A4, F, J), dazu Pommes frites (I) und Ketchup (Studierende: 4.26 EUR / Bedienstete: 7.75 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310282.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310282.html</link>
    <author>Mensologie</author>
    </item>
    <item>
    <title>Suppenstation: Mexikanischer Feuertopf mit Schweinefleisch und Kidneybohnen (2.18 EUR / 3.97 EUR)</title>
    <description>Suppenstation: Mexikanischer Feuertopf mit Schweinefleisch und Kidneybohnen (Studierende: 2.18 EUR / Bedienstete: 3.97 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310951.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310951.html</link>
    <author>Mensologie</author>
    </item>
    <item>
    <title>Med by you: Reis, veganer Planted-Krautgulasch (I, A, A4, J), Couscous (A, A1) (4.01 EUR / 7.30 EUR)</title>
    <description>Med by you: Reis, veganer Planted-Krautgulasch (I, A, A4, J), Couscous (A, A1) (Studierende: 4.01 EUR / Bedienstete: 7.30 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310953.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310953.html</link>
    <author>Mensologie</author>
    </item>
    <item>
    <title>Rote Linsen-Lasagne (A, A1, F, I) dazu Salat (ausverkauft)</title>
    <description>Rote Linsen-Lasagne (A, A1, F, I) dazu Salat (ausverkauft)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-308835.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-308835.html</link>
    <author>Mensa Siedepunkt</author>
    </item>
    <item>
    <title>Gegrilltes OfengemÃ¼se mit kÃ¶rniger HÃ¼ttenkÃ¤secreme (G), dazu Pestokartoffeln (G, H, H4) (4.20 EUR / 7.64 EUR)</title>
    <description>Gegrilltes OfengemÃ¼se mit kÃ¶rniger HÃ¼ttenkÃ¤secreme (G), dazu Pestokartoffeln (G, H, H4) (Studierende: 4.20 EUR / Bedienstete: 7.64 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-308836.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-308836.html</link>
    <author>Mensa Siedepunkt</author>
    </item>
    <item>
    <title>Abendangebot: Spaghetti (A, A1) Bolognese (I) mit geriebenem Gouda (G) (3.05 EUR / 5.55 EUR)</title>
    <description>Abendangebot: Spaghetti (A, A1) Bolognese (I) mit geriebenem Gouda (G) (Studierende: 3.05 EUR / Bedienstete: 5.55 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-308837.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-308837.html</link>
    <author>Mensa Siedepunkt</author>
    </item>
    <item>
    <title>Abendangebot: Spaghetti (A, A1) mit Sojabolognese (F, I, J) und geriebenem veganen Schmelz (2.89 EUR / 5.25 EUR)</title>
    <description>Abendangebot: Spaghetti (A, A1) mit Sojabolognese (F, I, J) und geriebenem veganen Schmelz (Studierende: 2.89 EUR / Bedienstete: 5.25 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-308838.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-308838.html</link>
    <author>Mensa Siedepunkt</author>
    </item>
    <item>
    <title>KÃ¼rbis-GemÃ¼sesuppe (A, A1, F) (2.18 EUR / 3.97 EUR)</title>
    <description>KÃ¼rbis-GemÃ¼sesuppe (A, A1, F) (Studierende: 2.18 EUR / Bedienstete: 3.97 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310910.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310910.html</link>
    <author>Mensa Siedepunkt</author>
    </item>
    <item>
    <title>Bunte Salatvariation aus Eisbergsalat, Chinakohl, Gurke, Tomaten, Paprika und Couscous-Linsenmix (A, A1), dazu kleine FrÃ¼hlingsrollen (A, A1, F), inklusive einem Dressing nach Wahl (3.05 EUR / 5.54 EUR)</title>
    <description>Bunte Salatvariation aus Eisbergsalat, Chinakohl, Gurke, Tomaten, Paprika und Couscous-Linsenmix (A, A1), dazu kleine FrÃ¼hlingsrollen (A, A1, F), inklusive einem Dressing nach Wahl (Studierende: 3.05 EUR / Bedienstete: 5.54 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310955.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310955.html</link>
    <author>Mensa Siedepunkt</author>
    </item>
    <item>
    <title>Bunte Salatvariation aus Eisbergsalat, Chinakohl, Gurke, Tomaten, Paprika und Couscous-Linsenmix (A, A1), dazu FalafelbÃ¤llchen (A, A1), inklusive einem Dressing nach Wahl (3.05 EUR / 5.54 EUR)</title>
    <description>Bunte Salatvariation aus Eisbergsalat, Chinakohl, Gurke, Tomaten, Paprika und Couscous-Linsenmix (A, A1), dazu FalafelbÃ¤llchen (A, A1), inklusive einem Dressing nach Wahl (Studierende: 3.05 EUR / Bedienstete: 5.54 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310956.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310956.html</link>
    <author>Mensa Siedepunkt</author>
    </item>
    <item>
    <title>Grillteller mit Biersteak (A, A3, J), GrillwÃ¼rstchen und kleinen Hacksteaks (A, A1, C) auf Letscho (J), dazu Kartoffelkroketten (A, A1) (2.35 EUR / 4.90 EUR)</title>
    <description>Grillteller mit Biersteak (A, A3, J), GrillwÃ¼rstchen und kleinen Hacksteaks (A, A1, C) auf Letscho (J), dazu Kartoffelkroketten (A, A1) (Studierende: 2.35 EUR / Bedienstete: 4.90 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310964.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310964.html</link>
    <author>Mensa Siedepunkt</author>
    </item>
    <item>
    <title>Buntes GemÃ¼se in Sojacreme (F) mit Reis (2.35 EUR / 4.90 EUR)</title>
    <description>Buntes GemÃ¼se in Sojacreme (F) mit Reis (Studierende: 2.35 EUR / Bedienstete: 4.90 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310401.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310401.html</link>
    <author>Mensa Johanna</author>
    </item>
    <item>
    <title>Schweinekeulenbraten in SchwarzbiersoÃŸe (A, A1, A3, I) mit Bayrischkraut und Petersilienkartoffeln oder KartoffelklÃ¶ÃŸen (L) (ausverkauft)</title>
    <description>Schweinekeulenbraten in SchwarzbiersoÃŸe (A, A1, A3, I) mit Bayrischkraut und Petersilienkartoffeln oder KartoffelklÃ¶ÃŸen (L) (ausverkauft)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310402.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310402.html</link>
    <author>Mensa Johanna</author>
    </item>
    <item>
    <title>SpinatknÃ¶del (A, A1, C, G) mit Sahnepilzen (A, A1, G), geriebenem Gouda (G) und Salat (J) (ausverkauft)</title>
    <description>SpinatknÃ¶del (A, A1, C, G) mit Sahnepilzen (A, A1, G), geriebenem Gouda (G) und Salat (J) (ausverkauft)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310403.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310403.html</link>
    <author>Mensa Johanna</author>
    </item>
    <item>
    <title>RÃ¤uchertofuwÃ¼rfel mit Ananas, Pfirsich und Chili (A, A1, F), dazu mediterraner GemÃ¼sereis (2.35 EUR / 4.90 EUR)</title>
    <description>RÃ¤uchertofuwÃ¼rfel mit Ananas, Pfirsich und Chili (A, A1, F), dazu mediterraner GemÃ¼sereis (Studierende: 2.35 EUR / Bedienstete: 4.90 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310479.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310479.html</link>
    <author>Mensa WUeins</author>
    </item>
    <item>
    <title>HÃ¤hnchenschnitzel Cordon bleu (A, A1, G) mit GeflÃ¼gelsoÃŸe (I) und KarottengemÃ¼se, dazu KartoffelbÃ¤llchen (C) (ausverkauft)</title>
    <description>HÃ¤hnchenschnitzel Cordon bleu (A, A1, G) mit GeflÃ¼gelsoÃŸe (I) und KarottengemÃ¼se, dazu KartoffelbÃ¤llchen (C) (ausverkauft)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310483.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310483.html</link>
    <author>Mensa WUeins</author>
    </item>
    <item>
    <title>RÃ¤uchertofuwÃ¼rfel mit Ananas, Pfirsich und Chili (A, A1, F), dazu mediterraner GemÃ¼sereis (2.35 EUR / 4.90 EUR)</title>
    <description>RÃ¤uchertofuwÃ¼rfel mit Ananas, Pfirsich und Chili (A, A1, F), dazu mediterraner GemÃ¼sereis (Studierende: 2.35 EUR / Bedienstete: 4.90 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310480.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310480.html</link>
    <author>Mensa BrÃ¼hl</author>
    </item>
    <item>
    <title>HÃ¤hnchenschnitzel Cordon bleu (A, A1, G) mit GeflÃ¼gelsoÃŸe (I) und KarottengemÃ¼se, dazu KartoffelbÃ¤llchen (C) (ausverkauft)</title>
    <description>HÃ¤hnchenschnitzel Cordon bleu (A, A1, G) mit GeflÃ¼gelsoÃŸe (I) und KarottengemÃ¼se, dazu KartoffelbÃ¤llchen (C) (ausverkauft)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310484.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310484.html</link>
    <author>Mensa BrÃ¼hl</author>
    </item>
    <item>
    <title>COM RANG - Eierreis mit Karotten, roten Zwiebeln und Erbsen (A, A1, C, F, K) (3.00 EUR / 5.45 EUR)</title>
    <description>COM RANG - Eierreis mit Karotten, roten Zwiebeln und Erbsen (A, A1, C, F, K) (Studierende: 3.00 EUR / Bedienstete: 5.45 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-309252.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-309252.html</link>
    <author>Mensa U-Boot</author>
    </item>
    <item>
    <title>GA NUONG - gegrillte HÃ¤hnchenbrust mit Kaiserschoten, Porree, Kokos und Bambussprossen (A, A1, F, K), dazu Thai Reis oder Mie Nudeln (A, A1, F, K) (4.50 EUR / 8.18 EUR)</title>
    <description>GA NUONG - gegrillte HÃ¤hnchenbrust mit Kaiserschoten, Porree, Kokos und Bambussprossen (A, A1, F, K), dazu Thai Reis oder Mie Nudeln (A, A1, F, K) (Studierende: 4.50 EUR / Bedienstete: 8.18 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-309266.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-309266.html</link>
    <author>Mensa U-Boot</author>
    </item>
    <item>
    <title>COM/MIE CHAY - mit Kaiserschoten, Porree, Kokos und Bambussprossen (A, A1, F, K),dazu Thai Reis oder Mie Nudeln (A, A1, F, K) (3.65 EUR / 6.64 EUR)</title>
    <description>COM/MIE CHAY - mit Kaiserschoten, Porree, Kokos und Bambussprossen (A, A1, F, K),dazu Thai Reis oder Mie Nudeln (A, A1, F, K) (Studierende: 3.65 EUR / Bedienstete: 6.64 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-309267.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-309267.html</link>
    <author>Mensa U-Boot</author>
    </item>
    <item>
    <title>COM RANG - Eierreis mit Schweinefleisch, Karotten, roten Zwiebeln und Erbsen (A, A1, C, F, K) (4.39 EUR / 7.99 EUR)</title>
    <description>COM RANG - Eierreis mit Schweinefleisch, Karotten, roten Zwiebeln und Erbsen (A, A1, C, F, K) (Studierende: 4.39 EUR / Bedienstete: 7.99 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-309269.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-309269.html</link>
    <author>Mensa U-Boot</author>
    </item>
    <item>
    <title>gebratene HÃ¤hnchenkeule (F) mit Apfelrotkohl und Petersilienkartoffeln (3.44 EUR / 6.25 EUR)</title>
    <description>gebratene HÃ¤hnchenkeule (F) mit Apfelrotkohl und Petersilienkartoffeln (Studierende: 3.44 EUR / Bedienstete: 6.25 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310661.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310661.html</link>
    <author>Mensa TellerRandt</author>
    </item>
    <item>
    <title>Soja-Geschnetzeltes mit Champignon und Paprika (F), dazu GemÃ¼sebulgur (A, A1, I) (2.35 EUR / 4.90 EUR)</title>
    <description>Soja-Geschnetzeltes mit Champignon und Paprika (F), dazu GemÃ¼sebulgur (A, A1, I) (Studierende: 2.35 EUR / Bedienstete: 4.90 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310954.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310954.html</link>
    <author>Mensa TellerRandt</author>
    </item>
    <item>
    <title>Bratwurst mit Sauerkraut und Petersilinkartoffeln (3.44 EUR / 6.25 EUR)</title>
    <description>Bratwurst mit Sauerkraut und Petersilinkartoffeln (Studierende: 3.44 EUR / Bedienstete: 6.25 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310957.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310957.html</link>
    <author>Mensa TellerRandt</author>
    </item>
    <item>
    <title>Deftiger Kasslerkammbraten (A, A1), dazu Fasssauerkraut und HefeknÃ¶del (A, A1, C, G) (3.82 EUR / 6.95 EUR)</title>
    <description>Deftiger Kasslerkammbraten (A, A1), dazu Fasssauerkraut und HefeknÃ¶del (A, A1, C, G) (Studierende: 3.82 EUR / Bedienstete: 6.95 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310058.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310058.html</link>
    <author>Mensa Kraatschn</author>
    </item>
    <item>
    <title>Sojageschnetzeltes &quot;ZÃ¼richer Art&quot; mit Champignons in SahnesoÃŸe (F), dazu Tagliatelle (A, A1) und ein bunter Salat (2.35 EUR / 4.90 EUR)</title>
    <description>Sojageschnetzeltes &quot;ZÃ¼richer Art&quot; mit Champignons in SahnesoÃŸe (F), dazu Tagliatelle (A, A1) und ein bunter Salat (Studierende: 2.35 EUR / Bedienstete: 4.90 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310059.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310059.html</link>
    <author>Mensa Kraatschn</author>
    </item>
    <item>
    <title>Levantinische SpezialitÃ¤ten - &quot;Shakshuka&quot; GemÃ¼se-Paprikapfanne mit Ei, (C, L), dazu gebackene Kartoffelecken und Knoblauch-Dip (A,A1,A4,H,J) (3.74 EUR / 6.80 EUR)</title>
    <description>Levantinische SpezialitÃ¤ten - &quot;Shakshuka&quot; GemÃ¼se-Paprikapfanne mit Ei, (C, L), dazu gebackene Kartoffelecken und Knoblauch-Dip (A,A1,A4,H,J) (Studierende: 3.74 EUR / Bedienstete: 6.80 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310060.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310060.html</link>
    <author>Mensa Kraatschn</author>
    </item>
    <item>
    <title>Terrine: Heute: Vegane Blumenkohl-Cremesuppe (A,A1,F) oder deftiger Bohneneintopf mit Kassler (-), Preisangabe fÃ¼r kleine Schale (1.13 EUR / 2.06 EUR)</title>
    <description>Terrine: Heute: Vegane Blumenkohl-Cremesuppe (A,A1,F) oder deftiger Bohneneintopf mit Kassler (-), Preisangabe fÃ¼r kleine Schale (Studierende: 1.13 EUR / Bedienstete: 2.06 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310674.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310674.html</link>
    <author>Mensa Kraatschn</author>
    </item>
    <item>
    <title>Heute: Kartoffelerbsenstampf (F), Currylinsenreis (I), Falafelstreifen (A, A1) und ChampignonkÃ¶pfe in Sojarahm (F), Preisangabe fÃ¼r kleine Schale (3.05 EUR / 5.54 EUR)</title>
    <description>Heute: Kartoffelerbsenstampf (F), Currylinsenreis (I), Falafelstreifen (A, A1) und ChampignonkÃ¶pfe in Sojarahm (F), Preisangabe fÃ¼r kleine Schale (Studierende: 3.05 EUR / Bedienstete: 5.54 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310796.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310796.html</link>
    <author>Mensa Kraatschn</author>
    </item>
    <item>
    <title>Pastatheke heute: Zwei Sorten Pasta (A,A1), dazu vegane GemÃ¼se-RahmsoÃŸe (A,A1, F) oder GeflÃ¼gelsoÃŸe (A,A1,G) und auf Wunsch geriebener KÃ¤se (G), Preisangabe fÃ¼r kleinen Teller (2.07 EUR / 3.76 EUR)</title>
    <description>Pastatheke heute: Zwei Sorten Pasta (A,A1), dazu vegane GemÃ¼se-RahmsoÃŸe (A,A1, F) oder GeflÃ¼gelsoÃŸe (A,A1,G) und auf Wunsch geriebener KÃ¤se (G), Preisangabe fÃ¼r kleinen Teller (Studierende: 2.07 EUR / Bedienstete: 3.76 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310961.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310961.html</link>
    <author>Mensa Kraatschn</author>
    </item>
    <item>
    <title>Deftiger Kasslerkammbraten (A, A1), dazu Fasssauerkraut und HefeknÃ¶del (A, A1, C, G) (3.82 EUR / 6.95 EUR)</title>
    <description>Deftiger Kasslerkammbraten (A, A1), dazu Fasssauerkraut und HefeknÃ¶del (A, A1, C, G) (Studierende: 3.82 EUR / Bedienstete: 6.95 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310704.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310704.html</link>
    <author>Mensa Mahlwerk</author>
    </item>
    <item>
    <title>Sojageschnetzeltes &quot;ZÃ¼richer Art&quot; mit Champignons in SahnesoÃŸe (F), dazu Tagliatelle (A, A1) und ein bunter Salat (2.35 EUR / 4.90 EUR)</title>
    <description>Sojageschnetzeltes &quot;ZÃ¼richer Art&quot; mit Champignons in SahnesoÃŸe (F), dazu Tagliatelle (A, A1) und ein bunter Salat (Studierende: 2.35 EUR / Bedienstete: 4.90 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310705.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310705.html</link>
    <author>Mensa Mahlwerk</author>
    </item>
    <item>
    <title>RÃ¤uchertofuwÃ¼rfel mit Ananas, Pfirsich und Chili (A, A1, F), dazu mediterraner GemÃ¼sereis (2.35 EUR / 4.90 EUR)</title>
    <description>RÃ¤uchertofuwÃ¼rfel mit Ananas, Pfirsich und Chili (A, A1, F), dazu mediterraner GemÃ¼sereis (Studierende: 2.35 EUR / Bedienstete: 4.90 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310481.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310481.html</link>
    <author>Mensa Stimm-Gabel</author>
    </item>
    <item>
    <title>HÃ¤hnchenschnitzel Cordon bleu (A, A1, G) mit GeflÃ¼gelsoÃŸe (I) und KarottengemÃ¼se, dazu KartoffelbÃ¤llchen (C) (4.43 EUR / 8.05 EUR)</title>
    <description>HÃ¤hnchenschnitzel Cordon bleu (A, A1, G) mit GeflÃ¼gelsoÃŸe (I) und KarottengemÃ¼se, dazu KartoffelbÃ¤llchen (C) (Studierende: 4.43 EUR / Bedienstete: 8.05 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310485.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310485.html</link>
    <author>Mensa Stimm-Gabel</author>
    </item>
    <item>
    <title>RÃ¤uchertofuwÃ¼rfel mit Ananas, Pfirsich und Chili (A, A1, F), dazu mediterraner GemÃ¼sereis (2.35 EUR / 4.90 EUR)</title>
    <description>RÃ¤uchertofuwÃ¼rfel mit Ananas, Pfirsich und Chili (A, A1, F), dazu mediterraner GemÃ¼sereis (Studierende: 2.35 EUR / Bedienstete: 4.90 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310482.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310482.html</link>
    <author>Mensa Palucca Hochschule</author>
    </item>
    <item>
    <title>HÃ¤hnchenschnitzel Cordon bleu (A, A1, G) mit GeflÃ¼gelsoÃŸe (I) und KarottengemÃ¼se, dazu KartoffelbÃ¤llchen (C) (4.43 EUR / 8.05 EUR)</title>
    <description>HÃ¤hnchenschnitzel Cordon bleu (A, A1, G) mit GeflÃ¼gelsoÃŸe (I) und KarottengemÃ¼se, dazu KartoffelbÃ¤llchen (C) (Studierende: 4.43 EUR / Bedienstete: 8.05 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310486.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310486.html</link>
    <author>Mensa Palucca Hochschule</author>
    </item>
    <item>
    <title>DÃ¼rrrÃ¶hrsdorfer Bratwurst (A, A1, J) mit Sauerkraut und KartoffelpÃ¼ree (G) (3.19 EUR / 5.80 EUR)</title>
    <description>DÃ¼rrrÃ¶hrsdorfer Bratwurst (A, A1, J) mit Sauerkraut und KartoffelpÃ¼ree (G) (Studierende: 3.19 EUR / Bedienstete: 5.80 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-309755.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-309755.html</link>
    <author>MiO - Mensa im Osten</author>
    </item>
    <item>
    <title>Mediterrane Tortelloni mit Basilikum-KÃ¤sekruste (A, A1) auf Spinat-CremesoÃŸe (F) (2.35 EUR / 4.90 EUR)</title>
    <description>Mediterrane Tortelloni mit Basilikum-KÃ¤sekruste (A, A1) auf Spinat-CremesoÃŸe (F) (Studierende: 2.35 EUR / Bedienstete: 4.90 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-309756.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-309756.html</link>
    <author>MiO - Mensa im Osten</author>
    </item>
    <item>
    <title>Tagessuppe - vegetarische Kartoffelsuppe (G, I), kleine Schale (1.13 EUR / 2.06 EUR)</title>
    <description>Tagessuppe - vegetarische Kartoffelsuppe (G, I), kleine Schale (Studierende: 1.13 EUR / Bedienstete: 2.06 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310949.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310949.html</link>
    <author>MiO - Mensa im Osten</author>
    </item>
    <item>
    <title>Vegane Theke - Schwarzwurzel in Sojarahm (A, A1, F), GrÃ¼nkohl, Kurkumareis und Spaghetti mit getrockneten Tomaten und Basilikum (A, A1), kleiner Teller (3.05 EUR / 5.54 EUR)</title>
    <description>Vegane Theke - Schwarzwurzel in Sojarahm (A, A1, F), GrÃ¼nkohl, Kurkumareis und Spaghetti mit getrockneten Tomaten und Basilikum (A, A1), kleiner Teller (Studierende: 3.05 EUR / Bedienstete: 5.54 EUR)</description>
    <guid>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310950.html</guid>
    <link>https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310950.html</link>
    <author>MiO - Mensa im Osten</author>
    </item>
    </channel>
    </rss>
    """#
}
