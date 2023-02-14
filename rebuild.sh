tag=docker.io/rjones30/gluex:latest
docker build --network host --tag $tag .
#docker build --no-cache --network host --tag $tag .
singularity build --sandbox out docker://registry.hub.docker.com/rjones30/gluex:latest
if [[ $? == 0 ]]; then
    echo -n "docker build --tag $tag completed successfully, to update the image "
    echo "on dockerhub you need to follow up with the command below."
    echo "$ sudo docker push $tag"
else
    echo -n "docker build --tag $tag failed, please fix the problems before you "
    echo "push the updates to dockerhub."
fi
