#!/system/bin/busybox sh

echo "Hello Yota!" > /var/log/yota-hello.log
echo "Trying to detect IP of hello.yota.ru..." >> /var/log/yota-hello.log

IP=''
TRY=0

while [ -z $IP ]; do
    IP=`busybox ping -c 1 hello.yota.ru | busybox grep -Eo -m 1 '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'`;
    if [ $TRY -ge 1 ]; then
        echo "Failed to ping host hello.yota.ru. Sleep 1 second before retry..." >> /var/log/yota-hello.log
        sleep 1
    fi
    TRY=$(($TRY+1))
    if [ $TRY -ge 10 ]; then
        echo "Limit of retries has been exceeded. Gave up." >> /var/log/yota-hello.log
        IP='94.25.232.253'
        echo "Using last known IP $IP" >> /var/log/yota-hello.log
        break;
    fi
done

echo "IP: ${IP}. Sending request..." >> /var/log/yota-hello.log

busybox nc $IP 80 2>&1 >> /var/log/yota-hello.log << EOF
POST /php/go.php HTTP/1.0
Host: hello.yota.ru
Connection: close
Content-Length: 115
Cache-Control: max-age=0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
Origin: http://hello.yota.ru
Upgrade-Insecure-Requests: 1
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.103 Safari/537.36
Content-Type: application/x-www-form-urlencoded
Referer: http://hello.yota.ru/light/
Accept-Language: en-US,en;q=0.8,ru;q=0.6,es;q=0.4

accept_lte=1&redirurl=http%3A%2F%2Fwww.yota.ru%2F&city=ulyanovsk&connection_type=light&service_id=Sliders_Free_Temp
EOF

echo "" >> /var/log/yota-hello.log
echo "Done" >> /var/log/yota-hello.log
