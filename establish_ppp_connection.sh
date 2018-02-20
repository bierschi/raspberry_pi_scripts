#!/usr/bin/env bash

check_internet(){
wget -q --spider http://google.com
if [ $? -eq 0 ];
then
   install_ppp_package
else
  echo -e "please check your internet connection and retry!\n"
  exit 1
fi

}

install_ppp_package(){
echo -e "install package ppp \n"
  sudo apt-get install ppp
}

delete_serial_output(){
# delete serial output to console
sed -i s/console=serial0,115200/""/g /boot/cmdline.txt

echo -e "delete serial output to console\n"
}

swap_uart(){

# UART auf ttyAMA0
echo >> /boot/config.txt
echo "#swap uart" >> /boot/config.txt
echo dtoverlay=pi3-miniuart-bt >> /boot/config.txt
echo enable_uart=1 >> /boot/config.txt
echo force_turbo=1 >> /boot/config.txt

echo -e "successfully configured file /boot/config.txt\n"
}



create_file_gprs_in_peers(){
# create file gprs in /etc/ppp/peers/
echo > /etc/ppp/peers/gprs
echo user \"internet\" >> /etc/ppp/peers/gprs
echo connect \"/usr/sbin/chat -v -f /etc/chatscripts/gprs -T em\" >> /etc/ppp/peers/gprs
echo /dev/ttyAMA0 >> /etc/ppp/peers/gprs
echo ${baudrate} >> /etc/ppp/peers/gprs
echo noipdefault >> /etc/ppp/peers/gprs
echo defaultroute >> /etc/ppp/peers/gprs
echo replacedefaultroute >> /etc/ppp/peers/gprs
echo hide-password >> /etc/ppp/peers/gprs
echo noauth >> /etc/ppp/peers/gprs
echo persist >> /etc/ppp/peers/gprs
echo usepeerdns >> /etc/ppp/peers/gprs

echo -e "successfully configured file /etc/ppp/peers/gprs\n"
}

create_file_gprs_in_chatscripts(){
# create file gprs in /etc/chatscripts/
echo > /etc/chatscripts/gprs
echo ABORT    BUSY >> /etc/chatscripts/gprs
echo ABORT    VOICE >> /etc/chatscripts/gprs
echo ABORT    \"NO CARRIER\" >> /etc/chatscripts/gprs
echo ABORT    \"NO DIALTONE\" >> /etc/chatscripts/gprs
echo ABORT    \"NO DIAL TONE\" >> /etc/chatscripts/gprs
echo ABORT    \"NO ANSWER\" >> /etc/chatscripts/gprs
echo ABORT    \"DELAYED\" >> /etc/chatscripts/gprs
echo ABORT    \"ERROR\" >> /etc/chatscripts/gprs
echo ABORT    \"+CGATT: 0\" >> /etc/chatscripts/gprs
echo \"\"  AT >> /etc/chatscripts/gprs
echo TIMEOUT    12 >> /etc/chatscripts/gprs
echo OK    ATH >> /etc/chatscripts/gprs
echo OK    ATE1 >> /etc/chatscripts/gprs
if $(echo $2 | grep -q '^[0-9]\+$')
then
  echo OK \"AT+CPIN=${pin}\" >> /etc/chatscripts/gprs
else
  echo -e "no pin is selected\n"
fi
echo OK    AT+CGDCONT=1,\"IP\",\"${apn}\",\"\",0,0 >> /etc/chatscripts/gprs
echo OK ATD*99# >> /etc/chatscripts/gprs
echo TIMEOUT    22 >> /etc/chatscripts/gprs
echo CONNECT    \"\" >> /etc/chatscripts/gprs

echo -e "successfully configured file /etc/chatscripts/gprs\n"
}


set_interface_ppp(){
#ppp0 in /etc/network/interfaces
if grep -q 'auto gprs' /etc/network/interfaces;
then
  echo -e "provider gprs already set in /etc/network/interfaces\n"
else
  echo "  " >> /etc/network/interfaces
  echo "#set up ppp0 interface" >> /etc/network/interfaces
  echo auto gprs >> /etc/network/interfaces
  echo iface gprs inet ppp >> /etc/network/interfaces
  echo provider gprs >> /etc/network/interfaces
fi

echo -e "successfully configured file /etc/network/interfaces\n"
}

####################main####################

echo -e "\nConfiguration starts\n"

read -p "please enter the apn data for your provider: " apn
read -p "please enter the pin for the SIM card, if no pin is set enter \"no\": " pin
read -p "please enter the baudrate for your gsm module: " baudrate

check_internet
delete_serial_output
swap_uart
create_file_gprs_in_peers $baudrate
create_file_gprs_in_chatscripts $apn $pin
set_interface_ppp

echo -e "configuration finished \n"

echo "reboot starts in 5 seconds"
sleep 5
sudo reboot
