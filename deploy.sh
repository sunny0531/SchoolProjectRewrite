#!/usr/bin/env bash
echo Moving into go
# shellcheck disable=SC2164
cd go
echo Building
env GOOS=linux GOARCH=arm64 go build -o build/school-project-linux-arm64 cmd/school-project/main.go
echo Leaving go
# shellcheck disable=SC2103
cd ..
echo Ansible task
ansible-playbook -i ansible/inventory.yaml ansible/playbook.yaml -K --tags "go"