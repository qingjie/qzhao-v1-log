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
                echo '==============================Push Docker Image======================================='
                
            }
        }
      
        stage('Deploy to Kubernetes'){
            container('kubectl') {
                
              echo '==========================Deploying Image======================================'
               

            )
            def userInput = input(
                id: 'userInput',
                message: 'Choose a deploy environment',
                parameters: [
                    [
                        $class: 'ChoiceParameterDefinition',
                        choices: "Dev\nQA\nProd",
                        name: 'Env'
                    ]
                ]
            )
            echo "This is a deploy step to ${userInput}"
            }
        }

       
    } catch (e) {
        currentBuild.result = "FAILED"
        
    }
  }
}
