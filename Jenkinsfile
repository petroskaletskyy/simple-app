def init

pipeline {
    agent any
    
    environment{
        IMAGE_TAG="${BUILD_NUMBER}-v2"    
    }    

    stages {
        stage('Git clone') {
            steps {
                git branch: 'main', 
                credentialsId: 'github-key', 
                url: 'https://github.com/petroskaletskyy/simple-app.git'
            }
        }
        stage('Docker build') {
            steps {
                sh 'docker build -t pskaletskyy/simple-app:$IMAGE_TAG .'
            }
        }
        stage('Push image to Dockerhub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'password', usernameVariable: 'username')]) {
                    sh 'docker login -u=${username} -p="${password}"'
                }
                sh 'docker push pskaletskyy/simple-app:$IMAGE_TAG'
            }
        }
        stage('Deploy Docker image to remote server') {
            steps {
                script {
                    def remote = [:]
                    remote.name = "node"
                    remote.host = "3.71.38.16"
                    remote.allowAnyHosts = true
                
                    withCredentials([sshUserPrivateKey(credentialsId: 'remore-server', keyFileVariable: 'key', usernameVariable: 'user')]) {
                        remote.user = user
                        remote.identityFile = key
                        sshCommand remote: remote, command: 'docker stop $(docker ps -qa) || true'
                        sshCommand remote: remote, command: 'docker rm $(docker ps -qa)  || true'
                        sh 'echo docker run -d -p 8082:80 pskaletskyy/simple-app:$IMAGE_TAG > run.sh'
                        sshPut remote: remote, from: 'run.sh', into: '/home/petro.skaletskyy'
                        sshCommand remote: remote, command: 'cat /home/petro.skaletskyy/run.sh | bash'
                        sshRemove remote: remote, path: '/home/petro.skaletskyy/run.sh'
                    }
                }
            }
        }
    }
}
