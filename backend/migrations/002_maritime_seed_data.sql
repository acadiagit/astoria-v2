-- Astoria v2 — Real Maritime Seed Data
-- Source: Ship Registers and Enrollments of Machias, Maine 1780-1930
-- Prepared by The National Archives Project, WPA, 1942
-- Digitized by Google Books from University of Michigan General Library
--
-- This seed data contains REAL vessel records extracted from the
-- Machias Customs District registers. Each document record represents
-- one vessel with its complete registration history.
--
-- Embeddings are generated separately by the seed_embeddings.py script.

-- ============================================================
-- Vessels (from Abstracts of Registers and Enrollments, A-K)
-- ============================================================

INSERT INTO documents (title, archive_name, content_type, raw_content, checksum, metadata) VALUES

-- 1. A. HOOPER
('Ship Registry: A. Hooper',
 'Machias Ship Registers 1780-1930',
 'text',
 'A. HOOPER, schooner, of Calais. Official No. 448. Built at Eden, 1854. 67.25 tons; 79.3 ft. x 21.7 ft. x 6.7 ft. One deck, two masts, square stern, a billethead. Previously registered May 25, 1897, at Calais. Enrolled (temporary), No. 63, Nov. 4, 1897, at Machias. Owners: Howard Q. Boardman, 1/4, E. B. Todd, 3/4, Calais. Master: Thomas E. Patterson.',
 'sha256_hooper_001',
 '{"type": "ship", "ship_name": "A. Hooper", "ship_type": "schooner", "hailing_port": "Calais", "tonnage_gross": 67.25, "length_ft": 79.3, "breadth_ft": 21.7, "depth_ft": 6.7, "decks": 1, "masts": 2, "stern": "square", "head": "billethead", "year_built": 1854, "place_built": "Eden", "master": "Thomas E. Patterson", "owners": [{"name": "Howard Q. Boardman", "share": "1/4", "residence": "Calais"}, {"name": "E. B. Todd", "share": "3/4", "residence": "Calais"}], "entry_number": 1}'::jsonb),

-- 2. A. McNICHOL
('Ship Registry: A. McNichol',
 'Machias Ship Registers 1780-1930',
 'text',
 'A. McNICHOL, schooner, of New York City. Official No. 105433, Sig. let. J. Q. G. M. Built at East Machias, 1874, by Gilbert Trott, master carpenter. 122.38 gross tons, 116.26 net tons; 93 ft. x 24.75 ft. x 7.9 ft. One deck, two masts, square stern, a billethead. First enrolled (temporary), No. 2, Nov. 14, 1874, at Machias. Owners: J. C. Reed, 2/16, A. McNichol, 5/16, D. H. McNichol, 1/16, Calais; John Q. Twitchell, James P. Champlin and Frank A. Champlin, 1/16, copartners, Portland; C. E. Sears, 7/16, New York City. Master: J. C. Reed. The vessel had an extensive registration history with multiple ownership changes between 1874 and 1902, primarily involving East Machias, Machiasport, and Calais owners. Final enrollment No. 15, Sept. 5, 1882, at Machias with James A. Flynn, 1/14, Machiasport; George E. Burrall, 6/14, Elizabeth T. Talbot, 1/14, East Machias; A. McNichol, 5/14, D. H. McNichol, 1/14, Calais. Master: James A. Flynn.',
 'sha256_mcnichol_001',
 '{"type": "ship", "ship_name": "A. McNichol", "ship_type": "schooner", "hailing_port": "New York City", "official_number": 105433, "tonnage_gross": 122.38, "tonnage_net": 116.26, "length_ft": 93, "breadth_ft": 24.75, "depth_ft": 7.9, "decks": 1, "masts": 2, "stern": "square", "head": "billethead", "year_built": 1874, "place_built": "East Machias", "builder": "Gilbert Trott", "master": "J. C. Reed", "entry_number": 2}'::jsonb),

-- 3. A. RICHARDS (brig)
('Ship Registry: A. Richards (Brig)',
 'Machias Ship Registers 1780-1930',
 'text',
 'A. RICHARDS, brig, of Boston, Mass. Built at Columbia Falls, 1863, by Arthur Stevens, master carpenter. 274 30/95 tons; 109 ft. x 28 ft. 4 in. x 10 ft. One deck, two masts, square stern, a billethead. Registered (temporary), No. 11, Oct. 17, 1863, at Machias. Owners: Joseph Crandon and John H. Crandon, 2/16, copartners, Pelham B. Peterson, 1/16, Elisha Hathaway, 1/16, Columbia Falls; Charles Donovan, 2/16, Ellis Wass, 2/16, Addison; Alfred Richards and Samuel P. Adams, 2/16, copartners, Abial Goss, 2/16, John N. Deveraux, 1/16, Boston, Mass.; James E. Brett, 2/16, Oliver Bryant, 1/16, New York City. Master: Charles Donovan.',
 'sha256_richards_brig_001',
 '{"type": "ship", "ship_name": "A. Richards", "ship_type": "brig", "hailing_port": "Boston, Mass.", "tonnage": 274, "length_ft": 109, "breadth_ft": 28.33, "depth_ft": 10, "decks": 1, "masts": 2, "stern": "square", "head": "billethead", "year_built": 1863, "place_built": "Columbia Falls", "builder": "Arthur Stevens", "master": "Charles Donovan", "entry_number": 3}'::jsonb),

