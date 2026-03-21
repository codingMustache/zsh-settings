_command_time_preexec() {
  # check excluded
  if [ -n "$ZSH_COMMAND_TIME_EXCLUDE" ]; then
    cmd="$1"
    for exc ($ZSH_COMMAND_TIME_EXCLUDE) do;
      if grep -qF "$exc" <<< "$cmd"; then
        # echo "command excluded: $exc"
        return
      fi
    done
  fi

  # Check if EPOCHREALTIME is available for millisecond precision
  if [[ -n "$EPOCHREALTIME" ]]; then
    _command_time_timer=${timer:-$EPOCHREALTIME}
    export ZSH_COMMAND_TIME_HAS_MILLISECONDS="true"
  else
    _command_time_timer=${timer:-$SECONDS}
    export ZSH_COMMAND_TIME_HAS_MILLISECONDS="false"
  fi
  ZSH_COMMAND_TIME_MSG=${ZSH_COMMAND_TIME_MSG-"Time: %s"}
  ZSH_COMMAND_TIME_COLOR=${ZSH_COMMAND_TIME_COLOR-"white"}
  ZSH_COMMAND_TIME_NO_COLOR=${ZSH_COMMAND_TIME_NO_COLOR-""}
  export ZSH_COMMAND_TIME=""
}

_command_time_precmd() {
  local -F timer_show
  if [ $_command_time_timer ]; then
    if [[ "$ZSH_COMMAND_TIME_HAS_MILLISECONDS" == "true" ]]; then
      timer_show=$((EPOCHREALTIME - $_command_time_timer))
      # Ensure ZSH_COMMAND_TIME_MIN_SECONDS is treated as a float for comparison
      local -F min_threshold=${ZSH_COMMAND_TIME_MIN_SECONDS:-0.0} # Default to 0.0s for float
    else
      timer_show=$(($SECONDS - $_command_time_timer))
      local min_threshold=${ZSH_COMMAND_TIME_MIN_SECONDS:-0} # Default to 0s for integer
    fi

    if [ -n "$TTY" ] && (( timer_show >= min_threshold )); then
      export ZSH_COMMAND_TIME="$timer_show"
      if [ ! -z ${ZSH_COMMAND_TIME_MSG} ]; then
        zsh_command_time
      fi
    fi
    unset _command_time_timer
  fi
}

zsh_command_time() {
  local days hours min sec sec_fmt timer_show color
  if [ -n "$ZSH_COMMAND_TIME" ]; then
    # Round to integers
    typeset -i days=$(( ${ZSH_COMMAND_TIME} / 86400 ))
    typeset -i hours=$(( ${ZSH_COMMAND_TIME} / 3600 % 24 ))
    typeset -i min=$(( ${ZSH_COMMAND_TIME} / 60 % 60 ))
    typeset -i total_sec=$(( ${ZSH_COMMAND_TIME} ))
    sec=$(( ZSH_COMMAND_TIME % 60 ))
    sec_fmt=$(printf '%d' "$sec")s
    color="$ZSH_COMMAND_TIME_COLOR"
    if [[ "$ZSH_COMMAND_TIME" == *.* ]]; then
      # If SECONDS is a float, we limit the precision to 2 decimal places
      sec_fmt=$(printf '%02.2f' "$sec")
    fi
    if [[ "$total_sec" -lt 60 ]]; then # less than 1 minute
        timer_show="${sec_fmt}s"
    elif [[ "$total_sec" -lt 3600 ]]; then  # less than 1 hour
        timer_show="${min}m ${sec_fmt}s"
    elif [[ "$days" -eq 0 ]]; then  # less than 1 day
        timer_show="${hours}h ${min}m ${sec_fmt}s"
    else # 1 day or more
        timer_show="${days}d ${hours}h ${min}m ${sec_fmt}s"
    fi
    if [ -n "$ZSH_COMMAND_TIME_NO_COLOR" ]; then
      color="$ZSH_COMMAND_TIME_COLOR"
    else
        if [[ "$total_sec" -lt ${ZSH_COMMAND_TIME_SECONDS_GREEN:-60} ]]; then
            color="green"
        elif [[ "$total_sec" -lt ${ZSH_COMMAND_TIME_SECONDS_YELLOW:-180} ]]; then
            color="yellow"
        else
            color="red"
        fi
    fi
    print -P "%F{$ZSH_COMMAND_TIME_COLOR}$(printf "${ZSH_COMMAND_TIME_MSG}" "%F{$color}$timer_show")%f"
  fi
}

precmd_functions+=(_command_time_precmd)
preexec_functions+=(_command_time_preexec)
