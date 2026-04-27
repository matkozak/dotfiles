#!/bin/sh
input=$(cat)

# --- git + folder context ---
cwd=$(echo "$input" | jq -r '.cwd // .workspace.current_dir // empty')
folder=$(basename "$cwd")
branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null)
dirty=$(git -C "$cwd" status --porcelain 2>/dev/null)
git_part=""
if [ -n "$branch" ]; then
    [ -n "$dirty" ] && branch="${branch}*"
    git_part="${branch} ${folder} | "
else
    git_part="${folder} | "
fi

# --- model ---
model=$(echo "$input" | jq -r '.model.display_name')

# --- context window ---
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
ctx_part=""
[ -n "$used" ] && ctx_part=$(printf " | ctx %.0f%%" "$used")

# --- rate limits ---
rate_part=""
five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_resets=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
if [ -n "$five_pct" ] && [ -n "$five_resets" ]; then
    resets_hhmm=$(date -d "@$five_resets" +%H:%M 2>/dev/null || date -r "$five_resets" +%H:%M 2>/dev/null)
    rate_part=$(printf " | 5h: %.0f%% (resets %s)" "$five_pct" "$resets_hhmm")
fi

# --- token counts ---
in_tok=$(echo "$input" | jq -r '.context_window.total_input_tokens')
out_tok=$(echo "$input" | jq -r '.context_window.total_output_tokens')
tok_part=$(printf " | in %s out %s" "$in_tok" "$out_tok")

printf "%s%s%s%s%s" "$git_part" "$model" "$ctx_part" "$rate_part" "$tok_part"