-- 4. A. RICHARDS (schooner)
('Ship Registry: A. Richards (Schooner)',
 'Machias Ship Registers 1780-1930',
 'text',
 'A. RICHARDS, schooner, of Boston, Mass. Official No. 260, Sig. let. H. B. K. G. Built at Columbia Falls, 1864, by John S. Allen, master carpenter. 226 16/95 tons; 95 ft. 7 in. x 27 ft. 1 in. x 10 ft. One deck, two masts, square stern, a billethead. Registered (temporary), No. 16, Dec. 16, 1864, at Machias. Owners: Joseph Crandon and John H. Crandon, 1/2, copartners, Columbia Falls; Seth C. Arey, 1/16, South Thomaston; Alfred Richards, 1/8, John N. Deveraux, 1/16, Samuel B. Locke, 1/16, Charles A. Kilham, 1/16, A. G. Sawyer, 1/16, David Barnes, 1/16, Boston, Mass. Master: Seth C. Arey. Later readmeasured at 159.88 tons; 94.5 ft. x 27.2 ft. x 9 ft. Ownership changed to Willey family interests of Columbia Falls, Rockland, St. George, and Augusta.',
 'sha256_richards_sch_001',
 '{"type": "ship", "ship_name": "A. Richards", "ship_type": "schooner", "hailing_port": "Boston, Mass.", "official_number": 260, "tonnage_gross": 226, "length_ft": 95.58, "breadth_ft": 27.08, "depth_ft": 10, "decks": 1, "masts": 2, "stern": "square", "head": "billethead", "year_built": 1864, "place_built": "Columbia Falls", "builder": "John S. Allen", "master": "Seth C. Arey", "entry_number": 4}'::jsonb),

-- 5. A. SAWYER
('Ship Registry: A. Sawyer',
 'Machias Ship Registers 1780-1930',
 'text',
 'A. SAWYER, schooner, of Jonesport. Built at Calais, 1847. 128 38/95 tons; 79 ft. 5 in. x 22 ft. 1 5/8 in. x 8 ft. 4 in. One deck, two masts, square stern, a billethead. Previously registered Sept. 7, 1855, at Passamaquoddy. Registered, No. 11, May 11, 1858, at Machias. Owner: Reuben Lamson, Jonesport. Master: Reuben Lamson.',
 'sha256_sawyer_001',
 '{"type": "ship", "ship_name": "A. Sawyer", "ship_type": "schooner", "hailing_port": "Jonesport", "tonnage": 128, "length_ft": 79.42, "breadth_ft": 22.14, "depth_ft": 8.33, "decks": 1, "masts": 2, "stern": "square", "head": "billethead", "year_built": 1847, "place_built": "Calais", "master": "Reuben Lamson", "entry_number": 5}'::jsonb),

-- 6. A. B. PERRY
('Ship Registry: A. B. Perry',
 'Machias Ship Registers 1780-1930',
 'text',
 'A. B. PERRY, schooner, of Addison. Official No. 105309, Sig. let. J. N. M. K. Built at Addison, 1873, by Thomas Look, master carpenter. 203.52 tons; 114.2 ft. x 28.8 ft. x 8.75 ft. One deck, three masts, elliptic stern, a billethead. Enrolled, No. 15, Nov. 14, 1873, at Cherryfield. Owners: Porter B. Look, 6/64, Susannah A. Look, 2/64, Sarah A. Look, 2/64, Mary M. Look, 4/64, Augustus J. Look, 2/64, W. A. Sawyer, 2/64, John H. Austin, 4/64, J. N. Austin, 2/64, J. B. Look, 2/64, Obed T. Crowley, 2/64, Joseph Nash, 1/64, C. B. Nash, 1/64, F. M. Merritt, 2/64, Judson T. Heath, 2/64, Addison; Amos Godfrey, 2/64, Millbridge; J. S. Bucknam, 8/64, Columbia Falls; E. S. Smith, 2/64, Jesse L. Nash Jr., 2/64, Columbia; A. B. Perry & Co., 4/64, Margaret L. Union, 2/64, Boston, Mass.; Marcus Hunter & Co., 4/64, Stephen H. Mills & Co., 4/64, Charles W. Potter, 4/64, New York City. Master: Porter B. Look. The vessel had extensive registration history through 1898 with the Look family maintaining majority ownership.',
 'sha256_perry_001',
 '{"type": "ship", "ship_name": "A. B. Perry", "ship_type": "schooner", "hailing_port": "Addison", "official_number": 105309, "tonnage": 203.52, "length_ft": 114.2, "breadth_ft": 28.8, "depth_ft": 8.75, "decks": 1, "masts": 3, "stern": "elliptic", "head": "billethead", "year_built": 1873, "place_built": "Addison", "builder": "Thomas Look", "master": "Porter B. Look", "entry_number": 6}'::jsonb),

-- 7. A. F. KINDBERG
('Ship Registry: A. F. Kindberg',
 'Machias Ship Registers 1780-1930',
 'text',
 'A. F. KINDBERG, schooner, of Machias. Official No. 649, Sig. let. H. B. R. L. Built at East Haven, Conn., 1865. 226 gross tons, 196 net tons; 112.3 ft. x 29.3 ft. x 10.2 ft. One deck, two masts, square stern, a billethead, built of wood. Previously enrolled June 6, 1912, at Bangor. Enrolled, No. 9, Sept. 11, 1916, at Machias. Owner: J. H. Lindsey, Machias. Master: Harvey E. Wakefield. Surrendered, July 6, 1917, at Eastport, trade changed.',
 'sha256_kindberg_001',
 '{"type": "ship", "ship_name": "A. F. Kindberg", "ship_type": "schooner", "hailing_port": "Machias", "official_number": 649, "tonnage_gross": 226, "tonnage_net": 196, "length_ft": 112.3, "breadth_ft": 29.3, "depth_ft": 10.2, "decks": 1, "masts": 2, "stern": "square", "head": "billethead", "year_built": 1865, "place_built": "East Haven, Conn.", "master": "Harvey E. Wakefield", "disposition": "Surrendered July 6, 1917, trade changed", "entry_number": 7}'::jsonb),

