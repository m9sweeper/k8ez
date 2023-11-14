# RUN FROM DOCKER

### Step 1: 

Copy file contents from Alpine/Debian folder and paste those in the project root directory. 

### Step 2:
Run the following commands to build the image and create container for Alpine/Debian based image.
```sh
docker build -t myapp .
docker run --name myapp -p 3000:3000 myapp
```


