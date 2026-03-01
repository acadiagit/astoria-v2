-- Expanded seed data for maritime history RAG application
-- Ship registry entries from Machias Ship Registers 1780-1930
-- Vessels 25-84 (continuing from existing records 1-24)

INSERT INTO documents (title, content, doc_type, source_url, archive_name, metadata) VALUES
(
  'Ship Registry: ABBY MORSE',
  $$ABBY MORSE, schooner, of Steuben. Official No. 195. Built at Essex, Mass., 1853. 32 tons; 58 ft. x 17.5 ft. x 6.2 ft. One deck, two masts, square stern, billethead.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ABBY MORSE", "vessel_type": "schooner", "hailing_port": "Steuben", "official_number": "195", "tonnage": 32, "dimensions": "58 ft. x 17.5 ft. x 6.2 ft.", "year_built": 1853, "place_built": "Essex, Mass.", "builder": null, "decks": 1, "masts": 2, "stern_type": "square", "head_type": "billethead", "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: ABIGAIL',
  $$ABIGAIL, schooner, of North Haven, Mass. Official No. 490. Built at Essex, Mass., 1837. 35.08 tons; 54.6 ft. x 16.6 ft. x 7.1 ft. One deck, two masts, square stern, billethead.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ABIGAIL", "vessel_type": "schooner", "hailing_port": "North Haven, Mass.", "official_number": "490", "tonnage": 35.08, "dimensions": "54.6 ft. x 16.6 ft. x 7.1 ft.", "year_built": 1837, "place_built": "Essex, Mass.", "builder": null, "decks": 1, "masts": 2, "stern_type": "square", "head_type": "billethead", "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: ACARA',
  $$ACARA, schooner, of Harrington. Official No. 105302. Built at Harrington, 1873, by William A. Nash, master carpenter. 142.54 gross tons, 135.41 net tons; 91.5 ft. x 27.3 ft. x 8.2 ft. One deck, two masts, square stern, figurehead.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ACARA", "vessel_type": "schooner", "hailing_port": "Harrington", "official_number": "105302", "tonnage": 142.54, "tonnage_net": 135.41, "dimensions": "91.5 ft. x 27.3 ft. x 8.2 ft.", "year_built": 1873, "place_built": "Harrington", "builder": "William A. Nash", "decks": 1, "masts": 2, "stern_type": "square", "head_type": "figurehead", "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: ACELIA THURLOW',
  $$ACELIA THURLOW, brig, of New York City. Official No. 1837. Built at Harrington, 1869, by O. P. Rumball, master carpenter. 473.69 tons; 125.2 ft. x 30 ft. x 17.4 ft. Two decks, two masts, elliptic stern, billethead.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ACELIA THURLOW", "vessel_type": "brig", "hailing_port": "New York City", "official_number": "1837", "tonnage": 473.69, "dimensions": "125.2 ft. x 30 ft. x 17.4 ft.", "year_built": 1869, "place_built": "Harrington", "builder": "O. P. Rumball", "decks": 2, "masts": 2, "stern_type": "elliptic", "head_type": "billethead", "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: ACTIVE',
  $$ACTIVE, schooner, of Addison. Built at Addison, Mass. (now Maine), 1802, by Samuel Bucknam Jr., master carpenter. 96 tons and 48 ft.; 70 ft. x 21 ft. 8 in. x 7 ft. 4 in. One deck, two masts, square stern.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ACTIVE", "vessel_type": "schooner", "hailing_port": "Addison", "official_number": null, "tonnage": 96, "dimensions": "70 ft. x 21 ft. 8 in. x 7 ft. 4 in.", "year_built": 1802, "place_built": "Addison, Mass. (now Maine)", "builder": "Samuel Bucknam Jr.", "decks": 1, "masts": 2, "stern_type": "square", "head_type": null, "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: ACTIVE',
  $$ACTIVE, schooner, of Machias. Official No. 722. Built at Bass River, Conn., 1854. 47.06 tons; 60 ft. x 22.5 ft. x 5.8 ft. One deck, two masts, square stern, billethead.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ACTIVE", "vessel_type": "schooner", "hailing_port": "Machias", "official_number": "722", "tonnage": 47.06, "dimensions": "60 ft. x 22.5 ft. x 5.8 ft.", "year_built": 1854, "place_built": "Bass River, Conn.", "builder": null, "decks": 1, "masts": 2, "stern_type": "square", "head_type": "billethead", "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: ADA ADELIA',
  $$ADA ADELIA, schooner, of Millbridge. Official No. 1324. Built at Eastport, 1866. 17.32 tons; 48 ft. x 16.7 ft. x 4.5 ft. One deck, two masts, square stern.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ADA ADELIA", "vessel_type": "schooner", "hailing_port": "Millbridge", "official_number": "1324", "tonnage": 17.32, "dimensions": "48 ft. x 16.7 ft. x 4.5 ft.", "year_built": 1866, "place_built": "Eastport", "builder": null, "decks": 1, "masts": 2, "stern_type": "square", "head_type": null, "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: ADA BARKER',
  $$ADA BARKER, schooner, of Jonesport. Official No. 105133. Built at Jonesport, 1872, by George E. Watts, master carpenter. 231.44 gross tons, 219.87 net tons; 113 ft. x 30 ft. x 9.3 ft. One deck, three masts, square stern, billethead.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ADA BARKER", "vessel_type": "schooner", "hailing_port": "Jonesport", "official_number": "105133", "tonnage": 231.44, "tonnage_net": 219.87, "dimensions": "113 ft. x 30 ft. x 9.3 ft.", "year_built": 1872, "place_built": "Jonesport", "builder": "George E. Watts", "decks": 1, "masts": 3, "stern_type": "square", "head_type": "billethead", "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: ADA WISWELL',
  $$ADA WISWELL, bark, of New York City. Official No. 105399. Built at East Machias, 1874, by William H. Stevens, master carpenter. 557.85 tons; 140 ft. x 30.2 ft. x 16.9 ft. Two decks, three masts, square stern, billethead.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ADA WISWELL", "vessel_type": "bark", "hailing_port": "New York City", "official_number": "105399", "tonnage": 557.85, "dimensions": "140 ft. x 30.2 ft. x 16.9 ft.", "year_built": 1874, "place_built": "East Machias", "builder": "William H. Stevens", "decks": 2, "masts": 3, "stern_type": "square", "head_type": "billethead", "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: ADA P. GOULD',
  $$ADA P. GOULD, bark, of Addison. Official No. 105377. Built at Addison, 1874, by James W. Sawyer, master carpenter. 521.15 gross tons, 495.10 net tons; 131.6 ft. x 31.2 ft. x 17.5 ft. Two decks, three masts, elliptic stern, billethead.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ADA P. GOULD", "vessel_type": "bark", "hailing_port": "Addison", "official_number": "105377", "tonnage": 521.15, "tonnage_net": 495.10, "dimensions": "131.6 ft. x 31.2 ft. x 17.5 ft.", "year_built": 1874, "place_built": "Addison", "builder": "James W. Sawyer", "decks": 2, "masts": 3, "stern_type": "elliptic", "head_type": "billethead", "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: ADALINE RICHARDSON',
  $$ADALINE RICHARDSON, brig, of Addison. Official No. 1831. Built at Addison, 1867, by L. A. Knowles, master carpenter. 223.42 tons; 107.35 ft. x 28.25 ft. x 10.50 ft. One deck, two masts, square stern, billethead.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ADALINE RICHARDSON", "vessel_type": "brig", "hailing_port": "Addison", "official_number": "1831", "tonnage": 223.42, "dimensions": "107.35 ft. x 28.25 ft. x 10.50 ft.", "year_built": 1867, "place_built": "Addison", "builder": "L. A. Knowles", "decks": 1, "masts": 2, "stern_type": "square", "head_type": "billethead", "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: ADALINE AND ROSINA',
  $$ADALINE AND ROSINA, schooner, of East Machias. Built at East Machias, 1844, by John Bancroft, master carpenter. 110 14/95 tons; 75 ft. 8 in. x 22 ft. 9 in. x 7 ft. 5 in. One deck, two masts, square stern, billethead.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ADALINE AND ROSINA", "vessel_type": "schooner", "hailing_port": "East Machias", "official_number": null, "tonnage": 110.14, "dimensions": "75 ft. 8 in. x 22 ft. 9 in. x 7 ft. 5 in.", "year_built": 1844, "place_built": "East Machias", "builder": "John Bancroft", "decks": 1, "masts": 2, "stern_type": "square", "head_type": "billethead", "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: ADAMS',
  $$ADAMS, schooner, of Steuben. Built at Steuben, 1825, by Asa Dyer, master carpenter. 129 12/95 tons; 74 ft. 2 in. x 23 ft. 4 in. x 8 ft. 8 in. One deck, two masts, square stern.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ADAMS", "vessel_type": "schooner", "hailing_port": "Steuben", "official_number": null, "tonnage": 129.12, "dimensions": "74 ft. 2 in. x 23 ft. 4 in. x 8 ft. 8 in.", "year_built": 1825, "place_built": "Steuben", "builder": "Asa Dyer", "decks": 1, "masts": 2, "stern_type": "square", "head_type": null, "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: ADDIE',
  $$ADDIE, schooner, of Boothbay Harbor. Official No. 511. Built at Kennebunkport, 1867. 76 tons; 75.2 ft. x 23.3 ft. x 7.1 ft. One deck, two masts, square stern, billethead.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ADDIE", "vessel_type": "schooner", "hailing_port": "Boothbay Harbor", "official_number": "511", "tonnage": 76, "dimensions": "75.2 ft. x 23.3 ft. x 7.1 ft.", "year_built": 1867, "place_built": "Kennebunkport", "builder": null, "decks": 1, "masts": 2, "stern_type": "square", "head_type": "billethead", "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: ADDIE J',
  $$ADDIE J, schooner, of Machias. Official No. 105904. Built at Millbridge, 1880, by Gilbert M. Leighton, master carpenter. 41.93 gross tons, 39.84 net tons; 58 ft. x 19.3 ft. x 5.7 ft. One deck, two masts, square stern, billethead.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ADDIE J", "vessel_type": "schooner", "hailing_port": "Machias", "official_number": "105904", "tonnage": 41.93, "tonnage_net": 39.84, "dimensions": "58 ft. x 19.3 ft. x 5.7 ft.", "year_built": 1880, "place_built": "Millbridge", "builder": "Gilbert M. Leighton", "decks": 1, "masts": 2, "stern_type": "square", "head_type": "billethead", "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: ADDIE FULLER',
  $$ADDIE FULLER, schooner, of Boston, Mass. Official No. 1443. Built at Thomaston, 1867. 206.22 tons; 106.4 ft. x 29.8 ft. x 9.2 ft. One deck, two masts, square stern, billethead.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ADDIE FULLER", "vessel_type": "schooner", "hailing_port": "Boston, Mass.", "official_number": "1443", "tonnage": 206.22, "dimensions": "106.4 ft. x 29.8 ft. x 9.2 ft.", "year_built": 1867, "place_built": "Thomaston", "builder": null, "decks": 1, "masts": 2, "stern_type": "square", "head_type": "billethead", "owners_first_enrollment": null, "master_first_enrollment": null}'
);

