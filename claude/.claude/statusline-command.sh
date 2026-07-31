#!/bin/sh
input=$(cat)

# --- colors (16-color ANSI, follows terminal theme) ---
esc=$(printf '\033')
c_git="${esc}[92m"
c_model="${esc}[95m"
c_ctx="${esc}[96m"
c_rate="${esc}[93m"
c_off="${esc}[0m"

# --- git + folder context ---
cwd=$(echo "$input" | jq -r '.cwd // .workspace.current_dir // empty')
folder=$(basename "$cwd")
branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null)
dirty=$(git -C "$cwd" status --porcelain 2>/dev/null)
git_part=""
if [ -n "$branch" ]; then
    [ -n "$dirty" ] && branch="${branch}*"
    git_part="${c_git}${branch} ${folder}${c_off} | "
else
    git_part="${c_git}${folder}${c_off} | "
fi

# --- model + effort ---
model=$(echo "$input" | jq -r '.model.display_name')
effort=$(echo "$input" | jq -r '.effort.level // empty')
[ -n "$effort" ] && model="${model} (${effort})"
model_part="${c_model}${model}${c_off}"

# --- context window ---
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
ctx_part=""
[ -n "$used" ] && ctx_part=$(printf " | %sctx %.0f%%%s" "$c_ctx" "$used" "$c_off")

# --- rate limits ---
rate_part=""
five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_resets=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
if [ -n "$five_pct" ] && [ -n "$five_resets" ]; then
    resets_hhmm=$(date -d "@$five_resets" +%H:%M 2>/dev/null || date -r "$five_resets" +%H:%M 2>/dev/null)
    rate_part=$(printf " | %s5h: %.0f%% (resets %s)%s" "$c_rate" "$five_pct" "$resets_hhmm" "$c_off")
fi

seven_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
if [ -n "$seven_pct" ]; then
    rate_part="${rate_part}$(printf " | %s7d: %.0f%%%s" "$c_rate" "$seven_pct" "$c_off")"
fi

printf "%s%s%s%s" "$git_part" "$model_part" "$ctx_part" "$rate_part"
