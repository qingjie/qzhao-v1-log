def REGISTRY='https://hub.docker.com'
def ENV='dev'
def BRANCH='master'
def APP_NAMESPACE='jenkins'
def GIT_COMMIT=''

podTemplate(label: 'builder', containers: [
  containerTemplate(name: 'maven', image: 'maven:alpine', ttyEnabled: true, command: 'cat'),
  containerTemplate(name: 'kubectl', image: 'lachlanevenson/k8s-kubectl:v1.15.9', command: 'cat', ttyEnabled: true),
  containerTemplate(name: 'docker', image: 'docker', ttyEnabled: true, command: 'cat'),
  containerTemplate(name: 'helm', image: 'lachlanevenson/k8s-helm:v2.16.5', command: 'cat', ttyEnabled: true)
  ],
  serviceAccount: "jenkins", privileged: 'true',
  volumes: [
  hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock')
  ]) {

  node('builder') {
    try {

      echo "${BRANCH}:----------11111-------:${env.JOB_NAME}"

      stage('Clone') {
        echo '==========================1. Clone code from github/gitlab================================='
        git branch: "${BRANCH}", credentialsId: 'github-id-id_rsa', url: "git@github.com:qingjie/${env.JOB_NAME}.git"
        GIT_COMMIT = sh(returnStdout: true, script: "git rev-parse --short=8 HEAD").trim()
        echo "-------------------zhaoqingjie-----:${GIT_COMMIT}"
      }

      stage('Test') {
        echo '========================================2. Test============================================='
      }

      stage('Build a Maven project') {
        container('maven') {
          echo '==============================3. Build a Maven project===================================='
          sh "mvn -B -q clean compile test install"
        }
      }

      stage('Build Docker image') {
        container('docker') {
          echo '==============================4. Build Docker Image======================================='
          //sh "docker build -t ${env.JOB_NAME}-${ENV}:${GIT_COMMIT} -t ${env.JOB_NAME}-${ENV}:latest ."
          sh "docker build -t qzhao/qzhao-v1-log-1.0.0:v1 ."
          sh "docker tag qzhao/qzhao-v1-log-1.0.0:v1 qingjiezhao/qzhao-v1-log:${GIT_COMMIT}"
        }
      }

      stage('Push') {
        container('docker') {
          echo '==============================5. Push to Registry======================================='
            withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'Password', usernameVariable: 'Username')]){
              sh "docker login -u ${Username} -p ${Password}"
              //docker.image("${env.JOB_NAME}-${ENV}:${GIT_COMMIT}").push()
              //docker.image("${env.JOB_NAME}-${ENV}:latest").push()
              sh "docker push qingjiezhao/qzhao-v1-log:${GIT_COMMIT}"
             }   
            } 
      }
      stage('YAML') {
        echo '==============================6. Change YAML File Stage====================================='
        
        
      }

      stage('Deploy to Kubernetes'){
            container('kubectl') {
              echo '==========================7. Deploy to Kubernetes======================================'
              
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
              sh "sed -i 's/<VERSION>/${GIT_COMMIT}/g' deployment.yaml"
             
              if (userInput == "DEV") {
                  // deploy dev stuff
                 echo "======dev========="
                 sh "cat deployment.yaml"
                 sh "kubectl version"
                 //sh "kubectl create serviceaccount --namespace kube-system tiller"
                 //sh "kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller"
                 //sh "kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'"
                 //sh "kubectl apply -f deployment.yaml"
                
                 
              } else if (userInput == "QA"){
                  // deploy qa stuff
                 echo "=======qa========"
              } else {
                  // deploy prod stuff
                 echo "======PROD========="
              }

            }
      }
      
      stage('Deploy to Kubernetes with Helm'){
        
        container('helm') {
          echo '==============================7. Helm Stage====================================='
          sh "helm list"
          sh "helm init --client-only"
          sh "helm upgrade qzhao-v1-log ./qzhao-v1-log --install --set image.tag=${GIT_COMMIT}"
        }
      }
    } catch (e) {
        currentBuild.result = "FAILED"
    }
  }
}
