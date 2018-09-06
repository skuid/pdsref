#!/usr/bin/env bash

enckey=$(cat /dev/urandom | LC_ALL=C tr -c -d 'a-zA-Z0-9' | fold -w 32 | head -n 1)

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
        sed -i '' "s|${condition}.*|$line|" $file
    fi
}

yum install docker

service docker start

curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) \
    -o /usr/bin/docker-compose
chmod a+x /usr/bin/docker-compose

mkdir env
envfile="env/warden"

addLine2File "WARDEN_ENCRYPTION_KEY=" "WARDEN_ENCRYPTION_KEY=${enckey}" "${envfile}"

printf "Would you like to start the local postgres image? [y|N] "
read custompg

if [ "${custompg}" == "y" ]
then
    pghost="postgres"
    pgport=5432
    pgdatabase="warden"
    pguser="warden"
    pgpassword="wardenDBpass"

    addUpdateLine2File "PGHOST=" "PGHOST=${pghost}" "${envfile}"
    addUpdateLine2File "PGPORT=" "PGPORT=${pgport}" "${envfile}"
    addUpdateLine2File "PGDATABASE=" "PGDATABASE=${pgdatabase}" "${envfile}"
    addUpdateLine2File "PGUSER=" "PGUSER=${pguser}" "${envfile}"
    addUpdateLine2File "PGPASSWORD=" "PGPASSWORD=${pgpassword}" "${envfile}"
else
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

    addUpdateLine2File "PGHOST=" "PGHOST=${pghost}" "${envfile}"
    addUpdateLine2File "PGPORT=" "PGPORT=${pgport}" "${envfile}"
    addUpdateLine2File "PGDATABASE=" "PGDATABASE=${pgdatabase}" "${envfile}"
    addUpdateLine2File "PGUSER=" "PGUSER=${pguser}" "${envfile}"
    addUpdateLine2File "PGPASSWORD=" "PGPASSWORD=${pgpassword}" "${envfile}"
fi


