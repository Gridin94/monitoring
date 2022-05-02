## Outbrain hame assignment

# Develop a tool that will spin up a Prometheus environment with Grafana

__Configure CI/CD pipelines to deploy the Node Weight Tracker application for 2 environments: Staging and Production.__

__In addition I've set a script that automatically changes the OKTA uris according to the running env.__

__In this project I have used everything we've learned so far and previous projects.__

## Prerequisites for the project

- __IaC with Terraform- Provisioning of two identical environments : [Week 6 project](https://github.com/Gridin94/Terraform/tree/CI-CD).__

- __Node Weight Tracker - The Bootcamp application which you can find [here](https://github.com/Gridin94/bootcamp-app) .__

Project environment:
![week-8-envs](https://camo.githubusercontent.com/5b41c84bd41e6a41560415440ee422765f39c0cafd7c2e755ee429d8fabb0a70/68747470733a2f2f626f6f7463616d702e7268696e6f70732e696f2f696d616765732f7765656b2d362d656e76732e706e67)



__Before using this project the following files should be edited:__

**inventories**
- **production**
  - hosts &emsp;&emsp;&emsp;__*# production nodes ip's*__

- **staging**

  - hosts &emsp;&emsp;&emsp;__*# staging nodes ip's*__

**group_vars:**

- all.yml


__Read documentation in source files.__

__In this project I implemented a CI/CD piplines as code.__
__First I've created a new pipline, then selected my project repository and then selected a Docker template to connect my `Azure Container Registry` with the pipeline.__

![docker build and push](https://user-images.githubusercontent.com/90269123/141819618-53fd2415-f947-4588-89a7-f4cc54b0b3b2.JPG)


![piplines](https://user-images.githubusercontent.com/90269123/141819654-d031cf9f-9f37-4962-a227-43fdf41df730.jpg)


In addition, I followed the 'feature branch workflow' by adding a branch policy for the master branch: __*any change need a code review and build validation before integrating them to the master branch.*__

![branch policy](https://user-images.githubusercontent.com/90269123/141818787-b9dfa300-0784-4616-b4a0-b28af01ad4ae.jpg)

I used 2 environments (staging / production) with their resources and variables to target the deployments from the pipline.

## Continuous Integration

When there is any change in the feature branch the CI process builds a Docker Image.

__Only__ when a feature branch integrated to the master branch the CI process get back into action and in addition to building a new image pushes the image to the Azure Container Registry.

## Continuous Deployment and Continuous Delivery

The continuous deployment and continuous delivery pipelines are similar except that the continuous delivery requires manual approval.

To make the continuous delivery pipline wait for approval I chose the environment I want and then `Approvals and checks > Add check > Approvals`.

To manage the dockers I've used ansible that pull the latest image from the Azure Container Registry and deploys it to the vms.