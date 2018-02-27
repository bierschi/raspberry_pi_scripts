#!/usr/bin/env bash


delete_serial_output(){
# delete serial output to console
sed -i s/console=serial0,115200/""/g /boot/cmdline.txt

echo -e "delete serial output to console\n"
}

enable_uart(){
echo >> /boot/config.txt
echo "#enable uart" >> /boot/config.txt
echo enable_uart=1 >> /boot/config.txt

echo -e "successfully enabled uart in file /boot/config.txt\n"
}

swap_uart(){

# UART auf ttyAMA0
echo >> /boot/config.txt
echo "#swap uart" >> /boot/config.txt
echo dtoverlay=pi3-miniuart-bt >> /boot/config.txt
echo force_turbo=1 >> /boot/config.txt

echo -e "successfully configured file /boot/config.txt\n"
}

select_serial_option(){
read -rep $'Do you want to use the mini uart (ttyS0) or the powerful uart (ttyAMA0)? Type: 1 (for ttyS0), type: 2 (for ttyAMA0)\n' numbers

if (( $numbers > 0 )) && (( $numbers < 3 ))
then
  delete_serial_output
  if [ $numbers -eq 1 ]
  then
    echo -e "create the mini uart (ttyS0)\n"
    enable_uart
  else
    echo -e "create the powerful uart (ttyAMA0)\n"
    enable_uart
    swap_uart
  fi
else
  echo -e "wrong number, please retry!"
  select_serial_option
fi
}

####################main####################

echo -e "\nConfiguration starts\n"

select_serial_option

echo -e "configuration finished \n"

echo "reboot starts in 5 seconds"
sleep 5
sudo reboot
