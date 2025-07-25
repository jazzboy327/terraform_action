#!/bin/bash
# Usage: ./parse-issue-to-tfvars.sh local_test.txt

sed -nE 's/^[- ]*환경: (.+)/environment = "\1"/p' "$1"
sed -nE 's/^[- ]*위치: (.+)/location = "\1"/p' "$1"
sed -nE 's/^[- ]*리소스 그룹: (.+)/resource_group_name = "\1"/p' "$1"
sed -nE 's/^[- ]*VNet: (.+)/vnet_name = "\1"/p' "$1"
sed -nE 's/^[- ]*CIDR: (.+)/address_space = \1/p' "$1"
sed -nE 's/^[- ]*Subnet: (.+)/subnet_address_prefixes = \1/p' "$1"
sed -nE 's/^[- ]*VM 이름: (.+)/vm_name = "\1"/p' "$1"
sed -nE 's/^[- ]*VM 크기: (.+)/vm_size = "\1"/p' "$1"
sed -nE 's/^[- ]*관리자 계정: (.+)/admin_username = "\1"/p' "$1"
sed -nE 's/^[- ]*서비스명: (.+)/service_name = "\1"/p' "$1"
sed -nE 's/^[- ]*팀명: (.+)/team_name = "\1"/p' "$1"