-- 8. A. H. WASS
('Ship Registry: A. H. Wass',
 'Machias Ship Registers 1780-1930',
 'text',
 'A. H. WASS, brig, of Columbia. Built at Columbia, 1847, by Henry D. Leighton, master carpenter. 170 60/95 tons; 84 ft. 6 in. x 13 ft. 11 in. x 9 ft. 8 in. One deck, two masts, square stern, a billethead. Enrolled, No. 49, Nov. 30, 1847, at Machias. Owners: Jesse L. Nash, 3/4, Columbia; Alexander H. Wass, 1/4, Boston, Mass. Master: Alexander H. Wass Jr., Columbia. Enrolled, No. 31, Sept. 28, 1848, at Machias. Owners: Alexander H. Wass Jr., Alexander H. Wass, Jesse L. Nash, Columbia; Robert Emerson, John Emerson, Boston, Mass. Master: same. Previously enrolled (temporary) Jan. 3, 1848, at New York City.',
 'sha256_wass_001',
 '{"type": "ship", "ship_name": "A. H. Wass", "ship_type": "brig", "hailing_port": "Columbia", "tonnage": 170, "length_ft": 84.5, "breadth_ft": 13.92, "depth_ft": 9.67, "decks": 1, "masts": 2, "stern": "square", "head": "billethead", "year_built": 1847, "place_built": "Columbia", "builder": "Henry D. Leighton", "master": "Alexander H. Wass Jr.", "entry_number": 8}'::jsonb),

-- 9. A. J. DYER
('Ship Registry: A. J. Dyer',
 'Machias Ship Registers 1780-1930',
 'text',
 'A. J. DYER, schooner, of Jonesport. Official No. 535, Sig. let. H. B. P. C. Built at Jonesport, 1855, by John G. Sawyer, master carpenter. 131 34/95 tons; 75 ft. 9 in. x 24 ft. 4 in. x 8 ft. 3 in. One deck, two masts, square stern, a billethead. Enrolled, No. 63, Oct. 3, 1855, at Machias. Owners: Nathaniel C. Rogers, 4/16, Daniel J. Sawyer, 5/16, John Rogers, 2/16, Fellows Rogers, 2/16, George Rogers, 2/16, A. J. Dyer, 1/16, Jonesport. Master: Nathaniel C. Rogers. Multiple enrollments through 1873 with the Rogers and Sawyer families of Jonesport and the Bagley family. Readmeasured in 1865 at 103.92 tons; 75 ft. x 24.4 ft. x 8.2 ft.',
 'sha256_dyer_001',
 '{"type": "ship", "ship_name": "A. J. Dyer", "ship_type": "schooner", "hailing_port": "Jonesport", "official_number": 535, "tonnage_gross": 131, "length_ft": 75.75, "breadth_ft": 24.33, "depth_ft": 8.25, "decks": 1, "masts": 2, "stern": "square", "head": "billethead", "year_built": 1855, "place_built": "Jonesport", "builder": "John G. Sawyer", "master": "Nathaniel C. Rogers", "entry_number": 9}'::jsonb),

-- 10. A. J. MILLER
('Ship Registry: A. J. Miller',
 'Machias Ship Registers 1780-1930',
 'text',
 'A. J. MILLER, schooner, of Boston, Mass. Official No. 105773, Sig. let. J. S. W. F. Built at Northport, N. Y., 1878. 105 tons; 94 ft. x 27 ft. x 6 ft. One deck, two masts, elliptic stern, a billethead. Previously enrolled June 14, 1902, at Boston, Mass. Registered (temporary), No. 19, Aug. 19, 1912, at Machias. Owners: Louis E. Lunt, 3/4, Thomas Butler and E. J. Butler, 1/4, copartners, of Thomas Butler & Co., Boston, Mass. Master: David A. Pittie.',
 'sha256_miller_001',
 '{"type": "ship", "ship_name": "A. J. Miller", "ship_type": "schooner", "hailing_port": "Boston, Mass.", "official_number": 105773, "tonnage": 105, "length_ft": 94, "breadth_ft": 27, "depth_ft": 6, "decks": 1, "masts": 2, "stern": "elliptic", "head": "billethead", "year_built": 1878, "place_built": "Northport, N.Y.", "master": "David A. Pittie", "entry_number": 10}'::jsonb),

-- 11. A. K. McKENZIE
('Ship Registry: A. K. McKenzie',
 'Machias Ship Registers 1780-1930',
 'text',
 'A. K. McKENZIE, schooner, of Addison. Built at Addison, 1853, by James H. Sawyer, master carpenter. 173 26/95 tons; 92 ft. x 25 ft. 6 in. x 8 ft. 5 in. One deck, two masts, square stern, a billethead. Enrolled, No. 56, Oct. 7, 1853, at Machias. Owners: A. K. McKenzie, 4/16, Enoch Richardson, 2/16, Joel S. Crowley, 4/16, James Curtis, 1/16, Susanna K. Emerson, 1/16, David M. Wass, 2/16, Addison; Thomas Drisko, 1/16, Ellis B. McKenzie, 1/16, Jonesport. Master: Thomas Drisko. Multiple enrollments through 1859 with ownership shared among Addison, Jonesport, Columbia, and Boston interests.',
 'sha256_mckenzie_001',
 '{"type": "ship", "ship_name": "A. K. McKenzie", "ship_type": "schooner", "hailing_port": "Addison", "tonnage": 173, "length_ft": 92, "breadth_ft": 25.5, "depth_ft": 8.42, "decks": 1, "masts": 2, "stern": "square", "head": "billethead", "year_built": 1853, "place_built": "Addison", "builder": "James H. Sawyer", "master": "Thomas Drisko", "entry_number": 11}'::jsonb),

-- 12. A. L. MITCHELL
('Ship Registry: A. L. Mitchell',
 'Machias Ship Registers 1780-1930',
 'text',
 'A. L. MITCHELL, schooner, of Machias. Official No. 105833, Sig. let. J. T. H. G. Built at Millbridge, 1879, by E. Dyer, master carpenter. 146.66 gross tons, 139.33 net tons; 96.7 ft. x 28.2 ft. x 7.7 ft. One deck, two masts, elliptic stern, a billethead. Registered, No. 131, May 29, 1879, at Machias. Owners: A. L. Mitchell, 2/64, S. S. Hovey, 4/64, Francis Leighton, 4/64, Joel Hinckley, 10/64, John Leighton, 4/64, L. H. Leighton, 4/64, A. H. Martin, 4/64, Frank Strout, 1/64, Edmund N. Wallace, 2/64, Augustus H. Wallace, 2/64, Effie J. Wallace, 2/64, Lorenzo Leighton, 1/64, Frank Brown, 4/64, Millbridge; G. R. Campbell, Charles Campbell and S. N. Campbell, 2/64, copartners, John W. Coffin, 2/64, Francis S. Nickels, 2/64, Cherryfield; John D. Knowlton, 2/64, Nellie Holt Knowlton, 2/64, Camden; F. M. Hopkins, 4/64, Brooklyn, N.Y.; Jed Frye, W. S. Nickels and J. W. Fitzsimmons, 6/64, copartners, New York City. Master: A. L. Mitchell.',
 'sha256_mitchell_001',
 '{"type": "ship", "ship_name": "A. L. Mitchell", "ship_type": "schooner", "hailing_port": "Machias", "official_number": 105833, "tonnage_gross": 146.66, "tonnage_net": 139.33, "length_ft": 96.7, "breadth_ft": 28.2, "depth_ft": 7.7, "decks": 1, "masts": 2, "stern": "elliptic", "head": "billethead", "year_built": 1879, "place_built": "Millbridge", "builder": "E. Dyer", "master": "A. L. Mitchell", "entry_number": 12}'::jsonb),

