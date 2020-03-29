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
        

        stage('Build a Maven project') {
            container('maven') {
                mave --version
            }
        }

        stage('Build Docker image') {
            container('docker') {
                echo '==============================Build Docker Image======================================='
                docker info
                echo '==============================Push Docker Image======================================='
                
            }
        }

       
    } catch (e) {
        currentBuild.result = "FAILED"
        
    }
  }
}
