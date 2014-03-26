#
# wally's bashrc
# https://github.com/wallyhall/wallys-bashrc
#
# The MIT License (MIT)
# 
# Copyright (c) 2014 wallyhall
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
###############################################################################
#
# In the name of thanks and references:
#  http://tldp.org/LDP/abs/html/sample-bashrc.html
#  http://linux.die.net/Bash-Beginners-Guide/sect_12_02.html
#  http://www.woodwose.net/thatremindsme
#	/2011/05/forking-parallel-processes-in-bash/
#
#  And a huge thank-you to Chris Long - colleague and friend, for original
#  concept, new ideas, testing and code contributions.
#
###############################################################################
## Return if Bash isn't running interactively. 
[ -z "$PS1" ] && return

###############################################################################
## Define some colours etc

NC='\033[m'  # Color Reset

# ===Normal==         ; ==Bold==             ; ==Background==
  Black='\033[0;30m'  ; BBlack='\033[1;30m'  ; On_Black='\033[40m'
  Red='\033[0;31m'    ; BRed='\033[1;31m'    ; On_Red='\033[41m'
  Green='\033[0;32m'  ; BGreen='\033[1;32m'  ; On_Green='\033[42m'
  Yellow='\033[0;33m' ; BYellow='\033[1;33m' ; On_Yellow='\033[43m'
  Blue='\033[0;34m'   ; BBlue='\033[1;34m'   ; On_Blue='\033[44m'
  Purple='\033[0;35m' ; BPurple='\033[1;35m' ; On_Purple='\033[45m'
  Cyan='\033[0;36m'   ; BCyan='\033[1;36m'   ; On_Cyan='\033[46m'
  White='\033[0;37m'  ; BWhite='\033[1;37m'  ; On_White='\033[47m'

# Default colour mapping
c1=$Cyan
c2=$White
c3=$White
c4=$Red
c5=$BRed
c6=$Green
c7=$BGreen
c8=$Purple
c9=$White

c10=$White
c11=$White
c12=$Purple
c13=$White
c14=$White
c15=$White
c16=$White

c17=$White
c18=$Purple
c19=$Cyan
c20=$White
c21=$White
c22=$White

c23=$Green
c24=$Red

c25=$Purple

b1=$On_Blue

##############################################################################

function err ()
{
	echo -e "$1" 1>&2
}

function wbrc
{
	if [ ! -z $1 ]; then
		case "$1" in
			sb )
				if [ -z $2 ] || [[ ! $2 =~ ^(on|off)$ ]]; then
					err "wbrc sb <on|off>"
				elif [ $2 == 'on' ]; then
					CLOCK_ENABLED=1
					echo "$UPDATER_PID"
					[ ! -z $UPDATER_PID ] && kill -s sigusr2 "$UPDATER_PID"
				else
					CLOCK_ENABLED=0
					[ ! -z $UPDATER_PID ] && kill -s sigusr1 "$UPDATER_PID"
				fi
				;;
		esac
	else
		less <<EOT
	
	wally's bashrc formally welcomes you.
	=====================================

	About
	-----
	wbrc is the result of some patient fiddling by Matthew Hall (wally) and
	Chris Long.
	
	Functionally it adds little, asthetically it adds a splash.
	
	The UI is intended to be responsive to terminal size, maintaining a pretty
	and helpful appearance even when you're tight on space.
	
	
	Alpha warning
	-------------
	PLEASE NOTE:
		The version you're running is deemed alpha.
		There are bugs.  There will be more bugs.  It will act unexpectedly.
	
	It's hoped that you use wbrc - and *enjoy* using it.
	Please feel very welcome in providing comments and patches ...
		https://github.com/wallyhall/wallys-bashrc
	

	Colour configuration
	--------------------
	Configuration of colours etc is welcome via editing ~/.wbrc
	
	Grab the default colour mix from github:
		https://github.com/wallyhall/wallys-bashrc
		
	Then mix and match as you please.  All colours can be changed.
	
	
	Status bar toggling
	-------------------
	The status bar can be toggled.
	
	wbrc sb on	 # enables
	wbrc sb off  # disables
	
	It can be set to default "off" in your .wrbc file.
	Just add "wbrc sb off" to it.

