# Run from Dockerfile

### Step 1:

Copy the files from Alpine/Debian directory and paste it to the app's root directory.

### Step 2:

Go to the app's root directory and run the following docker commands:

```
docker build -t myapp .
docker run --name myapp -p 3000:3000 myapp
```
