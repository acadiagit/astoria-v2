-- Astoria v2 — Maritime Seed Data
-- Populates the documents table with structured maritime records.
-- Embeddings are generated separately by the seed_embeddings.py script.
--
-- Data types: ships, voyages, ports
-- Period: 1840s-1890s Pacific Northwest / Columbia River maritime history

-- ============================================================
-- Ships
-- ============================================================

INSERT INTO documents (title, archive_name, content_type, raw_content, checksum, metadata) VALUES

-- 1. Tonquin
('Ship Registry: Tonquin',
 'Astoria Maritime Archive',
 'text',
 'The Tonquin was an American merchant vessel, a 290-ton ship built in New York in 1807. She was dispatched by John Jacob Astor''s Pacific Fur Company to establish a fur trading post at the mouth of the Columbia River. Under the command of Captain Jonathan Thorn, the Tonquin departed New York on September 8, 1810, carrying 33 men including partners, clerks, and voyageurs of the Pacific Fur Company. After a difficult passage around Cape Horn, she arrived at the Columbia River bar on March 22, 1811. The crossing of the bar was treacherous — Captain Thorn sent a boat crew to sound the channel, and several men were lost in the violent surf. The Tonquin played a central role in founding Fort Astoria, the first permanent American settlement on the Pacific coast. After offloading supplies and settlers, the Tonquin sailed north to Vancouver Island for fur trading. In June 1811, following a confrontation with the Tla-o-qui-aht people at Clayoquot Sound, the ship was attacked and destroyed. The vessel was blown up, likely by a surviving crew member who ignited the powder magazine, killing everyone aboard and many of the attackers.',
 'sha256_tonquin_001',
 '{"type": "ship", "ship_name": "Tonquin", "ship_type": "merchant vessel", "tonnage": 290, "year_built": 1807, "port_of_registry": "New York", "captain": "Jonathan Thorn", "owner": "Pacific Fur Company"}'::jsonb),

-- 2. Peacock
('Ship Registry: USS Peacock',
 'Astoria Maritime Archive',
 'text',
 'The USS Peacock was a sloop-of-war in the United States Navy, built at the New York Navy Yard and launched in 1828. She displaced 559 tons and carried 18 guns. The Peacock served in multiple naval expeditions, including the United States Exploring Expedition (1838-1842) under Lieutenant Charles Wilkes. On July 18, 1841, while attempting to enter the Columbia River, the Peacock ran aground on the shoals near the river bar. Despite efforts to free the vessel, she was pounded by heavy surf and eventually broke apart. All crew were rescued, but the ship was a total loss. The wreck site near Cape Disappointment became known as Peacock Spit, a name still used on navigation charts today. The loss of the Peacock highlighted the extreme danger of the Columbia River bar, which would claim numerous vessels over the following decades. The crew salvaged what equipment they could and were transported to Fort Vancouver. The incident contributed to the establishment of improved navigational aids at the river mouth.',
 'sha256_peacock_001',
 '{"type": "ship", "ship_name": "USS Peacock", "ship_type": "sloop-of-war", "tonnage": 559, "year_built": 1828, "port_of_registry": "New York", "captain": "William Hudson", "owner": "United States Navy", "fate": "wrecked 1841"}'::jsonb),

-- 3. Shark
('Ship Registry: USS Shark',
 'Astoria Maritime Archive',
 'text',
 'The USS Shark was a schooner in the United States Navy, commissioned in 1821. She displaced 198 tons and carried 12 guns. After years of service patrolling against piracy in the Caribbean and slave trade off Africa, the Shark was assigned to the Pacific Squadron. On September 10, 1846, while attempting to cross the Columbia River bar under the command of Lieutenant Neil Howison, the Shark struck a submerged sandbar. The vessel was carried by the current onto Clatsop Spit, where she broke apart in the heavy surf. All hands survived, though the ship and most of her stores were lost. Parts of the Shark''s hull and a cannon washed ashore and were recovered by local settlers. The wreck further cemented the Columbia River bar''s fearsome reputation as the "Graveyard of the Pacific." One of the Shark''s cannons was later recovered and is now displayed in Astoria, Oregon, serving as a historical artifact.',
 'sha256_shark_001',
 '{"type": "ship", "ship_name": "USS Shark", "ship_type": "schooner", "tonnage": 198, "year_built": 1821, "port_of_registry": "Philadelphia", "captain": "Neil Howison", "owner": "United States Navy", "fate": "wrecked 1846"}'::jsonb),

