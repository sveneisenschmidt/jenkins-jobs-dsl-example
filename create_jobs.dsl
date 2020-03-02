job("create-jobs") {

    def jenkinsJobRepository          = "${JENKINS_JOB_REPOSITORY}"

	description("Creates and updates jobs from $jenkinsJobRepository")
	keepDependencies(false)
	disabled(false)
	concurrentBuild(false)

	steps {
	    shell("ls -a")
		dsl {
			ignoreExisting(false)
			removeAction("DISABLE")
			removeViewAction("DELETE")
			lookupStrategy("SEED_JOB")
			external("./**/*.dsl")
		}
	}

	scm {
	    git {
            id = 'jenkins-jobs'
            branch("master")
            remote {
                url("$jenkinsJobRepository")
            }
        }
	}

	wrappers {
		preBuildCleanup {
			deleteDirectories(false)
			cleanupParameter()
		}
		copyDataToWorkspacePlugin {
            folderPath("./jobs-dsl")
            makeFilesExecutable(false)
            deleteFilesAfterBuild(false)
		}
	}
}
