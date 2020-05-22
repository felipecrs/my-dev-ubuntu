#!/usr/bin/env bash

set -euxo pipefail

vagrant destroy -f
vagrant box update
vagrant up
