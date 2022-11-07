### Infrastructure project to deploy a microservice using ansible and terraform.
- **This project has the following details**
- **In this project lets consider the following.**
#### Infrastructure deployments.
Lets look at the pipeline configuration.
- **Our architecture contains an ansible playbook for deploying an RDS database and configuring connection to it using present pings. and troubleshoot connections.**
- **If the conditions are properly made then we have a steady deployment with the public schema running mysql queries.**
- **Also in this project was the need to configure a role that enables read and write access for the user.</br>**
- **Lastly and most importantly was the need to implement data retention and high availabilty settings by changing our portsfrom 5432(default) to 1337 to limit attacks to our instance**
#### Lets look at our microservice application</br>
- **To Deploy a javascript frontend to a java backend, We connect the strings with access in the same networks**</br>
- **I reengineered the maven code to meet the demands as specified for this project**</br>
- **Using docker compose amd kubernetes namespace or cloud subnetting is one very  key way of achieving this.<\br>**
- **To run this applications locally we copy the built javascript application to the `src/main/resources/static` folder and then sandwhich into the maven pom.xml file to serve the same network</br>**
