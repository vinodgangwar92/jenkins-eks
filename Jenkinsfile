pipeline {
    agent any

    environment {
        IMAGE_NAME = "vinodgangwar92/ekslab"
        IMAGE_TAG  = "039"
    }

    stages {

        stage('Checkout Code from GitHub') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/vinodgangwar92/jenkins-eks.git'
            }
        }

        stage('Docker Build') {
            steps {
                bat '''
                docker build -t %IMAGE_NAME%:%IMAGE_TAG% .
                '''
            }
        }

        stage('Docker Login & Push') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-cred',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    bat '''
                    echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin
                    docker push %IMAGE_NAME%:%IMAGE_TAG%
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes (EKS)') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                    bat '''
                    set KUBECONFIG=%KUBECONFIG%

                    kubectl set image deployment/admin-dashboard admin-dashboard=%IMAGE_NAME%:%IMAGE_TAG%
                    kubectl apply -f deployment.yaml
                    kubectl apply -f service.yaml
                    '''
                }
            }
        }

    }

    post {
        always {
            echo "Pipeline completed!"
        }
        success {
            echo "Deployment to EKS successful!"
        }
        failure {
            echo "Build or Deployment failed!"
        }
    }
}
