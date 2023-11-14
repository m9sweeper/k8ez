# Run from Docker

### Step 1:
Copy the files from Alpine/Debian directory and paste it to the app's root directory. 

### Step 2:
Go to the app's directory (/code/hello-rails) and run the following commands to build the docker image and run the container. 
```sh
docker build -t myapp .
docker run --name myapp -p 3000:3000 myapp
```