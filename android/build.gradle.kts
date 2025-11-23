allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// Patch: ensure Android subprojects have a namespace to satisfy AGP 8+
subprojects {
    plugins.withId("com.android.application") {
        val androidExt = extensions.findByName("android")
        if (androidExt != null) {
            try {
                val getNs = androidExt.javaClass.methods.firstOrNull { it.name == "getNamespace" }
                val currentNs = getNs?.invoke(androidExt) as? String
                if (currentNs.isNullOrEmpty()) {
                    val setNs = androidExt.javaClass.methods.firstOrNull { it.name == "setNamespace" }
                    val nsValue = (project.group?.toString()?.takeIf { it.isNotEmpty() } ?: "com.example.${project.name}")
                    setNs?.invoke(androidExt, nsValue)
                }
            } catch (_: Exception) {
                // Ignore if extension does not support namespace yet
            }
        }
    }
    plugins.withId("com.android.library") {
        val androidExt = extensions.findByName("android")
        if (androidExt != null) {
            try {
                val getNs = androidExt.javaClass.methods.firstOrNull { it.name == "getNamespace" }
                val currentNs = getNs?.invoke(androidExt) as? String
                if (currentNs.isNullOrEmpty()) {
                    val setNs = androidExt.javaClass.methods.firstOrNull { it.name == "setNamespace" }
                    val nsValue = (project.group?.toString()?.takeIf { it.isNotEmpty() } ?: "com.example.${project.name}")
                    setNs?.invoke(androidExt, nsValue)
                }
            } catch (_: Exception) {
                // Ignore if extension does not support namespace yet
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
