pipeline {
    agent any

    environment {
        GCP_PROJECT_ID2 = 'poshan-403704'
        APP_IMAGE_NAME = 'express-app'
        GAR_REGION = 'asia-south1' // Define the region for Artifact Registry
        GKE_CLUSTER_NAME = 'poshanclu'
        K8S_NAMESPACE = 'default'
    }

    stages {
        stage('Git Checkout') {
            steps {
                // Check out the source code from your Git repository
                checkout scm
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker version'
                sh 'docker build -t express-app .'
                sh 'docker image list'
            }
        }

        stage("Push Image to Artifact Registry") {
            steps {
                withCredentials([file(credentialsId: "poshan", variable: 'GC_KEY')]) {
                    sh "rm -f cred.json"
                    sh "ls -l"
                    sh "cp ${env:GC_KEY} cred.json"
                }
                script {
                    sh "gcloud auth activate-service-account --key-file=cred.json"
                    sh "docker tag express-app:latest ${GAR_REGION}-docker.pkg.dev/${GCP_PROJECT_ID2}/poshan/${APP_IMAGE_NAME}:${env.BUILD_ID}"
                    sh "gcloud auth configure-docker ${GAR_REGION}-docker.pkg.dev"
                    sh "docker push ${GAR_REGION}-docker.pkg.dev/${GCP_PROJECT_ID2}/poshan/${APP_IMAGE_NAME}:${env.BUILD_ID}"
                }
            }
        }

        stage('Deploy to GKE') {
            steps {
                script {
                    // Authenticate to GKE cluster
                    // sh "gcloud(project: GCP_PROJECT_ID2, credentialsId: 'poshan', clusterName: GKE_CLUSTER_NAME, zone: 'asia-south1-b')"
                    // Set the Kubectl context to your GKE cluster
                    sh "gcloud container clusters get-credentials ${GKE_CLUSTER_NAME} --zone asia-south1-b --project ${GCP_PROJECT_ID2}"

                    sh "sed -i 's/tagversion/${env.BUILD_ID}/g' deployment.yaml"

                    // Apply the Kubernetes manifest to deploy the application
                    sh "kubectl apply -f deployment.yaml -n ${K8S_NAMESPACE}"
                    sh "kubectl apply -f service.yaml -n ${K8S_NAMESPACE}"
                    cleanWs()
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline succeeded!'
            // Send a success notification
            emailext (
                subject: 'Pipeline Succeeded',
                body: 'Your Jenkins pipeline has succeeded!',
                to: 'cryptojeevan6@gmail.com',
                attachLog: false
            )
        }
        failure {
            echo 'Pipeline failed!'
            // Send a failure notification
            emailext (
                subject: 'Pipeline Failed',
                body: 'Your Jenkins pipeline has failed. Please look into it!',
                to: 'cryptojeevan6@gmail.com',
                attachLog: true
            )
        }
    }
}
