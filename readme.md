# This repository creates a EKS Application in AWS

## 1 - Create an account in the AWS

## 2 - Install the Terraform

- 2.1 - Terraform Install

  ```
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
    sudo apt-get update && sudo apt-get install terraform
  
  ```


- 2.2 - Test the Terraform installation with this command and the output is like that:
  
  ``` 
    terraform version

  ```
    Terraform v1.2.2
    on linux_amd64

- 2.3 - Install the AWS CLI, I use this URL: <https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html>

  ```
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

    unzip awscliv2.zip

    sudo ./aws/install
  
  ```


- 2.4 - Testing the AWS CLI Installation and the output is like that:
  
  ```
    aws --version

  ```
    aws-cli/2.7.7 Python/3.9.11 Linux/5.10.16.3-microsoft-standard-WSL2 exe/x86_64.ubuntu.20 prompt/off


- 2.5 - Configure and Connect to AWS using CLI

  ```
    AWS Configure
  
  ```
    *Obs.: This command will request secrets to connect in your AWS Account


- 2.6 - Verify the account ID:

  ```
    aws sts get-caller-identity 
  
  ```


- 2.7 - Create S3 Private Classic to save your .TFSTATE file

    2.7.1 - *Obs.: The AWS doesn't allow to create S3 with the same name that already exist. 

    2.7.2 - You need to change the file provider.tf (line 11) the name of your private bucket before run terraform.

    2.7.3 - The provider has been configured to default eu-west-2 region, if you need to use different region and zones, you need to change to your region in provider.tf (line 13 and 19) and in main.tf (line 18, 33, 49 and 63), to your zones. 


- 2.8 - Install docker

    2.8.1 - Open the URL <https://docs.docker.com/engine/install/ubuntu/> and get the latest stable version of Docker

```
    sudo apt-get install \
        ca-certificates \
        curl \
        gnupg \
        lsb-release`

       sudo mkdir -p /etc/apt/keyrings`

        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg`
```


- 2.9 - Create an image of the application in the website directory

```
        docker build -t <private_repo>/web-app .

        docker push <private_repo>/web-app
        
        *Obs.: According you private repo, you need to change <private_repo> in manifests/deploy.yaml (line 17).
        If you don't change value, the default image tiagostello/web-app will be used. 


```
- 2.10 - You need to initiate the terraform with the terraform init command
```
   terraform init

      Initializing modules...
      
      Initializing the backend...
      
      Initializing provider plugins...
      
      Terraform has been successfully initialized!
      
      You may now begin working with Terraform. Try running "terraform plan" to see
      any changes that are required for your infrastructure. All Terraform commands
      should now work.
      
      If you ever set or change modules or backend configuration for Terraform,
      rerun this command to reinitialize your working directory. If you forget, other
      commands will detect it and remind you to do so if necessary.
```


- 2.11 - Now you can runs the Terraform Plan to see all the resources that you will create

```
    terraform plan
```

- 2.12 - Runs the terraform apply to create all resources. (--auto-approve is used to apply without confirmation)

```
    terraform apply --auto-approve
```

- 2.13 - Install Kubectl

```
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

- 2.14 - Update your kubeconfig to get the values from EKS.

```
    aws eks update-kubeconfig --name eks-app --region eu-west-2
```
    The command shows:
        Updated context arn:aws:eks:eu-west-2:************:cluster/eks-app in /home/******/.kube/config


- 2.15 - Try to get the Kubernetes Objects with kubectl
```
    kubectl get pods -A
    kubectl get ingress -n web-app
```
    the command shows:
    NAME              CLASS   HOSTS   ADDRESS                           PORTS   AGE
    ingress-web-app   alb     *       k8s-xxp-inxxessw-xxx.com          80      25m


- 2.15 - If you want to see the Kubernetes dashboard, you need to get the token with that command: 

```
    kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep eks-admin | awk '{print $1}')
```

    The example output is as follows.

    Name:         eks-admin-token-b5zv4
    Namespace:    kube-system
    Labels:       <none>
    Annotations:  kubernetes.io/service-account.name=eks-admin
                kubernetes.io/service-account.uid=bcfe66ac-39be-11e8-97e8-026dce96b6e8

    Type:  kubernetes.io/service-account-token

    Data
    ====
    ca.crt:     1025 bytes
    namespace:  11 bytes
    token:      <authentication_token>

- 2.16 - You need to copy <authentication_token>

- 2.17 - Runs the kubeproxy command

```
    kubectl proxy
```
    To access the dashboard endpoint, open the following link with a web browser: 
    <http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#!/login.>

    Choose Token, paste the <authentication_token> (according step 2.16) output from the previous command into the Token field, and choose SIGN IN.


- 2.18 - If you want to destroy, just runs the terraform destroy command (This command supported --auto-approve flag also)

```
  terraform destroy 
```