-- 13. A. R. KEENE
('Ship Registry: A. R. Keene',
 'Machias Ship Registers 1780-1930',
 'text',
 'A. R. KEENE, schooner, of Columbia Falls. Official No. 106890, Sig. let. K. J. V. W. Built at Columbia Falls, 1891, by Gilbert Frost, master carpenter. 364.03 gross tons, 345.83 net tons; 138.5 ft. x 32.9 ft. x 10.7 ft. One deck, three masts, elliptic stern, a billethead. Enrolled, No. 47, Nov. 11, 1891, at Machias. Owners: George N. Rogers, 24/64, John E. Rogers, 8/64, Charles Keene, 2/64, Daniel J. Sawyer, 8/64, T. A. Drisko, 2/64, W. S. Woodward, 2/64, John A. Beal, 2/64, W. H. Beal, 1/64, E. M. Sawyer, 1/64, Jonesport; H. M. Leighton, 2/64, George Grant, 2/64, G. L. Bucknam, 1/64, Isaac Carleton, 6/64, Columbia Falls; Knowlton Bros., 2/64, Camden; Joseph A. Coffin, 1/64, Machias. Master: George N. Rogers. Later tonnage amended to 314.56 tons, then again to 314 tons.',
 'sha256_keene_001',
 '{"type": "ship", "ship_name": "A. R. Keene", "ship_type": "schooner", "hailing_port": "Columbia Falls", "official_number": 106890, "tonnage_gross": 364.03, "tonnage_net": 345.83, "length_ft": 138.5, "breadth_ft": 32.9, "depth_ft": 10.7, "decks": 1, "masts": 3, "stern": "elliptic", "head": "billethead", "year_built": 1891, "place_built": "Columbia Falls", "builder": "Gilbert Frost", "master": "George N. Rogers", "entry_number": 13}'::jsonb),

-- 14. A. T. HAYNES
('Ship Registry: A. T. Haynes',
 'Machias Ship Registers 1780-1930',
 'text',
 'A. T. HAYNES, schooner, of Jonesport. Official No. 1930. Built at Tremont, 1869. 29 tons; 49 ft. x 18 ft. x 5 ft. One deck, two masts, square stern, a billethead. Previously enrolled (temporary) Mar. 2, 1900, at New York City. Enrolled, No. 48, Mar. 20, 1900, at Machias. Owner: E. F. Kelley, Jonesport. Master: A. T. Haynes. Multiple enrollments through 1909 with the Kelley and Foss families of Jonesport. Final enrollment No. 22, Mar. 29, 1909, at Machias. Owners: J. S. Foss, 1/2, Willard Foss, 1/2, Machias.',
 'sha256_haynes_001',
 '{"type": "ship", "ship_name": "A. T. Haynes", "ship_type": "schooner", "hailing_port": "Jonesport", "official_number": 1930, "tonnage": 29, "length_ft": 49, "breadth_ft": 18, "depth_ft": 5, "decks": 1, "masts": 2, "stern": "square", "head": "billethead", "year_built": 1869, "place_built": "Tremont", "master": "A. T. Haynes", "entry_number": 14}'::jsonb),

-- 15. A. T. KINGSLEY
('Ship Registry: A. T. Kingsley',
 'Machias Ship Registers 1780-1930',
 'text',
 'A. T. KINGSLEY, schooner, of Columbia Falls. Built at Columbia Falls, 1864, by Ephraim Strout, master carpenter. 170.01 tons; 97.5 ft. x 27.2 ft. x 9 ft. One deck, two masts, square stern, a billethead. Registered, No. 2, Jan. 14, 1865, at Machias. Owners: Albion T. Kingsley, 5/8, William Bucknam, 1/8, Robert W. Bucknam, 1/16, George L. Bucknam, 1/16, Columbia Falls; Joanna Strout, 1/16, Francis M. Strout, 1/16, Harrington. Master: Albion T. Kingsley.',
 'sha256_kingsley_001',
 '{"type": "ship", "ship_name": "A. T. Kingsley", "ship_type": "schooner", "hailing_port": "Columbia Falls", "tonnage": 170.01, "length_ft": 97.5, "breadth_ft": 27.2, "depth_ft": 9, "decks": 1, "masts": 2, "stern": "square", "head": "billethead", "year_built": 1864, "place_built": "Columbia Falls", "builder": "Ephraim Strout", "master": "Albion T. Kingsley", "entry_number": 15}'::jsonb),

-- 16. ABAGAIL
('Ship Registry: Abagail',
 'Machias Ship Registers 1780-1930',
 'text',
 'ABAGAIL, schooner, of Harrington. Built at Ipswich, Mass., 1812. 22 29/95 tons; 28 ft. 2 in. x 12 ft. x 5 ft. 8 in. One deck, two masts, pink stern. Previously enrolled June 27, 1837, at Portland. Enrolled, No. 40, June 5, 1839, at Machias. Owner: Nathaniel Fickett, Harrington. Master: Nathaniel Fickett. Enrolled, No. 30, June 14, 1840, at Machias. Owners: Simeon Brown, Nathaniel Huckings, Harrington. Master: Simeon Brown.',
 'sha256_abagail_001',
 '{"type": "ship", "ship_name": "Abagail", "ship_type": "schooner", "hailing_port": "Harrington", "tonnage": 22, "length_ft": 28.17, "breadth_ft": 12, "depth_ft": 5.67, "decks": 1, "masts": 2, "stern": "pink", "year_built": 1812, "place_built": "Ipswich, Mass.", "master": "Nathaniel Fickett", "entry_number": 16}'::jsonb),

