#!/bin/bash

rm ./roleswithhosts.txt
rm ./rolesnohosts.txt
rm ./allroles.txt
rm ./deadnodes.txt
rm ./unsortednodes.txt

knife role list > allroles.txt

for role in `tr '\n' ' ' < allroles.txt`
do 
  HOSTS=`cat ./empty`
  EMPTY=`cat ./empty`
  rm /tmp/rolesearchscratch.txt
  echo `knife search -i "roles:$role"` > /tmp/rolesearchscratch.txt
  HOSTS=`cat /tmp/rolesearchscratch.txt`
  if [ "$HOSTS" = "$EMPTY" ]; then
    echo $role >> ./rolesnohosts.txt
  else
    echo $role >> ./roleswithhosts.txt
    for host in $HOSTS
    do
      HOSTIP=`dig +short $host`
      if [ "$HOSTIP" = "$EMPTY" ]; then
        echo $host >> ./unsortednodes.txt
      fi
    done
  fi
done

cat ./unsortednodes.txt | sort | uniq > ./deadnodes.txt
