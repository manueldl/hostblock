#!/bin/sh
# hostblock.sh

umask 0022

blockdir='/etc/hosts.d'
adblock='http://winhelp2002.mvps.org/hosts.txt'
syshost='/etc/hosts'

merge() {
    echo "Merging "$blockdir"/*... "
    cat "$blockdir"/*.{conf,block}  > "$syshost"
}

update() {
    echo "Updating blocked hosts..."
    # Grepping only 0.0.0.0 starting lines for security reasons.
    curl -s "$adblock" | grep ^'0.0.0.0 ' > "$blockdir"/adblock.block
}

block() {
    echo "Blocking advertisements... "
    for i in "$blockdir"/*.unblock
    do
        mv "$f" "${f%.unblock}.block" 2> /dev/null
    done
}

unblock() {
    echo "Unblocking advertisements... "
    for i in "$blockdir"/*.block
    do
        mv "$f" "${f%.block}.unblock" 2> /dev/null
    done
}

if [ ! -d "$blockdir" ]
then
    mkdir -p "$blockdir" || exit 1
    echo "WARNING: Moving $syshost to $dir/hosts.conf"
    cat "$syshost" > "$blockdir/hosts.conf"
fi

for i in "$@"
do
    "$i"
done

