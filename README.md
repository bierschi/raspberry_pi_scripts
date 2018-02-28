# A repository for useful raspberry pi scripts

## Scripts
- can_interfaces.sh
- establish_ppp_connection.sh
- hifiberry_configuration.sh
- serial_connection.sh



## can_interfaces.sh
Executing the "can_interfaces.sh" script, you can load the "can0" and/or the
"can1" interface. Depending if you use the pican2 (only "can0") or the
pican2 duo board("can0" and "can1") .

Tested only with the pican2 and the pican2 duo board containing the MCP2515 CAN controller
with the MCP2551 CAN transceiver

<br>

<img src="https://cdn.shopify.com/s/files/1/1560/1473/products/picture-template_pican2_1.jpg?v=1503590593" alt="example" width="200" height="200"> <img src="https://cdn.shopify.com/s/files/1/1560/1473/products/IMG_0002-3.jpg?v=1502370327" alt="example" width="200" height="200">


## establish_ppp_connection.sh


### hifiberry_configuration.sh


### serial_connection.sh

The default setting on GPIO 14 and 15 is the mini uart (ttyS0) (because of
the bluetooth module). To change this settings, we have to load the correct
device tree overlay "pi3-miniuart-bt".

"pi3-miniuart-bt" switches the Raspberry Pi 3 and Raspberry Pi Zero W Bluetooth
function to use the mini UART (ttyS0), and restores UART0/ttyAMA0 to
GPIOs 14 and 15.

<br>

#### Test the serial connection

install minicom to interact with the uart
<pre><code>
sudo apt install minicom
</pre></code>


option -b is the baudrate, select the appropriate baudrate for your use case

if you use the mini uart, insert following command in terminal:
<pre><code>
minicom -b 9600 -D /dev/ttyS0
</pre></code>

if you use the powerful uart, insert following command in terminal:
<pre><code>
minicom -b 9600 -D /dev/ttyAMA0
</pre></code>
