"""
Astoria v2 — LLM router service.

Classifies query complexity and routes to the appropriate model:
  SIMPLE  → Gemini 2.0 Flash  (fast SQL generation, factual lookups)
  COMPLEX → Claude Sonnet      (multi-step research, analysis)
  RESEARCH → Groq / Llama 3.3  (narrative synthesis with citations)
"""

import structlog
import anthropic
import google.generativeai as genai
from groq import Groq

from app.core.config import get_settings
from app.models.schemas import QueryComplexity

logger = structlog.get_logger()

# Lazy-initialized clients
_gemini_configured = False
_anthropic_client: anthropic.Anthropic | None = None
_groq_client: Groq | None = None


def _ensure_gemini() -> None:
    """Configure Gemini API (idempotent)."""
    global _gemini_configured
    if not _gemini_configured:
        settings = get_settings()
        genai.configure(api_key=settings.google_api_key)
        _gemini_configured = True


def _ensure_anthropic() -> anthropic.Anthropic:
    """Get or create the Anthropic client."""
    global _anthropic_client
    if _anthropic_client is None:
        settings = get_settings()
        _anthropic_client = anthropic.Anthropic(api_key=settings.anthropic_api_key)
    return _anthropic_client


def _ensure_groq() -> Groq:
    """Get or create the Groq client."""
    global _groq_client
    if _groq_client is None:
        settings = get_settings()
        _groq_client = Groq(api_key=settings.groq_api_key)
    return _groq_client


# ── Query Classification ──────────────────────────────────────

CLASSIFIER_PROMPT = """You are a query classifier for a maritime history research database.
Classify the user's question into exactly one category:

SIMPLE — Can be answered with a direct SQL query or factual lookup.
Examples: "How many ships were registered in New York?", "List voyages in 1850",
"What was the tonnage of the SS Atlantic?"

COMPLEX — Requires combining multiple data points, comparison, or pattern analysis.
Examples: "Compare trade routes between Boston and Philadelphia in the 1840s",
"What patterns emerge in ship losses during winter months?"

RESEARCH — Asks for narrative explanation, historical context, or synthesis.
Examples: "Explain the significance of clipper ships in the 1850s trade",
"Write a summary of maritime activity in the Port of Astoria"

Respond with ONLY the word: SIMPLE, COMPLEX, or RESEARCH"""


def classify_query(question: str) -> QueryComplexity:
    """Classify a user question by complexity using Gemini Flash (fast + cheap)."""
    _ensure_gemini()
    settings = get_settings()

    try:
        model = genai.GenerativeModel(settings.llm_sql_model)
        response = model.generate_content(
            [CLASSIFIER_PROMPT, f"\nUser question: {question}\n\nClassification:"],
            generation_config=genai.GenerationConfig(
                max_output_tokens=10,
                temperature=0.0,
            ),
        )
        raw = response.text.strip().upper()

        if "COMPLEX" in raw:
            return QueryComplexity.COMPLEX
        elif "RESEARCH" in raw:
            return QueryComplexity.RESEARCH
        else:
            return QueryComplexity.SIMPLE

    except Exception as e:
        logger.warning("classifier_fallback", error=str(e))
        return QueryComplexity.SIMPLE


# ── LLM Completion ─────────────────────────────────────────────

def call_gemini(system_prompt: str, user_prompt: str) -> str:
    """Call Gemini Flash for SQL generation and simple factual queries."""
    _ensure_gemini()
    settings = get_settings()

    model = genai.GenerativeModel(
        settings.llm_sql_model,
        system_instruction=system_prompt,
    )
    response = model.generate_content(
        user_prompt,
        generation_config=genai.GenerationConfig(
            max_output_tokens=2000,
            temperature=0.1,
        ),
    )
    return response.text


def call_claude(system_prompt: str, user_prompt: str) -> str:
    """Call Claude Sonnet for complex research and analysis."""
    client = _ensure_anthropic()
    settings = get_settings()

    response = client.messages.create(
        model=settings.llm_research_model,
        max_tokens=4000,
        system=system_prompt,
        messages=[{"role": "user", "content": user_prompt}],
        temperature=0.3,
    )
    return response.content[0].text


def call_groq(system_prompt: str, user_prompt: str) -> str:
    """Call Groq / Llama for narrative synthesis."""
    client = _ensure_groq()
    settings = get_settings()

    response = client.chat.completions.create(
        model=settings.llm_narrative_model,
        messages=[
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": user_prompt},
        ],
        max_tokens=4000,
        temperature=0.4,
    )
    return response.choices[0].message.content


def generate_answer(
    complexity: QueryComplexity,
    system_prompt: str,
    user_prompt: str,
) -> tuple[str, str]:
    """Route to the right LLM based on complexity.

    Returns (answer_text, model_name).
    """
    settings = get_settings()

    if complexity == QueryComplexity.SIMPLE:
        answer = call_gemini(system_prompt, user_prompt)
        return answer, settings.llm_sql_model

    elif complexity == QueryComplexity.COMPLEX:
        answer = call_claude(system_prompt, user_prompt)
        return answer, settings.llm_research_model

    else:  # RESEARCH
        answer = call_groq(system_prompt, user_prompt)
        return answer, settings.llm_narrative_model
