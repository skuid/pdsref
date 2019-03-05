#!/usr/bin/env bash
set -e

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

wardenfile="env/warden"
clorthofile="env/clortho"

if [[ -f $wardenfile ]]; then
  echo "${wardenfile} already exists. Chickening out. Move the file and rerun this script if you want to run postgres locally."
  exit 1
fi

if [[ -f $clorthofile ]]; then
  echo "${clorthofile} already exists. Chickening out. Move the file and rerun this script if you want to run postgres locally."
  exit 1
fi

pghost="warden_postgres"
pgport=5432
pgdatabase="warden"
pguser="warden"
pgpassword="wardenDBpass"

addUpdateLine2File "PGHOST=" "PGHOST=${pghost}" "${wardenfile}"
addUpdateLine2File "PGPORT=" "PGPORT=${pgport}" "${wardenfile}"
addUpdateLine2File "PGDATABASE=" "PGDATABASE=${pgdatabase}" "${wardenfile}"
addUpdateLine2File "PGUSER=" "PGUSER=${pguser}" "${wardenfile}"
addUpdateLine2File "PGPASSWORD=" "PGPASSWORD=${pgpassword}" "${wardenfile}"

pghost="clortho_postgres"
pgport=6543
pgdatabase="clortho"
pguser="clortho"
pgpassword="clorthoDBpass"

addUpdateLine2File "PGHOST=" "PGHOST=${pghost}" "${clorthofile}"
addUpdateLine2File "PGPORT=" "PGPORT=${pgport}" "${clorthofile}"
addUpdateLine2File "PGDATABASE=" "PGDATABASE=${pgdatabase}" "${clorthofile}"
addUpdateLine2File "PGUSER=" "PGUSER=${pguser}" "${clorthofile}"
addUpdateLine2File "PGPASSWORD=" "PGPASSWORD=${pgpassword}" "${clorthofile}"
