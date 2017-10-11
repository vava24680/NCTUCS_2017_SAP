#! /bin/sh
touch cookie-jar.txt
status=0
while [ $status -eq 0 ] ; do
	account=`dialog --output-fd 1 --inputbox "Please input the Account" 20 20`
	password=`dialog --output-fd 1 --insecure --passwordbox "Please input the Portal Password" 20 20`
	curl -s -c cookie-jar.txt https://portal.nctu.edu.tw/captcha/pic.php
	curl -s -b cookie-jar.txt -c cookie-jar.txt https://portal.nctu.edu.tw/captcha/pitctest/pic.php -o captcha.png
	captcha_num=`curl -s -F 'image=@./captcha.png' -i https://nasa.cs.nctu.edu.tw/sap/2017/hw2/captcha-solver/api/ | awk 'NR==8 {printf("%d",$1)}'`
	echo -e "\n This is captcha ${captcha_num}"
	temp=`curl -b cookie-jar.txt -c cookie-jar.txt -d "username=${account}&password=${password}&seccode=${captcha_num}&pwdtype=static&Submit2=(Login)" https://portal.nctu.edu.tw/portal/chkpas.php? | grep "alert"`
	status=$?
done
echo -e "\nStatus : ${status}"
url=`curl -b cookie-jar.txt -c cookie-jar.txt https://portal.nctu.edu.tw/portal/relay.php?D=cos | node extractFormdata.js`
curl -s -b cookie-jar.txt -c cookie-jar.txt -d "${url}" https://course.nctu.edu.tw/index.asp
clear
curl -b cookie-jar.txt https://course.nctu.edu.tw/adSchedule.asp -o - | iconv -f big5 -t utf-8 | \
	grep -E "<tr>	<td|		.*<br>|<font.+><h2>&nbsp" | \
	sed -e 's/	//g;s/<br>//g;s///g;' | \
	awk 'BEGIN{printf("Mon Tue Wed Thur Fri Sat Sun ");}\
	/<tr><td.*/{printf("\n");}\
	/<font.+><h2>&nbsp/{printf(". ");}\
	/^[^<]/{printf("%s ",$0)}\
	END{printf("\n");}' | column -t