-- 17. ABBIE INGALLS
('Ship Registry: Abbie Ingalls',
 'Machias Ship Registers 1780-1930',
 'text',
 'ABBIE INGALLS, schooner, of Machias. Official No. 1618, Sig. let. J. F. N. H. Built at Machias, 1868, by Lowell Nash, master carpenter. 175.36 tons; 106 ft. x 26.2 ft. x 10 ft. One deck, two masts, square stern, a billethead. Enrolled, No. 25, July 17, 1868, at Machias. Owners: William C. Holway, 4/16, Ladwick Holway, 4/16, Clark Perry, 2/16, Ignatius Sargent, 1/16, John K. Ames, 1/16, Machias; N. B. Ingalls, 2/16, Nelson Ingalls, 2/16, Machiasport. Master: N. B. Ingalls. Extensive registration history 1868-1897 with multiple ownership changes involving the Ingalls, Holway, Sargent, Sawyer, and Kelley families. Tonnage amended to 183.94 gross tons, 174.74 net tons in 1873.',
 'sha256_ingalls_001',
 '{"type": "ship", "ship_name": "Abbie Ingalls", "ship_type": "schooner", "hailing_port": "Machias", "official_number": 1618, "tonnage": 175.36, "length_ft": 106, "breadth_ft": 26.2, "depth_ft": 10, "decks": 1, "masts": 2, "stern": "square", "head": "billethead", "year_built": 1868, "place_built": "Machias", "builder": "Lowell Nash", "master": "N. B. Ingalls", "entry_number": 17}'::jsonb),

-- 18. ABBIE C. STUBBS
('Ship Registry: Abbie C. Stubbs',
 'Machias Ship Registers 1780-1930',
 'text',
 'ABBIE C. STUBBS, schooner, of New York City. Official No. 106060, Sig. let. J. V. W. F. Built at New Haven, Conn., 1882. 345.46 gross tons, 295 net tons; 130 ft. x 32.2 ft. x 12 ft. One deck, three masts, square stern, a billethead, built of wood. Previously enrolled (temporary) May 18, 1920, at Jacksonville, Fla. Registered (temporary), No. 2, July 7, 1920, at Machias. Owners: Charles R. Tryon Jr., 8/64, Eastport; William C. Reid, 12/64, Fred H. Colwell, 16/64, John N. Cosgrove, 4/64, Daniel J. Leary, 24/64, Brooklyn, N. Y. Master: Stephen E. Peabody, Jonesport. Surrendered, Sept. 10, 1920, at New York City. Subsequently registered and surrendered at Machias in 1921 and 1922, with trade changed July 31, 1922.',
 'sha256_stubbs_001',
 '{"type": "ship", "ship_name": "Abbie C. Stubbs", "ship_type": "schooner", "hailing_port": "New York City", "official_number": 106060, "tonnage_gross": 345.46, "tonnage_net": 295, "length_ft": 130, "breadth_ft": 32.2, "depth_ft": 12, "decks": 1, "masts": 3, "stern": "square", "head": "billethead", "year_built": 1882, "place_built": "New Haven, Conn.", "master": "Stephen E. Peabody", "disposition": "Trade changed July 31, 1922", "entry_number": 18}'::jsonb),

-- 19. ABBIE G. COLE
('Ship Registry: Abbie G. Cole',
 'Machias Ship Registers 1780-1930',
 'text',
 'ABBIE G. COLE, schooner, of Machiasport. Official No. 106819, Sig. let. K. J. L. G. Built at East Machias, 1891, by Charles J. Frye, master carpenter. 273.32 gross tons, 259.65 net tons; 129.2 ft. x 30.6 ft. x 10.3 ft. One deck, three masts, elliptic stern, a billethead. Registered, No. 1, July 1, 1891, at Machias. Owners: Jerome B. Cole, 36/384, Elvira A. Cole, 6/384, Aaron Grant, 12/384, Angeline Grant, 12/384, Zemro R. Thompson, 12/384, in trust, Caroline Cole, 12/384, James A. Flynn, 6/384, Henrietta Sanborn, 6/384, George Thompson, 6/384, Machiasport; T. W. Cooper, 24/384, W. E. Cooper, 24/384, J. O. Pope & Co., 24/384, Herbert Harris, 6/384, E. P. Gardner, 6/384, Pope, Harris & Co., 18/384, East Machias; Charles Sargent, 6/384, Portland; Morey Gardner, 9/384, I. M. Sargent, 9/384, I. M. Sargent, 2/384, Henry C. Sargent, 2/384, estate of Ignatius Sargent, 12/384, John Inglee & Son, 24/384, George D. Perry, 12/384, W. C. Holway, 18/384, T. J. Batchelder, 6/384, John Shaw, 12/384, Machias; Joseph Smith, 6/384, Ellery T. Smith, 6/384, Wilbur Smith, 6/384, Marshfield; Knowlton Bros., 6/384, Camden; James F. Bliss & Co., 12/384, Boston, Mass.; Horace B. Rawson and George S. Rawson, 12/384, New York City. Master: Jerome B. Cole.',
 'sha256_cole_001',
 '{"type": "ship", "ship_name": "Abbie G. Cole", "ship_type": "schooner", "hailing_port": "Machiasport", "official_number": 106819, "tonnage_gross": 273.32, "tonnage_net": 259.65, "length_ft": 129.2, "breadth_ft": 30.6, "depth_ft": 10.3, "decks": 1, "masts": 3, "stern": "elliptic", "head": "billethead", "year_built": 1891, "place_built": "East Machias", "builder": "Charles J. Frye", "master": "Jerome B. Cole", "entry_number": 19}'::jsonb),

