# ExtNetSim
Network Simulation Environment for MLSysOps Project. This project integrates multiple open-source dependencies for dedicated network entity and makes them functional together.

This page contains operative instructions to install, configure and use the 5G network environment simulator to generate rich datasets and traces in the light of MLSysOps goal. The simulator has been designed to integrate physical-layer realism with system-level metrics to capture critical factors affecting resource allocation, security and anomaly detection, enabling dynamic modeling of 5G network scenarios such as node mobility, connection management and real-time responses to network conditions. In particular, we have extended the simulator with a power-based jammer to further evaluate the system resilience to interference.

The dependencies of the simulator are outlined as below:

- `Open5GS` is available on https://github.com/open5gs/open5gs under GNU AGPL v3.0 license.
- `srsRAN` is available on https://github.com/srsran/srsRAN_4G under GNU AGPL v3.0 license.
- `GNU Radio` is available on https://github.com/gnuradio/gnuradio under GPL-3.0 license. 

## Network Simulation Environment Installation

1. Install dependencies:
    - Install required packages: `cmake, make, gcc, g++, libuhd-dev and libboost-all-dev`
    - Ensure you have `Python3` and `pip` installed 

2. Install srsRAN:
    - Clone the srsRAN repository: 
    ```bash
    git clone https://github.com/srsran/srsRAN.git 
    cd srsRAN
    ```
    - Build and install:
    ```bash
    mkdir build && cd build 
    cmake .. 
    make 
    sudo make install 
    ```
3. Install Open5GS:
    - Clone the repository:
    ```bash
    git clone https://github.com/open5gs/open5gs.git 
    cd open5gs
    ```
    - Build and install:
    ```bash
    meson build --prefix=/usr 
    ninja -C build 
    sudo ninja -C build install 
    ```
4. Configure Networking:
    - Set up network interfaces for core and RAN communication.
    - Use the open5gs configuration files to define the 5G core network structure (`/etc/open5gs/*.yaml`)

## Power-based jammer installation

The GNU Radio installation is described [here](https://wiki.gnuradio.org/index.php?title=Creating_Python_OOT_with_gr-modtool).

1. Update system packages: before installing GNU Radio Companion, ensure your system packages are up to date:
```bash
sudo apt update 
sudo apt upgrade
```

2. Install dependencies: install required dependencies for GNU Radio:
```bash
sudo apt install cmake g++ libboost-all-dev libgmp-dev swig python3-dev python3-mako \
python3-numpy python3-scipy python3-requests python3-pip libqt5opengl5-dev \
liblog4cpp5-dev libzmq3-dev libfftw3-dev
```

3. Install GNU Radio: install through package manager or GitHub (preferred):

    - Clone GNU repository:
    ```bash
    git clone https://github.com/gnuradio/gnuradio.git 
    cd gnuradio
    ```

    - Build and install:
    ```bash
    mkdir build && cd build 
    cmake .. 
    make -j$(nproc) 
    sudo make install 
    sudo ldconfig 
    ```

4. Launch GNU Radio Companion:

    - Start the graphical user interface to verify the GUI installation: 
    ```bash
    gnuradio-companion
    ```

## Power-based jammer getting started

1. Creating the Power-based Jammer flowgraph:

    - Launch GNU radio companion and create a new flowgraph by dragging and dropping blocks from the library 
    - Connect block from the input to the output 
    - Double click on the block to configure its parameters

2. For the special Jammer block: 
    - Consider updating the libraries if OOT modules are not installed: 
    ```bash
    sudo apt-get install gnuradio-dev cmake libspdlog-dev clang-format 
    ```
    - Create an OOT Module:

        - Open terminal and navigate to an appropriate directory for writing the software 

        - GNURadio comes packaged with `gr-modtool`, a software tool used to create out-of-tree(OOT) modules. An OOT module can be thought of as a collection of custom GNU radio blocks. Create an OOT module named customModule using `gr_modtool`: 
        ```bash 
        gr_modtool newmod customModule 
        ```

        - The directory `gr-customModule` is created which contains all the skeleton code for an OOT module, however, it does not yet have any blocks. Move into the `gr-customModule` directory: 
        ```bash
        cd gr-customModule 
        ```

        The directory contains the following: 
        `apps/ cmake/ CmakeLists.txt  docs/ examples/ grc/ include/ lib/ MANIFEST.yml/ python/`

        - Create the OOT Block: 
        ```bash 
        gr_modtool add Jammer 
        ```

        - The command will start a questionnaire about how the block is to be defined: type, language and parameters. In our case (general, python). 

        - New files will be generated: 
        `python/custumModule/addJammer.py`
        `grc/customModule_addJammer.block.yml` 

        - Modify the python file: `python/customModule/addJammer.py`: [example](examples/addJammer.py)

        - Update the yml file to look as the [example](examples/customModule_jammer.block.yml).

        - Compile and install the block:
        ```bash
        mkdir build 
        cd build 
        cmake .. 
        make 
        sudo make install  
        sudo ldconfig 
        ```

        - Start gnuradio-companion, search for customModule and the jammer block will be present.  
