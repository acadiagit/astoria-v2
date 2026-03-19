"""
# File: backend/app/services/web_scraper.py
# Astoria v2 — Maine maritime history web scraper.
# Targets known historical sources for Blue Hill, Sullivan,
# Milbridge, and Machias, Maine.
# All config sourced from app.core.config (get_settings).
"""

import structlog
from app.services.loader_agent import load_document

logger = structlog.get_logger()

# --- Known historical sources by town ---
TOWN_SOURCES = {
    "Blue Hill": [
        "https://en.wikipedia.org/wiki/Blue_Hill,_Maine",
        "https://www.mainememory.net/sitebuilder/site/895/page/1302/display",
    ],
    "Sullivan": [
        "https://en.wikipedia.org/wiki/Sullivan,_Maine",
        "https://www.mainememory.net/sitebuilder/site/895/page/1302/display",
    ],
    "Milbridge": [
        "https://en.wikipedia.org/wiki/Milbridge,_Maine",
    ],
    "Machias": [
        "https://en.wikipedia.org/wiki/Machias,_Maine",
        "https://www.mainememory.net/sitebuilder/site/895/page/1302/display",
    ],
}


def scrape_town(town: str, loaded_by: str = None) -> dict:
    """
    Scrape all known sources for a given town.

    Returns:
        dict with total docs loaded, chunks created, errors
    """
    sources = TOWN_SOURCES.get(town)
    if not sources:
        return {"status": "error", "message": f"Unknown town: {town}"}

    results = {
        "town": town,
        "sources_attempted": len(sources),
        "docs_loaded": 0,
        "chunks_created": 0,
        "duplicates": 0,
        "errors": [],
    }

    for url in sources:
        try:
            logger.info("scraping_url", town=town, url=url)
            result = load_document(
                source=url,
                town=town,
                archive_name="Web Archive",
                loaded_by=loaded_by,
            )
            if result["status"] == "success":
                results["docs_loaded"] += 1
                results["chunks_created"] += result["chunks_created"]
            elif result["status"] == "duplicate":
                results["duplicates"] += 1
        except Exception as e:
            logger.error("scrape_error", town=town, url=url, error=str(e))
            results["errors"].append(f"{url}: {str(e)}")

    results["status"] = "completed"
    return results


def scrape_all_towns(loaded_by: str = None) -> dict:
    """Scrape all four Maine towns."""
    all_results = {}
    for town in TOWN_SOURCES:
        logger.info("scraping_town", town=town)
        all_results[town] = scrape_town(town, loaded_by=loaded_by)
    return all_results
# end web_scraper.py
