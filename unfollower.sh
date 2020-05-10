#!/bin/bash

string4=$(openssl rand -hex 32 | cut -c 1-4)
string8=$(openssl rand -hex 32  | cut -c 1-8)
string12=$(openssl rand -hex 32 | cut -c 1-12)
string16=$(openssl rand -hex 32 | cut -c 1-16)
device="android-$string16"
uuid=$(openssl rand -hex 32 | cut -c 1-32)
phone="$string8-$string4-$string4-$string4-$string12"
guid="$string8-$string4-$string4-$string4-$string12"
header='Connection: "close", "Accept": "*/*", "Content-type": "application/x-www-form-urlencoded; charset=UTF-8", "Cookie2": "$Version=1" "Accept-Language": "en-US", "User-Agent": "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)"'
var=$(curl -i -s -H "$header" https://i.instagram.com/api/v1/si/fetch_headers/?challenge_type=signup&guid=$uuid > /dev/null)
var2=$(echo $var | grep -o 'csrftoken=.*' | cut -d ';' -f1 | cut -d '=' -f2)
ig_sig="4f8732eb9ba7d1c8e8897a75d6474d4eb3f5279137431b2aafb71fafe2abe178"


banner() {
clear
printf " \e[0m\n"
printf " \e[1;93m _   _        __      _ _                        \e[0m\n"
printf " \e[1;93m| | | |      / _|    | | |                \e[1;92m   _   \e[0m\n"
printf " \e[1;93m| | | |_ __ | |_ ___ | | | _____      __  \e[1;92m _| |_ \e[0m\n"
printf " \e[1;93m| | | | '_ \|  _/ _ \| | |/ _ \ \ /\ / /  \e[1;92m|_   _|\e[0m\n"
printf " \e[1;93m| |_| | | | | || (_) | | | (_) \ V  V /   \e[1;92m  |_|  \e[0m\n"
printf " \e[1;93m \___/|_| |_|_| \___/|_|_|\___/ \_/\_/           \e[0m\n"
printf " \e[0m\n"
printf " \e[1;96m [\e[0m\e[1;97m+\e[0m\e[1;96m]\e[0m\e[1;92m Created By HTR-TECH (Tahmid Rayat)\e[0m\n"
printf " \e[0m\n"

}



user_login() {


if [[ $user == "" ]]; then
printf " \e[1;96m[\e[0m\e[1;97m+\e[0m\e[1;96m]\e[0m\e[1;96m Instagram Login\e[0m\n"
printf "\n"
read -p $' \e[1;96m[\e[0m\e[1;97m+\e[0m\e[1;96m]\e[0m\e[1;93m Input Username\e[1;96m : \e[0m\e[1;92m' user
fi

if [[ -e .cookie.$user ]]; then

printf "\n"
printf " \e[1;96m[\e[0m\e[1;97m+\e[0m\e[1;96m]\e[0m\e[1;93m Login Creds Found for \e[0m\e[1;92m %s\e[0m\n" $user

default_use_cookie="Y"

printf "\n"
read -p $' \e[1;96m[\e[0m\e[1;97m+\e[0m\e[1;96m]\e[0m\e[1;93m Use Previous Creds ?\e[0m\e[1;96m [Y/n] : \e[0m\e[1;92m ' use_cookie

use_cookie="${use_cookie:-${default_use_cookie}}"

if [[ $use_cookie == *'Y'* || $use_cookie == *'y'* ]]; then
printf "\n"
printf " \e[1;96m[\e[0m\e[1;97m+\e[0m\e[1;96m]\e[0m\e[1;93m Logging in using Previous Creds...\e[0m\n"
else
rm -rf .cookie.$user
user_login
fi


else

printf "\n"
read -s -p $' \e[1;96m[\e[0m\e[1;97m+\e[0m\e[1;96m]\e[0m\e[1;93m Input Password\e[1;96m : \e[0m' pass
printf "\n"
data='{"phone_id":"'$phone'", "_csrftoken":"'$var2'", "username":"'$user'", "guid":"'$guid'", "device_id":"'$device'", "password":"'$pass'", "login_attempt_count":"0"}'

IFS=$'\n'

hmac=$(echo -n "$data" | cut -d " " -f2)
useragent='User-Agent: "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)"'

printf "\n"
printf " \e[1;96m[\e[0m\e[1;97m+\e[0m\e[1;96m]\e[0m\e[1;93m Logging in as\e[0m\e[1;92m %s\e[0m\e[1;93m ...\e[0m\n" $user
printf "\n"
IFS=$'\n'
var=$(curl -c .cookie.$user -d "ig_sig_key_version=4&signed_body=$hmac.$data" -s --user-agent 'User-Agent: "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)"' -w "\n%{http_code}\n" -H "$header" "https://i.instagram.com/api/v1/accounts/login/" | grep -o "logged_in_user\|challenge\|many tries\|Please wait" | uniq ); 
if [[ $var == "challenge" ]]; then printf " \e[1;96m[\e[0m\e[1;91m!\e[0m\e[1;96m]\e[0m\e[1;93m Ip Blocked \e[1;96m[\e[0m\e[1;91m!\e[0m\e[1;96m]\e[0m\n" ; exit 1; elif [[ $var == "logged_in_user" ]]; then printf " \e[1;96m[\e[0m\e[1;97m+\e[0m\e[1;96m]\e[0m\e[1;92m Successfully Logged in !\e[0m\n" ; elif [[ $var == "Please wait" ]]; then echo " Please wait"; fi; 

fi

}


following_info() {

user_id=$(curl -L -s 'https://www.instagram.com/'$user_account'' > .getid && grep -o  'profilePage_[0-9]*.' .getid | cut -d "_" -f2 | tr -d '"')

curl -L -b .cookie.$user -s --user-agent 'User-Agent: "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)"' -w "\n%{http_code}\n" -H "$header" "https://i.instagram.com/api/v1/friendships/$user_id/following" > $user_account.following.temp


cp $user_account.following.temp $user_account.following.00
count=0

while [[ true ]]; do
big_list=$(grep -o '"big_list": true' $user_account.following.temp)
maxid=$(grep -o '"next_max_id": "[^ ]*.' $user_account.following.temp | cut -d " " -f2 | tr -d '"' | tr -d ',')

if [[ $big_list == *'big_list": true'* ]]; then

url="https://i.instagram.com/api/v1/friendships/6971563529/following/?rank_token=$user_id\_$guid&max_id=$maxid"

curl -L -b .cookie.$user -s --user-agent 'User-Agent: "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)"'  -H "$header" "$url" > $user_account.followers.temp

cp $user_account.following.temp $user_account.following.$count

unset maxid
unset url
unset big_list
else
grep -o 'username": "[^ ]*.' $user_account.following.* | cut -d " " -f2 | tr -d '"' | tr -d ',' | sort > $user_account.following_temp
mkdir core
cat $user_account.following_temp | uniq > core/$user_account.following_list.txt
rm -rf $user_account.following_temp

tot_following=$(wc -l core/$user_account.following_list.txt | cut -d " " -f1)
printf "\n"
printf " \e[1;96m[\e[0m\e[1;97m+\e[0m\e[1;96m]\e[0m\e[1;96m You are Following\e[0m\e[92m %s\e[0m\e[1;96m users.\e[0m\n" $tot_following
printf "\n"
printf " \e[1;96m[\e[0m\e[1;97m+\e[0m\e[1;96m]\e[0m\e[1;96m Following List Saved at :\e[0m\e[1;92m core/%s.following_list.txt\e[0m\n" $user_account
printf "\n"

if [[ ! -d .$user_account/raw_following/ ]]; then
mkdir -p .$user_account/raw_following/
fi
cat $user_account.following.* > .$user_account/raw_following/backup.following.txt
rm -rf $user_account.following.*
break

fi
echo $count
let count+=1

done



}

bot() {

user_account=$user
following_info

printf "\n"
printf " \e[1;96m[\e[0m\e[1;97m+\e[0m\e[1;96m]\e[0m\e[1;93m Unfollowing Users from\e[0m\e[1;92m %s \e[0m\e[1;93m...\e[0m\n" $user_account
printf "\n"
printf "\n"
printf " \e[1;96m[\e[0m\e[1;97m+\e[0m\e[1;96m]\e[0m\e[1;93m Press \"Ctrl + C\" to stop... \e[0m\n"
sleep 4
while [[ true ]]; do


for unfollow_name in $(cat core/$user_account.following_list.txt); do

username_id=$(curl -L -s 'https://www.instagram.com/'$user'' > .getmyid && grep -o  'profilePage_[0-9]*.' .getmyid | cut -d "_" -f2 | tr -d '"')

user_id=$(curl -L -s 'https://www.instagram.com/'$unfollow_name'' > .getunfollowid && grep -o  'profilePage_[0-9]*.' .getunfollowid | cut -d "_" -f2 | tr -d '"')


data='{"_uuid":"'$guid'", "_uid":"'$username_id'", "user_id":"'$user_id'", "_csrftoken":"'$var2'"}'
hmac=$(echo -n "$data" | cut -d " " -f2)
printf "\n"
printf " \e[1;96m[\e[0m\e[1;97m+\e[0m\e[1;96m]\e[0m\e[1;93m Unfollowing\e[0m\e[1;92m %s\e[0m\e[1;93m..." $unfollow_name
printf "\n"
check_unfollow=$(curl -s -L -b .cookie.$user -d "ig_sig_key_version=4&signed_body=$hmac.$data" -s --user-agent 'User-Agent: "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)"' -w "\n%{http_code}\n" -H "$header" "https://i.instagram.com/api/v1/friendships/destroy/$user_id/" | grep -o '"following": false' ) 

if [[ $check_unfollow == "" ]]; then
printf " \e[1;96m[\e[0m\e[1;91m!\e[0m\e[1;96m]\e[0m\e[1;93m Error, Try after Few Minutes \e[1;96m[\e[0m\e[1;91m!\e[0m\e[1;96m]\e[0m\n"
exit 1
else
printf " \e[1;92m    [✔] Unfollowed [✔]\n"
printf "\n"
fi

sleep 3
done


done

}

menu() {

printf "\n"
printf " \e[1;96m[\e[0m\e[1;97m01\e[0m\e[1;96m]\e[0m\e[1;93m Get Following List\e[0m\n"
printf "\n"
printf " \e[1;96m[\e[0m\e[1;97m02\e[0m\e[1;96m]\e[0m\e[1;93m Activate Unfollower\e[0m\n"
printf "\n"
printf " \e[1;96m[\e[0m\e[1;97m03\e[0m\e[1;96m]\e[0m\e[1;93m More Tools from Us\e[0m\n"
printf "\n"


read -p $' \e[1;96m[\e[0m\e[1;97m+\e[0m\e[1;96m]\e[0m\e[1;96m Choose an Option\e[1;96m : \e[0m\e[1;92m' option
printf "\n"


if [[ $option == 1 || $option == 01 ]]; then

user_login
default_user=$user

 
printf "\n"
read -p $' \e[1;96m[\e[0m\e[1;97m+\e[0m\e[1;96m]\e[0m\e[1;96m Account \e[0m\e[1;93m(Leave blank for Current acc): \e[0m\e[1;92m' user_account

user_account="${user_account:-${default_user}}"
following_info
elif [[ $option == 2 || $option == 02 ]]; then

user_login
bot
elif [[ $option == 3 || $option == 03 ]]; then

xdg-open https://github.com/htr-tech/
sleep 2
exit 1

else

printf "\n"
printf " \e[1;96m[\e[0m\e[1;91m!\e[0m\e[1;96m]\e[0m\e[1;93m Invalid Option \e[1;96m[\e[0m\e[1;91m!\e[0m\e[1;96m]\e[0m\n"
sleep 2
menu

fi
}


banner
menu
