#!/usr/bin/env bash

while getopts s:p: flag
do
    case "${flag}" in
        s) script=${OPTARG};;
        p) platform=${OPTARG};;
    esac
done
