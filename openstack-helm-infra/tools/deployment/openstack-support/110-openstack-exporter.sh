#!/bin/bash

#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.

set -xe

#NOTE: Lint and package chart
make prometheus-openstack-exporter
: ${OSH_INFRA_EXTRA_HELM_ARGS_OS_EXPORTER:="$(./tools/deployment/common/get-values-overrides.sh prometheus-openstack-exporter)"}

#NOTE: Deploy command
: ${OSH_EXTRA_HELM_ARGS:=""}
helm upgrade --install prometheus-openstack-exporter \
    ./prometheus-openstack-exporter \
    --namespace=openstack \
    ${OSH_EXTRA_HELM_ARGS} \
    ${OSH_INFRA_EXTRA_HELM_ARGS_OS_EXPORTER}
#NOTE: Wait for deploy
./tools/deployment/common/wait-for-pods.sh openstack
