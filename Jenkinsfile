pipeline
{
	agent any
	stages {
		stage('Trigger Image Build') {
			steps {
				script {
					echo "Triggering job for branch ${env.BRANCH_NAME}"
					BRANCH_TO_TAG=env.BRANCH_NAME.replace("/","%2F")
					build job: "../Build.Dist/${BRANCH_TO_TAG}", wait: false
				}
			}
		}
	}
}
