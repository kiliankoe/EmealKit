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
        "url": "https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310965.html",
        "soldout": true
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
        "url": "https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310969.html",
        "soldout": false
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
        "url": "https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310958.html",
        "soldout": false
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
        "url": "https://www.studentenwerk-dresden.de/mensen/speiseplan/details-308943.html",
        "soldout": false
      }
    ]
    """#
}
