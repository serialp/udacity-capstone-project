node {
    def registry = 'serialp/udacity-capstone-project'
    stage('Checking out git repo') {
      echo 'Checkout...'
      checkout scm
    }
    stage('Checking environment') {
      echo 'Checking environment...'
      sh 'git --version'
      echo "Branch: ${env.BRANCH_NAME}"
      sh 'docker -v'
    }
    stage("Linting") {
      echo "Linting HTML Code"
            sh "tidy -qe *.html"
      //sh '/home/ubuntu/.local/bin/hadolint Dockerfile'
    }
    stage('Building image') {
	    echo 'Building Docker image...'
      withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
	     	sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"
	     	sh "docker build -t ${registry} ."
	     	sh "docker tag ${registry} ${registry}"
	     	sh "docker push ${registry}"
      }
    }
    stage('Deploying') {
      echo 'Deploying to AWS...'
      dir ('./') {
        withAWS(credentials: 'cheick', region: 'us-west-2') {
            sh "aws eks --region us-west-2 update-kubeconfig --name EKSCluster-OFEyNN5de2aT"
            sh "kubectl apply -f kubernetes-confs/aws-auth-cm.yaml"
            sh "kubectl set image deployment/capstone-app capstone-app=${registry}:latest"
            sh "kubectl apply -f kubernetes-confs/app-deployment.yaml"
            sh "kubectl get nodes"
            sh "kubectl get pods"
            //sh "aws cloudformation update-stack --stack-name udacity-capstone-nodes --template-body file://aws/worker_nodes.yml --parameters file://aws/worker_nodes_parameters.json --capabilities CAPABILITY_IAM"
        }
      }
    }
    stage("Cleaning up") {
      echo 'Cleaning up...'
      sh "docker system prune"
    }
}