EOT
	fi
}

function UpdateUsers
{
	USERS="$(users)"
	USERS_BRIEF="$(echo "$USERS" | cut -d' ' -f -5)"
	USERS_EXTRA=$(( $(echo "$USERS" | wc -w) - 5 ))
	if [ $USERS_EXTRA -gt 0 ]; then
		USERS_BRIEF="${USERS_BRIEF} (and $USERS_EXTRA others)"
	fi
}

function UpdateLoadAvg
{
	if [ -r "/proc/loadavg" ]; then
		LOAD_AVG=$(cat /proc/loadavg | cut -d' ' -f 2)
	elif [ "$(uname)" == 'Darwin' ]; then
		LOAD_AVG=$(sysctl -n vm.loadavg | cut -d' ' -f 3)
	else
		LOAD_AVG='';
	fi
	
	if [ "$LOAD_AVG" != '' ]; then
		CPU_LOAD=$(bc <<< "scale=4; x = ( $LOAD_AVG / $CPU_COUNT ) * 50; \
scale=0; x/1")
		if [ $CPU_LOAD -le 30 ]; then
			CPU_COLOUR=$Green
			CPU_GRAPH_BAR='_'
		elif [ $CPU_LOAD -le 60 ]; then
			CPU_COLOUR=$Yellow
			CPU_GRAPH_BAR='.'
		else
			CPU_COLOUR=$Red
			CPU_GRAPH_BAR=':'
		fi

		CPU_GRAPH="${CPU_GRAPH:1}${CPU_GRAPH_BAR}"
	fi
}

function UpdateStatus
{
	BLANK_LINE=''
	COLS=$(tput cols)
	I=$COLS
	while [ $I -gt 0 ]; do
		I=$((I - 1))
		BLANK_LINE="${BLANK_LINE} "
	done	
	BLANK_LINE="${b1}${BLANK_LINE}${NC}"
	
	ROW=1
	tput sc
	echo -en "\033[0;0f${BLANK_LINE}"
	echo -en "\033[0;0f${c10}${b1}$(date)  "
	
	[[ $COLS -lt 70 ]] && ROW=$(( $ROW + 1 )) && 
		echo -en "\033[$ROW;0f${BLANK_LINE}\033[$ROW;0f"
	echo -en "${c11}${b1}${USER}${c12}${b1}@${c13}${b1}\
$(hostname -s)  "

	[[ $COLS -lt 110 ]] && ROW=$(( $ROW + 1 )) &&
		echo -en "\033[$ROW;0f${BLANK_LINE}\033[$ROW;0f"
	echo -en "${c14}${b1}CPU: ${CPU_COLOUR}${b1}${CPU_LOAD}% \
[${CPU_GRAPH}]  "

	[[ $COLS -lt 160 ]] && ROW=$(( $ROW + 1 )) && 
		echo -en "\033[$ROW;0f${BLANK_LINE}\033[$ROW;0f"
	echo -en "${c15}${b1}Users: [${c16}${b1}$USERS_BRIEF]"
	echo -en "${NC}"
	tput rc
}

###############################################################################
## Load the .wbrc

CLOCK_ENABLED=1

if [ -r ~/.wbrc ]; then
	if [ $(stat -f'%#p' ~/.wbrc) -ne 0100600 ]; then
		err "\n\n\n** Not loading .wbrc - permissions must be 0600 for security."
	elif [ $(stat -f'%u' ~/.wbrc) -ne $(id -u) ]; then
		err "\n\n\n** Not loading .wbrc - must be owned by your user."
	else
		. ~/.wbrc
	fi
fi

###############################################################################
## Detect number of CPU cores

if [ -r "/proc/cpuinfo" ]; then
	CPU_COUNT=$(grep -c 'processor' /proc/cpuinfo)
elif [ "$(uname)" == 'Darwin' ]; then
	CPU_COUNT=$(sysctl -n machdep.cpu.core_count)
else
	CPU_COUNT=4
fi

