#!/usr/bin/env bash


## Add a line to a file in a fairly idempotent way
addLine2File() {
    if [[ $# -eq 3 ]]; then
        condition=$1
        line=$2
        file=$3
    elif [[ $# -eq 2 ]]; then
        condition=$1
        line=$1
        file=$2
    else
        echo "Invalid number of arguments to addLine2File"
        exit 1
    fi

    if ! grep -qF "$condition" "$file"; then
        echo "Adding '$line' to $file"
        echo "$line" >> "$file"
    else
        echo "'$condition' already exists in $file. Doing nothing"
    fi
}

addUpdateLine2File() {
    if [[ $# -eq 3 ]]; then
        condition=$1
        line=$2
        file=$3
    else
        echo "Invalid number of arguments to addUpdateLine2File"
        exit 1
    fi

    if ! grep -qF "$condition" "$file"; then
        echo "Adding '$line' to $file"
        echo "$line" >> "$file"
    else
        echo "'$condition' already exists in $file. Replacing it instead"
        sed -i "s|${condition}.*|$line|" $file
    fi
}

yum -y install docker

service docker start

curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) \
    -o /usr/bin/docker-compose
chmod a+x /usr/bin/docker-compose

wardenfile="env/warden"
clorthofile="env/clortho"
mkdir env

if [[ -f $wardenfile ]]; then
    # ask user if they want to overwrite
    printf "Environment variable file ${wardenfile} exists, would you like to overwrite? This will lose all of your current settings [y|N] "
    read custompg

    if [ "${custompg}" == "y" ]; then
        writewarden=1
    fi
else
    writewarden=1
    enckey=$(cat /dev/urandom | LC_ALL=C tr -c -d 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    addLine2File "WARDEN_ENCRYPTION_KEY=" "WARDEN_ENCRYPTION_KEY=${enckey}" "${wardenfile}"
fi

if [[ $writewarden -eq 1 ]]; then
    echo "Enter the database details for Warden: -------"
    printf "PGHOST: "
    read pghost
    printf "PGPORT: "
    read pgport
    printf "PGDATABASE: "
    read pgdatabase
    printf "PGUSER: "
    read pguser
    printf "PGPASSWORD: "
    read -s pgpassword
    echo ""

    addUpdateLine2File "PGHOST=" "PGHOST=${pghost}" "${wardenfile}"
    addUpdateLine2File "PGPORT=" "PGPORT=${pgport}" "${wardenfile}"
    addUpdateLine2File "PGDATABASE=" "PGDATABASE=${pgdatabase}" "${wardenfile}"
    addUpdateLine2File "PGUSER=" "PGUSER=${pguser}" "${wardenfile}"
    addUpdateLine2File "PGPASSWORD=" "PGPASSWORD=${pgpassword}" "${wardenfile}"
fi

if [[ -f $clorthofile ]]; then
    # ask user if they want to overwrite
    printf "Environment variable file ${clorthofile} exists, would you like to overwrite? This will lose all of your current settings [y|N] "
    read overwrite

    if [ "${overwrite}" == "y" ]; then
        writeclortho=1
    fi
else
    writeclortho=1
fi

if [[ $writeclortho -eq 1 ]]; then
    echo "Enter the database details for Clortho: -------"
    printf "PGHOST: "
    read pghost
    printf "PGPORT: "
    read pgport
    printf "PGDATABASE: "
    read pgdatabase
    printf "PGUSER: "
    read pguser
    printf "PGPASSWORD: "
    read -s pgpassword
    echo ""

    addUpdateLine2File "PGHOST=" "PGHOST=${pghost}" "${clorthofile}"
    addUpdateLine2File "PGPORT=" "PGPORT=${pgport}" "${clorthofile}"
    addUpdateLine2File "PGDATABASE=" "PGDATABASE=${pgdatabase}" "${clorthofile}"
    addUpdateLine2File "PGUSER=" "PGUSER=${pguser}" "${clorthofile}"
    addUpdateLine2File "PGPASSWORD=" "PGPASSWORD=${pgpassword}" "${clorthofile}"
fi