-- 20. ABBIE H. HODGMAN
('Ship Registry: Abbie H. Hodgman',
 'Machias Ship Registers 1780-1930',
 'text',
 'ABBIE H. HODGMAN, schooner, of Harrington. Official No. 1619, Sig. let. J. F. N. K. Built at Harrington, 1868, by Alonzo P. Nash, master carpenter. 152.55 gross tons, 144.92 net tons; 89.7 ft. x 27.6 ft. x 8.7 ft. One deck, two masts, square stern, a billethead. Enrolled, No. 39, Sept. 18, 1868, at Machias. Owners: William A. Eaton, 1/16, Stillman W. Nash, 5/32, Alonzo P. Nash, 1/16, Albert M. Nash, 3/32, Stillman E. Nash, 1/32, Uriah N. Nash, 1/32, Moses H. Nash, 1/32, Harrington; Albert Brown, 2/32, East Machias; George Harris, 8/32, Machias; John Magee Jr., 2/32, Columbia Falls; Elizabeth M. Nash, 2/32, Cherryfield; Abbie H. Hodgman, 1/32, Mary E. Moseley, 1/32, Boston, Mass. Master: William A. Eaton. Extensive registration history through 1886 with the Nash family of Harrington maintaining primary ownership, and shares distributed among families in East Machias, Machias, Columbia Falls, Cherryfield, Calais, and Andover, Mass.',
 'sha256_hodgman_001',
 '{"type": "ship", "ship_name": "Abbie H. Hodgman", "ship_type": "schooner", "hailing_port": "Harrington", "official_number": 1619, "tonnage_gross": 152.55, "tonnage_net": 144.92, "length_ft": 89.7, "breadth_ft": 27.6, "depth_ft": 8.7, "decks": 1, "masts": 2, "stern": "square", "head": "billethead", "year_built": 1868, "place_built": "Harrington", "builder": "Alonzo P. Nash", "master": "William A. Eaton", "entry_number": 20}'::jsonb),

-- 21. ABBIE S. WALKER
('Ship Registry: Abbie S. Walker',
 'Machias Ship Registers 1780-1930',
 'text',
 'ABBIE S. WALKER, schooner, of Vinalhaven. Official No. 106218, Sig. let. K. B. S. W. Built at Jonesboro, 1883, by William L. Tupper, master carpenter. 190.74 gross tons, 181.21 net tons; 103.7 ft. x 28.7 ft. x 8.5 ft. One deck, three masts, elliptic stern, a billethead, built of wood. Enrolled (temporary), No. 40, Nov. 20, 1883, at Machias. Owners: E. P. Walker, 12/64, Lydia M. Webster, 4/64, Lucy E. Walls, 4/64, J. R. Frohock, 2/64, S. P. Berry, 2/64, Chaney Noyes, 2/64, Georgianna Collis, 2/64, Robert Diack, 2/64, E. H. Lyford and George P. Ginn, 2/64, copartners, Rebecca J. Glidden, 1/64, J. F. Hopkins, 1/64, Lottie Pullen, 1/64, W. T. Littlefield, 1/64, J. L. Black, 1/64, Elisha Smith, 1/64, Vinalhaven; G. M. Brainard, 4/64, E. H. Lawry, 4/64, John Blethen, 4/64, Rockland; F. J. Dobbin, 2/64, Daniel J. Sawyer, 2/64, J. B. Dobbin, 2/64, N. Rumery, 2/64, Jonesport; F. O. Hichborn, 2/64, Stockton; J. R. Bodwell, 2/64, Hallowell; J. T. Lewis, 2/64, Portland. Master: F. J. Dobbin. Later registered through 1925 with numerous ownership changes.',
 'sha256_walker_001',
 '{"type": "ship", "ship_name": "Abbie S. Walker", "ship_type": "schooner", "hailing_port": "Vinalhaven", "official_number": 106218, "tonnage_gross": 190.74, "tonnage_net": 181.21, "length_ft": 103.7, "breadth_ft": 28.7, "depth_ft": 8.5, "decks": 1, "masts": 3, "stern": "elliptic", "head": "billethead", "year_built": 1883, "place_built": "Jonesboro", "builder": "William L. Tupper", "master": "F. J. Dobbin", "entry_number": 21}'::jsonb),

-- 22. ABBY MORSE
('Ship Registry: Abby Morse',
 'Machias Ship Registers 1780-1930',
 'text',
 'ABBY MORSE, schooner, of Steuben. Official No. 195. Built at Essex, Mass., 1853. 32 tons; 58 ft. x 17.5 ft. x 6.2 ft. One deck, two masts, square stern, a billethead. Previously enrolled Aug. 16, 1898, at Southwest Harbor. Enrolled, No. 16, Sept. 30, 1898, at Machias. Owner: Gilman N. Williams, Steuben. Master: Orlando T. King. Enrolled, No. 28, Dec. 5, 1899, at Machias. Owner: Jesse E. Stevens, Steuben. Master: Frederick Nutter.',
 'sha256_morse_001',
 '{"type": "ship", "ship_name": "Abby Morse", "ship_type": "schooner", "hailing_port": "Steuben", "official_number": 195, "tonnage": 32, "length_ft": 58, "breadth_ft": 17.5, "depth_ft": 6.2, "decks": 1, "masts": 2, "stern": "square", "head": "billethead", "year_built": 1853, "place_built": "Essex, Mass.", "master": "Orlando T. King", "entry_number": 22}'::jsonb),