INSERT INTO documents (title, content, doc_type, source_url, archive_name, metadata) VALUES
(
  'Ship Registry: ADDIE RYARSON',
  $$ADDIE RYARSON, schooner, of Lubec. Official No. 1110. Built at Lubec, 1865. 178.10 tons; 98.7 ft. x 26 ft. x 9.7 ft. One deck, two masts, square stern, billethead.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ADDIE RYARSON", "vessel_type": "schooner", "hailing_port": "Lubec", "official_number": "1110", "tonnage": 178.10, "dimensions": "98.7 ft. x 26 ft. x 9.7 ft.", "year_built": 1865, "place_built": "Lubec", "builder": null, "decks": 1, "masts": 2, "stern_type": "square", "head_type": "billethead", "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: ADDIE E. SNOW',
  $$ADDIE E. SNOW, schooner, of Rockland. Official No. 105616. Built at Rockland, 1876. 154.73 tons; 95.8 ft. x 26.4 ft. x 9.4 ft. One deck, two masts, square stern, billethead.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ADDIE E. SNOW", "vessel_type": "schooner", "hailing_port": "Rockland", "official_number": "105616", "tonnage": 154.73, "dimensions": "95.8 ft. x 26.4 ft. x 9.4 ft.", "year_built": 1876, "place_built": "Rockland", "builder": null, "decks": 1, "masts": 2, "stern_type": "square", "head_type": "billethead", "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: ADDIE L. PERKINS',
  $$ADDIE L. PERKINS, schooner, of Millbridge. Official No. 1940. Built at Penobscot, 1873. 80.04 tons; 78.5 ft. x 22 ft. x 7 ft. One deck, two masts, square stern, billethead.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ADDIE L. PERKINS", "vessel_type": "schooner", "hailing_port": "Millbridge", "official_number": "1940", "tonnage": 80.04, "dimensions": "78.5 ft. x 22 ft. x 7 ft.", "year_built": 1873, "place_built": "Penobscot", "builder": null, "decks": 1, "masts": 2, "stern_type": "square", "head_type": "billethead", "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: ADDISON',
  $$ADDISON, schooner, of Addison. Built at Addison, 1831, by Nathaniel Nash, master carpenter. 115 11/95 tons; 74 ft. x 22 ft. 4 in. x 8 ft. 1 in. One deck, two masts, square stern.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ADDISON", "vessel_type": "schooner", "hailing_port": "Addison", "official_number": null, "tonnage": 115.11, "dimensions": "74 ft. x 22 ft. 4 in. x 8 ft. 1 in.", "year_built": 1831, "place_built": "Addison", "builder": "Nathaniel Nash", "decks": 1, "masts": 2, "stern_type": "square", "head_type": null, "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: ADELAIDE',
  $$ADELAIDE, schooner, of Machias. Official No. 452. Built at Surry, 1839. 89.70 gross tons, 85.22 net tons; 77.4 ft. x 23.2 ft. x 6.9 ft. One deck, two masts, square stern, billethead.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ADELAIDE", "vessel_type": "schooner", "hailing_port": "Machias", "official_number": "452", "tonnage": 89.70, "tonnage_net": 85.22, "dimensions": "77.4 ft. x 23.2 ft. x 6.9 ft.", "year_built": 1839, "place_built": "Surry", "builder": null, "decks": 1, "masts": 2, "stern_type": "square", "head_type": "billethead", "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: ADOLF ENGLES',
  $$ADOLF ENGLES, bark, of New York City. Official No. 105424. Built at Millbridge, 1874, by Eli Foster, master carpenter. 648.27 tons; 142 ft. x 32.3 ft. x 18.2 ft. Two decks, three masts, elliptic stern, figurehead.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ADOLF ENGLES", "vessel_type": "bark", "hailing_port": "New York City", "official_number": "105424", "tonnage": 648.27, "dimensions": "142 ft. x 32.3 ft. x 18.2 ft.", "year_built": 1874, "place_built": "Millbridge", "builder": "Eli Foster", "decks": 2, "masts": 3, "stern_type": "elliptic", "head_type": "figurehead", "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: ADVANCE',
  $$ADVANCE, brig, of Addison. Built at Brewer, 1845. 160 28/95 tons; 89 ft. 8 in. x 23 ft. 10 in. x 8 ft. 6 in. One deck, two masts, square stern, billethead.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ADVANCE", "vessel_type": "brig", "hailing_port": "Addison", "official_number": null, "tonnage": 160.29, "dimensions": "89 ft. 8 in. x 23 ft. 10 in. x 8 ft. 6 in.", "year_built": 1845, "place_built": "Brewer", "builder": null, "decks": 1, "masts": 2, "stern_type": "square", "head_type": "billethead", "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: AEROLITE',
  $$AEROLITE, oil screw, of Jonesport. Official No. 226868. Built at Dennysville, 1927. 25.91 gross tons, 12 net tons; 51.2 ft. x 14.7 ft. x 6.2 ft. One deck, two masts, square stern, plain head, built of wood.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "AEROLITE", "vessel_type": "oil screw", "hailing_port": "Jonesport", "official_number": "226868", "tonnage": 25.91, "tonnage_net": 12, "dimensions": "51.2 ft. x 14.7 ft. x 6.2 ft.", "year_built": 1927, "place_built": "Dennysville", "builder": null, "decks": 1, "masts": 2, "stern_type": "square", "head_type": "plain head", "construction_material": "wood", "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: AGATE',
  $$AGATE, brig, of Machias. Built at Machiasport, 1848, by James Stuart, master carpenter. 194 88/95 tons; 95 ft. 5 in. x 24 ft. 2 in. x 9 ft. 5 in. One deck, two masts, square stern, billethead.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "AGATE", "vessel_type": "brig", "hailing_port": "Machias", "official_number": null, "tonnage": 194.92, "dimensions": "95 ft. 5 in. x 24 ft. 2 in. x 9 ft. 5 in.", "year_built": 1848, "place_built": "Machiasport", "builder": "James Stuart", "decks": 1, "masts": 2, "stern_type": "square", "head_type": "billethead", "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: AGENORIA',
  $$AGENORIA, brig, of Machias. Built at Jonesboro, 1822, by Samuel Small, master carpenter. 171 8/95 tons; 80 ft. x 23 ft. x 10 ft. 8 in. One deck, two masts, square stern.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "AGENORIA", "vessel_type": "brig", "hailing_port": "Machias", "official_number": null, "tonnage": 171.08, "dimensions": "80 ft. x 23 ft. x 10 ft. 8 in.", "year_built": 1822, "place_built": "Jonesboro", "builder": "Samuel Small", "decks": 1, "masts": 2, "stern_type": "square", "head_type": null, "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: AGRICOLA',
  $$AGRICOLA, schooner, of New York City. Official No. 433. Built at Biddeford, 1836, by Cyrus Gordon, master carpenter. 64.41 tons; 70.7 ft. x 22.4 ft. x 6.6 ft. One deck, two masts, square stern, billethead.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "AGRICOLA", "vessel_type": "schooner", "hailing_port": "New York City", "official_number": "433", "tonnage": 64.41, "dimensions": "70.7 ft. x 22.4 ft. x 6.6 ft.", "year_built": 1836, "place_built": "Biddeford", "builder": "Cyrus Gordon", "decks": 1, "masts": 2, "stern_type": "square", "head_type": "billethead", "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: AILSA',
  $$AILSA, gas screw, of Jonesport. Official No. 107329. Built at Machias, 1895. 8 gross tons, 6 net tons; 37.5 ft. x 13.2 ft. x 5.6 ft. One deck, one mast, pink stern, billethead, built of wood.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "AILSA", "vessel_type": "gas screw", "hailing_port": "Jonesport", "official_number": "107329", "tonnage": 8, "tonnage_net": 6, "dimensions": "37.5 ft. x 13.2 ft. x 5.6 ft.", "year_built": 1895, "place_built": "Machias", "builder": null, "decks": 1, "masts": 1, "stern_type": "pink", "head_type": "billethead", "construction_material": "wood", "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: AKBAR',
  $$AKBAR, brig, of Machias. Official No. 105352. Built at Machias, 1874, by J. L. Nash, master carpenter. 432.16 gross tons, 414.59 net tons; 127.5 ft. x 28.5 ft. x 16.8 ft. Two decks, two masts, square stern, billethead.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "AKBAR", "vessel_type": "brig", "hailing_port": "Machias", "official_number": "105352", "tonnage": 432.16, "tonnage_net": 414.59, "dimensions": "127.5 ft. x 28.5 ft. x 16.8 ft.", "year_built": 1874, "place_built": "Machias", "builder": "J. L. Nash", "decks": 2, "masts": 2, "stern_type": "square", "head_type": "billethead", "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: ALAMO',
  $$ALAMO, brig, of East Machias. Official No. 534. Built at East Machias, 1856, by William E. Cummings, master carpenter. 171 51/95 tons; 93 ft. 7 in. x 24 ft. 10 in. x 8 ft. 4 in. One deck, two masts, square stern, billethead.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ALAMO", "vessel_type": "brig", "hailing_port": "East Machias", "official_number": "534", "tonnage": 171.53, "dimensions": "93 ft. 7 in. x 24 ft. 10 in. x 8 ft. 4 in.", "year_built": 1856, "place_built": "East Machias", "builder": "William E. Cummings", "decks": 1, "masts": 2, "stern_type": "square", "head_type": "billethead", "owners_first_enrollment": null, "master_first_enrollment": null}'
);

