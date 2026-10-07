"""Hermes plugin generated from the shared agent skill pack."""

from pathlib import Path


def register(ctx):
    base_dir = Path(__file__).parent
    # Hermes exposes these as namespaced skills, e.g. plugin-name:skill-name.
    ctx.register_skill('skill-director', base_dir / 'skills' / 'skill-director' / 'SKILL.md')
    ctx.register_skill('it-owner', base_dir / 'skills' / 'it-owner' / 'SKILL.md')
