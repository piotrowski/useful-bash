#!/bin/bash

backup_volume () {
  volumes=( $(docker inspect --format='{{.Mounts}}' "$1" | awk 'BEGIN {RS="{"; FS=" "} NR>1 { printf "%s ", $2 }') )

  unique_volumes=( $(tr ' ' '\n' <<< "${volumes[@]}" | sort -u | tr '\n' ' ') )

  for volume in "${unique_volumes[@]}"; do
    docker run --rm -v "$(pwd)":/backup -v "$volume":/"$volume" busybox tar -zcf "/backup/$volume.tar.gz" "$volume"
  done
}

(
  read -r -p "Following script will stop a container while backuping files. Are you sure? [y/N]" response

  case "$response" in
    [yY][eE][sS]|[yY])
      docker_containers=( $@ )

      for container in "${docker_containers[@]}"; do
        echo "Backup of ${container} started."
        docker stop "$container" 1> /dev/null
        backup_volume "$container"
        docker start "$container" 1> /dev/null
      done
      ;;
    *)
      echo "Abort"
      ;;
  esac
)