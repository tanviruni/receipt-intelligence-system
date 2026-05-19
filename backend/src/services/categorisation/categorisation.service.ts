/**
 * Categorisation service — assigns a category to a line item name using keyword matching.
 *
 * Keyword lists are intentionally broad to handle common OCR noise
 * (e.g. partial words, lowercase/uppercase variation).
 *
 * Falls back to SONSTIGES when no keyword matches — never crashes.
 */

export type Category =
  | 'LEBENSMITTEL'
  | 'HAUSHALT'
  | 'GASTRONOMIE'
  | 'GESUNDHEIT'
  | 'ELEKTRONIK'
  | 'SONSTIGES';

const RULES: Array<{ category: Category; keywords: string[] }> = [
  {
    category: 'LEBENSMITTEL',
    keywords: [
      'milch',
      'brot',
      'butter',
      'käse',
      'joghurt',
      'eier',
      'fleisch',
      'wurst',
      'schinken',
      'fisch',
      'obst',
      'gemüse',
      'salat',
      'tomaten',
      'kartoffel',
      'nudeln',
      'reis',
      'mehl',
      'zucker',
      'öl',
      'saft',
      'wasser',
      'bier',
      'wein',
      'kaffee',
      'tee',
      'müsli',
      'chips',
      'schokolade',
      'eis',
      'marmelade',
      'honig',
      'gewürz',
      'sauce',
      'konserve',
      'tiefkühl',
      'getränk',
      'snack',
      'backware',
    ],
  },
  {
    category: 'HAUSHALT',
    keywords: [
      'spülmittel',
      'waschmittel',
      'reiniger',
      'schwamm',
      'tuch',
      'papier',
      'küchenrolle',
      'toilettenpapier',
      'müllbeutel',
      'beutel',
      'folie',
      'kerze',
      'batterie',
      'glühbirne',
      'lampe',
      'seife',
      'shampoo',
      'duschgel',
      'zahnpasta',
      'rasierer',
      'windel',
      'haushalt',
      'putzmittel',
      'desinfekt',
    ],
  },
  {
    category: 'GASTRONOMIE',
    keywords: [
      'restaurant',
      'café',
      'bistro',
      'pizza',
      'burger',
      'döner',
      'currywurst',
      'pommes',
      'sandwich',
      'wrap',
      'sushi',
      'kebab',
      'speise',
      'menü',
      'getränk',
      'espresso',
      'latte',
      'cappuccino',
      'trinkgeld',
      'bedienung',
      'service',
    ],
  },
  {
    category: 'GESUNDHEIT',
    keywords: [
      'apotheke',
      'medikament',
      'tablette',
      'vitamin',
      'pflaster',
      'verband',
      'arzt',
      'rezept',
      'salbe',
      'tropfen',
      'spray',
      'maske',
      'handschuh',
      'desinfektion',
      'ibuprofen',
      'paracetamol',
      'aspirin',
      'nasenspray',
      'augentropfen',
    ],
  },
  {
    category: 'ELEKTRONIK',
    keywords: [
      'kabel',
      'adapter',
      'ladegerät',
      'usb',
      'hdmi',
      'kopfhörer',
      'lautsprecher',
      'fernbedienung',
      'akku',
      'speicherkarte',
      'sd',
      'drucker',
      'tinte',
      'patrone',
      'maus',
      'tastatur',
      'monitor',
      'laptop',
      'tablet',
      'handy',
      'smartphone',
      'elektronik',
    ],
  },
];

/**
 * Returns the best-matching category for a given item name.
 * Matching is case-insensitive and checks for substring presence.
 */
export function categorise(itemName: string): Category {
  const lower = itemName.toLowerCase();

  for (const rule of RULES) {
    if (rule.keywords.some((keyword) => lower.includes(keyword))) {
      return rule.category;
    }
  }

  return 'SONSTIGES';
}
