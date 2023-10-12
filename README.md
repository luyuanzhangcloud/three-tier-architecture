# three-tier-architecture
In this project I created a three-tier web application.

1.	 Presentation Layer (Front-End): Customer can visit this application by putting in a simple domain name in their browser; Then the domain name thezhangagency.com will guide traffic to an application load balancer;
 
2.	Business Logic Layer (Middle Tier): This layer consists of VPC networking and servers; 

  1.	3 public subnets and 3 private subnets are created in a VPC; 
  2.	3 private subnets are needed to enable multi-AZ for MySQL RDS
  3.	The public subnets are accessible from internet through an internet gateway in the VPC;
  4.	The private subnets are associated with route tables that have route tos NAT gateways. This is needed in case the servers need to install update; However inbound traffic from internet outside the VPC cannot reach the servers;
  5.	To keep the servers secure, the servers’ security group only accepts inbound traffic from the load balancer;
  6.	Servers are launched and maintained by an auto scaling group that spans the private subnets to ensure high availability; 

3.	Data Layer (Back-End): Data is stored in server EBS root volumes, S3 bucket, and MySQL database.  
  .	Servers are authorized to read and write to a S3 central storage bucket through EC2 role; 
  .	Servers are also authorized to read and write to a MySQL database through EC2 role; 
	the database is multi-AZ enabled to ensure availability and durability;

If you are going to run the Terraform code, please make sure you have these:
	AWS cli user profile;    an S3 bucket for statefile;    a hosted zone and a domain name

Story 1: Create Networking Components in AWS  
These components were created: 
(1)	VPC: 1 VPC;
(2)	Subnets: total 6 subnets are created in 3 availabilty zones;   Each zone hosts 1 public subnet and 1 private subnet; The public subnets are for internet traffic routing;            The private subnets are to host the web servers and the database;
(3)	Internet gateway: 1 internet gateway attached to this VPC;
(4)	NAT gateways: 3 NAT gateways; one in each public subnet;
(5)	Route tables:1 public routable tables associate with the 3public subnets in zone 1a, 1b, and 1c; 
3 private route tables associated with the 3 private subnets; 
the private route tables each have one route to a NAT gateway in the same AZ;
(6)	Application load balancer: it is internet facing; balanced to the 3 public subnets; it SG allows https from anywhere; listens to port 80;  (see LoadBalancer.tf)
(7)	Launch template: for web servers; 1 launch template with no AZ specified; 
LT has instance profile attached to it which will allow the web servers access to S3 and RDS;
The SG of this LT allows http traffic from the load balancer;
Includes a user data in the bootstrap, that will install https and create an index.html
(8)	Auto scaling group: launch instances from the above LT; ensure at least 3 EC2 are running; (see AutoScalingGroup.tf)
(9)	Target group: EC2 instance launched from the above LT are automatically registered to a target group;
(10)	S3 bucket: an IAM role is created for EC2, with a S3 policy that grants EC2 full access to this bucket; the instance profile of this role is attached to the launch template; (see S3.tf)
(11)	MySQL cluster: multi-AZ enabled to ensure high availability in 3 AZ; its SG in bound rules allows port 3306 access from web servers that has a specific SG ID.  (see MySQL.tf)


Step 2: Ensure high availability
	High availability have been ensured through these network settings:
a.	multiple availability zone; each has 1 private subnet and 1 public subnet; each public subnet has public route table and NAT gateway; this makes sure that customers can always reach the load balancer, and I will always have one subnet working, and can access internet;
b.	Auto scaling group: if one server fails, the auto scaling group will launch another one to maintain availability; 
c.	Multi-AZ RDS: ensures that at least one MySQL engine is always available to the web servers;

Story 3: Enable Monitoring of the Three Tier Application
A CloudWatch alarm is created to monitor auto scaling group’s CPU utilization; When it is in alarm, a notification will be sent to my email; (See ASG_notification.tf)

Story 4; Storage
	I created 2 additional storages that centrally store some files and data that can be accessible by all servers: S3 bucket and MySQL RDS. (see s3.tf and MySQL.tf)
	IAM roles are created to allow servers full access to these storages.  (see IAM-Ec2-Role.tf)

Story 5: Access web application through DNS service
	When a customer request to access my domain name, the request will be routed to my load balancer as alias through simple routing. (see R53.tf)


Story 6: Architectural Design 
Please see the figures attached at the end of this file. The acceptance criteria states :“ We need to have architectural design that shows all the components of this Three Tier application. ”.  I believe the graph generated from terraform should have ALL the components. 
I also tried to generate the diagram using former2.com and cloudformation. I scanned my account, and selected the components in this infrastructure, then generate a .yaml file, and paste it into cloudformation. The diagram is not as pretty as I hoped.

Story 7: Deploy the Presentation Layer (Front-End) for Production Environment in a Different Region
To deploy this infrastructure in a different region, I only need to change the region and AZs in the variables.tf

Story 8: Deploy Three Tier Resources using Infrastructure as Code    
	All the components are created with Terraform, except the S3 bucket for the statefile, and the hosted zone for my domain.  In order to deploy this from a different account, you need to change these:
	User profile and credentials in provider.tf and backend.tf
	S3 bucket name in backend.tf
	hosted_zone_id in variables.tf

Story 9: Containerize the Web Application (Presentation Layer (Front-End)    
	The following are the steps to containerize the application and run in kubenetes. 
1.	Create a dockerfile, and name is “dockerfile”. The contents are as below.
FROM amazonlinux
RUN yum -y install httpd
RUN yum -y install git
RUN echo ?Hello World from $(hostname -f)? > /var/www/html/index.html

CMD ["/user/sbin/httpd", "-D", "FOREGROUND"]
EXPOSE 80
2.	Open git bash, go to the directory where the dockerfile is, and create an image from dockerfile
docker build -t my-app .
3.	Create a .yaml file my-app-deployment.yaml for deployment: 
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app-deployment
spec:
  replicas: 3  # Adjust the number of replicas as needed
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
        - name: my-app-container
          image: my-app
          ports:
            - containerPort: 80
4. run kubenete to deploy the application:
	kubectl  apply –f my-app-deployment.yaml
