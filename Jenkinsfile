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
    GIT_REPO =                       "https://github.com/haltaf/EKSPOC.git"
    DOCKER_IMAGE_NAME =              "ekspoc"
    CONTAINER_REGISTRY =             "376682452203.dkr.ecr.eu-west-1.amazonaws.com"
    CONTAINER_REGISTRY_CREDENTIALS = "AWS"
    SMART_CHECK_HOSTNAME =           "internal-adbe6e2acda2611e9b9f90a22f0b3998-896642001.eu-west-1.elb.amazonaws.com"
    SMART_CHECK_CREDENTIALS =        "smart-check-jenkins-user"
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
    stage('Scan') {
      twistlockScan ca: '',
      cert: '',
      compliancePolicy: 'critical',
      dockerAddress: 'unix:///var/run/docker.sock',
      gracePeriodDays: 0,
      ignoreImageBuildTime: true,
      image: 'dev/ubun2:test',
      key: '',
      logLevel: 'true',
      policy: 'warn',
      requirePackageUpdate: false,
      timeout: 10
    }

 }
}
