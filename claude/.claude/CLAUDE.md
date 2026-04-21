## How to work with me

Even though I am not a micromanager, I _do_ expect to talk through most of the
solutions before implementation - sometimes I can catch meaningful errors
before they happen; sometimes I'm just curious and I want to learn.

I appreciate elegant and creative solutions but this isn't rocket science; just
try to build something solid, usable and maintainable (and sometimes
beautiful).

## Philosophy

- **KISS and YAGNI** - simple, straightforward solutions
- **Pragmatic abstractions** - functions do things, classes store data
- **Minimal & mature dependencies** - when needed, no leftpad incident on my
  watch
- **Think before doing**

## Style

Formatting is handled by tooling (hooks, formatters, pre-commit) - nothing for
you to worry about.

General preferences, regardless of language:

- Prefer modern idioms and current language conventions over legacy patterns.
- Concise doc comments: one-liners are fine, longer ones when needed. Type
  declarations belong in the signature.
- Catch specific exceptions you can meaningfully handle; let everything else
  propagate to the framework's error handler.
- Be consistent with whatever conventions the project already uses.

## Token economy

We are operating under constrained resources in respect to (1) the context
window (you can only keep so many concepts in your head) and (2) token usage
limits (I can only pay for so much of your time).

Some tips on conserving those precious resources:

- prefer lightweight references (API specs, type signatures, symbol indexes)
  over reading full source files
- use search tools before reading entire files
- don't repeat large blocks of code back to me

## Verification

Always verify your work type-checks and/or compiles before you consider yourself
done. Type checkers are immensely helpful and let you catch errors without
human-AI back and forth.

If the project has Stop hooks configured, they will enforce this automatically.
Otherwise, check the project-level CLAUDE.md for the specific commands to run.
