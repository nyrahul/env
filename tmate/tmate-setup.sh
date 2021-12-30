#!/usr/bin/env bash

RED="\033[0;31m"
GREEN="\033[0;32m"
CYAN="\033[0;36m"
NC="\033[0m" # No Color

abspath ()
{
    f=$@;
    if [ -d "$f" ]; then
        base="";
        dir="$f";
    else
        base="/$(basename "$f")";
        dir=$(dirname "$f");
    fi;
    dir=$(cd "$dir" && /bin/pwd);
    echo "$dir$base"
}

statusline()
{
	status=$1
	shift
	[[ $status == AOK ]] || [[ $status == "0" ]] &&
		{
			printf "[${GREEN}OK${NC}] $*\n"
			return
		}
	[[ $status == WAIT ]] &&
		{
			printf "[${CYAN}..${NC}] $*\r"
			return
		}
	printf "[${RED}FAIL${NC}] $*\n"
	exit 1
}

install_tmate()
{
	sudo apt -y install tmate
	statusline $? "tmate installed"
}

install_ssmtp()
{
	sudo apt -y install ssmtp
	statusline $? "ssmtp installed"
}

advisory()
{
	col_len=0
	while read line; do
		c=`echo "$line" | wc -c`
		[[ $c -gt $col_len ]] && col_len=$c
	done < <(printf "$1\n")
	str=`printf "%${col_len}s"`
	str=${str// /=}
	printf "\n$str\n"
	printf "$1"
	printf "\n$str\n"
}

setup_ssmtp_user_passwd()
{
	echo -n "Gmail Password:"
	read -s password
	starthdr="#------------[Start $username `date`]-------------"
	endhdr="#------------[End $username `date`]-------------"
	sudo sh -c "cat >> $CONFFILE" <<-EOF
$starthdr #TMATELINE
root=$username #TMATELINE
mailhub=smtp.gmail.com:465 #TMATELINE
FromLineOverride=YES #TMATELINE
AuthUser=$username #TMATELINE
AuthPass=$password #TMATELINE
UseTLS=YES #TMATELINE
$endhdr #TMATELINE
EOF
}

remove_ssmtp_cfg()
{
	sudo sed -i "/TMATELINE/d" $CONFFILE
	statusline $? "removing existing credentials for $username from $CONFFILE"
}

setup_ssmtp()
{
	CONFFILE=/etc/ssmtp/ssmtp.conf
	advisory "Note: It is advised to setup a temp gmail account for such purpose\nYou have to enable _Allow Less Secure App On_ for that account.\nRef: https://support.google.com/accounts/answer/6010255?hl=en\nTHE PASSWORD WILL BE KEPT IN PLAIN TEXT in $CONFFILE"
	echo -n "Gmail Username:"
	read username
	sudo grep "TMATELINE" $CONFFILE >/dev/null
	if [ $? -ne 0 ]; then
		setup_ssmtp_user_passwd
		echo;
	else
		statusline AOK "mail account already configured, reusing..."
	fi
	statusline WAIT "testing mail account..."
	printf "Subject: tmate gmail setup test\n\nignore this mail..." | ssmtp $username
	[[ $? -ne 0 ]] && 
		statusline NOK "Failed testing ssmtp. Check gmail credentials and try again." && 
		remove_ssmtp_cfg && exit
	statusline AOK "Gmail Account Tested with SSMTP"
}

install_systemd()
{
	sudo sh -c "cat > /etc/systemd/system/tmate.service" <<-EOF
[Install]
WantedBy=multi-user.target

[Unit]
Description=Tmate-SSH
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
Restart=always
User=root
ExecStart=$BASEDIR/tmate-start.sh "nyrahul@gmail.com"
EOF
	statusline AOK "installed systemd scripts for tmate"
}

main()
{
	BASEDIR=`dirname $(abspath $0)`
	install_tmate
	install_ssmtp
	setup_ssmtp
	install_systemd
	sudo systemctl enable tmate.service
	sudo systemctl start tmate.service
}

main
