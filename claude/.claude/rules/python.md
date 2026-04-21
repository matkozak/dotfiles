---
paths:
  - "**/*.py"
---

## Python

### Tooling

- global `pip install` is disabled, always have a `.venv`
- always use `uv` to manage environment: `uv add`, `uv run`, etc.
- `uv pip install` if you must, for ephemeral dependencies which don't deserve
  `uv add`

### Type annotations

Annotate everything. Prefer modern idioms (`int | None`, not `Optional[int]`),
but don't sweat it. The linter will take care of it.

### Docstrings

Keep them concise:

- one liners are fine
- multiline numpy style when warranted
- no types in docstrings (static type annotations are the source of truth)

### Formatting

Handled by `ruff` via hooks. Don't worry about it.

One caveat though: if you add an import without using it, don't be surprised if
the `isort` linter gets rid of it.

### Verification

Type checking is love, type checking is life.

Hooks should enforce type checking with `pyright`. For everyone's benefit,
always make sure the types are actually correct.
