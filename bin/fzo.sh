#!/usr/bin/env bash
set -euo pipefail

local flag="${1-}"

local usage_msg="usage: fzo [-a|-e]"

case "$flag" in
    # Open with the system default application
    "")
        local file
        file=$(fzf) || return
        if [[ "$(uname -s)" == "Darwin" ]]; then
            open -- "$file"
        elif command -v xdg-open >/dev/null 2>&1; then
            xdg-open "$file"
        elif command -v gio >/dev/null 2>&1; then
            gio open "$file"
        else
            printf 'ERROR: fzo: no file opener found\n' >&2
            return 1
        fi
        ;;

    # Choose a GUI application from .desktop files
    "-a")
        local file
        file=$(fzf) || return

        # Mac
        if [[ "$(uname -s)" == "Darwin" ]]; then
            local app=$(
                find /Applications "$HOME/Applications" \
                    -type d \
                    -name '*.app' \
                    -print 2>/dev/null |
                sed 's#^.*/##; s/\.app$//' |
                sort -u |
                fzf
            ) || return

            open -a "$app" -- "$file"

        # Linux
        else
            local data_home="${XDG_DATA_HOME:-"$HOME/.local/share"}"
            local data_dirs="${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"

            local dir name try_exec

            local desktop=$(
                {
                    # User applications.
                    if [[ -d "$data_home/applications" ]]; then
                        find "$data_home/applications" \
                            -type f \
                            -name '*.desktop' \
                            -print 2>/dev/null
                    fi

                    # System applications.
                    for dir in ${data_dirs//:/ }; do
                        [[ -d "$dir/applications" ]] || continue

                        find "$dir/applications" \
                            -type f \
                            -name '*.desktop' \
                            -print 2>/dev/null
                    done
                } |
                while IFS= read -r desktop; do
                    # Only ordinary GUI application entries.
                    grep -q '^Type=Application$' "$desktop" || continue

                    # Don't show explicitly hidden applications.
                    grep -q '^Hidden=true$' "$desktop" && continue

                    # Don't show applications intentionally excluded from menus.
                    grep -q '^NoDisplay=true$' "$desktop" && continue

                    name=$(
                        sed -n 's/^Name=\(.*\)$/\1/p' "$desktop" |
                        head -n 1
                    )

                    [[ -n "$name" ]] || continue

                    # If TryExec is present, make sure the executable exists.
                    try_exec=$(
                        sed -n 's/^TryExec=\(.*\)$/\1/p' "$desktop" |
                        head -n 1
                    )

                    if [[ -n "$try_exec" ]]; then
                        if [[ "$try_exec" == */* ]]; then
                            [[ -x "$try_exec" ]] || continue
                        else
                            command -v "$try_exec" >/dev/null 2>&1 || continue
                        fi
                    fi

                    printf '%s\t%s\n' "$name" "$desktop"
                done |
                sort -t $'\t' -k1,1f -u |
                fzf --with-shell='zsh -c' |
                cut -f2-
            ) || return

            [[ -f "$desktop" ]] || return 1

            # Read desktop-entry fields.
            local exec_line=$(
                sed -n 's/^Exec=\(.*\)$/\1/p' "$desktop" |
                head -n 1
            )

            if [[ -z "$exec_line" ]]; then
                printf 'ERROR: fzo: no `Exec=` entry in:\n  %s\n' "$desktop" >&2
                return 1
            fi

            local workdir=$(
                sed -n 's/^Path=\(.*\)$/\1/p' "$desktop" |
                head -n 1
            )

            local name=$(
                sed -n 's/^Name=\(.*\)$/\1/p' "$desktop" |
                head -n 1
            )

            local icon=$(
                sed -n 's/^Icon=\(.*\)$/\1/p' "$desktop" |
                head -n 1
            )

            # Parse `Exec=` according to desktop-entry quoting rules.
            local argv=()
            local arg=''
            local in_quotes=false
            local escaped=false
            local i c

            for ((i = 0; i < ${#exec_line}; i++)); do
                c="${exec_line:i:1}"

                if [[ "$escaped" == true ]]; then
                    case "$c" in
                        '"'|'`'|'$'|'\'|$'\n')
                            arg+="$c"
                            ;;
                        *)
                            arg+="\\$c"
                            ;;
                    esac

                    escaped=false
                    continue
                fi

                if [[ "$c" == '\' ]]; then
                    escaped=true
                    continue
                fi

                if [[ "$c" == '"' ]]; then
                    if [[ "$in_quotes" == true ]]; then
                        in_quotes=false
                    else
                        in_quotes=true
                    fi
                    continue
                fi

                if [[ "$in_quotes" == false && "$c" == ' ' ]]; then
                    if [[ -n "$arg" ]]; then
                        argv+=("$arg")
                        arg=''
                    fi
                    continue
                fi

                arg+="$c"
            done

            if [[ -n "$arg" ]]; then
                argv+=("$arg")
            fi

            if ((${#argv[@]} == 0)); then
                printf 'ERROR: fzo: could not parse `Exec=` in:\n  %s\n' "$desktop" >&2
                return 1
            fi

            # Expand desktop-entry field codes.
            local expanded=()
            for arg in "${argv[@]}"; do
                case "$arg" in
                    '%f'|'%F'|'%u'|'%U')
                        expanded+=("$file")
                        ;;

                    '%c')
                        expanded+=("$name")
                        ;;

                    '%k')
                        expanded+=("$desktop")
                        ;;

                    '%i')
                        if [[ -n "$icon" ]]; then
                            expanded+=("--icon" "$icon")
                        fi
                        ;;

                    '%%')
                        expanded+=('%')
                        ;;

                    *'%f'*|*'%F'*|*'%u'*|*'%U'*|*'%c'*|*'%k'*|*'%i'*|*'%%'*)
                        printf 'ERROR: fzo: unsupported field-code placement in `Exec=`:\n  %s\n' \
                            "$exec_line" >&2
                        return 1
                        ;;

                    *)
                        expanded+=("$arg")
                        ;;
                esac
            done

            # Launch the application.
            if [[ -n "$workdir" ]]; then
                cd "$workdir" 2>/dev/null || {
                    printf 'ERROR: fzo: cannot `cd` to `Path=` directory:\n  %s\n' "$workdir" >&2
                    exit 1
                }
            fi
            command -- "${expanded[@]}"
         fi
        ;;

    # Choose an arbitrary executable from PATH
    "-e")
        local file
        file=$(fzf) || return

        local app=$(
            {
                IFS=:
                for dir in $PATH; do
                    [[ -d "$dir" ]] || continue

                    for executable in "$dir"/*; do
                        [[ -f "$executable" && -x "$executable" ]] || continue
                        printf '%s\n' "${executable##*/}"
                    done
                done
            } |
            sort -u |
            fzf
        ) || return

        [[ -n "$app" ]] || return 1

        command -- "$app" "$file"
        ;;

    # Unrecognised flag
    *)
        printf 'ERROR: fzo: unrecognised flag "%s"\n' "$flag" >&2
        printf '%s\n' "$usage_msg" >&2
        return 1
        ;;
esac

