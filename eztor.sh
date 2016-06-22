#!/bin/bash
clear
if [ "$1" != "start" ] && [ "$1" != "stop" ]; then
	echo "############ $(tput setaf 196)Invalid Arguments$(tput sgr0) ############"
	echo "$(tput setaf 64)Valid Arguments:$(tput sgr0) eztor start  or  eztor stop"
	exit
fi
UNAME=$(uname)
if [ "$UNAME" != "Linux" ] && [ "$UNAME" != "Darwin" ]; then
	echo "############ $(tput setaf 196)OS Not Supported: $UNAME$(tput sgr0) ############"
	echo "$(tput setaf 64)Supported:$(tput sgr0) Linux and Darwin"
	exit
fi
ME=`basename "$0"`
sudo -v
echo "$(tput setaf 45)" # teal
echo "  ______  _______         "
echo " |  ____||__   __|        "
echo " | |__   ___| | ___  _ __ "
echo " |  __| |_  / |/ _ \| '__|"
echo " | |____ / /| | (_) | |   "
echo " |______/___|_|\___/|_|   "
echo "                          "                           
echo "$(tput sgr0)Easy Tor Script"
echo "$(tput setaf 45)---------------"
echo "$(tput sgr0)If nothing changes once the script is run check you enter the correct device"
echo ""
echo "WIP210616"
echo "$(tput setaf 45)----------------------------------------------------------------------------"
echo "$(tput sgr0)" # default
echo -n "Please enter device you are connected to the internet with (wi-fi | ethernet | display ethernet): "
read INTERFACE
if [ "$1" = "stop" ]; then
	pgrep -f "$ME start" | xargs kill -9
	pgrep -x tor | xargs kill -9
else
	echo -n "Please enter end point (2 character code code) or leave blank for random: "
	read END
	echo -n "Would you like to keep changing or stay at same place (jump | stay)? "
	read TYPE
	if [ "$TYPE" = "jump" ]; then
		echo -n "Please enter the amount to secounds to wait before jumping: "
		read JUMP
		clear
		if [ "$UNAME" = "Darwin" ]; then
			sudo networksetup -setsocksfirewallproxy $INTERFACE 127.0.0.1 9050 off
			sudo networksetup -setsocksfirewallproxystate $INTERFACE on
		fi
		if [ "$UNAME" = "Linux" ]; then
			gsettings set org.gnome.system.proxy mode 'none'
			gsettings set org.gnome.system.proxy.socks host 'localhost'
			gsettings set org.gnome.system.proxy.socks port 9050
			gsettings set org.gnome.system.proxy mode 'manual'
		fi
		echo -n "SOCKS proxy " # not newline
		echo "$(tput setaf 64)enabled." # green
		echo "$(tput setaf 24)REMEBER TO RUN eztor WITH AGRUEMENT stop IN ANOTHER WINDOW TO END THIS" # blue
		echo "$(tput setaf 136)Starting Tor..." # orange
		echo "$(tput sgr0)" # default
		while [ "true" ]
		do
			if [ "$COUNT" == 1 ]; then
				clear
				echo "$(tput setaf 24)REMEBER TO RUN eztor WITH AGRUEMENT stop IN ANOTHER WINDOW TO END THIS" # blue
				echo "$(tput setaf 136)Restarting Tor for new ip..." # orange
				echo "$(tput sgr0)" # default
			else
				((COUNT++))
			fi 
			if [ ! -z "$END" -a "$END" != " " ] || [ ! -z "$END" -a "$END" != " " ]; then
		    	if [ "$UNAME" = "Darwin" ]; then
		    		gtimeout "$JUMP"s tor ExitNodes {$END} # CircuitBuildTimeout 10 LearnCircuitBuildTimeout 0 MaxCircuitDirtiness NUM <-Playing around with this verison on new ip
		    	fi
		    	if [ "$UNAME" = "Linux" ]; then
		    		timeout "$JUMP"s tor ExitNodes {$END}
		    	fi
		    else
				if [ "$UNAME" = "Darwin" ]; then
					gtimeout "$JUMP"s tor
		    	fi
		    	if [ "$UNAME" = "Linux" ]; then
		    		timeout "$JUMP"s tor
		    	fi
			fi
		done
	else
		clear
		if [ "$UNAME" = "Darwin" ]; then
			sudo networksetup -setsocksfirewallproxy $INTERFACE 127.0.0.1 9050 off
			sudo networksetup -setsocksfirewallproxystate $INTERFACE on
   		fi
    	if [ "$UNAME" = "Linux" ]; then
    		gsettings set org.gnome.system.proxy mode 'none'
			gsettings set org.gnome.system.proxy.socks host 'localhost'
			gsettings set org.gnome.system.proxy.socks port 9050
			gsettings set org.gnome.system.proxy mode 'manual'
    	fi
		echo -n "SOCKS proxy " # not newline
		echo "$(tput setaf 64)enabled." # green
		echo "$(tput setaf 24)REMEBER TO RUN eztor WITH AGRUEMENT stop IN ANOTHER WINDOW TO END THIS" # blue
		echo "$(tput setaf 136)Starting Tor..." # orange
		echo "$(tput sgr0)" # default
		if [ ! -z "$END" -a "$END" != " " ] || [ ! -z "$END" -a "$END" != " " ]; then
		    tor ExitNodes {$END}
		else
			tor
		fi
	fi
fi
clear
if [ "$UNAME" = "Darwin" ]; then
	sudo networksetup -setsocksfirewallproxystate $INTERFACE off
fi
if [ "$UNAME" = "Linux" ]; then
	gsettings set org.gnome.system.proxy mode 'none'
fi
echo "$(tput setaf 136)Ending Tor..."
echo -n "$(tput sgr0)SOCKS Proxy " #default
echo "$(tput setaf 196)disabled." # red
echo "$(tput sgr0)" # default
