pipeline {
    agent any
    environment {
        AWS_ACCOUNT_ID="129676970375"
        AWS_DEFAULT_REGION="us-east-1"
        IMAGE_REPO_NAME="gatling-runner"
        IMAGE_TAG="latest"
        AWS_REPORT_BUCKET="gatlingbkt"
        PROFILE="EcrRegistryFullAccessEC2"
        REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
    }

    // Logging to AWS ECR
    stages {

         stage('Logging into AWS ECR') {
            steps {
                script {
                sh "aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
                }

            }
        }


    // Building Docker images
    stage('Building image') {
      steps{
        script {
          dockerImage = docker.build "${IMAGE_REPO_NAME}:${IMAGE_TAG}"
        }
      }
    }

    // Uploading Docker images into AWS ECR
    stage('Pushing to ECR') {
     steps{
         script {
                sh "docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:$IMAGE_TAG"
                sh "docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG}"
         }
        }
    }

     // Run Gatling Image
    stage('Run Gatling Image') {
         steps{
             script {
                    sh "docker run --rm -v ${HOME}/.aws/credentials:/root/.aws/credentials:ro gatling-runner -r ${AWS_REPORT_BUCKET}-p ${PROFILE}"
             }
           }
        }
        
     stage('Create report') {
        steps{
           script {
              sh "./scripts/generateHTMLReport.sh -r ${AWS_REPORT_BUCKET}"
              gatlingArchive()
           }
        }
    }
    }
}