-- 23. ABBY A. SNOW
('Ship Registry: Abby A. Snow',
 'Machias Ship Registers 1780-1930',
 'text',
 'ABBY A. SNOW, schooner, of Addison. Official No. 1393. Built at Bath, 1867. 35.93 tons; 57.7 ft. x 17.9 ft. x 6.5 ft. One deck, two masts, square stern, a billethead. Previously enrolled May 26, 1871, at Portland. Enrolled, No. 11, Aug. 13, 1872, at Machias. Owners: George K. Merritt, 1/16, Addison; William J. Underwood and Charles J. Underwood, 15/16, copartners, Boston, Mass. Master: George K. Merritt. Enrolled, of Jonesport, No. 7, Aug. 8, 1873, at Machias. Owners: George K. Merritt; Samuel B. Cummings, 1/16, Jonesport; William J. Underwood and Charles J. Underwood, 15/16, copartners, Boston, Mass. Master: Samuel B. Cummings.',
 'sha256_snow_001',
 '{"type": "ship", "ship_name": "Abby A. Snow", "ship_type": "schooner", "hailing_port": "Addison", "official_number": 1393, "tonnage": 35.93, "length_ft": 57.7, "breadth_ft": 17.9, "depth_ft": 6.5, "decks": 1, "masts": 2, "stern": "square", "head": "billethead", "year_built": 1867, "place_built": "Bath", "master": "George K. Merritt", "entry_number": 23}'::jsonb),

-- 24. ABIGAIL (sloop)
('Ship Registry: Abigail',
 'Machias Ship Registers 1780-1930',
 'text',
 'ABIGAIL, sloop, of Machias. Built at Machias, Mass. (now Maine), 1816, by Ebenezer Stetson, master carpenter. 93 tons; 70 ft. x 21 ft. 8 in. x 7 ft. 2 in. One deck, one mast, square stern. Enrolled, No. 10, Sept. 3, 1816, at Machias. Owners: Isaac Ames, mariner, Jacob Longfellow, trader, Jonathan Longfellow, yeoman, Daniel Longfellow, blacksmith, Machias. Master: Isaac Ames. Readmeasured at 93 tons; 75 ft. x 21 ft. 7 1/2 in. x 7 ft. 2 in. Multiple enrollments through 1823 with Isaac Ames as master. The Abigail was converted from a sloop to a schooner by 1818.',
 'sha256_abigail_001',
 '{"type": "ship", "ship_name": "Abigail", "ship_type": "sloop", "hailing_port": "Machias", "tonnage": 93, "length_ft": 70, "breadth_ft": 21.67, "depth_ft": 7.17, "decks": 1, "masts": 1, "stern": "square", "year_built": 1816, "place_built": "Machias, Mass. (now Maine)", "builder": "Ebenezer Stetson", "master": "Isaac Ames", "entry_number": 24}'::jsonb);


-- ============================================================
-- Port Profiles (Maine maritime district)
-- ============================================================

INSERT INTO documents (title, archive_name, content_type, raw_content, checksum, metadata) VALUES

('Port Profile: Machias, Maine',
 'Machias Ship Registers 1780-1930',
 'text',
 'The Customs District of Machias, Massachusetts, was created by Act of July 31, 1789, as Number III of fourteen collection districts. It was one of the districts mentioned in the very first Customs Act of 1790. By Act of March 2, 1799, a collector was appointed to reside at the ports of Machias and Passamaquoddy. At that time Machias (incorporated 1784) was the only incorporated town in the area and therefore made the port of entry. It was an immense town which included the shore towns of Machiasport and East Machias until 1826, and the two interior towns of Whitneyville, set off in 1845, and Marshfield, set off in 1846. In those days, Machias had a large foreign trade, and a Spanish vice consul. The name was changed to District of Machias, Maine, by Act of March 3, 1820. Its territorial limits embraced the southerly shores of Washington County from Moose Cove in the town of Trescott westerly to the Hancock line. The district was discontinued and the position of Collector abolished June 30, 1913, by the President''s order of March 3, 1913. Machias was one of the most important shipbuilding centers in eastern Maine, with 120 vessels documented as built there between 1800 and 1920.',
 'sha256_port_machias_001',
 '{"type": "port", "port_name": "Machias", "state": "Maine", "established": 1789, "discontinued": 1913, "total_vessels_hailing": 655, "total_vessels_built": 120}'::jsonb),

('Port Profile: East Machias, Maine',
 'Machias Ship Registers 1780-1930',
 'text',
 'East Machias, set off from Machias in 1826, was the most prolific shipbuilding community in the Machias Customs District. Between 1820 and 1915, a total of 139 vessels were built there, more than any other single location in the district. The town sits along the East Machias River, which provided both waterpower for sawmills and launching sites for newly built vessels. Master carpenters such as Gilbert Trott built schooners and brigs using locally harvested timber. The East Machias shipyards produced vessels ranging from small fishing schooners of 30 tons to substantial three-masted coasting schooners exceeding 250 tons. The vessels built there traded along the Atlantic seaboard from the Maritime Provinces to the Gulf states, carrying lumber, fish, and general cargo. Many East Machias-built vessels were owned by networks of local families who held fractional shares — a common financing method that distributed both investment and risk across the community.',
 'sha256_port_eastmachias_001',
 '{"type": "port", "port_name": "East Machias", "state": "Maine", "total_vessels_built": 139, "building_span": "1820-1915", "total_vessels_hailing": 172}'::jsonb),

('Port Profile: Columbia Falls, Maine',
 'Machias Ship Registers 1780-1930',
 'text',
 'Columbia Falls, situated on the Pleasant River in Washington County, was a significant shipbuilding center within the Machias Customs District. Between 1805 and 1890, 41 vessels were built there, ranging from small sloops to substantial brigs and three-masted schooners. Master carpenters including Arthur Stevens, John S. Allen, Ephraim Strout, and Gilbert Frost built vessels that traded from Maine to the Caribbean and along the entire Atlantic coast. The Crandon family — particularly Joseph Crandon and John H. Crandon — were among the most prominent vessel owners, often holding majority shares in Columbia Falls-built ships. The Bucknam family also featured prominently in Columbia Falls maritime history, both as owners and investors. Columbia Falls vessels were typically registered at Machias, the district headquarters, and hailed from ports throughout the district. The town''s shipyards benefited from abundant local timber and the navigable Pleasant River, which provided direct access to the sea.',
 'sha256_port_columbiafalls_001',
 '{"type": "port", "port_name": "Columbia Falls", "state": "Maine", "total_vessels_built": 41, "building_span": "1805-1890", "total_vessels_hailing": 68}'::jsonb),

