# Source the command time plugin
# Prevent the plugin from printing the time directly, we will handle formatting in PROMPT
export ZSH_COMMAND_TIME_MSG=""

if [ -f ~/.config/zsh/src/plugins/elasped-time.zsh ]; then
	source ~/.config/zsh/src/plugins/elasped-time.zsh
else
    print "404: not loading plugins"
fi


# ---------------------------
# 🎨 Icons
# ---------------------------
icon_user=""
icon_host=""
icon_dir=""
icon_git=""
icon_time="⏱"
icon_prompt="❯"

# ---------------------------
# 🎨 Prompt Components
# ---------------------------
user="%F{14}${icon_user} %n%f"
host="%F{14}${icon_host} %m%f"
separator="%F{red}@%f"
directory="%F{11}${icon_dir} %2~%f"

# Git format
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats " %F{green}${icon_git} %b%f"
zstyle ':vcs_info:git:*' actionformats " %F{green}${icon_git} %b%f %F{red}(%a)%f"

# ---------------------------
# Hook into precmd for vcs_info
# ---------------------------
_prompt_precmd() {
  vcs_info

  # Format elapsed time similarly to how elasped-time.zsh would
  local timer_show_formatted=""
  if [[ -n "$ZSH_COMMAND_TIME" ]]; then
    local -F total_elapsed_time="$ZSH_COMMAND_TIME" # Use a float variable for the total time
    local days hours min color
    local -F seconds_with_decimals # Variable to hold seconds with decimal places
    local sec_fmt # String for printf output

    typeset -i days=$(( total_elapsed_time / 86400 ))
    typeset -i hours=$(( total_elapsed_time / 3600 % 24 ))
    typeset -i min=$(( total_elapsed_time / 60 % 60 ))
    seconds_with_decimals=$(( total_elapsed_time % 60.0 )) # Calculate seconds with decimals

    # Format seconds with two decimal places if milliseconds are available
    if [[ "$ZSH_COMMAND_TIME_HAS_MILLISECONDS" == "true" ]]; then
      sec_fmt=$(printf '%02.2f' "$seconds_with_decimals")
    else
      # Fallback to integer seconds if no millisecond precision
      sec_fmt=$(printf '%d' "${seconds_with_decimals%.*}")
    fi

    if (( total_elapsed_time < 60.0 )); then # less than 1 minute
        timer_show_formatted="${sec_fmt}s"
    elif (( total_elapsed_time < 3600.0 )); then  # less than 1 hour
        timer_show_formatted="${min}m ${sec_fmt}s"
    elif (( days == 0 )); then  # less than 1 day
        timer_show_formatted="${hours}h ${min}m ${sec_fmt}s"
    else # 1 day or more
        timer_show_formatted="${days}d ${hours}h ${min}m ${sec_fmt}s"
    fi

    # Determine color based on time, using defaults from elasped-time.zsh if not set
    local ZSH_COMMAND_TIME_SECONDS_GREEN=${ZSH_COMMAND_TIME_SECONDS_GREEN:-60}
    local ZSH_COMMAND_TIME_SECONDS_YELLOW=${ZSH_COMMAND_TIME_SECONDS_YELLOW:-180}

    # Use floating point comparison for total_elapsed_time
    if (( total_elapsed_time < ZSH_COMMAND_TIME_SECONDS_GREEN )); then
        color="green"
    elif (( total_elapsed_time < ZSH_COMMAND_TIME_SECONDS_YELLOW )); then
        color="yellow"
    else
        color="red"
    fi
    elapsed=" %F{$color}${icon_time} ${timer_show_formatted}%f"
  else
    elapsed=""
  fi
}
precmd_functions+=(_prompt_precmd)

# ---------------------------
# 💻 Prompt Layout
# ---------------------------
PROMPT='${user}${separator}${host} ${directory}${vcs_info_msg_0_}${elapsed}
%F{red}${icon_prompt}%f '
RPROMPT="%F{224} %* %f"
