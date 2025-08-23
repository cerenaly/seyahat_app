// Define the buildscript block for plugin dependencies
buildscript {
    repositories {
        google() // Required for Google Services plugin
        mavenCentral() // Required for other dependencies
    }
    dependencies {
        classpath("com.google.gms:google-services:4.3.15") // Google Services plugin
    }
}



val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name);
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
