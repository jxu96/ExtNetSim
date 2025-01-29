#!/bin/bash

source ./.env

HOST_ADDRESS=$(hostname -I | awk '{print $1}')
OUTPUT_SMF_CONFIG="smf-${BUILD_TAG}.yaml"
OUTPUT_UPF_CONFIG="upf-${BUILD_TAG}.yaml"

if [[ -f "${OUTPUT_SMF_CONFIG}" ]]; then
  rm "${OUTPUT_SMF_CONFIG}"
fi

if [[ -f "${OUTPUT_UPF_CONFIG}" ]]; then
  rm "${OUTPUT_UPF_CONFIG}"
fi

cat > "${OUTPUT_SMF_CONFIG}" << EOF
global:
  max:
    ue: 1024  # The number of UE can be increased depending on memory size.

smf:
  sbi:
    server:
      - dev: eth0
        port: ${SMF_SBI_PORT}
        advertise: ${HOST_ADDRESS}
    client:
      scp:
        - uri: ${FIVEGC_HOST}
  pfcp:
    server:
      - dev: eth0
    client:
      upf:
        - address: open5gs-upf
          dnn: internet
  gtpc:
    server:
      - dev: eth0
  gtpu:
    server:
      - dev: eth0
  metrics:
    server:
      - dev: eth0
        port: 9090
  session:
    - subnet: ${SUBNET_V4}
      dnn: internet
  dns:
    - 8.8.8.8
    - 8.8.4.4
    # - 2001:4860:4860::8888
    # - 2001:4860:4860::8844
  mtu: 1400

  freeDiameter: /usr/local/etc/freeDiameter/smf.conf

  info:
    - s_nssai:
      - sst: ${SST}
        sd: ${SD}
        dnn:
          - internet
      tai:
        - plmn_id:
            mcc: 001
            mnc: 01
          tac:
            - ${TAC}
EOF

cat > "${OUTPUT_UPF_CONFIG}" << EOF
global:
  max:
    ue: 1024  # The number of UE can be increased depending on memory size.

upf:
  pfcp:
    server:
      - dev: eth0
        advertise: open5gs-upf
  gtpu:
    server:
      - dev: eth0
        port: 2152
        advertise: ${HOST_ADDRESS}
  session:
    - subnet: ${SUBNET_V4}
      dnn: internet
      dev: ogstun
  metrics:
    server:
      - dev: eth0
        port: 9090
EOF