CPU_GRAPH='             '
CPU_COLOUR=$Green
CPU_LOAD='0'

###############################################################################
## Hostname, user, ssh connection etc - to make a pretty prompt

if [ "$(whoami)" == "root" ]; then
	PRIV_PROMPT='#'
	PRIV_COLOUR=$c4
	PRIV_BCOLOUR=$c5
else
	PRIV_PROMPT='$'
	PRIV_COLOUR=$c6
	PRIV_BCOLOUR=$c7
fi

if [ -z "${SUDO_USER}" ]; then
	SHELL_USER="\[${PRIV_COLOUR}$(whoami)"
else
	SHELL_USER="\[${c1}${SUDO_USER}\[${c2}[\[${PRIV_COLOUR}$(whoami)\
\[${c3}]"
fi

USER_HOST="$SHELL_USER\[${c8}@\[${PRIV_COLOUR}\h"
if [ ! -z "${SSH_CONNECTION}" ]; then
	USER_HOST="[${USER_HOST}\[${c25}:\[${PRIV_COLOUR}$(echo \
		"$SSH_CONNECTION" | cut -d' ' -f 4)\[${c9}]"
fi

###############################################################################
## Sub-shell
# This sub-shell wakes on interrupts or every second (whichever comes first)
# It's solely responsible for updating CPU graphs, logged on users, etc.
# Every second it redraws the status bar (top of the screen)
# Redrawing of the status bar can be paused using SIGUSR* interrupts.
# Ran as a sub-shell to keep your bash shell free to do more important stuff.
{
	REFRESH=1
	
	trap 'REFRESH=0; UpdateStatus' SIGUSR2
	trap 'REFRESH=1' SIGUSR1

	while [ 1 ]; do
		kill -0 $$
		if [ $? -ne 0 ]; then
			exit
		fi

		# Do slow stuff before starting to draw on the screen.
		UpdateLoadAvg
		UpdateUsers
		
		if [ $REFRESH -eq 0 ]; then
			UpdateStatus
		fi

		# The following is a work-around to let the traps interrupt sleeping.
		#   But also not continue the bigger while[1] loop
		sleep 1 &
		SLEEP_PID=$!
		SLEEPING=0
		while [ $SLEEPING -eq 0 ]; do
			wait $SLEEP_PID
			kill -0 $SLEEP_PID &> /dev/null
			SLEEPING=$?
		done
	done
} &
UPDATER_PID=$!

trap 'kill "$UPDATER_PID"' EXIT

##############################################################################
## Set PS1

PS1a="\[${c17}\]\D{%b%d %H:%M:%S}"
PS1b="${USER_HOST}\[${c18}\]:\[${c19}\]\w\[${PRIV_BCOLOUR}\]\
${PRIV_PROMPT}\\[${NC}\] "

function SetPrompt
{
	## Keep at start
	if [ $? -eq 0 ]; then
		RESULT_COLOUR=$c23;
	else
		RESULT_COLOUR=$c24;
	fi
	
	((DURATION=$(date +%s)-$CMD_START_TIME))
	((h=$DURATION/3600))
	((m=($DURATION%3600)/60))
	((s=$DURATION%60))	
	
	COLS=$(tput cols)
	ROWS=$(tput lines)

	## Responsive sizing
	if [ $COLS -gt 80 ]; then
		PS1="${PS1a} \[${20}\][\[${c21}\]+\[${RESULT_COLOUR}\]\
${h}h${m}m${s}\[${c22}\]] ${PS1b}"
	else
		PS1=$PS1b
	fi

	# Start the clock
	[[ $CLOCK_ENABLED -eq 1 ]] && kill -s sigusr2 "$UPDATER_PID"

	## Keep at end
	trap 'CMD_START_TIME=$(date +%s); kill -s sigusr1 "$UPDATER_PID"; \
trap - DEBUG' DEBUG
}

###############################################################################
## Set prompt_command (runs every time the prompt is shown)

PROMPT_COMMAND='SetPrompt'

###############################################################################
## Any final initialisations before continuing

CMD_START_TIME=$(date +%s)

# Make some room for the status bar
echo -e "\n\n** wbrc active **"

