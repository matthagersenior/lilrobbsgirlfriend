# LilRobbsGirlfriend — Revision C procurement and build plan

Checked 2026-10-17. **Not a purchase-ready turnkey kit.** The source CAD and exported STL bundle currently supplied as a ChatGPT attachment; do not assume the exploded concept illustration matches all hardware fits. Prototype SLA/PLA geometry has been exported and checked for manifold meshes, but the structural handle, power circuit, motor mounting and final sensor performance need physical engineering.

## Orderable component listings (medium 96 mm configuration)
|Item|Quantity|Listed unit price|Seller|
|---|---:|---:|---|
|Raspberry Pi 5 2GB|1|$77.50|https://www.pishop.us/product/raspberry-pi-5-2gb/|
|Pi 5 active cooler|1|$10.95|https://www.pishop.us/product/raspberry-pi-active-cooler/|
|Official 32GB A2 microSD|1|$19.95|https://www.pishop.us/product-category/raspberry-pi/sd-cards/|
|Camera Module 3|1|$29.25|https://www.pishop.us/product-category/raspberry-pi/raspberry-pi-cameras/|
|Pi 5 camera adapter cable|1|$3.95|https://www.pishop.us/product/camera-cable-for-raspberry-pi-5/|
|ESP32 Feather V2 with headers|1|$20.95|https://www.adafruit.com/product/5900|
|Pololu 100:1 37D 12V gearmotor|4|$38.95|https://www.pololu.com/product/4745|
|Pololu 37D stamped bracket *pair*|2|$11.95|https://www.pololu.com/product/1084|
|Pololu 6mm shaft-to-12mm-hex adapter *pair*|2|$6.95|https://www.pololu.com/product/2686|
|96 mm / 12mm hex rubber tire set of 4|1|$55.95|https://vxb.com/products/4x-1-10-rc-off-road-wheel-tires-set-with-5-spoke-r|
|Cytron MDD20A dual motor driver|1|$38.50|https://www.cytron.io/c-industry/p-20amp-6v-30v-dc-motor-driver-2-channels|
|Bioenno 12V 6Ah LiFePO4 BLF-1206CUSTOM|1|$89.99|https://www.bioennopower.com/products/12v-6ah-lfp-battery-pvc-blf-1206custom|
|Bioenno LiFePO4 2A DC plug charger|1|$21.99|https://www.bioennopower.com/collections/battery-chargers/charger|
|Pololu 5V6A buck regulator|1|$31.95|https://www.pololu.com/product/5571|
|Adafruit 5V3A servo UBEC|1|$9.95|https://www.adafruit.com/product/1385|
|Seeed ReSpeaker Lite USB 2-mic array|1|$24.90|https://www.digikey.com/en/products/detail/seeed-technology-co-ltd/107990273/24814468|
|Seeed 4 ohm 5W mono enclosed speaker|1|$2.00|https://www.seeedstudio.com/ReSpeaker-Lite-with-Raspberry-Pi.html|
|Adafruit assembled two-servo pan/tilt|1|$18.95|https://www.adafruit.com/product/1967|
|Adafruit VL53L1X 4m ToF board|3|$14.95|https://www.adafruit.com/product/3967|
|DFRobot latching emergency stop switch|1|$7.50|https://www.robotshop.com/products/emergency-stop-switch|
|Raspberry Pi USB flash drive 128GB|1|$29.95|https://www.pishop.us/product-category/raspberry-pi/pi-accessories/|

**Listed product subtotal: $732.63**, not including tax, shipping, or required unpriced hardware.

Interchangeable additional wheel sets with the *same four metal 12mm hex adapters*:
- Apartment (69mm, 4 mounted): $34.99 — https://www.hackfabhobbies.com/products/powerhobby-1-10-rally-car-avantgarde-mounted-tires-claw-wheels-4-12mm-hex
- Rough-terrain (110mm, 4 mounted): $39.99 — https://integy.shop/products/tires-inserts-wheels-for-1-10-rc-short-course-off-road-c32264

**Subtotal with all three wheel sets: $807.61** before missing safety/wiring items.

## Stop-before-order items
- Four motors list 5.5A extrapolated stall each; motor power could momentarily exceed the 6Ah battery's 12A continuous / 24A 2-second ratings. Current limiting and real tests mandatory.
- The 5V rail needs a tested 5A USB-C input method for Pi 5 and a separate power path for servos; buck regulators are not complete cabling.
- No final fuse, DC-rated E-stop power isolation, properly sized cable/fuse/distribution, contact sensor, cliff detector, steel chassis reinforcement or motor bracket hardware list is approved yet.
- 37D L-brackets can flex; manufacturer suggests a stronger machined bracket for high loads.
- Individual ToF sensors have a narrow FoV and camera is monocular. Not certified for obstacle, hole or stair avoidance.
- LiFePO4 charger is for manual charging; automatic docking is later.
- No one-handed carrying promise until mass and handle load tests.
- Color-rendered **reference assemblies contain wheels and motors that are NOT printed**; print the individual STLs instead.

## Revised printable Rev C parts
Chassis front + rear (one each), body cowl (two), battery cradle, electronics deck, head front + rear, face visor, eye rings (two), neck shell, speaker grille, handle *appearance mockup*, and modular wheel-motor adapter plates (four). All exported STL bodies fit a 256x256mm P1S bed by geometric extents, but functional fit still needs physical verification.

## Software build
Pi 5: Raspberry Pi OS, Python, Picamera2, computer vision, intent engine, encrypted device API, voice integration.
ESP32: Arduino or ESP-IDF deterministic motor PWM, current limits, watchdog, stop-on-disconnect, independent interlock.
Companion phone app: device CRUD, accessible virtual joystick, generic controller support, follow/watch/sentry commands, remote cameras and settings.
