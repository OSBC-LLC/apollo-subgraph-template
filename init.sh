#!/bin/bash

read -p "Enter module name: " VALUE
echo "replacing 'github.com/OSBC-LLC/apollo-subgraph-template' with:"
echo "           $VALUE"

sed -i -e "s+github.com/OSBC-LLC/apollo-subgraph-template+$VALUE+g"
