# reflex -d none -s -r '.sh' -- bash -c "clear; bash omnicli.sh; echo -e \"\n\n__________________________________\n\"; bash omnicli.sh asdf"

source ./omnicli.sh;

separator="\n__________________________________\n\n";

# ────────────────────────────────────────────────────────────────────────────────

clear;
omnicli

echo -e $separator

omnicli asdf
