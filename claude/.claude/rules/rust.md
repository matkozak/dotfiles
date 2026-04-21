---
paths:
  - "**/*.rs"
---

## Rust

### Tooling

Standard cargo. `cargo build`, `cargo check`, `cargo test`, `cargo clippy`.

### Formatting

Handled by `rustfmt` via hooks. Don't worry about it.

### Verification

Always run `cargo check` before declaring done — it catches cross-crate and
trait-resolution issues that LSP can miss. Run `cargo test` when you've changed
logic covered by tests. `cargo clippy` is welcome but optional.