INSERT INTO documents (title, content, doc_type, source_url, archive_name, metadata) VALUES
(
  'Ship Registry: ALASKA',
  $$ALASKA, schooner, of East Machias. Official No. 1561. Built at East Machias, 1867, by William E. Cummings, master carpenter. 173.61 gross tons, 164.93 net tons; 102 ft. x 26.1 ft. x 9.1 ft. One deck, two masts, square stern, billethead, built of wood.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ALASKA", "vessel_type": "schooner", "hailing_port": "East Machias", "official_number": "1561", "tonnage": 173.61, "tonnage_net": 164.93, "dimensions": "102 ft. x 26.1 ft. x 9.1 ft.", "year_built": 1867, "place_built": "East Machias", "builder": "William E. Cummings", "decks": 1, "masts": 2, "stern_type": "square", "head_type": "billethead", "construction_material": "wood", "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: ALBATROSS',
  $$ALBATROSS, schooner, of Jonesboro. Built at Jonesboro, 1826, by Sylvanus Coombs, master carpenter. 27 17/95 tons; 40 ft. 7 in. x 13 ft. 2 in. x 6 ft. One deck, two masts, square stern.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ALBATROSS", "vessel_type": "schooner", "hailing_port": "Jonesboro", "official_number": null, "tonnage": 27.17, "dimensions": "40 ft. 7 in. x 13 ft. 2 in. x 6 ft.", "year_built": 1826, "place_built": "Jonesboro", "builder": "Sylvanus Coombs", "decks": 1, "masts": 2, "stern_type": "square", "head_type": null, "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: ALBATROSS',
  $$ALBATROSS, schooner, of Steuben. Official No. 1321. Built at Clinton, Conn., 1839. 45.38 tons; 59.2 ft. x 20.5 ft. x 6 ft. One deck, two masts, square stern, billethead.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ALBATROSS", "vessel_type": "schooner", "hailing_port": "Steuben", "official_number": "1321", "tonnage": 45.38, "dimensions": "59.2 ft. x 20.5 ft. x 6 ft.", "year_built": 1839, "place_built": "Clinton, Conn.", "builder": null, "decks": 1, "masts": 2, "stern_type": "square", "head_type": "billethead", "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: ALBERT',
  $$ALBERT, schooner, of Jonesport. Official No. 533. Built at Harrington, 1849. 99 8/95 tons; 72 ft. x 21 ft. 9 in. x 7 ft. 5 in. One deck, two masts, square stern, billethead.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ALBERT", "vessel_type": "schooner", "hailing_port": "Jonesport", "official_number": "533", "tonnage": 99.08, "dimensions": "72 ft. x 21 ft. 9 in. x 7 ft. 5 in.", "year_built": 1849, "place_built": "Harrington", "builder": null, "decks": 1, "masts": 2, "stern_type": "square", "head_type": "billethead", "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: ALBERT TREAT',
  $$ALBERT TREAT, schooner, of New York City. Official No. 851. Built at Franklin, 1859. 140.95 tons; 87 ft. x 23.9 ft. x 7.8 ft. One deck, two masts, square stern, billethead.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ALBERT TREAT", "vessel_type": "schooner", "hailing_port": "New York City", "official_number": "851", "tonnage": 140.95, "dimensions": "87 ft. x 23.9 ft. x 7.8 ft.", "year_built": 1859, "place_built": "Franklin", "builder": null, "decks": 1, "masts": 2, "stern_type": "square", "head_type": "billethead", "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: ALBERT L. BUTLER',
  $$ALBERT L. BUTLER, schooner, of Boston, Mass. Official No. 1826. Built at Thomaston, 1869. 344.01 tons; 119.9 ft. x 29.8 ft. x 10.1 ft. One deck, three masts, square stern, billethead.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ALBERT L. BUTLER", "vessel_type": "schooner", "hailing_port": "Boston, Mass.", "official_number": "1826", "tonnage": 344.01, "dimensions": "119.9 ft. x 29.8 ft. x 10.1 ft.", "year_built": 1869, "place_built": "Thomaston", "builder": null, "decks": 1, "masts": 3, "stern_type": "square", "head_type": "billethead", "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: ALEXANDER CAMPBELL',
  $$ALEXANDER CAMPBELL, bark, of Cherryfield. Official No. 105362. Built at Cherryfield, 1874, by Eli Foster, master carpenter. 475.01 tons; 139.6 ft. x 31.4 ft. x 12.2 ft. One deck, three masts, elliptic stern, figurehead.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ALEXANDER CAMPBELL", "vessel_type": "bark", "hailing_port": "Cherryfield", "official_number": "105362", "tonnage": 475.01, "dimensions": "139.6 ft. x 31.4 ft. x 12.2 ft.", "year_built": 1874, "place_built": "Cherryfield", "builder": "Eli Foster", "decks": 1, "masts": 3, "stern_type": "elliptic", "head_type": "figurehead", "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: ALEXANDER MILLIKEN',
  $$ALEXANDER MILLIKEN, brig, of Jonesport. Built at Jonesport, 1848, by Jeremiah Drisko, master carpenter. 176 18/95 tons; 88 ft. 7 1/2 in. x 24 ft. 9 in. x 9 ft. 2 in. One deck, two masts, square stern, billethead.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ALEXANDER MILLIKEN", "vessel_type": "brig", "hailing_port": "Jonesport", "official_number": null, "tonnage": 176.18, "dimensions": "88 ft. 7.5 in. x 24 ft. 9 in. x 9 ft. 2 in.", "year_built": 1848, "place_built": "Jonesport", "builder": "Jeremiah Drisko", "decks": 1, "masts": 2, "stern_type": "square", "head_type": "billethead", "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: ALEXANDER NICKELS',
  $$ALEXANDER NICKELS, brig, of New York City. Official No. 860. Built at Cherryfield, 1863. 271.08 tons; 110 ft. x 26.5 ft. x 9.5 ft. One deck, two masts, elliptic stern, billethead.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ALEXANDER NICKELS", "vessel_type": "brig", "hailing_port": "New York City", "official_number": "860", "tonnage": 271.08, "dimensions": "110 ft. x 26.5 ft. x 9.5 ft.", "year_built": 1863, "place_built": "Cherryfield", "builder": null, "decks": 1, "masts": 2, "stern_type": "elliptic", "head_type": "billethead", "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: ALEXANDRIA',
  $$ALEXANDRIA, schooner, of Jonesport. Official No. 530. Built at Augusta, 1845. 95.46 tons; 78 ft. x 23.3 ft. x 7.7 ft. One deck, two masts, square stern, billethead.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ALEXANDRIA", "vessel_type": "schooner", "hailing_port": "Jonesport", "official_number": "530", "tonnage": 95.46, "dimensions": "78 ft. x 23.3 ft. x 7.7 ft.", "year_built": 1845, "place_built": "Augusta", "builder": null, "decks": 1, "masts": 2, "stern_type": "square", "head_type": "billethead", "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: ALBION',
  $$ALBION, schooner, of Sullivan. Built at Camden, Mass. (now Maine), 1805. 100 75/95 tons; 72 ft. x 20 ft. 9 in. x 7 ft. 9 in. One deck, two masts, square stern.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ALBION", "vessel_type": "schooner", "hailing_port": "Sullivan", "official_number": null, "tonnage": 100.78, "dimensions": "72 ft. x 20 ft. 9 in. x 7 ft. 9 in.", "year_built": 1805, "place_built": "Camden, Mass. (now Maine)", "builder": null, "decks": 1, "masts": 2, "stern_type": "square", "head_type": null, "owners_first_enrollment": null, "master_first_enrollment": null}'
);

