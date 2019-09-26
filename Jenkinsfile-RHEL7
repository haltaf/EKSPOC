pipeline {
  
  environment {
    /*
    IMPORTANT!!! - Set the values for the following environment variables to match your environment.
    
    Note:  You must set up *Jenkins credentials* for the following script variables:
    - CONTAINER_REGISTRY_CREDENTIALS (kind: AWS Credentials)
    - SMART_CHECK_CREDENTIALS (kind: Username with password)
    - AWS_ECR_READ_CREDENTIALS (kind: Username with password)
    - KUBE_CONFIG (kind: Secret text)
    
    */
    GIT_REPO =                       "https://github.com/howie-howerton/jenkins-flask-tutorial.git"
    DOCKER_IMAGE_NAME =              "flask-docker"
    CONTAINER_REGISTRY =             "756757677343.dkr.ecr.us-east-1.amazonaws.com"
    CONTAINER_REGISTRY_CREDENTIALS = "ecr-credentials"
    SMART_CHECK_HOSTNAME =           "a645f47c9d59311e9b7120246f383e95-1289210322.us-east-1.elb.amazonaws.com"
    SMART_CHECK_CREDENTIALS =        "smart-check-jenkins-user"
    AWS_ECR_READ_CREDENTIALS =       "aws-ecr-read-credentials"
    //KUBE_CONFIG =                    "kubeconfig"
   // KUBE_YML_FILE_IN_GIT_REPO =      "flask-docker-kube.yml"
  }

  agent  any
  stages {
    stage("Cloning Git Repo") {
      steps {
        git "$GIT_REPO"
      }
    }

    stage("Building image") {
      steps{
        script {
          dockerImage = docker.build('$DOCKER_IMAGE_NAME:$BUILD_NUMBER')
        }
      }
    }

    stage("Stage Image") {
      steps{
        script {
          docker.withRegistry('https://$CONTAINER_REGISTRY', 'ecr:us-east-1:ecr-credentials' ) {
            dockerImage.push()
          }
        }
      }
    }

    stage("Smart Check Scan") {
        steps {
            withCredentials([
                usernamePassword([
                    credentialsId: AWS_ECR_READ_CREDENTIALS,
                    usernameVariable: "ACCESS_KEY_ID",
                    passwordVariable: "SECRET_ACCESS_KEY",
                ])             
            ]){            
                smartcheckScan([
                    imageName: "$CONTAINER_REGISTRY/$DOCKER_IMAGE_NAME:$BUILD_NUMBER",
                    smartcheckHost: "$SMART_CHECK_HOSTNAME",
                    insecureSkipTLSVerify: true,
                    smartcheckCredentialsId: SMART_CHECK_CREDENTIALS,
                    imagePullAuth: new groovy.json.JsonBuilder([
                        aws: [ 
                            region: "us-east-1", 
                            accessKeyID: ACCESS_KEY_ID, 
                            secretAccessKey: SECRET_ACCESS_KEY
                        ]
                    ]).toString(),
                    findingsThreshold: new groovy.json.JsonBuilder([
                        malware: 0,
                        vulnerabilities: [
                            defcon1: 0,
                            critical: 0,
                            high: 0,
                        ],
                        contents: [
                            defcon1: 0,
                            critical: 0,
                            high: 3,
                        ],
                        checklists: [
                            defcon1: 0,
                            critical: 0,
                            high: 0,
                        ],
                    ]).toString(),
                ])
              }
            }
        }
        

    stage ("Deploy to Cluster") {
      steps{
        echo "Deploying to Cluster..."
        //input 'Deploy to Kubernetes?'
        //milestone(1)
        //kubernetesDeploy(
         //   kubeconfigId: KUBE_CONFIG,
         //   configs: KUBE_YML_FILE_IN_GIT_REPO,
         //   enableConfigSubstitution: true
        //)
      }
    }
  }
}