('Port Profile: Addison, Maine',
 'Machias Ship Registers 1780-1930',
 'text',
 'Addison, located on the coast of Washington County at the mouth of the Pleasant River, was one of the most productive shipbuilding communities in the Machias Customs District. Between 1800 and 1890, a remarkable 91 vessels were documented as built there — making it the second most prolific building port after East Machias. The Look family was central to Addison''s maritime economy: Thomas Look served as master carpenter, while Porter B. Look, Luther W. Look, and their relatives served as masters and held ownership shares in numerous vessels. The town''s shipyards produced primarily schooners for the coasting trade, carrying lumber, fish, and lime along the coast from Maine to New York, Philadelphia, and beyond. Addison vessels frequently registered ownership shares distributed among families in Addison, Jonesport, Harrington, Cherryfield, Columbia Falls, and other Washington County communities — reflecting the tight-knit economic networks of Down East Maine.',
 'sha256_port_addison_001',
 '{"type": "port", "port_name": "Addison", "state": "Maine", "total_vessels_built": 91, "building_span": "1800-1890", "total_vessels_hailing": 167}'::jsonb),

('Port Profile: Jonesport, Maine',
 'Machias Ship Registers 1780-1930',
 'text',
 'Jonesport, situated on Moosabec Reach in Washington County, was a major seafaring community within the Machias Customs District. The town was home to 269 vessels documented in the registers — more than any other hailing port in the district. Jonesport''s protected harbor and proximity to rich fishing grounds made it a natural center for maritime activity. The Rogers, Sawyer, Kelley, and Beal families were among the most prominent vessel-owning families. Jonesport-based vessels engaged in fishing, coasting trade, and lumber transport. The town''s mariners were renowned for their seamanship in the challenging waters of the Gulf of Maine. Between 1820 and 1915, 28 vessels were built in Jonesport itself, while many more Jonesport-owned vessels were built at neighboring ports like East Machias, Columbia Falls, and Addison. The Jonesport fleet included everything from small fishing sloops to large three-masted schooners capable of carrying cargo to distant ports.',
 'sha256_port_jonesport_001',
 '{"type": "port", "port_name": "Jonesport", "state": "Maine", "total_vessels_built": 28, "building_span": "1820-1915", "total_vessels_hailing": 269}'::jsonb);


-- ============================================================
-- Historical Context Documents
-- ============================================================

INSERT INTO documents (title, archive_name, content_type, raw_content, checksum, metadata) VALUES

('Historical Context: Fractional Ship Ownership in Down East Maine',
 'Machias Ship Registers 1780-1930',
 'text',
 'A distinctive feature of maritime commerce in the Machias district was the system of fractional ship ownership. Rather than a single owner financing an entire vessel, shares were divided among numerous investors — sometimes as many as 30 or more individuals. Shares were expressed as fractions: 1/4, 1/16, 2/64, 3/384, and so on. This system served multiple purposes. It distributed the financial risk of vessel ownership across many families, making it possible for even modest households to participate in the maritime economy. A fisherman might own 1/16 of a schooner while a merchant held 1/4 and the master carpenter who built the vessel retained 1/8. Women frequently appeared as owners, sometimes identified as holding shares "in trust" or as estates. The fractional ownership system also reflected the tight community bonds of Down East Maine, where families intermarried and business relationships spanned generations. When a vessel was lost or condemned, the financial impact was spread across the community rather than devastating a single owner.',
 'sha256_context_ownership_001',
 '{"type": "historical_context", "topic": "fractional_ship_ownership", "period": "1780-1930", "region": "Down East Maine"}'::jsonb),

('Historical Context: Shipbuilding in the Machias District',
 'Machias Ship Registers 1780-1930',
 'text',
 'The District of Machias was one of the great shipbuilding regions of 19th-century America. Between 1780 and 1930, a total of 1,990 vessels were documented in the registers — built at 280 different ports and places. Maine alone accounted for 1,581 vessels built at 117 locations. The peak decades of construction were the 1850s through 1870s, when schooners, brigs, barks, and full-rigged ships slid down the ways at dozens of small yards along the rivers and harbors of Washington County. The most common vessel type was the schooner, with 1,002 built during the period — reflecting the practical needs of the coasting trade. Sloops (136), barks (39), brigs (101), and ships (10) were also built. The dominant building material was wood, primarily local spruce, pine, and oak. By the 1890s, shipbuilding had declined sharply as steam vessels and railroad expansion reduced demand for wooden sailing vessels. The last significant construction activity in the district occurred during the World War I era, when a brief revival of wooden shipbuilding took place to replace tonnage lost to German submarines.',
 'sha256_context_shipbuilding_001',
 '{"type": "historical_context", "topic": "shipbuilding_overview", "period": "1780-1930", "region": "District of Machias", "total_vessels": 1990, "total_building_ports": 280}'::jsonb),

('Historical Context: Collectors of Customs, District of Machias',
 'Machias Ship Registers 1780-1930',
 'text',
 'The Collectors of Customs for the District of Machias served as the federal government''s maritime administrators, responsible for documenting vessel registrations, collecting duties, and enforcing trade regulations. The first collector, Stephen Smith, was appointed March 21, 1791, when the district was part of Massachusetts. After Maine''s statehood in 1820, the district became Machias, Maine. Notable collectors included: Stephen Smith (1791), Lemuel Trescott (1807-1807), Jeremiah O''Brien (1811) — a name linked to the famous Revolutionary War naval engagement at Machias, Samuel A. Morse (1820-1832), William Brown (1836-1840), William F. Smith (1841), William B. Smith (1849-1850), A. F. Parlin (1857-1857), William B. Smith (1861-1861), Stephen Longfellow (1864-1867), George Leavitt (1875-1879), John L. Pierce (1883-1886), John F. Lynch (1887), Eldridge H. Bryant (1891), George W. Drisko (1895-1896), John K. Ames (1897-1901), and Frank L. Shaw (1901-1910). The district was abolished June 30, 1913.',
 'sha256_context_collectors_001',
 '{"type": "historical_context", "topic": "collectors_of_customs", "period": "1791-1913", "region": "District of Machias"}'::jsonb);