INSERT INTO documents (title, content, doc_type, source_url, archive_name, metadata) VALUES
(
  'Ship Registry: ALBION',
  $$ALBION, schooner, of Steuben. Built at Steuben, 1826, by Samuel Parrish, master carpenter. 45 61/95 tons; 49 ft. x 17 ft. x 6 ft. 7 in. One deck, two masts, square stern, figurehead.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ALBION", "vessel_type": "schooner", "hailing_port": "Steuben", "official_number": null, "tonnage": 45.64, "dimensions": "49 ft. x 17 ft. x 6 ft. 7 in.", "year_built": 1826, "place_built": "Steuben", "builder": "Samuel Parrish", "decks": 1, "masts": 2, "stern_type": "square", "head_type": "figurehead", "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: ALCORA',
  $$ALCORA, schooner, of East Machias. Official No. 536. Built at East Machias, 1864, by William E. Cummings, master carpenter. 197 64/95 tons; 94 ft. 6 in. x 25 ft. 8 in. x 9 ft. 3 in. One deck, two masts, square stern, billethead.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ALCORA", "vessel_type": "schooner", "hailing_port": "East Machias", "official_number": "536", "tonnage": 197.67, "dimensions": "94 ft. 6 in. x 25 ft. 8 in. x 9 ft. 3 in.", "year_built": 1864, "place_built": "East Machias", "builder": "William E. Cummings", "decks": 1, "masts": 2, "stern_type": "square", "head_type": "billethead", "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: ALDINE',
  $$ALDINE, schooner, of East Machias. Official No. 105320. Built at East Machias, 1873, by William E. Cummings, master carpenter. 202.74 tons; 105.5 ft. x 26.7 ft. x 9.65 ft. One deck, two masts, square stern, billethead.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ALDINE", "vessel_type": "schooner", "hailing_port": "East Machias", "official_number": "105320", "tonnage": 202.74, "dimensions": "105.5 ft. x 26.7 ft. x 9.65 ft.", "year_built": 1873, "place_built": "East Machias", "builder": "William E. Cummings", "decks": 1, "masts": 2, "stern_type": "square", "head_type": "billethead", "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: ALICE LORD',
  $$ALICE LORD, schooner, of Bangor. Official No. 107774. Built at Millbridge, 1902, by Charles C. Strout, master carpenter. 373 gross tons, 291 net tons; 134.1 ft. x 32 ft. x 10.3 ft. One deck, three masts, elliptic stern, billethead.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ALICE LORD", "vessel_type": "schooner", "hailing_port": "Bangor", "official_number": "107774", "tonnage": 373, "tonnage_net": 291, "dimensions": "134.1 ft. x 32 ft. x 10.3 ft.", "year_built": 1902, "place_built": "Millbridge", "builder": "Charles C. Strout", "decks": 1, "masts": 3, "stern_type": "elliptic", "head_type": "billethead", "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: ALICE BENTLEY',
  $$ALICE BENTLEY, brig, of Columbia. Built at Columbia, 1847, by Samuel Small, master carpenter. 197 43/95 tons; 88 ft. x 24 ft. 10 in. x 10 ft. 4 in. One deck, two masts, square stern, figurehead.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ALICE BENTLEY", "vessel_type": "brig", "hailing_port": "Columbia", "official_number": null, "tonnage": 197.45, "dimensions": "88 ft. x 24 ft. 10 in. x 10 ft. 4 in.", "year_built": 1847, "place_built": "Columbia", "builder": "Samuel Small", "decks": 1, "masts": 2, "stern_type": "square", "head_type": "figurehead", "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: ALLEGRO',
  $$ALLEGRO, schooner, of East Machias. Official No. 105231. Built at East Machias, 1873, by William E. Cummings, master carpenter. 173.35 tons; 100 ft. x 26.5 ft. x 9.15 ft. One deck, two masts, square stern, billethead.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ALLEGRO", "vessel_type": "schooner", "hailing_port": "East Machias", "official_number": "105231", "tonnage": 173.35, "dimensions": "100 ft. x 26.5 ft. x 9.15 ft.", "year_built": 1873, "place_built": "East Machias", "builder": "William E. Cummings", "decks": 1, "masts": 2, "stern_type": "square", "head_type": "billethead", "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: ALMA',
  $$ALMA, schooner, of East Machias. Official No. 105150. Built at East Machias, 1872, by Robert M. Cummings, master carpenter. 180.17 gross tons, 171.16 net tons; 104 ft. x 26.55 ft. x 8.81 ft. One deck, two masts, square stern, billethead.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ALMA", "vessel_type": "schooner", "hailing_port": "East Machias", "official_number": "105150", "tonnage": 180.17, "tonnage_net": 171.16, "dimensions": "104 ft. x 26.55 ft. x 8.81 ft.", "year_built": 1872, "place_built": "East Machias", "builder": "Robert M. Cummings", "decks": 1, "masts": 2, "stern_type": "square", "head_type": "billethead", "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: ALMIRA',
  $$ALMIRA, schooner, of Steuben. Built at Steuben, 1821, by Walter Dyer, master carpenter. 82 7/95 tons; 62 ft. x 19 ft. 4 in. x 8 ft. One deck, two masts, square stern.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ALMIRA", "vessel_type": "schooner", "hailing_port": "Steuben", "official_number": null, "tonnage": 82.07, "dimensions": "62 ft. x 19 ft. 4 in. x 8 ft.", "year_built": 1821, "place_built": "Steuben", "builder": "Walter Dyer", "decks": 1, "masts": 2, "stern_type": "square", "head_type": null, "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: ALONZO SMALL',
  $$ALONZO SMALL, bark, of New York City. Official No. 85323. Built at Millbridge, 1874, by Edmund L. Young, master carpenter. 468.55 tons; 138.6 ft. x 30.1 ft. x 12.1 ft. One deck, three masts, elliptic stern, billethead.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ALONZO SMALL", "vessel_type": "bark", "hailing_port": "New York City", "official_number": "85323", "tonnage": 468.55, "dimensions": "138.6 ft. x 30.1 ft. x 12.1 ft.", "year_built": 1874, "place_built": "Millbridge", "builder": "Edmund L. Young", "decks": 1, "masts": 3, "stern_type": "elliptic", "head_type": "billethead", "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: ALPHA',
  $$ALPHA, schooner, of East Machias. Official No. 529. Built at East Machias, 1867, by William H. Knight, master carpenter. 143.81 tons; 96 ft. x 26.3 ft. x 8.3 ft. One deck, two masts, square stern, billethead.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ALPHA", "vessel_type": "schooner", "hailing_port": "East Machias", "official_number": "529", "tonnage": 143.81, "dimensions": "96 ft. x 26.3 ft. x 8.3 ft.", "year_built": 1867, "place_built": "East Machias", "builder": "William H. Knight", "decks": 1, "masts": 2, "stern_type": "square", "head_type": "billethead", "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: ALPINE',
  $$ALPINE, schooner, of Machias. Official No. 178. Built at Brunswick, 1849. 73.49 tons; 69.1 ft. x 22.7 ft. x 6.9 ft. One deck, two masts, square stern, billethead.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ALPINE", "vessel_type": "schooner", "hailing_port": "Machias", "official_number": "178", "tonnage": 73.49, "dimensions": "69.1 ft. x 22.7 ft. x 6.9 ft.", "year_built": 1849, "place_built": "Brunswick", "builder": null, "decks": 1, "masts": 2, "stern_type": "square", "head_type": "billethead", "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: ALTA V. COLE',
  $$ALTA V. COLE, schooner, of Harrington. Official No. 105441. Built at Harrington, 1874, by Galen C. Wilson, master carpenter. 202.71 gross tons, 192.58 net tons; 106 ft. x 29.1 ft. x 9.35 ft. One deck, two masts, elliptic stern, billethead.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ALTA V. COLE", "vessel_type": "schooner", "hailing_port": "Harrington", "official_number": "105441", "tonnage": 202.71, "tonnage_net": 192.58, "dimensions": "106 ft. x 29.1 ft. x 9.35 ft.", "year_built": 1874, "place_built": "Harrington", "builder": "Galen C. Wilson", "decks": 1, "masts": 2, "stern_type": "elliptic", "head_type": "billethead", "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: ALZENA',
  $$ALZENA, schooner, of Harrington. Built at Harrington, 1871, by Woodbury Leighton, master carpenter. 283.58 tons; 114.85 ft. x 28 ft. x 13.3 ft. One deck, two masts, elliptic stern, figurehead.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "ALZENA", "vessel_type": "schooner", "hailing_port": "Harrington", "official_number": null, "tonnage": 283.58, "dimensions": "114.85 ft. x 28 ft. x 13.3 ft.", "year_built": 1871, "place_built": "Harrington", "builder": "Woodbury Leighton", "decks": 1, "masts": 2, "stern_type": "elliptic", "head_type": "figurehead", "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: AMANDA',
  $$AMANDA, schooner, of Jonesport. Built at Warren, 1836, by Philip Montgomery, master carpenter. 114 19/95 tons; 78 ft. 2 in. x 23 ft. 1 in. x 7 ft. 4 in. One deck, two masts, square stern.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "AMANDA", "vessel_type": "schooner", "hailing_port": "Jonesport", "official_number": null, "tonnage": 114.20, "dimensions": "78 ft. 2 in. x 23 ft. 1 in. x 7 ft. 4 in.", "year_built": 1836, "place_built": "Warren", "builder": "Philip Montgomery", "decks": 1, "masts": 2, "stern_type": "square", "head_type": null, "owners_first_enrollment": null, "master_first_enrollment": null}'
);

INSERT INTO documents (title, content, doc_type, source_url, archive_name, metadata) VALUES
(
  'Ship Registry: AMANDA',
  $$AMANDA, brig, of Machias. Built at Machias, 1840, by John D. Smith, master carpenter. 177 58/95 tons; 87 ft. 10 in. x 24 ft. 11 in. x 9 ft. 3 1/2 in. One deck, two masts, square stern, figurehead.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "AMANDA", "vessel_type": "brig", "hailing_port": "Machias", "official_number": null, "tonnage": 177.61, "dimensions": "87 ft. 10 in. x 24 ft. 11 in. x 9 ft. 3.5 in.", "year_built": 1840, "place_built": "Machias", "builder": "John D. Smith", "decks": 1, "masts": 2, "stern_type": "square", "head_type": "figurehead", "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: AMELIA',
  $$AMELIA, schooner, of Machias. Built at Machias, 1857, by John Shaw, master carpenter. 147 35/95 tons; 85 ft. x 24 ft. x 7 ft. 10 in. One deck, two masts, square stern, billethead.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "AMELIA", "vessel_type": "schooner", "hailing_port": "Machias", "official_number": null, "tonnage": 147.36, "dimensions": "85 ft. x 24 ft. x 7 ft. 10 in.", "year_built": 1857, "place_built": "Machias", "builder": "John Shaw", "decks": 1, "masts": 2, "stern_type": "square", "head_type": "billethead", "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: AMERICA',
  $$AMERICA, schooner, of Harrington. Built at Dover, N. H., 1807. 27 72/95 tons; 42 ft. 9 in. x 12 ft. 11 in. x 5 ft. 10 in. One deck, two masts, pink stern.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "AMERICA", "vessel_type": "schooner", "hailing_port": "Harrington", "official_number": null, "tonnage": 27.75, "dimensions": "42 ft. 9 in. x 12 ft. 11 in. x 5 ft. 10 in.", "year_built": 1807, "place_built": "Dover, N. H.", "builder": null, "decks": 1, "masts": 2, "stern_type": "pink", "head_type": null, "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: AMERICA',
  $$AMERICA, schooner, of Addison. Built at Addison, Mass. (now Maine), 1816, by Samuel Small, master carpenter. 159 85/95 tons; 81 ft. 11 in. x 23 ft. 4 in. x 9 ft. 7 in. One deck, two masts, square stern.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "AMERICA", "vessel_type": "schooner", "hailing_port": "Addison", "official_number": null, "tonnage": 159.89, "dimensions": "81 ft. 11 in. x 23 ft. 4 in. x 9 ft. 7 in.", "year_built": 1816, "place_built": "Addison, Mass. (now Maine)", "builder": "Samuel Small", "decks": 1, "masts": 2, "stern_type": "square", "head_type": null, "owners_first_enrollment": null, "master_first_enrollment": null}'
),
(
  'Ship Registry: AMERICAN TEAM',
  $$AMERICAN TEAM, schooner, of Bangor. Official No. 105609. Built at Lyme, Conn., 1876. 376 gross tons, 307 net tons; 121.2 ft. x 31.4 ft. x 11 ft. Two decks, three masts, elliptic stern, billethead.$$,
  'vessel_registry',
  NULL,
  'Machias Ship Registers 1780-1930',
  '{"vessel_name": "AMERICAN TEAM", "vessel_type": "schooner", "hailing_port": "Bangor", "official_number": "105609", "tonnage": 376, "tonnage_net": 307, "dimensions": "121.2 ft. x 31.4 ft. x 11 ft.", "year_built": 1876, "place_built": "Lyme, Conn.", "builder": null, "decks": 2, "masts": 3, "stern_type": "elliptic", "head_type": "billethead", "owners_first_enrollment": null, "master_first_enrollment": null}'
);
-- Enrichment Documents for Machias Ship Registers 1780-1930 RAG Application
-- New England Maritime History

