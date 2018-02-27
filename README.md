# A repository for useful raspberry pi scripts

- can_interfaces.sh
- establish_ppp_connection.sh
- hifiberry_configuration.sh
- serial_connection.sh



### can_interfaces.sh
Executing the "can_interfaces.sh" script, you can load the "can0" and/or the
"can1" interface. Depending if you use the pican2 (only "cano") or the
pican2 duo ("can0" and "can1") board.

Tested only with the pican2 and the pican2 duo board containing the MCP2515 CAN controller
with the MCP2551 CAN transceiver

### establish_ppp_connection.sh


### hifiberry_configuration.sh


### serial_connection.sh

The default setting on GPIO 14 and 15 is the mini uart (ttyS0) (because of
the bluetooth module). To change this settings, we have to load the correct
device tree overlay "pi3-miniuart-bt".

"pi3-miniuart-bt" switches the Raspberry Pi 3 and Raspberry Pi Zero W Bluetooth
function to use the mini UART (ttyS0), and restores UART0/ttyAMA0 to
GPIOs 14 and 15.


<br>

install minicom to interact with the uart
<pre><code>
sudo apt install minicom
</pre></code>

<br>

##### Test the serial connection
option -b is the baudrate, select the appropriate baudrate for your use case

if you use the mini uart, insert following command in terminal:
<pre><code>
minicom -b 9600 -D /dev/ttyS0
</pre></code>

if you use the powerful uart, insert following command in terminal:
<pre><code>
minicom -b 9600 -D /dev/ttyAMA0
</pre></code>
