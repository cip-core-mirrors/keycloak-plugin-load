#!/bin/bash

if [ -z "$1" ]; then
    echo -e "\e[31m------> Please enter plugin definition file\e[0m"
    exit
fi

if [ -d "/tmp/plugins" ]; then
    ## Dir already exist
    echo "------> Plugins directory already exists"
else
    echo "------> Create plugin directory"
    mkdir '/tmp/plugins'
fi

if [ -f "/tmp/plugins/current.json" ]; then
    extension_array=($(jq '.[]' /tmp/plugins/current.json))
else
    declare -a extension_array
fi

declare -a clean_extension_array


wanted_extension=$(jq -cr '.[]' $1)

# Check unused extension
for row in ${extension_array[@]}; do

    if [[ ! ${wanted_extension[@]} =~ ${row} ]]; then
        echo "------> Delete unused extension ${row}"
        rm -rf "/tmp/plugins/$(echo $row | jq -r '.').jar"
    else
        clean_extension_array+=($row)
    fi
done

for row in ${wanted_extension[@]}; do

    name=$(echo ${row} | jq -r '.name')

    if [[ ! ${extension_array[@]} =~ ${name} ]]; then
        echo "------> Download ${name} plugin"

        clean_extension_array+=($(echo ${row} | jq '.name'))
        wget -q -O "/tmp/plugins/${name}.jar" $(echo ${row} | jq -r '.url')
    else
        echo "------> ${name} plugin already exist"
    fi
    
done

echo ${clean_extension_array[@]} | jq -s '.' > /tmp/plugins/current.json