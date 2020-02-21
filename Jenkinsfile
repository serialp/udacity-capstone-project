pipeline{
    agent any

    stages{
        stage("Linting"){
            steps{
                echo "Linting HTML Code"
                sh "tidy -qe *.html"
            }
        }
        stage("Build Docker Image"){
            steps{
                script {
                    app_image = docker.build("serialp/capstone-app")
                }
            }
        }
        stage ('Push Image to Registry') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub') {
                        app_image.push("${env.GIT_COMMIT[0..7]}")
                        app_image.push("latest")
                    }
                }
            }
        }
        stage ('Deploy to EKS') {
            steps {
                sh "kubectl set image deployments/capstone-app capstone-app=serialp/capstone-app:${env.GIT_COMMIT[0..7]} --record"
            }
        }
    }
}