-- 4. Columbia Rediviva
('Ship Registry: Columbia Rediviva',
 'Astoria Maritime Archive',
 'text',
 'The Columbia Rediviva was an American privately owned ship that achieved fame as the first American vessel to circumnavigate the globe. Built in 1773 in Plymouth, Massachusetts, she displaced 212 tons. Under Captain Robert Gray, the Columbia Rediviva crossed the bar of the great river of the west on May 11, 1792, becoming the first documented non-indigenous vessel to enter the river. Gray named the river "Columbia" after his ship — the name that endures to this day. The Columbia River was previously noted by Spanish and British explorers from offshore but never entered. Gray spent nine days trading with the Chinook people near the river mouth before departing. His discovery established American claims to the region, which would later be central to the Oregon boundary dispute with Britain. The Columbia Rediviva completed her second circumnavigation in 1793 and was subsequently used as a coastal trader before being broken up around 1801.',
 'sha256_columbia_001',
 '{"type": "ship", "ship_name": "Columbia Rediviva", "ship_type": "full-rigged ship", "tonnage": 212, "year_built": 1773, "port_of_registry": "Boston", "captain": "Robert Gray", "owner": "Joseph Barrell and partners"}'::jsonb),

-- 5. Beaver (Hudson's Bay Co.)
('Ship Registry: SS Beaver',
 'Astoria Maritime Archive',
 'text',
 'The SS Beaver was a paddle steamer built in 1835 at the Blackwall Yard on the Thames River in London, England. She displaced 109 tons and was the first steamship to operate in the Pacific Northwest. Constructed for the Hudson''s Bay Company, the Beaver was shipped to the Columbia District under sail, arriving at Fort Vancouver in April 1836. She was fitted with her paddle wheels upon arrival and became an essential vessel for the fur trade, coastal surveying, and transport along the Pacific coast from the Columbia River to Alaska. The Beaver served the Hudson''s Bay Company for over 30 years, carrying furs, supplies, and company officials between trading posts. During the Fraser Canyon Gold Rush of 1858, she was chartered as a survey vessel by the Royal Navy. The Beaver ran aground at Prospect Point in the First Narrows of Vancouver''s Burrard Inlet on July 26, 1888, and was eventually broken up by wave action. Her engine was salvaged and is preserved at the Vancouver Maritime Museum.',
 'sha256_beaver_001',
 '{"type": "ship", "ship_name": "SS Beaver", "ship_type": "paddle steamer", "tonnage": 109, "year_built": 1835, "port_of_registry": "London", "captain": "David Home", "owner": "Hudson''s Bay Company", "fate": "wrecked 1888"}'::jsonb),

-- 6. Peter Iredale
('Ship Registry: Peter Iredale',
 'Astoria Maritime Archive',
 'text',
 'The Peter Iredale was a four-masted steel bark built in 1890 at Maryport, England. She displaced 2,075 tons and was primarily employed in the grain and general cargo trade between Europe and the Pacific coast. On October 25, 1906, while en route from Salinas Cruz, Mexico to Portland, Oregon to pick up a cargo of wheat, the Peter Iredale encountered heavy fog and a strong southerly wind near the mouth of the Columbia River. The vessel ran aground on Clatsop Beach, just south of the river entrance. Captain H. Lawrence and his crew of 25 all survived without injury. Salvage attempts proved unsuccessful, and the ship was abandoned to the elements. The wreck of the Peter Iredale remains visible on the beach at Fort Stevens State Park to this day, making it one of the most accessible and photographed shipwrecks on the Pacific coast. The rusted iron skeleton of the bow section continues to stand against the waves, a stark monument to the dangers of the Columbia River bar.',
 'sha256_piredale_001',
 '{"type": "ship", "ship_name": "Peter Iredale", "ship_type": "four-masted bark", "tonnage": 2075, "year_built": 1890, "port_of_registry": "Liverpool", "captain": "H. Lawrence", "owner": "Peter Iredale & Co.", "fate": "wrecked 1906"}'::jsonb),

-- 7. Great Republic
('Ship Registry: Great Republic',
 'Astoria Maritime Archive',
 'text',
 'The Great Republic was a sidewheel steamship of 1,421 tons built in 1866 at Greenpoint, New York. She was owned by the North Pacific Transportation Company and operated on the route between San Francisco and Portland, Oregon, via Astoria. The Great Republic was one of the premier passenger vessels serving the Pacific Northwest coast during the late 1860s and 1870s. She could carry over 500 passengers and substantial cargo. The vessel regularly crossed the Columbia River bar, though each crossing remained perilous. The Great Republic transported settlers, miners heading to gold strikes, and mail between California and Oregon. She also played a role in the early tourism industry, bringing visitors to see the scenic Columbia River. In 1879, she was sold and converted for use in the trans-Pacific trade between San Francisco and China. She continued in service until being broken up in 1889.',
 'sha256_greatrep_001',
 '{"type": "ship", "ship_name": "Great Republic", "ship_type": "sidewheel steamship", "tonnage": 1421, "year_built": 1866, "port_of_registry": "New York", "owner": "North Pacific Transportation Company"}'::jsonb),

-- 8. Rosecrans
('Ship Registry: Rosecrans',
 'Astoria Maritime Archive',
 'text',
 'The Rosecrans was a steel-hulled steam schooner of 2,363 tons, built in 1883 at Glasgow, Scotland, originally named Methven Castle. She was acquired by the Associated Oil Company for use as an oil tanker on the Pacific coast. The Rosecrans was a frequent visitor to the Columbia River, carrying petroleum products from California to Portland. On January 7, 1913, during a powerful winter storm, the Rosecrans attempted to cross the Columbia River bar. Despite having an experienced Columbia River bar pilot aboard, the vessel struck Peacock Spit and quickly broke apart in the mountainous seas. Of her crew of 36, only two men survived, making it one of the deadliest shipwrecks in Columbia River history. The disaster prompted calls for improved safety measures at the river bar, including the construction of the North Jetty and enhanced rescue capabilities at the Cape Disappointment Life-Saving Station.',
 'sha256_rosecrans_001',
 '{"type": "ship", "ship_name": "Rosecrans", "ship_type": "steam schooner", "tonnage": 2363, "year_built": 1883, "port_of_registry": "San Francisco", "owner": "Associated Oil Company", "fate": "wrecked 1913"}'::jsonb),

-- 9. Oriole
('Ship Registry: Oriole',
 'Astoria Maritime Archive',
 'text',
 'The Oriole was a bark of 462 tons built in 1854 at Bath, Maine. She was employed in the lumber trade between the Pacific Northwest and San Francisco, carrying Douglas fir timber from mills along the Columbia River to the rapidly growing California market. The Oriole made regular runs between Astoria and San Francisco, typically carrying loads of 300,000 board feet of sawn lumber. She was representative of the fleet of sailing vessels that sustained the Pacific coast lumber trade during the mid-19th century. Her captain, J.W. Mitchell, was known for his skillful navigation of the Columbia River bar and the tricky channels of the lower river. The Oriole''s cargo manifests, preserved in the Astoria customs house records, provide valuable data about the volume and value of the lumber trade during the 1850s and 1860s. She was eventually sold to Hawaiian interests in 1868 and continued in the Pacific trade until she was condemned and broken up in 1874.',
 'sha256_oriole_001',
 '{"type": "ship", "ship_name": "Oriole", "ship_type": "bark", "tonnage": 462, "year_built": 1854, "port_of_registry": "Bath, Maine", "captain": "J.W. Mitchell", "cargo": "lumber"}'::jsonb),

-- 10. Brother Jonathan
('Ship Registry: Brother Jonathan',
 'Astoria Maritime Archive',
 'text',
 'The Brother Jonathan was a sidewheel steamship of 1,181 tons, built in 1850 at Williamsburg, New York. She was one of the most important passenger and cargo vessels operating between San Francisco, Portland, and other Pacific coast ports during the 1850s and 1860s. The Brother Jonathan carried thousands of settlers, gold miners, and businessmen along the coast, including stops at Astoria and the Columbia River. She was known for her speed and relative comfort. On July 30, 1865, while en route from San Francisco to Portland and Victoria, the Brother Jonathan struck an uncharted rock near Crescent City, California during a storm. The ship sank rapidly, taking 225 of the 244 people aboard to their deaths. It was one of the worst maritime disasters in Pacific coast history. The wreck was located in 1993 and yielded a significant treasure of gold coins and artifacts, now valued at millions of dollars.',
 'sha256_brotherj_001',
 '{"type": "ship", "ship_name": "Brother Jonathan", "ship_type": "sidewheel steamship", "tonnage": 1181, "year_built": 1850, "port_of_registry": "New York", "fate": "sunk 1865"}'::jsonb);


-- ============================================================
-- Voyages
-- ============================================================

INSERT INTO documents (title, archive_name, content_type, raw_content, checksum, metadata) VALUES

('Voyage: Columbia Rediviva — First Entry to Columbia River (1792)',
 'Astoria Maritime Archive',
 'text',
 'On May 11, 1792, Captain Robert Gray sailed the Columbia Rediviva across the bar of a great river on the Pacific coast of North America. After several days of observing the current and breakers from offshore, Gray identified a navigable channel and entered the river on a flood tide. The ship anchored in a bay on the north side of the river, near a large Chinook village. Gray spent nine days exploring the lower river, trading with the Chinook people for sea otter furs, and taking observations. He named the river "Columbia" after his vessel. Gray''s log records the river as being approximately one mile wide at the entrance, with strong currents and dangerous shoals. The discovery established American territorial claims to the Columbia River drainage and the Oregon Country. The crew traded cloth, iron, and copper for approximately 150 sea otter skins and 300 beaver pelts. Gray departed the river on May 20, 1792, continuing his voyage northward along the coast.',
 'sha256_voy_columbia_001',
 '{"type": "voyage", "ship_name": "Columbia Rediviva", "captain": "Robert Gray", "departure_port": "at sea (Pacific coast)", "arrival_port": "Columbia River mouth", "arrival_date": "1792-05-11", "departure_date": "1792-05-20", "cargo": "trade goods (cloth, iron, copper)", "crew_count": 30}'::jsonb),

('Voyage: Tonquin — New York to Columbia River (1810-1811)',
 'Astoria Maritime Archive',
 'text',
 'The Tonquin departed New York harbor on September 8, 1810, under the command of Captain Jonathan Thorn, carrying supplies and personnel for John Jacob Astor''s Pacific Fur Company. The voyage around Cape Horn was marked by severe weather and tensions between Captain Thorn and the fur company partners aboard. The ship called at the Falkland Islands and Hawaii before making landfall on the Oregon coast. On March 22, 1811, the Tonquin arrived at the mouth of the Columbia River. The bar crossing proved disastrous — Thorn sent out a boat to sound the channel, and the crew of five were lost in the violent breakers. A second boat with three men was also swamped, though some survivors were later recovered. Once across the bar, the ship anchored at a site selected for Fort Astoria. Over the following weeks, the crew and company personnel unloaded supplies and began construction of the trading post. The Tonquin departed in June 1811 for a trading voyage to Vancouver Island, where she was attacked and destroyed.',
 'sha256_voy_tonquin_001',
 '{"type": "voyage", "ship_name": "Tonquin", "captain": "Jonathan Thorn", "departure_port": "New York", "arrival_port": "Columbia River / Fort Astoria", "departure_date": "1810-09-08", "arrival_date": "1811-03-22", "cargo": "supplies, trade goods, personnel", "crew_count": 33}'::jsonb),

('Voyage: USS Peacock — Final Expedition to Columbia River (1841)',
 'Astoria Maritime Archive',
 'text',
 'The USS Peacock, under the command of Lieutenant William Hudson as part of the United States Exploring Expedition, arrived off the Columbia River bar on July 17, 1841. Her mission was to survey the river and establish contact with American settlers in the Oregon Country. On July 18, with the bar pilot''s guidance, the Peacock attempted to enter the river through the main channel south of Cape Disappointment. The vessel struck a shoal and was immediately caught by the powerful current and breaking surf. Despite anchoring and attempting to kedge off, the Peacock was driven further onto the sands. By evening, the ship was listing heavily and taking on water. Over the next two days, the crew systematically abandoned ship, ferrying men, instruments, and records to shore in ship''s boats. All 150 crew and officers were saved, along with many of the expedition''s scientific collections. The Peacock broke apart within a week. The area of the wreck has been known as Peacock Spit on nautical charts ever since.',
 'sha256_voy_peacock_001',
 '{"type": "voyage", "ship_name": "USS Peacock", "captain": "William Hudson", "departure_port": "Pacific Survey", "arrival_port": "Columbia River bar", "arrival_date": "1841-07-17", "cargo": "scientific instruments, survey equipment", "crew_count": 150}'::jsonb),

('Voyage: Great Republic — San Francisco to Portland via Astoria (1870)',
 'Astoria Maritime Archive',
 'text',
 'The Great Republic departed San Francisco on March 15, 1870, on her regular coastal run to Portland, Oregon. The sidewheel steamer carried 387 passengers, including families of settlers bound for the Willamette Valley, miners heading to newly discovered gold deposits in eastern Oregon, and general travelers. The cargo manifest listed 220 tons of merchandise, mining equipment, household goods, and mail. After a 36-hour coastal passage, the vessel arrived at the Columbia River bar on March 17. The bar crossing was routine under clear skies and moderate swells, guided by pilot Captain George Flavel. The Great Republic stopped at Astoria to discharge 45 passengers and 30 tons of freight before continuing upriver. The journey from Astoria to Portland took an additional 8 hours against the current. Passengers noted the dense forests along the riverbanks and the snow-capped peak of Mount Hood visible in the distance. The vessel docked at Portland''s waterfront at approximately 6 PM on March 17, 1870.',
 'sha256_voy_greatrep_001',
 '{"type": "voyage", "ship_name": "Great Republic", "captain": "unnamed", "departure_port": "San Francisco", "arrival_port": "Portland", "departure_date": "1870-03-15", "arrival_date": "1870-03-17", "cargo": "merchandise, mining equipment, household goods, mail", "crew_count": 85}'::jsonb),

('Voyage: Peter Iredale — Salinas Cruz to Portland (1906)',
 'Astoria Maritime Archive',
 'text',
 'The four-masted bark Peter Iredale departed Salinas Cruz, Mexico on September 26, 1906, in ballast, bound for Portland, Oregon, where she was to load a cargo of wheat for the European market. Under the command of Captain H. Lawrence with a crew of 25, the vessel made good time northward along the coast. On October 25, 1906, as the Peter Iredale approached the mouth of the Columbia River, she encountered dense fog and a strong southerly wind. The vessel was driven off course and struck the beach at Clatsop Spit, approximately two miles south of the south jetty. The impact was gentle enough that no crew members were injured. Captain Lawrence immediately ordered the anchors dropped and signaled for assistance, but the rising tide and shifting sands made salvage impossible. The crew was evacuated safely by the U.S. Life-Saving Service. The Peter Iredale was declared a total loss. Captain Lawrence, upon viewing his stranded ship, reportedly said, "May God bless you, and may your bones bleach in the sands."',
 'sha256_voy_piredale_001',
 '{"type": "voyage", "ship_name": "Peter Iredale", "captain": "H. Lawrence", "departure_port": "Salinas Cruz, Mexico", "arrival_port": "Clatsop Beach (wrecked)", "departure_date": "1906-09-26", "arrival_date": "1906-10-25", "cargo": "in ballast", "crew_count": 25}'::jsonb),

('Voyage: Rosecrans — San Francisco to Portland (1913, final voyage)',
 'Astoria Maritime Archive',
 'text',
 'The steam schooner Rosecrans departed San Francisco on January 5, 1913, loaded with a full cargo of fuel oil destined for Portland, Oregon. The vessel carried a crew of 36 under the command of Captain L.F. Johnson. The Rosecrans encountered increasingly severe weather as she steamed northward along the coast. By January 7, a powerful winter storm had developed, with gale-force winds and heavy seas. Despite the storm, the Rosecrans attempted to cross the Columbia River bar. A bar pilot was embarked, but visibility was near zero in the driving rain and spray. At approximately 5:30 AM, the vessel struck Peacock Spit — the same treacherous shoal where the USS Peacock had been lost 72 years earlier. The Rosecrans immediately began breaking up in the tremendous surf. The crew had little time to react. Only two men survived, clinging to wreckage until they were rescued by the Point Adams Life-Saving Station crew. The 34 lives lost made it one of the worst disasters in the history of the Columbia River bar.',
 'sha256_voy_rosecrans_001',
 '{"type": "voyage", "ship_name": "Rosecrans", "captain": "L.F. Johnson", "departure_port": "San Francisco", "arrival_port": "Columbia River bar (wrecked)", "departure_date": "1913-01-05", "arrival_date": "1913-01-07", "cargo": "fuel oil", "crew_count": 36}'::jsonb),

('Voyage: SS Beaver — London to Fort Vancouver (1835-1836)',
 'Astoria Maritime Archive',
 'text',
 'The SS Beaver departed London on August 29, 1835, under sail, bound for the Columbia River and Fort Vancouver via Cape Horn. Her paddle wheel machinery was stowed aboard for installation upon arrival. The Beaver was the first steamship sent to the Pacific Northwest, commissioned by the Hudson''s Bay Company to modernize their coastal trading operations. The voyage took seven months, arriving at Fort Vancouver on April 10, 1836. The ship was greeted with great excitement by the fort''s inhabitants, as she represented a dramatic technological advancement over the sailing vessels that had previously served the fur trade. The Beaver''s side paddle wheels were installed at Fort Vancouver over the next several weeks. Her first steam-powered voyage was a short trip on the Columbia River in June 1836, marking a new era of steam navigation in the Pacific Northwest. The Governor of the Hudson''s Bay Company, George Simpson, noted that the Beaver would "revolutionize our communications along the coast."',
 'sha256_voy_beaver_001',
 '{"type": "voyage", "ship_name": "SS Beaver", "captain": "David Home", "departure_port": "London", "arrival_port": "Fort Vancouver", "departure_date": "1835-08-29", "arrival_date": "1836-04-10", "cargo": "trade goods, paddle wheel machinery, supplies", "crew_count": 31}'::jsonb),

('Voyage: Oriole — Astoria to San Francisco Lumber Run (1858)',
 'Astoria Maritime Archive',
 'text',
 'The bark Oriole departed Astoria, Oregon on June 12, 1858, carrying a full cargo of 310,000 board feet of Douglas fir lumber loaded at the Clatsop Mill on the south bank of the Columbia River. Under Captain J.W. Mitchell, the vessel crossed the Columbia River bar on the morning tide without incident and set course south for San Francisco. The passage took eleven days, with the Oriole arriving at San Francisco Bay on June 23, 1858. The lumber cargo was consigned to the firm of Pope & Talbot, who supplied the booming construction market in San Francisco. At the prevailing rate of $16 per thousand board feet, the cargo was valued at approximately $4,960 — a substantial sum for the period. After discharging her cargo, the Oriole loaded general merchandise and hardware for the return trip to Astoria, departing San Francisco on July 5 and arriving back at Astoria on July 14, 1858. This round trip was typical of the regular coastwise lumber trade that sustained the economy of the lower Columbia River region.',
 'sha256_voy_oriole_001',
 '{"type": "voyage", "ship_name": "Oriole", "captain": "J.W. Mitchell", "departure_port": "Astoria", "arrival_port": "San Francisco", "departure_date": "1858-06-12", "arrival_date": "1858-06-23", "cargo": "310,000 board feet Douglas fir lumber", "crew_count": 14}'::jsonb);


-- ============================================================
-- Ports
-- ============================================================

INSERT INTO documents (title, archive_name, content_type, raw_content, checksum, metadata) VALUES

('Port Profile: Astoria, Oregon',
 'Astoria Maritime Archive',
 'text',
 'Astoria, Oregon, situated at the mouth of the Columbia River, is the oldest American settlement west of the Rocky Mountains. Founded as Fort Astoria in 1811 by John Jacob Astor''s Pacific Fur Company, the town grew into a major port serving the Pacific Northwest lumber, salmon, and fur trades. Astoria''s deepwater harbor provided sheltered anchorage for vessels of all sizes, though ships first had to navigate the treacherous Columbia River bar to reach it. By the 1870s, Astoria was the second-largest city in Oregon, with a thriving commercial fishing industry that would eventually make it the "Salmon Canning Capital of the World." The port''s customs house processed hundreds of vessels annually, recording cargoes of lumber, grain, canned salmon, and general merchandise. Astoria also served as the primary pilot station for Columbia River navigation — licensed bar pilots would board incoming ships at the river mouth to guide them safely across the bar and upriver to Portland. The town''s waterfront featured wharves, warehouses, ship chandlers, boarding houses, and the offices of major shipping companies.',
 'sha256_port_astoria_001',
 '{"type": "port", "port_name": "Astoria", "state": "Oregon", "river": "Columbia River", "founded": 1811, "latitude": 46.1879, "longitude": -123.8313}'::jsonb),

('Port Profile: Portland, Oregon',
 'Astoria Maritime Archive',
 'text',
 'Portland, Oregon, located 110 miles upriver from the Columbia River''s mouth at the confluence of the Willamette and Columbia rivers, developed as the commercial hub of the Pacific Northwest during the mid-19th century. Founded in 1845, Portland''s location at the head of deep-water navigation on the Willamette River made it the natural transshipment point between ocean-going vessels and the agricultural hinterland of the Willamette Valley. By the 1860s, Portland''s waterfront stretched for over a mile along the west bank of the Willamette, handling exports of wheat, flour, lumber, and wool. The city became the primary grain port of the Pacific Northwest, with large sailing vessels loading wheat for Liverpool, Hong Kong, and other world markets. Steamships connected Portland to San Francisco on a regular schedule, while river steamers served communities along the Columbia and Willamette rivers. Portland''s harbor was managed by a port commission established in 1891, which oversaw dredging, wharf construction, and pilotage services. The port was a critical link in the Pacific Northwest''s connection to global trade networks.',
 'sha256_port_portland_001',
 '{"type": "port", "port_name": "Portland", "state": "Oregon", "river": "Willamette River / Columbia River", "founded": 1845, "latitude": 45.5152, "longitude": -122.6784}'::jsonb),

('Port Profile: San Francisco, California',
 'Astoria Maritime Archive',
 'text',
 'San Francisco served as the dominant port of the American Pacific coast from the Gold Rush of 1849 through the end of the 19th century. Its natural deep-water harbor, protected by the narrow Golden Gate strait, could accommodate hundreds of vessels simultaneously. For Columbia River shipping, San Francisco was the primary commercial partner — lumber, salmon, and grain shipped south from Astoria and Portland, while manufactured goods, mining supplies, and passengers traveled north. Regular steamship service connected San Francisco to Astoria and Portland beginning in the 1860s, with vessels of the Oregon Steam Navigation Company, North Pacific Transportation Company, and later the Oregon Railway and Navigation Company maintaining scheduled runs. San Francisco''s role as the Pacific coast''s financial and mercantile center meant that most shipping insurance, cargo brokering, and vessel chartering for the Pacific Northwest trade was conducted through San Francisco firms. The city''s Merchants Exchange tracked vessel arrivals and departures along the entire Pacific coast.',
 'sha256_port_sf_001',
 '{"type": "port", "port_name": "San Francisco", "state": "California", "founded": 1776, "latitude": 37.7749, "longitude": -122.4194}'::jsonb),

('Port Profile: Fort Vancouver, Washington',
 'Astoria Maritime Archive',
 'text',
 'Fort Vancouver, located on the north bank of the Columbia River approximately 100 miles upstream from the Pacific Ocean, served as the headquarters of the Hudson''s Bay Company''s Columbia District from 1825 to 1860. Established by Chief Factor John McLoughlin, the fort was the most important trading post in the Pacific Northwest, managing a vast network of fur trading operations extending from Alaska to California and from the coast to the Rocky Mountains. The fort''s waterfront included a wharf capable of handling ocean-going vessels, warehouses for furs and trade goods, and workshops for ship repair. Annual supply ships from London brought manufactured goods and provisions, returning laden with furs destined for the European market. After the Oregon Treaty of 1846 established the 49th parallel as the international boundary, Fort Vancouver came under American jurisdiction. The U.S. Army established a military post at the site in 1849. The Hudson''s Bay Company gradually relocated operations to Fort Victoria on Vancouver Island. The Columbia River at Fort Vancouver was deep enough for sailing vessels of up to 600 tons draft.',
 'sha256_port_ftvancouver_001',
 '{"type": "port", "port_name": "Fort Vancouver", "state": "Washington", "river": "Columbia River", "founded": 1825, "latitude": 45.6261, "longitude": -122.6562}'::jsonb),

('Port Profile: Cape Disappointment and the Columbia River Bar',
 'Astoria Maritime Archive',
 'text',
 'Cape Disappointment, at the northern headland of the Columbia River entrance, is the site of one of the most dangerous navigational passages in the world — the Columbia River bar. Where the powerful outflow of the Columbia meets the Pacific Ocean swells, constantly shifting sandbars create unpredictable channels and violent breakers. The bar has claimed over 2,000 vessels and approximately 700 lives since recordkeeping began. Cape Disappointment Light, first lit in 1856, was one of the first lighthouses on the Pacific coast, built to help guide vessels across the bar. The U.S. Life-Saving Service established a station at Cape Disappointment in 1877, and the station''s crews became legendary for their bravery in rescuing shipwreck survivors. The construction of the South Jetty (1885-1895) and North Jetty (1913-1917) attempted to stabilize the bar channel, with mixed results. A bar pilot station was established at Astoria, staffed by pilots who boarded incoming vessels to guide them across. Despite all improvements, the Columbia River bar remains one of the most challenging navigational passages in the world, earning its enduring nickname: the "Graveyard of the Pacific."',
 'sha256_port_capedisapp_001',
 '{"type": "port", "port_name": "Cape Disappointment", "state": "Washington", "river": "Columbia River", "latitude": 46.2758, "longitude": -124.0522}'::jsonb);