-- SHIP CONSTRUCTION & TYPES

INSERT INTO documents (title, content, doc_type, source_url, archive_name, metadata) VALUES (
  'Schooner Construction in 19th-Century Maine',
  $$Schooners dominated the fleet of the Machias customs district and represented the pinnacle of American maritime design in the 19th century. These vessels, typically two-masted with fore-and-aft rigging, were the workhorses of coastal trade and distant commerce from Maine's shipyards.

The construction of a Maine schooner began with careful selection of timber. Master builders preferred white oak for frames and keels, prized for its strength and durability in saltwater environments. Pine from Maine's vast forests provided the planking, while locust wood served for treenails and other structural components. The process started with laying the keel on riverbanks or beaches near Machias, Cherryfield, and East Machias—no formal shipyards existed in Washington County.

A typical schooner of the mid-19th century measured between 80-120 feet in length, displaced 150-300 tons under the old measurement system, and required a crew of eight to twelve men. The two masts—the foremast and the mainmast—were stepped at specific intervals to optimize sail efficiency. Schooners excelled in varied wind conditions and could navigate shallow rivers and harbors better than larger square-rigged vessels, making them ideal for the Maine coast's numerous inlets and ports.

The launch of a newly built schooner was a community event. The vessel, christened with the owner's chosen name and registered at the customs house, would slide down wooden ways into the river or bay. Local families often held fractional shares in the ownership, distributing both the risk and profit of the voyage. Construction took several months and cost between $4,000-$8,000 depending on size and finish. Master carpenters like William E. Cummings, Eli Foster, and James W. Sawyer earned reputations that brought clients from throughout Maine and beyond.

Rigging a schooner required skilled sailors and sailmakers. The mainsail and foresail were the primary working canvas, supplemented by jibs, staysails, and topsails. This arrangement allowed a small crew to manage the vessel efficiently across hundreds of miles of ocean. The speed and reliability of these Maine-built schooners made them highly sought in international commerce.$$,
  'ship_construction',
  NULL,
  'New England Maritime History',
  '{"topic": "Schooner design and construction", "region": "Washington County, Maine", "time_period": "1800-1900", "keywords": ["schooners", "shipbuilding", "Maine", "timber", "rigging", "Machias"]}'
);

INSERT INTO documents (title, content, doc_type, source_url, archive_name, metadata) VALUES (
  'Brigs and Barks of the Down East Fleet',
  $$While schooners dominated Maine's coastwise trade, larger square-rigged vessels—brigs and barks—represented the deep-water fleet that carried Maine products to distant markets. These more substantially built vessels required different construction techniques and were typically built for owners with greater capital resources.

A brig carried two masts, both square-rigged, with a crew of fifteen to twenty men. These vessels measured 100-150 feet in length and displaced 300-500 tons. The square-rigged configuration provided efficiency on long ocean voyages, particularly in steady trade winds. Down East builders constructed brigs with stouter frames and heavier planking than schooners, as they needed to withstand the stress of deep-water voyaging. White oak and locust timber took on even greater importance in brig construction.

Barks, larger still, carried three masts with the fore and main masts square-rigged and the mizzen (aft) mast fore-and-aft rigged. This hybrid arrangement offered the advantages of both configurations: square rig efficiency for ocean passages and fore-and-aft capability for maneuvering in coastal waters. Barks frequently measured 120-180 feet and displaced 400-800 tons. Their construction demanded exceptional skill, with frames often six to eight inches thick and planking secured with hundreds of wooden treenails.

Vessels of this class were built throughout Maine but concentrated in the more established yards. Cherryfield, Columbia Falls, and the larger towns produced more barks than the smaller riverside communities. A medium-sized bark might cost $15,000-$25,000 to build, requiring significant community investment. These vessels typically made longer voyages—to Australia, the East Indies, or around Cape Horn to California—carrying lumber, fish, and other Maine products.

The crew requirements for larger vessels created demand for experienced sailors. Officers and skilled seamen commanded wages double or triple those available in coastal trade. Insurance costs were higher for deep-water vessels, reflecting the greater risks of long voyages and distant markets. Yet the profits from successful voyages to foreign ports could be substantial, making brig and bark ownership an attractive investment for Maine merchants and shipbuilders with capital to invest.$$,
  'ship_construction',
  NULL,
  'New England Maritime History',
  '{"topic": "Brigs and barks in maritime commerce", "region": "New England", "time_period": "1780-1900", "keywords": ["brigs", "barks", "deep-water vessels", "square-rigged", "shipbuilding", "Maine"]}'
);

INSERT INTO documents (title, content, doc_type, source_url, archive_name, metadata) VALUES (
  'The Fractional Ownership System in Maine Maritime Commerce',
  $$The ownership structure of Maine vessels represented a unique democratic approach to maritime commerce. Rather than individual or small group ownership, most vessels were divided into sixteenths, thirty-seconds, or sixty-fourths of shares, allowing numerous investors to participate in ownership and profit.

This fractional ownership system emerged from practical necessity. A schooner costing $5,000 represented more capital than a single farmer, shopkeeper, or merchant typically controlled. By dividing ownership into sixty-four equal shares, forty people might each invest $78, making ship ownership accessible to the broader community. Widows, merchants, sea captains, carpenters, and farming families all appeared as vessel owners in the Machias customs records.

The system distributed risk significantly. If a voyage proved unprofitable or a vessel was lost at sea, the financial burden fell across many shoulders rather than decimating a single owner. Conversely, a successful voyage returning with cargo sold at premium prices distributed profits among all shareholders. Partnership agreements specified how expenses—captain's wages, repairs, insurance, port fees—were deducted before profits were divided according to share ownership.

Women appeared frequently as vessel owners in the Washington County records. Sophronia Lamson of Machias, Hannah Faulkingham of East Machias, and Sarah A. Look of Jonesport each owned fractions of multiple vessels. These women, often widows of ship captains or merchants, actively participated in maritime commerce and accumulated significant wealth through vessel ownership.

Families typically held multiple shares across several vessels, creating a diversified portfolio of maritime investments. The Campbell family of Cherryfield, for example, might own eight sixteenths of one schooner, six sixteenths of another, and full ownership of a third, spreading investment across different vessel types, captains, and trading routes. This diversification protected against catastrophic loss.

The system also encouraged trust and cooperation within maritime communities. Families had reputational incentives to maintain vessels in good condition and employ competent captains, as their own money remained at risk. Master carpenters and merchants who consistently oversaw profitable voyages attracted investors more readily. The fractional ownership system created networks of shared interest and mutual accountability throughout Washington County's maritime industry.$$,
  'ship_construction',
  NULL,
  'New England Maritime History',
  '{"topic": "Maritime ownership and investment patterns", "region": "Washington County, Maine", "time_period": "1780-1930", "keywords": ["ownership", "shares", "shareholders", "investment", "maritime commerce", "fractional ownership"]}'
);

INSERT INTO documents (title, content, doc_type, source_url, archive_name, metadata) VALUES (
  'Ship Measurement and Tonnage in the 19th Century',
  $$Understanding vessel tonnage in historical records requires familiarity with two distinct measurement systems that governed American maritime law during the Machias Ship Registers' period. The distinction between old and new measurement, and between registered and enrolled vessels, appears throughout these documents and shaped maritime commerce.

Before 1865, American vessels were measured under the "old measurement" system, which calculated tonnage using the formula: (Length - 3/5 Beam) × Beam × (Beam ÷ 2) ÷ 94. This mathematical approach, inherited from British maritime practice, often resulted in registered tonnages that seemed disconnected from actual cargo capacity. A schooner with old measurement tonnage of 75 tons might actually hold significantly more cargo.

The "new measurement" system, implemented in 1865, shifted to more accurate cargo-capacity calculations. New measurement tonnage represented the actual cubic measurement of the hold divided by 100. Vessels built or remeasured after 1865 show dramatically different tonnage figures than their predecessors, not because the ships changed but because measurement methods became more precise. This transition appears clearly in the Machias registers, with vessels remeasured in the 1870s-1880s showing substantially different official tonnages.

Gross tonnage and net tonnage represented different values. Gross tonnage included all enclosed spaces—hold, cabin, galley, forecastle. Net tonnage subtracted space devoted to propulsion (for steamships) and crew quarters. In the registers, net tonnage typically appears as the official recorded figure for calculating port fees and customs assessments.

Enrollment versus registration served different purposes. Vessels engaged in coastal trade were "enrolled" at their local customs house, a simpler process requiring basic information about vessel and ownership. Vessels engaged in foreign trade were "registered," requiring more detailed documentation and inspection. The Machias district maintained records of both enrolled vessels (mostly coastal traders and fishing vessels) and registered vessels (international commerce). Some vessels appeared in both categories as their trading patterns changed or as merchants transitioned operations.

Dimensions were recorded in a standardized manner: length of keel, extreme length, beam (width), and depth of hold. These measurements allowed customs officials to apply tonnage formulas consistently. Master measurers employed by the customs service conducted official surveys, and their measurements became legal documents governing vessel operations and fees.$$,
  'ship_construction',
  NULL,
  'New England Maritime History',
  '{"topic": "Vessel measurement and registration systems", "region": "New England", "time_period": "1780-1930", "keywords": ["tonnage", "measurement", "old measurement", "new measurement", "enrollment", "registration", "gross tonnage", "net tonnage"]}'
);

