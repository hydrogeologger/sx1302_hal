#!/usr/bin/env bash

IOT_SK_SX1302_RESET_PIN=17

echo "Accessing concentrator reset pin through GPIO$IOT_SK_SX1302_RESET_PIN..."

WAIT_GPIO() {
    sleep 0.1
}

iot_sk_init() {
    # setup GPIO
    echo "$IOT_SK_SX1302_RESET_PIN" > /sys/class/gpio/export; WAIT_GPIO

    # set GPIO as output
    echo "out" > /sys/class/gpio/gpio$IOT_SK_SX1302_RESET_PIN/direction; WAIT_GPIO

    # write output for SX1302 reset
    echo "1" > /sys/class/gpio/gpio$IOT_SK_SX1302_RESET_PIN/value; WAIT_GPIO
    echo "0" > /sys/class/gpio/gpio$IOT_SK_SX1302_RESET_PIN/value; WAIT_GPIO

    # set GPIO as input
    echo "in" > /sys/class/gpio/gpio$IOT_SK_SX1302_RESET_PIN/direction; WAIT_GPIO
}

iot_sk_term() {
    # cleanup GPIO
    if [ -d /sys/class/gpio/gpio$IOT_SK_SX1302_RESET_PIN ]
    then
        echo "$IOT_SK_SX1302_RESET_PIN" > /sys/class/gpio/unexport; WAIT_GPIO
    fi
}

iot_sk_term
iot_sk_init
sleep 3
./lora_pkt_fwd
