#!/bin/bash
#
# publish.sh - archives enterprise repo, scans for keys, creates github repo, uploads
#
# Copyright 2020 DXC Technology
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

for i in $*;
do
    echo $i;
    git clone git@github.dxc.com:soteria/${i}.git
    pushd ${i}
        git secrets --scan * || exit 1
        git archive --prefix dxc-soteria-${i}/ -o ../dxc-soteria-${i}.zip HEAD
    popd
    unzip -o dxc-soteria-${i}.zip
    pushd dxc-soteria-${i}
        git init
        curl https://www.apache.org/licenses/LICENSE-2.0.txt -o LICENSE
        git add *
        git commit -m "initial import"
        git branch -M master
        hub create --description "DXC Technology Labs (@dxc-labs) Project Soteria '${i}' component" \
            --homepage 'https://dxc.technology/opensource' --browse dxc-labs/dxc-soteria-${i}
        git push -u origin master
    popd
done