INSERT INTO documents (title, content, doc_type, source_url, archive_name, metadata) VALUES (
  'The Master Carpenter: Maine''s Shipbuilders',
  $$The master carpenters of 19th-century Maine occupied a unique position in their communities—part artist, part businessman, part engineer. These skilled craftsmen received no formal training in shipbuilding schools but learned through apprenticeship, experience, and the collective knowledge of Maine's maritime tradition. Their reputations determined their success and shaped the quality of American merchant fleets.

William E. Cummings of East Machias earned recognition as perhaps the most prolific builder in Washington County. Between 1840 and 1880, Cummings designed and supervised construction of dozens of vessels, ranging from small coastal schooners to substantial ocean-going ships. His name appears repeatedly in the customs records as master builder or owner. Cummings developed recognizable design characteristics—his vessels were known for speed, seaworthiness, and longevity, qualities that commanded premium prices and attracted distant investors.

Eli Foster of Cherryfield represented another tier of master builder whose work earned regional recognition. Foster's yards along the Narraguagus River produced vessels that served in the lumber trade throughout the 1860s-1880s. Like Cummings, Foster held financial interests in many of his vessels, ensuring his reputation directly affected his prosperity. A poorly built vessel that failed in service damaged both builder credibility and financial returns.

James W. Sawyer, working from Columbia Falls and neighboring areas, exemplified the smaller master builder who constructed vessels more modestly than the great names but maintained consistent quality. Sawyer's vessels appear throughout the registers from the 1870s onward, many built for local owners who preferred familiar craftsmen.

No formal shipyards with permanent infrastructure existed in the Machias district. Instead, master builders selected sites along rivers and beaches where vessels could be built and launched. They contracted with local timber merchants for white oak and pine, employing local laborers—carpenters, sawyers, caulkers, and apprentices—on a project basis. The master builder coordinated this complex operation, combining technical knowledge of hull design, structural integrity, and maritime law with business acumen.

Master builders often owned shares in vessels they built, creating financial incentives for quality. If a vessel proved unseaworthy or required costly repairs, the builder bore part of the loss. This alignment of interest between builder and owner produced vessels that served reliably for decades. A well-built schooner might operate profitably for thirty to forty years, building the builder's reputation with each successful voyage.

The transition from wood to iron and steel construction in the 1880s-1890s eliminated demand for traditional Maine shipbuilders. Few adapted to new technologies, and the great age of Down East wooden shipbuilding passed within a generation.$$,
  'ship_construction',
  NULL,
  'New England Maritime History',
  '{"topic": "Master carpenters and shipbuilders", "region": "Washington County, Maine", "time_period": "1840-1900", "keywords": ["master carpenters", "shipbuilders", "Cummings", "Foster", "Sawyer", "shipbuilding", "Maine craftsmen"]}'
);

-- HISTORICAL CONTEXT

INSERT INTO documents (title, content, doc_type, source_url, archive_name, metadata) VALUES (
  'The Lumber Trade and Maine''s Maritime Economy',
  $$The lumber trade represented the economic engine driving maritime development throughout New England and particularly in Washington County. The vast forests of interior Maine, harvested and milled along the region's river systems, created a commodity demanding efficient transportation. This demand gave birth to Maine's shipbuilding industry and sustained maritime commerce for more than a century.

Sawmills lined the Machias River, Narraguagus River, Pleasant River, and smaller streams throughout Washington County. Water power turned great circular saws that transformed logs into lumber—pine boards, oak timbers, spruce planks—destined for distant markets. The mills operated year-round when water levels permitted, producing thousands of board feet daily. This lumber required vessels for transport, and the profits from lumber sales created capital for ship construction.

The coasting trade carried Maine lumber to Boston, New York, Philadelphia, and Baltimore. Schooners loading at Machias, Cherryfield, and East Machias embarked on regular voyages to these markets, returning with manufactured goods, coal, and other products unavailable in Maine. The two-way trade created commerce that justified vessel construction and operation. A schooner might make four to six voyages annually, earning substantial freight revenues.

Shipbuilders and lumber merchants shared economic interests. A merchant operating a sawmill might construct vessels to transport his own lumber output, while maintaining a share in other vessels for diversified income. Master builders received payment partly in lumber and partly in cash, integrating the industries further. The intimate connection between Maine's forests and maritime commerce created an economic ecosystem where wood production, ship construction, and ocean commerce reinforced each other.

International demand for Maine lumber was substantial and growing. British shipyards required American timber; West Indian sugar plantations needed Maine lumber for construction and repairs; Australian colonies importing skilled labor and supplies found Maine vessels economical transport. American naval expansion in the mid-19th century created additional demand for timber and shipbuilding services.

The Civil War interrupted but ultimately reinforced this maritime economy. Union demands for merchant vessels to replace Confederate-destroyed shipping created unprecedented demand for Maine-built vessels. Post-war boom years from 1865-1880 witnessed the construction of some of the finest vessels ever built in the Machias district, as merchants and builders invested profits from wartime shipping into new construction.

The decline of wooden shipbuilding in the 1890s corresponded with but preceded the decline of Maine's sawmill industry. Steam vessels and iron ships could carry cargo more economically, and lumber markets shifted as American railroads penetrated western forests. The integrated maritime-forest economy that had sustained Washington County for decades fragmented, leaving communities to adapt to new economic realities.$$,
  'historical_context',
  NULL,
  'New England Maritime History',
  '{"topic": "Lumber trade and maritime commerce", "region": "Washington County, Maine", "time_period": "1780-1900", "keywords": ["lumber", "timber", "sawmills", "shipbuilding", "economic history", "maritime commerce"]}'
);

INSERT INTO documents (title, content, doc_type, source_url, archive_name, metadata) VALUES (
  'The Civil War and Its Impact on Maine Shipping',
  $$The American Civil War (1861-1865) profoundly disrupted and ultimately stimulated the maritime commerce of Maine. Confederate commerce raiders targeted Union merchant vessels, while blockades redirected trade patterns and insurance costs skyrocketed. Yet the demand for vessels to replace war losses and support Union logistics created unprecedented opportunities for Maine shipbuilders.

Confederate raiders like the CSS Alabama and CSS Shenandoah hunted Union merchant vessels across the world's oceans. Maine-built vessels, recognized as valuable properties, attracted particular attention from Confederate cruisers. Insurance rates for vessels engaged in foreign trade climbed from three to five percent annually to fifteen to twenty percent or higher in regions of raider activity. Some shipowners withdrew vessels from foreign trade entirely, seeking the relative safety of coastwise commerce.

The Union blockade of Confederate ports disrupted traditional trading patterns. New England vessels that had carried cotton from southern ports to northern mills sought alternative cargoes and routes. Some captains engaged in blockade-running, smuggling supplies past Union naval patrols—a risky but highly profitable enterprise. The opportunities created fortunes for adventurous merchants while destroying those who miscalculated risks.

Union government contracts for transport vessels and supply ships created demand exceeding supply. The military required thousands of vessels to transport troops, ammunition, provisions, and equipment to distant theaters. While steamships increasingly dominated wartime logistics, sailing vessels supplemented military transportation. Maine builders and owners secured contracts to construct vessels for Union service or to carry government supplies under contract.

Post-war expansion represented the Civil War's most lasting impact on Maine maritime commerce. Between 1865 and 1880, the great age of Down East wooden shipbuilding reached its zenith. Merchants who had accumulated wealth through successful wartime operations invested in vessel construction. Shipbuilders, confident in strong markets, accepted contracts for larger and more expensive vessels. The registers from this period document the construction of substantial barks and ships designed for distant ocean voyages.

The post-war boom generated wealth distributed throughout maritime communities. Master builders prospered sufficiently to invest in multiple vessels; craftsmen earned premium wages; merchants accumulated capital from shipping profits. The decade from 1870-1880 witnessed construction of some of the finest vessels ever built in the Machias district, representing the culmination of American wooden shipbuilding technology.

However, this post-war boom proved temporary. As European shipyards adopted iron and steel construction, and as steamship technology matured, wooden sailing vessels became economically obsolete. The very prosperity of the post-war years created overconfidence that obscured the structural decline approaching in the 1880s-1890s.$$,
  'historical_context',
  NULL,
  'New England Maritime History',
  '{"topic": "Civil War era maritime history", "region": "New England", "time_period": "1861-1865", "keywords": ["Civil War", "commerce raiders", "Union Navy", "shipbuilding", "insurance", "Maine maritime"]}'
);

INSERT INTO documents (title, content, doc_type, source_url, archive_name, metadata) VALUES (
  'The Decline of Wooden Shipbuilding 1890-1930',
  $$The final forty years of the Machias Ship Registers (1890-1930) documented the gradual but inevitable decline of Maine's wooden shipbuilding industry. Technological change, economic competition, and shifting commercial patterns combined to render the traditional skills of master carpenters obsolete. The communities that had prospered through maritime commerce adapted, but never regained their previous prominence.

The transition from sail to steam fundamentally altered shipbuilding economics. Steam vessels required iron or steel hulls, engine rooms, and complex mechanical systems foreign to traditional wooden shipbuilders. Established British and European yards possessed infrastructure and expertise in steel construction; American shipyards, concentrated on the Atlantic coast near coal and iron deposits, offered superior technology and lower costs. Maine builders, invested in wooden construction and working with local timber, could not compete economically.

Smaller sailing vessels continued to be built through the 1890s and into the early 1900s, but in declining numbers. The registers show construction of small schooners through the 1910s, but the owners and builders were increasingly aging men maintaining traditions rather than young investors betting on profitable futures. The last major vessels built in the district—a few barks and ships of the 1880s-1890s—represented departures. Few investors committed the capital necessary for large wooden vessels when steam alternatives offered faster, more reliable service.

Economic competition from other regions contributed to decline. Shipbuilding shifted to Portland, Boston, and other larger cities with superior infrastructure and access to capital. Even within Maine, smaller yards closed as construction concentrated in more efficient locations. Washington County's relative isolation—the lack of railroad connections until the 1880s—disadvantaged local builders competing for distant investors.

The lumber trade, which had sustained the maritime economy, declined simultaneously. Western railroads penetrated forests previously inaccessible and less economical to exploit than Maine timberlands. Lumber from Oregon, Washington, and other western states flooded markets previously dominated by Maine producers. Sawmill operations contracted, reducing the timber supply available to shipbuilders and the profits motivating maritime investment.

The last significant shipbuilding period in the Machias district occurred around 1885-1895. A few vessels of respectable size were constructed during this period, representing final investments in wooden sailing vessels before the complete transition to steam and steel. By 1900, new construction had become rare; by 1920, virtually no new vessels were being built in the traditional manner.

Communities adapted by transitioning to other maritime activities—boat building, fishing, shipyard work for large vessels built elsewhere. But the great age of independent shipbuilding in every small harbor was finished. The Machias Ship Registers stand as a historical monument to an era when small communities could sustain major maritime industries through skill, timber resources, and merchant capital.$$,
  'historical_context',
  NULL,
  'New England Maritime History',
  '{"topic": "Decline of wooden shipbuilding", "region": "Washington County, Maine", "time_period": "1890-1930", "keywords": ["wooden ships", "decline", "steam", "steel ships", "economic transition", "industrial change"]}'
);

