#!/usr/bin/env bash

C_BLU='\033[0;34m'
C_GRN='\033[0;32m'
C_RED='\033[0;31m'
C_YEL='\033[0;33m'
C_END='\033[0m'

function blue {
    printf "${C_BLU}$@${C_END}\n"
}

function green {
    printf "${C_GRN}$@${C_END}\n"
}

function red {
    printf "${C_RED}$@${C_END}\n"
}

function yellow {
    printf "${C_YEL}$@${C_END}\n"
}
