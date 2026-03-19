"""
# File: backend/app/services/document_parser.py
# Astoria v2 — Document parsing service.
# Handles PDF, DOCX, TXT, and URL content extraction.
# All config sourced from app.core.config (get_settings).
"""

import hashlib
import httpx
from pathlib import Path
from app.core.config import get_settings
import structlog

logger = structlog.get_logger()


def _checksum(text: str) -> str:
    """SHA-256 checksum for deduplication."""
    return hashlib.sha256(text.encode()).hexdigest()


def parse_txt(path: str) -> dict:
    """Parse plain text file."""
    content = Path(path).read_text(encoding="utf-8", errors="ignore")
    return {
        "title": Path(path).name,
        "content": content,
        "content_type": "text",
        "checksum": _checksum(content),
    }


def parse_pdf(path: str) -> dict:
    """Parse PDF file using PyMuPDF."""
    import fitz
    doc = fitz.open(path)
    content = "\n".join(page.get_text() for page in doc)
    doc.close()
    return {
        "title": Path(path).name,
        "content": content,
        "content_type": "pdf",
        "checksum": _checksum(content),
    }


def parse_docx(path: str) -> dict:
    """Parse Word document using python-docx."""
    from docx import Document
    doc = Document(path)
    content = "\n".join(p.text for p in doc.paragraphs if p.text.strip())
    return {
        "title": Path(path).name,
        "content": content,
        "content_type": "docx",
        "checksum": _checksum(content),
    }


def parse_url(url: str) -> dict:
    """Fetch and parse web page content."""
    from bs4 import BeautifulSoup
    response = httpx.get(url, timeout=30, follow_redirects=True)
    response.raise_for_status()
    soup = BeautifulSoup(response.text, "html.parser")
    for tag in soup(["script", "style", "nav", "footer"]):
        tag.decompose()
    title = soup.title.string if soup.title else url
    content = soup.get_text(separator="\n", strip=True)
    return {
        "title": title,
        "content": content,
        "content_type": "html",
        "source_url": url,
        "checksum": _checksum(content),
    }


def parse_document(source: str) -> dict:
    """Auto-detect source type and parse accordingly."""
    if source.startswith("http://") or source.startswith("https://"):
        logger.info("parsing_url", source=source)
        return parse_url(source)
    path = Path(source)
    suffix = path.suffix.lower()
    if suffix == ".pdf":
        logger.info("parsing_pdf", source=source)
        return parse_pdf(source)
    elif suffix == ".docx":
        logger.info("parsing_docx", source=source)
        return parse_docx(source)
    else:
        logger.info("parsing_txt", source=source)
        return parse_txt(source)
# end document_parser.py
