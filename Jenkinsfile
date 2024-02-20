#!groovy
@Library('silab') import com.ImageScanner

/**
 * pipeline script to build Java base images
 */

pipeline {
  agent {
    // this pipelines needs buildah installed on host
    label 'arm'
  }
  options {
    // Prevent running the same jobe in parallel
    disableConcurrentBuilds()

    // Abort build after 1 hour
    timeout(time: 1, unit: 'HOURS')

    // Remove old builds afer 30 days, keep max. 3 builds at the same time
    buildDiscarder(logRotator(daysToKeepStr:'30', numToKeepStr:'3', artifactDaysToKeepStr:'30', artifactNumToKeepStr:'3'))

    // Print timestamp for every log entry in console output
    timestamps()
  }

  parameters{
        booleanParam(name: 'PushImages', defaultValue: false, description: 'Push images also on non-master branches')
  }

  environment {
    // the docker registry to which the images should be pushed
    DOCKER_REGISTRY = 'auroranexus.smartstream-stp.com:5000'
  }

  stages {
    stage('Git checkout') {
      steps {
        checkout scm
      }
    }

    stage('Environment info') {
      steps {
        sh 'printenv | sort'
      }
    }
    stage('Build images') {
      parallel{
        stage('Cosign'){
          steps{
            sh 'bash ./buildah-build'
          }
        }
      }
    }
    stage('Push image') {
      when {
          anyOf { branch 'master'; expression {return params.PushImages}}
      }
      steps {
        sh 'podman push --tls-verify=false "${DOCKER_REGISTRY}/cosign:latest"'
      }
    }
    stage('Sign images'){
      steps{
        script {    
                withCredentials([
                    string(credentialsId: 'cosign-key-private-base64', variable: 'COSIGN_KEY_BASE64'), 
                    string(credentialsId: 'cosign-key-public-base64', variable: 'COSIGN_PUB_BASE64'),
                    string(credentialsId: 'cosign-key-password', variable: 'COSIGN_PASS'), 
                    usernamePassword(credentialsId: 'aurora-docker-auth', usernameVariable: 'OCI_LOGIN', passwordVariable: 'OCI_PASS')
                    ]) {
                              sh '''
                                podman run --rm \
                                -e COSIGN_PASS=${COSIGN_PASS}\
                                -e COSIGN_KEY=${COSIGN_KEY_BASE64}\
                                -e COSIGN_PUB=${COSIGN_PUB_BASE64}\
                                -e OCI_REGISTRY=${DOCKER_REGISTRY}\
                                -e OCI_PASS=${OCI_PASS}\
                                -e OCI_LOGIN=${OCI_LOGIN}\
                                ${DOCKER_REGISTRY}/cosign:latest sign ${DOCKER_REGISTRY}/cosign:latest'''
              }
        }
      }
    }
    
  }
}