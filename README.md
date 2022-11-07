### Infrastructure project to deploy a microservice using ansible and terraform.
- **This project has the following details**
- **In this project lets consider the following.**
#### Infrastructure deployments.
Lets look at the pipeline configuration.
- **Our architecture contains an ansible playbook for deploying an RDS database and configuring connection to it using present pings. and troubleshoot connections.**
- **If the conditions are properly made then we have a steady deployment with the public schema running mysql queries.**
- **Also in this project was the need to configure a role that enables read and write access for the user.**</br>
- **Lastly and most importantly was the need to implement data retention and high availabilty settings by changing our portsfrom 5432(default) to 1337 to limit attacks to our instance**
#### Lets look at our microservice application</br>
- **To Deploy a javascript frontend to a java backend, We connect the strings with access in the same networks**</br>
- **I reengineered the maven code to meet the demands as specified for this project**</br>
- **Using docker compose amd kubernetes namespace or cloud subnetting is one very  key way of achieving this.**<\br>
- **To run this applications locally we copy the built javascript application to the `src/main/resources/static` folder and then sandwhich into the maven pom.xml file to serve the same network**</br>
![Architecture](https://github.com/Osiephri/Dev_che1/blob/master/assets/Blank%20board%20(3).png)</br>
**Looking at the above diagram we see the architecture in which this project was built.**
**This are the steps taken to efficiently deploy the application and put them in a highly available environment.**</br>
# Lets look at the  architecture and the microservice running this project
- **This application has a database connected to an ec2 node group that is deployed in a kubernetes environment.**
- **As seen above the infrastructure deploys to the infrastructure environment depending on the lifecyle set for it.**
![EKS and infrastructure](https://github.com/Osiephri/Dev_che1/blob/master/assets/Blank%20board%20(2).png)
** With this project we are able to perfroma full task as a devops engineer.**
**Tasks that included:**
- **Running `npm install --legacy-peer-deps` to install the node application**</br>
- **We used the command `npm run build` To minify into a build folder for production workflows.</br>
- **Copied the ./build content in the `src/main/java/resources` directory to serve the application</br>
- **Performed my infrastructure changes by creating a resource with terraform commands like `terraform init`,`terraform plan`,terraform apply --auto-approve`**</br>
- **Did docker compose files to test aftter deploying to an hub**
- **Wrote my master jenkinsfile which makes use of paramaters to sync the infrastructure to the whole workablity.*
- **Self sufficient in dealing with several other issues**
- **Built the docker container and started exporting to kubernetes**
- **strated exporting to helm and test.**
# Majority of the deatils are well provisioned with ansible and just for jenkins automation
**we are connected to several clients as we hope to always deliver the themes*
