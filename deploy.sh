# TODO: 
# we will write a seperate script which will do below work:
# 1. Build all our images 
# 2. Tag each one 
# 3. push each to dockerhub

# Note : docker cmd which we are using here is the same that 
        # we used in previous .travis.yml(I mean login)
# build client image
docker build -t shailesh(dockerID)/multi-client -f ./client/Dockerfile ./client 
# build server image
docker build -t shailesh(dockerID)/multi-server -f ./server/Dockerfile ./server
# build server image
docker build -t shailesh(dockerID)/multi-worker -f ./worker/Dockerfile ./worker


####### Push image to docker hub ########
docker push shailesh(dockerID)/multi-client
docker push shailesh(dockerID)/multi-server
docker push shailesh(dockerID)/multi-worker


# we have push all the images so next step is 
# to read all the config/menifest files in k8's dir and apply them.
# kubectl is already installed as a part of .travis.yml file
# we will apply all the config/manifest files once just specifying folder name

kubectl apply -f k8s


# imperatively setting an latest created image to each deployments.
kubectl set image deployment/server-deployment server=shailesh(dockerID)/multi-server
# note server-deployment is the metadata name we have defined in yaml file and server is the container that going to be created.
# Note : As we have already discussed if we are building a new images then each time it'll be having Tag: latest
# but the problem is if we use above imperative cmd It'll go and check and say hey I see an image with latest Tag is already there..
# last time we have discussed to use versioning while building an image and same to be used with imperative cmd


########################################################
# I'll rewrite above code with updated Tag (latest + SHA) 
# please comment out above codes
#########################################################

# build client image with both Tag..
docker build -t shailesh(dockerID)/multi-client:latest -t shailesh(dockerID)/multi-client:$SHA -f ./client/Dockerfile ./client 
# build server image
docker build -t shailesh(dockerID)/multi-server:latest -t shailesh(dockerID)/multi-server:$SHA -f ./server/Dockerfile ./server
# build server image
docker build -t shailesh(dockerID)/multi-worker:latest -t shailesh(dockerID)/multi-worker:$SHA -f ./worker/Dockerfile ./worker


####### Push image to docker hub ########
docker push shailesh(dockerID)/multi-client:latest
docker push shailesh(dockerID)/multi-server:latest
docker push shailesh(dockerID)/multi-worker:latest

docker push shailesh(dockerID)/multi-client:$SHA
docker push shailesh(dockerID)/multi-server:$SHA
docker push shailesh(dockerID)/multi-worker:$SHA


kubectl apply -f k8s

kubectl set image deployment/server-deployment server=shailesh(dockerID)/multi-server:$SHA
kubectl set image deployment/client-deployment client=shailesh(dockerID)/multi-client:$SHA
kubectl set image deployment/worker-deployment worker=shailesh(dockerID)/multi-worker:$SHA