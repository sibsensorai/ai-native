"""Hermes plugin generated from the shared agent skill pack."""

from pathlib import Path


def register(ctx):
    base_dir = Path(__file__).parent
    # Hermes exposes these as namespaced skills, e.g. plugin-name:skill-name.
    ctx.register_skill('sibsensor-kontrol-poruchenii', base_dir / 'skills' / 'sibsensor-kontrol-poruchenii' / 'SKILL.md')