INSERT INTO documents (title, content, doc_type, source_url, archive_name, metadata) VALUES (
  'Women in Maine Maritime Commerce',
  $$Women appeared throughout the maritime records of the Machias district, though their roles often remained obscured by legal conventions that listed husbands as formal owners. However, numerous women held independent ownership of vessel shares and accumulated wealth through maritime investments, exerting significant economic influence in their communities.

Sophronia Lamson of Machias emerged as one of the district's most active female vessel owners. Her name appears repeatedly in the registers holding fractional ownership in multiple schooners throughout the 1850s-1880s. Lamson accumulated sufficient wealth to hold shares in six to ten vessels simultaneously—a portfolio indicating substantial accumulated capital and financial sophistication. She invested across different vessel types, builders, and captains, indicating strategic diversification rather than random accumulation.

Hannah Faulkingham of East Machias and Sarah A. Look of Jonesport similarly accumulated maritime investments. These women typically appear in the registers as widow, suggesting they inherited initial interests in vessels from deceased husbands but subsequently enlarged their holdings through shrewd investments. Their continued ownership through decades indicates active management of maritime investments, not passive inheritance.

The widows of sea captains and merchants often inherited vessel ownership. When a captain died at sea or on shore, his widow received his portion of vessel ownership. Smart widows—and the surviving records suggest many were—parlayed these inherited interests into larger fortunes by reinvesting dividends and applying accumulated knowledge of maritime commerce to new investments.

Women also participated as merchants and shopkeepers connected to maritime commerce. A merchant widow might own vessels carrying cargo her store could not supply locally—lumber from distant ports, provisions from Boston, manufactured goods from New York. These investments integrated her retail operations with maritime commerce, creating multiple profit streams.

The economic role of female vessel owners deserves greater recognition than conventional histories provide. Women's maritime investments represented independence and financial power in a male-dominated society. A woman holding shares in multiple vessels possessed wealth exceeding many male merchants and craftspeople. The ability to accumulate and manage this wealth suggests female participation in business decisions beyond formal ownership roles.

Cultural conventions obscured female economic activity. Male family members often conducted business transactions formally, though wives and widows directed investment strategy. The registers capture formal ownership but not informal influence. Daughters and wives learned maritime commerce through family involvement, and some achieved prominence as independent operators.

The transition away from sail and the decline of wooden shipbuilding affected female as well as male investors. As maritime commerce contracted in the 1890s-1920s, women's participation in vessel ownership declined proportionally. The registers' final entries document fewer female owners as the maritime economy contracted entirely.$$,
  'historical_context',
  NULL,
  'New England Maritime History',
  '{"topic": "Female participation in maritime commerce", "region": "Washington County, Maine", "time_period": "1780-1930", "keywords": ["women", "ownership", "merchants", "Lamson", "Faulkingham", "Look", "maritime investment"]}'
);

INSERT INTO documents (title, content, doc_type, source_url, archive_name, metadata) VALUES (
  'The WPA Ship Registry Project',
  $$The Machias Ship Registers (1780-1930) exist today because of a Depression-era preservation effort that rescued these historical documents from obscurity and deterioration. The Works Progress Administration (WPA), a New Deal program employing thousands during the 1930s, funded historical documentation projects throughout the United States. The preservation of Maine's maritime records represented one such project with lasting historical significance.

When the WPA project began, the original customs house documents recording vessel enrollment and registration faced an uncertain future. Customs house records, maintained at local ports, were dispersed across multiple locations and varied considerably in condition. Some documents remained in active government use; others had been transferred to warehouses where they faced moisture damage, rodent deterioration, and the inevitable decay of aged paper. Without intervention, much of this historical record would have been lost.

The project employed historians, clerical workers, and other personnel to locate, organize, and transcribe customs house records from maritime ports throughout New England and beyond. Workers traveled to customs houses and local archives, photographed documents, and compiled transcriptions into organized volumes. The resulting Machias Ship Registers volume represented years of systematic effort to preserve and organize one port's maritime history.

The transcription process itself involved editorial judgment. Project workers selected which information from customs documents to record, how to standardize vessel names and owner names spelled in various ways, and how to organize the material chronologically. The decisions made by WPA workers shaped how subsequent researchers encountered the historical record. Generally, the project staff exercised sound judgment in creating a usable resource while remaining faithful to original documents.

The WPA effort preserved information that would otherwise have been lost. Original customs house documents were often rough, abbreviated, and difficult for non-specialists to decipher. The typeset Machias Ship Registers provided clean, organized, accessible versions of this material. Researchers could consult the printed registers rather than hunting for fragile originals.

The project represented a public investment in historical preservation during a period when such work seemed less urgent than economic recovery. Yet the WPA's foresight ensured that historians and descendants of Maine maritime families could access their heritage. The Machias Ship Registers became a crucial primary source for understanding 19th-century American maritime commerce, shipbuilding, and local economic history.

The WPA project also documented its own historical significance. Project records often included notes about the condition of original documents and challenges encountered during transcription. These project files themselves became sources revealing how Depression-era historical work was conducted.$$,
  'historical_context',
  NULL,
  'New England Maritime History',
  '{"topic": "Historical preservation and documentation", "region": "New England", "time_period": "1930s", "keywords": ["WPA", "Works Progress Administration", "preservation", "customs records", "documentation", "archives"]}'
);

-- MARITIME GEOGRAPHY

INSERT INTO documents (title, content, doc_type, source_url, archive_name, metadata) VALUES (
  'Washington County, Maine: The Maritime Landscape',
  $$Washington County, Maine, occupies the extreme eastern portion of New England, a rugged coastline carved by glaciation into a landscape ideally suited to maritime commerce. The geography—rocky shores, deep harbors, and productive forests—created the conditions that nurtured America's premier wooden shipbuilding region during the 19th century.

The Machias River, the county's largest watercourse, flows northeastward from interior Maine toward the Atlantic, passing through the towns of Machias and East Machias before emptying into Machias Bay. The river's considerable depth allowed ocean-going vessels to navigate upstream to shipyards, lumber mills, and wharves. The river provided fresh water for shipbuilding operations and the tidal movement powered sawmills and other commercial operations. The Machias River became synonymous with maritime commerce and vessel construction.

The Narraguagus River, flowing through Cherryfield, offered similar advantages. This productive river supported sawmills, shipyards, and commercial wharves. The river's relatively steep gradient in its upper reaches powered sawmills that transformed logs into lumber. The lower Narraguagus provided deeper anchorage for vessels and maintained the economic infrastructure supporting maritime commerce.

The Pleasant River, flowing through Columbia Falls and Columbia, supported the twin villages that became major shipbuilding centers. These neighboring communities on a single river exemplified how maritime geography distributed economic activity across the county. Small harbors provided launching sites and anchorage; forests nearby provided timber; local communities supplied labor and capital.

Smaller rivers—Harrington, Abbot, and others—similarly supported maritime activity. Even where major vessels could not navigate, small coasting vessels could load local cargo and transport it to larger ports. The network of rivers, harbors, and coastal inlets created an integrated maritime economy.

The Gulf of Maine presents a challenging marine environment that shaped vessel design and maritime practices. Powerful currents, sudden fog banks, and rocky outcrops created navigation hazards. The waters between Maine and Nova Scotia, the approaches to major harbors, and the routes to distant ports required experienced captains and well-built vessels. The reputation of Maine vessels for seaworthiness partly reflected the demanding waters they regularly navigated.

The county's extreme eastern location positioned it for trading relationships with Canadian Maritimes and British Isles. Proximity to international waters made overseas commerce natural. The geography also created relative isolation from major New England cities, making maritime commerce crucial for economic contact with distant markets.

Seasonal patterns of ice and weather governed maritime activity. Summer months provided optimal sailing conditions; winter ice and storms limited operations. Shipbuilding occurred year-round, but launching times were carefully selected to take advantage of high water. The maritime calendar—when vessels could safely operate—shaped business planning and economic cycles.$$,
  'maritime_geography',
  NULL,
  'New England Maritime History',
  '{"topic": "Physical geography and maritime economy", "region": "Washington County, Maine", "time_period": "1780-1930", "keywords": ["geography", "rivers", "Machias", "Narraguagus", "Pleasant River", "harbors", "Gulf of Maine"]}'
);

INSERT INTO documents (title, content, doc_type, source_url, archive_name, metadata) VALUES (
  'The Customs District of Machias',
  $$The Customs District of Machias represented an administrative division of the United States Custom Service responsible for regulating maritime commerce across a substantial portion of Maine's Down East coast. Understanding how customs districts functioned illuminates the legal and commercial frameworks governing vessel operation and merchant activity during the Machias Ship Registers period.

A customs district comprised a primary port and typically several sub-ports. The District of Machias centered on the port of Machias but included sub-ports at Cherryfield, East Machias, and Jonesport, as well as additional ports of entry at smaller harbors. The collector of customs, resident at the primary port, held responsibility for enforcing federal maritime regulations, collecting duties on imported goods, and maintaining the official records of vessel enrollment and registration.

The district stretched from the town of Gouldsboro westward to include the communities along the Down East coast approaching the Canadian border. This substantial geographic area meant the collector and his deputies maintained an extensive operation involving multiple ports and considerable paperwork. The registers maintained at Machias recorded not just Machias-based vessels but those registered or enrolled at any port within the customs district.

Vessel enrollment applied to vessels engaged primarily in coastwise and inland trade—the schooners carrying lumber between Maine ports and Boston, the fishing vessels operating from local harbors, the small craft engaged in regional commerce. Enrollment was a simpler process than registration, requiring basic vessel information and ownership details. Enrolled vessels could legally operate in American coastal waters and carry domestic cargo.

Registration applied to vessels engaged in foreign trade—those sailing to ports in other nations, the West Indies, or beyond. Registration required more rigorous documentation and inspection to ensure vessels met safety standards and complied with federal maritime law. Registered vessels held the right to carry cargo to international ports and could potentially claim American registry in foreign harbors.

The customs house itself served multiple functions. Government officials collected tariffs on imports, assessed vessels for tax purposes, and maintained the extensive documentation recording every vessel's enrollment or registration. The customs house represented federal government presence in maritime communities, embodying commercial regulation and commercial opportunity.

Changes in federal maritime law appeared in the registers through altered documentation requirements. The transition from old measurement to new measurement tonnage rules affected how vessels were recorded. Shifts in tariff policy influenced what vessels were constructed and what cargoes were carried. The registers capture these regulatory changes as they affected actual vessel operations.

The customs district system gradually declined as transportation networks modernized. Railroad development reduced reliance on coastal shipping. Centralization of customs operations in the 20th century eliminated many smaller ports of entry. The Machias district, vital in 1850 and important in 1900, had become a minor operation by 1950.$$,
  'maritime_geography',
  NULL,
  'New England Maritime History',
  '{"topic": "Federal customs administration", "region": "Washington County, Maine", "time_period": "1780-1930", "keywords": ["customs district", "enrollment", "registration", "federal law", "maritime regulation", "customs house"]}'
);

