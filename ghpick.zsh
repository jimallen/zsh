# Optionally list extra orgs you want included (space-separated)
# export GH_EXTRA_ORGS="kartenmacherei another-org"
ghpick() {
  local me
  me=$(gh api user -q .login)

  # put each owner explicitly into an array
  local owners=(
    "$me"
    "kartenmacherei"
    "celebrate-company"
  )

  # Add extra orgs from environment variable if set
  if [[ -n "$GH_EXTRA_ORGS" ]]; then
    for org in ${=GH_EXTRA_ORGS}; do
      owners+=("$org")
    done
  fi

  # Collect all repos into a single stream
  local selected
  selected=$({
    for o in "${owners[@]}"; do
      gh repo list "$o" --limit 100 \
        --json nameWithOwner,description,isPrivate,pushedAt \
        --jq '.[] | [.nameWithOwner, (.description // "No description"), (if .isPrivate then "🔒" else "📂" end), .pushedAt] | @tsv' \
      2>/dev/null
    done
  } | fzf \
      --ansi \
      --delimiter=$'\t' \
      --preview='gh repo view {1}' \
      --preview-window=right:60%:wrap \
      --header='Select a repository (Tab to select multiple, Enter to clone/open)' \
      --with-nth=1,2,3 \
      --tabstop=2 \
    | cut -f1)

  # If a repo was selected, offer to clone or open it
  if [[ -n "$selected" ]]; then
    echo "Selected: $selected"
    echo -n "Action: [c]lone, [o]pen in browser, [v]iew, or [q]uit? "
    read -r action
    case "$action" in
      c)
        gh repo clone "$selected"
        ;;
      o)
        gh repo view "$selected" --web
        ;;
      v)
        gh repo view "$selected"
        ;;
      *)
        echo "Cancelled"
        ;;
    esac
  fi
}
