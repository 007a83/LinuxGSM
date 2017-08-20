#!/bin/bash
# LinuxGSM alert_telegram.sh function
# Author: Bennet Becker <bennet@becker-dd.de>
# Website: https://bytegaming.de
# Description: Sends Telegram Message alert including the server status.

local commandname="ALERT"
local commandaction="Alert"
local function_selfname="$(basename $(readlink -f "${BASH_SOURCE[0]}"))"


json=$(cat <<EOF
{
	"chat_id": "${telegramchatid}",
	"text": "${alertemoji} <b><a href="${alerturl}">${alertsubject}</a></b> ${alertemoji}\n\n${alertbody}",
	"parse_mode": "HTML",
}
EOF
)

fn_print_dots "Sending Telegram Message"
sleep 1
telegramsend=$(curl -sSL -H "Content-Type: application/json" -X POST -d """$json""" "https://api.telegram.org/bot${telegramtoken}/sendMessage" | grep -Po '(?<="description":").*?(?=")'|uniq)

if [ -n "${telegramsend}" ]; then
	fn_print_fail_nl "Sending Telegram Alert: ${telegramsend}"
	fn_script_log_fatal "Sending Telegram Alert: ${telegramsend}"
else
	fn_print_ok_nl "Sending Telegram Alert"
	fn_script_log_pass "Sent Telegram Alert"
fi
