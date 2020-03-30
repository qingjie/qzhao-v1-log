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
        echo "----------11111-------"
        //${env.JOB_NAME}
        //git branch: "${BRANCH}", credentialsId: 'git', url: "git@github.com:qingjie/${env.JOB_NAME}.git"
        echo "----------2222-------"
        //def GIT_COMMIT = sh(returnStdout: true, script: "git rev-parse HEAD").trim()
        echo "----------3333-------"
        stage('Build a Maven project') {
            container('maven') {
                sh "mvn --version"
            }
        }

        stage('Build Docker image') {
            container('docker') {
                echo '==============================Build Docker Image======================================='
                sh "docker info"
                withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'Password', usernameVariable: 'Username')]) {
            
                    sh "docker login -u ${Username} -p ${Password}"
                    sh "cat /root/.docker/config.json"
                    //sh "docker push cnych/jenkins-demo:${build_tag}"
                }
                echo '==============================Push Docker Image======================================='
                
            }
        }
      
      stage('Push') {
        echo "4.Push Docker Image Stage"
        
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
