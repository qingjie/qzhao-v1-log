def REGISTRY='https://hub.docker.com'
def ENV='dev'
def BRANCH='master'
def APP_NAMESPACE='jenkins'

podTemplate(label: 'builder', containers: [
  containerTemplate(name: 'maven', image: 'maven:alpine', ttyEnabled: true, command: 'cat'),
  containerTemplate(name: 'kubectl', image: 'lachlanevenson/k8s-kubectl:v1.10.5', command: 'cat', ttyEnabled: true),
  containerTemplate(name: 'docker', image: 'docker', ttyEnabled: true, command: 'cat')
  ], 
  serviceAccount: "jenkins", privileged: 'true', 
  volumes: [
  hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock')
  ]) {

  node('builder') {
    try {
       
       echo "${BRANCH}:----------11111-------:${env.JOB_NAME}"
       git branch: "${BRANCH}", credentialsId: 'github-id-id_rsa', url: "git@github.com:qingjie/${env.JOB_NAME}.git"
       def GIT_COMMIT = sh(returnStdout: true, script: "git rev-parse HEAD").trim()
       
       stage('Clone') {
            echo "Clone code from github/gitlab"
       }
       
       stage('Test') {
            echo "Clone code from github/gitlab"
       }
      
       stage('Build a Maven project') {
            container('maven') {
               sh "mvn -B -q clean compile test install"
            }
       }
      
       stage('Build Docker image') {
            container('docker') {
                echo '==============================Build Docker Image======================================='
                //sh "docker build -t ${env.JOB_NAME}-${ENV}:${GIT_COMMIT} -t ${env.JOB_NAME}-${ENV}:latest ."
                sh "docker build -t qzhao/qzhao-v1-log-1.0.0:v1 ."
                sh "docker tag qzhao/qzhao-v1-log-1.0.0:v1 qingjiezhao/qzhao-v1-log:${GIT_COMMIT}"
                echo '==============================Push Docker Image======================================='
                withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'Password', usernameVariable: 'Username')]){
                    sh "docker login -u ${Username} -p ${Password}"
                    //docker.image("${env.JOB_NAME}-${ENV}:${GIT_COMMIT}").push()
                    //docker.image("${env.JOB_NAME}-${ENV}:latest").push()
                    
                    
                    sh "docker push qingjiezhao/qzhao-v1-log:${GIT_COMMIT}"
                }
            }
        }
       
       stage('Push') {
            echo "Push to Registry"
       }
      
      stage('Deploy to Kubernetes'){
            container('kubectl') {
                
              echo '==========================Deploying Image======================================'

              def userInput = input(
                  id: 'userInput',
                  message: 'Choose a deploy environment',
                  parameters: [
                      [
                          $class: 'ChoiceParameterDefinition',
                          choices: "DEV\nQA\nPROD",
                          name: 'Env'
                      ]
                  ]
              )
              echo "This is a deploy step to ${userInput}"
              //sh "sed -i 's/<BUILD_TAG>/${build_tag}/' k8s.yaml"
              if (userInput == "DEV") {
                  // deploy dev stuff
                 echo "======dev========="
              } else if (userInput == "QA"){
                  // deploy qa stuff
                 echo "=======qa========"
              } else {
                  // deploy prod stuff
                 echo "======PROD========="
              }
    
            }
        }
       
    } catch (e) {
        currentBuild.result = "FAILED"
        
    }
  }
}