INSERT INTO documents (title, content, doc_type, source_url, archive_name, metadata) VALUES (
  'New England Coastal Trade Routes',
  $$The coasting trade of New England represented the foundation of maritime commerce linking the region's diverse economic activities. Vessels operating these well-established routes carried products from New England ports to distant markets while returning with goods unavailable in local areas. The cargo carried along these routes shaped both vessel design and community economic specialization.

The northern route connected Maine ports—Machias, Eastport, Portland—with Boston. This voyage of three to five days in favorable conditions carried Maine's primary export: lumber. Schooners loading at Machias, Cherryfield, or East Machias would sail southwest toward Boston, unload their lumber at wharves specializing in Maine products, and return laden with coal, grain, manufactured goods, and other cargo unavailable in Down East Maine. The regularity of this trade supported the construction of dozens of Maine-built vessels optimized for this specific route.

The southern coasting route extended from Maine through New York to Philadelphia and Baltimore. Longer than the Boston route (requiring seven to ten days), this voyage accessed larger markets and carried more diverse cargoes. Vessels operating this route might carry Maine lumber to New York, coal and manufactured goods from Pennsylvania to Maine. Some vessels continued to Norfolk, Virginia, or other southern ports, engaging in the more extensive trades.

Caribbean trade routes, though longer and riskier, attracted substantial investment. Maine vessels carried lumber and fish to Caribbean ports, particularly to islands dependent on imports. These vessels returned laden with molasses, sugar, and tropical products. The longer voyage and exposure to Caribbean hurricanes increased insurance costs but justified by higher profits on scarce tropical goods.

The international routes to Liverpool, London, and continental Europe represented the most ambitious ventures. Vessels undertook Atlantic crossings carrying wheat, cotton, or other commodities to European markets, returning with manufactures or European goods. These voyages required larger vessels and more experienced crews but offered substantial profits justifying the risks.

Seasonal patterns governed coastal trade. Summer months presented optimal sailing conditions; winter storms increased risks and voyage times. The coasting trade accelerated in spring and summer, with vessels making multiple voyages between April and November. Winter months saw fewer vessels attempting ocean voyages, though some hardy captains operated year-round.

Cargoes were diverse and specialized. Coal flowed from Pennsylvania and Virginia northward; grain moved from western regions; fish products moved from Maine and other ports. Cotton moved from the South to northern mills; manufactured goods moved southward. Each trade generated return cargoes, creating complex patterns of interregional commerce.

The coasting trade connected New England's diversified economy into an integrated whole. A Maine merchant might own interests in lumber sales, manufactured goods distribution, and grain trading—all supported by vessels moving cargo through established networks. The stability and predictability of coastal trade made it the foundation supporting more speculative international ventures.$$,
  'maritime_geography',
  NULL,
  'New England Maritime History',
  '{"topic": "Coastal trade patterns and routes", "region": "New England", "time_period": "1780-1930", "keywords": ["coasting trade", "cargo", "Boston route", "Caribbean", "international trade", "maritime commerce"]}'
);

INSERT INTO documents (title, content, doc_type, source_url, archive_name, metadata) VALUES (
  'Cherryfield and the Narraguagus River',
  $$Cherryfield, situated on the Narraguagus River approximately fifteen miles inland from the Atlantic, emerged as one of the primary shipbuilding centers of the Machias customs district. The community's location on a productive river and its proximity to timber resources made it an ideal location for maritime commerce. Cherryfield's history during the 19th century reflects the intimate connection between a river, a forest, and maritime commerce.

The Narraguagus River provided the essential infrastructure supporting Cherryfield's maritime industries. The river was navigable for ocean-going vessels despite its distance from the sea, allowing large schooners and brigs to be constructed and launched far upstream. The river's fall, particularly in its upper reaches, powered sawmills transforming logs into lumber. Multiple mills operated along the river, creating a lumber supply immediately adjacent to shipbuilding operations.

Sawmill operations dominated Cherryfield's economy. The Campbell family, among the earliest major sawmill operators, accumulated wealth and invested in maritime commerce. Sawmill profits provided capital for vessel construction and merchant operations. The integration of sawmill ownership and vessel ownership created a powerful economic entity—mill owners constructed vessels to carry their lumber products while diversifying investments through maritime commerce.

The Foster family represented another tier of Cherryfield maritime merchants. Eli Foster's reputation as a master builder brought customers from throughout Maine and beyond. Foster's vessels, built according to his recognized design preferences, earned reputations for speed and seaworthiness. Foster also maintained substantial ownership interests in multiple vessels, combining builder and merchant roles.

The Nickels family similarly contributed to Cherryfield's maritime prominence. Family members operated as merchants, vessel owners, and builders. The concentration of maritime skill and capital in a few families meant that Cherryfield's maritime fortunes depended significantly on the success or failure of individual families.

Cherryfield's designation as a sub-port of the customs district of Machias meant local collectors or customs officers maintained records of vessel enrollments and registrations. This official presence legitimized Cherryfield as a maritime center and created the documentation preserved in the Machias Ship Registers. Cherryfield vessels appear throughout these records, often built locally and owned by combinations of Cherryfield residents and distant investors.

The village developed distinctive character reflecting maritime specialization. Shipbuilding and sawmill operations dominated the economy; merchant families accumulated wealth and influence; maritime knowledge passed through families and communities. The cultural orientation toward maritime commerce and shipbuilding created a distinct identity persisting through the decline of wooden shipbuilding.

The Civil War era and post-war boom years represented Cherryfield's peak maritime importance. Construction records from the 1865-1880 period show numerous vessels launched from Cherryfield yards. After 1890, new construction declined sharply, and Cherryfield adapted to an economy increasingly divorced from maritime specialization.$$,
  'maritime_geography',
  NULL,
  'New England Maritime History',
  '{"topic": "Cherryfield as shipbuilding center", "region": "Washington County, Maine", "time_period": "1800-1900", "keywords": ["Cherryfield", "Narraguagus River", "sawmills", "Campbell", "Foster", "Nickels", "shipbuilding"]}'
);

INSERT INTO documents (title, content, doc_type, source_url, archive_name, metadata) VALUES (
  'Columbia Falls and Columbia: Twin Shipbuilding Villages',
  $$Columbia Falls and Columbia, neighboring communities situated on the Pleasant River, exemplified the small maritime centers that supported New England's shipbuilding economy. Though less prominent historically than larger centers, these twin villages produced numerous vessels that served throughout the maritime world. The families and craftspeople of Columbia Falls and Columbia built a tradition of maritime excellence recognized throughout the district.

The Pleasant River, though smaller than the Machias and Narraguagus, offered adequate depth for ocean-going vessels and the water power essential for sawmills. The river's configuration—providing both deep harbor and mill power—attracted maritime investment in the early decades of the 19th century. The relatively sheltered waters and proximity to interior forests made the location ideal for integrated sawmill-shipbuilding operations.

The Small family emerged as the primary maritime power in the Columbia area. Multiple generations of Smalls operated as builders, merchants, and vessel owners. The Small name appears repeatedly in the registers, associated with vessels built locally and operated by combinations of Columbia residents and distant investors. The Smalls accumulated sufficient wealth to maintain substantial ownership interests in multiple vessels simultaneously.

The Crandon family contributed parallel importance to Columbia's maritime commerce. Like the Smalls, the Crandons combined shipbuilding with merchant operations and vessel ownership. Crandon vessels appear throughout the registers, many constructed in local yards. The Crandon family's prominence was substantial enough that Crandon-built vessels attracted investors from Maine's major commercial centers.

The Dunbar family represented another significant maritime presence in the Columbia communities. Dunbars operated as shipbuilders and merchants, contributing to the village's maritime reputation. The concentration of maritime skill and capital in these three families meant Columbia's prosperity depended significantly on their success. When shipbuilding declined after 1890, these families faced economic disruption.

The villages' relative isolation compared to larger maritime centers like Machias and Cherryfield meant they operated somewhat independently. Columbia-built vessels reflected local preferences and builder characteristics. The Small, Crandon, and Dunbar families developed recognizable design approaches and built reputations attracting customers beyond their immediate locality.

The Civil War period and post-war reconstruction represented peak construction years for Columbia yards. Vessels built in the 1865-1880 period included some of respectable size and quality. However, like other small Maine builders, Columbia yards could not adapt to the transition toward steam and steel. The last significant construction activity occurred around 1890, with minimal new vessel building thereafter.

Columbia Falls and Columbia represented maritime achievement at a smaller scale than regional centers. Yet their contribution to the total output of New England shipbuilding was substantial. The registers preserve documentation of dozens of vessels built in these communities, testimony to the maritime skill and mercantile activity sustaining these small villages throughout the 19th century.$$,
  'maritime_geography',
  NULL,
  'New England Maritime History',
  '{"topic": "Columbia Falls and Columbia shipbuilding", "region": "Washington County, Maine", "time_period": "1780-1900", "keywords": ["Columbia Falls", "Columbia", "Pleasant River", "Small family", "Crandon", "Dunbar", "shipbuilding"]}'
);
