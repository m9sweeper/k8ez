# k8ez

Deploying apps should be easy! But all to often, its not. And deploying them in a secure way should be easy, too! 

k8ez makes it easy by providing a solid helm chart for deploying your apps. This helm chart can be used to deploy apps just a configuration file and a one-line command. 
If you need to modify it, feel free to copy-paste it or fork it. We release this simply as a tool to make building and deploying software to Kubernetes as easy as possible. 

# Getting Started

Assuming you already have helm installed and setup on your machien, deploying a simple app to kubernetes can be as simple as this: 

    git clone https://github.com/m9sweeper/k8ez.git
    helm upgrade --install --wait MY_APP_NAME ./k8ez/charts/k8ez --set-string image.image=MY_IMG_URL --set service.port=8080

You also may want to consider setting up a simple values file where you could put any configuration parameters, such as this (setting only what is required):

    # Configure the number of pods for this service.  If autoscale is enabled, replica count is not used.
    replicaCount: 2
    autoscale:
    enabled: false
    minPods: 2
    maxPods: 4
    cpuAverageUtilizationThreshold: 70
    
    # Enable and configure a service
    service:
    type: ClusterIP
    port: 80
    
    # Configure resources it will be given
    resources:
      limits:
        cpu: 300m
        memory: 512Mi
      requests:
        cpu: 50m
        memory: 128Mi
    
    # set service details
    service:
      type: ClusterIP
      port: 80
    
    ingress:
      hosts: []
        # Add lists of hosts
        # - example.local
        #- "localhost"
      path: /
    
      # Deploys a Kubernetes Ingress resource
      k8sIngress:
        enabled: true

Which could then be deployed like this: 

    helm upgrade --install --wait MY_APP_NAME ./k8ez/charts/k8ez --set-string image.image=MY_IMG_URL --values values.yaml

If k8ez does not quite do enough, you can either fork it and add to it, or create a /template-shims folder in your code repository and add it in when deploying: 

    cp -r template-shims/ k8ez/charts/k8ez/templates

# Features

 - Deployments and their typical parameters
 - Autoscaling
 - Services
 - Extra Services
 - Ingress (K8s Standard Ingress as well as Istio Ingress)
 - Extra Deployments
 - Stateful Sets
 - Cron Jobs
 - Jobs
 - Volume Mounts
 - Pod Disruption Budgets
 - Image Pull Secrets
 - Has reasonable defaults on security context

For a full list of options, see [charts/k8ez/values.yaml](charts/k8ez/values.yaml).

# Docker Images

We have built out sample docker images for a variety of technology stacks. We will continue to add more examples with the goal
of making it easier for people to compile and deploy their code. 

Each image (ideally) is built such that: 

 - Images are available for alpine or debian
 - It installs dependencies (using whatever is typical for the tech stack)
 - Apps run as a non-root user
 - Apps log to stdout

# Contribute

Contributions are welcome! Submit pull requests or bugfixes and DO NOT break backwards compatibility! 

We hope that this project will make it easier than ever for people to use Kubernetes to deploy their applications. 

