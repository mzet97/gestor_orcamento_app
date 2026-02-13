allprojects {
    repositories {
        google()
        mavenCentral()
    }

    // Fix for isar_flutter_libs lStar issue
    configurations.all {
        resolutionStrategy {
            force("androidx.core:core-ktx:1.12.0")
            force("androidx.appcompat:appcompat:1.6.1")
        }
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
                    val setNs = androidExt.javaClass.methods.firstOrNull { it.name ==="setNamespace" }
                    val nsValue = (project.group?.toString()?.takeIf { it.isNotEmpty() } ?: "com.example.${project.name}")
                    setNs?.invoke(androidExt, nsValue)
                }
            } catch (_: Exception) {
                // Ignore if extension does not support namespace yet
            }
        }
    }
}

// Patch específico para isar_flutter_libs - forçar compileSdk 34 e resolver lStar
subprojects {
    if (name.contains("isar_flutter_libs")) {
        afterEvaluate {
            extensions.findByName("android")?.let { androidExt ->
                try {
                    val setCompileSdk = androidExt.javaClass.getMethod("setCompileSdk", Int::class.javaObjectType)
                    setCompileSdk.invoke(androidExt, 34)
                } catch (_: Exception) {
                    // Ignore
                }
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
