#!/bin/bash

file=$1
db=$2
table=$3

if [ ! -f $file ] || [ -z $db ]; then
  echo "USAGE: $0 file database [table] > dump_file"
  exit
fi

if [ -z $table ]; then
  zcat $file | sed -n -e "/CREATE DATABASE.*${db}/,/CREATE DATABASE/p" | head -n -5
else
  zcat $file | sed -n -e "/CREATE DATABASE.*${db}/,/CREATE DATABASE/p" | sed -n -e "/CREATE TABLE.*${table}/,/CREATE TABLE/p" | head -n -8
fi

