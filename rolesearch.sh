#!/bin/bash

rm ./roleswithhosts.txt
rm ./rolesnohosts.txt
rm ./allroles.txt
rm ./deadnodes.txt

knife role list > allroles.txt
for role in `tr '\n' ' ' < allroles.txt`
do 
  HOSTS=`cat ./empty.txt`
  EMPTY=`cat ./empty.txt`
  rm /tmp/rolesearchscratch.txt
  echo `knife search -i "roles:$role"` > /tmp/rolesearchscratch.txt
  HOSTS=`cat /tmp/rolesearchscratch.txt`
  if [ "$HOSTS" = "$EMPTY" ]; then
    echo $role >> ./rolesnohosts.txt
  else
    echo $role >> ./roleswithhosts.txt
    for host in $HOSTS
    do
      HOSTIP=`resolveip -s $host`
      if [ "$HOSTIP" = "$EMPTY" ]; then
        echo $host >> ./deadnodes.txt
      fi
    done
  fi
done
