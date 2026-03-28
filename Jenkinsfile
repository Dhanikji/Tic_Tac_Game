pipeline {
agent any


environment {
    REGISTRY = "registry.local:5000"
    APP_NAME = "tic-tac"
    IMAGE = "${REGISTRY}/${APP_NAME}:${BUILD_NUMBER}"
}

stages {

    stage('Clone') {
        steps {
            git branch: 'main',
                url: 'https://github.com/Dhanikji/Tic_Tac_Game.git'
        }
    }

    stage('Build') {
        steps {
            sh 'podman build -t ${APP_NAME}:${BUILD_NUMBER} .'
        }
    }

    stage('Tag') {
        steps {
            sh 'podman tag ${APP_NAME}:${BUILD_NUMBER} ${IMAGE}'
        }
    }

    stage('Push') {
        steps {
            sh 'podman push --tls-verify=false ${IMAGE}'
        }
    }

    stage('Deploy') {
        steps {
            sh '''
                helm upgrade --install ${APP_NAME} ./tic-tac \
                -n react-app \
                --create-namespace \
                --set image.repository=${REGISTRY}/${APP_NAME} \
                --set image.tag=${BUILD_NUMBER} \
                --set serviceAccount.create=false \
                --set autoscaling.enabled=false \
                --set ingress.enabled=false
            '''
        }
    }

    stage('Verify') {
        steps {
            sh 'kubectl get pods -n react-app'
        }
    }
}

post {
    success {
        echo "✅ Build #${BUILD_NUMBER} successfully deployed!"
    }
    failure {
        echo "❌ Build #${BUILD_NUMBER} failed!"
    }
}


}

