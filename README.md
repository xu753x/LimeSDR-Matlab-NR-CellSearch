# LimeSDR-Matlab-NR-CellSearch

### General
This repository contains a wrapper for LimeSDR-USB drivers that allows to work from Matlab.
All necessary files for the wrapper is located in the folder "_library".
You can find basic examples for the usage of the library with Matlab 5G toolbox.

### Prerequisites
1. Matlab
2. LimeSDR-USB

### Usage
1. Add the folder "_library" in your matlab example folder suach as NRCellSearchMIBAndSIB1RecoveryExample
2. Add the code of lms_addin.m in NRCellSearchMIBAndSIB1RecoveryExample.m after the end of loadFromFile
3. Connect LimeSDR-USB
4. Run the examples

### System configuration
Original system configuration:
1. Windows 10 
2. Matlab with 5G Toolbox
3. LimeSDR-USB

### Known issues
1. First sample block always droped some packets.
2. If you get LimeSDR error: Rx calibration: MCU error 5 (Loopback signal weak: not connected/insufficient gain?), Increasese the gain(0-60).
3. Some USB3.0 TypeC HUB droped packets every 4 sample block in 30.72MSPS made it hard to decode sib1. In my test Ugreen HUB is OK.

### Reference
The code is based on the work from [RakhDamir](https://github.com/RakhDamir/LimeSDR-Matlab)

# License #
This code is distributed under an [MIT License](LICENSE.MIT).
