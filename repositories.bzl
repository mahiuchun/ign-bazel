load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def tinyxml2():
    native.new_local_repository(
        name = "tinyxml2",
        path = "/usr/include",
        build_file = "//ign_bazel/third_party:tinyxml2.BUILD",
    )

def freetype():
    native.new_local_repository(
        name = "freetype2",
        path = "/usr/include/freetype2",
        build_file_content = """
package(default_visibility = ["//visibility:public"])
cc_library(
    name = "headers",
    hdrs = glob(["**/*.h"])
)
""",
    )

def eigen3():
    _maybe(
        http_archive,
        name = "eigen3",
        build_file = "//ign_bazel/third_party:eigen3.BUILD",
        sha256 = "ca7beac153d4059c02c8fc59816c82d54ea47fe58365e8aded4082ded0b820c4",
        strip_prefix = "eigen-eigen-f3a22f35b044",
        urls = [
            "http://mirror.bazel.build/bitbucket.org/eigen/eigen/get/f3a22f35b044.tar.gz",
            "https://bitbucket.org/eigen/eigen/get/f3a22f35b044.tar.gz",
        ],
    )

def ogre_repositories():
    freetype()

def ign_bazel_repositories():
    _maybe(
        http_archive,
        name = "rules_python",
        strip_prefix = "rules_python-master",
        urls = ["https://github.com/bazelbuild/rules_python/archive/master.zip"],
    )

    _maybe(
        http_archive,
        name = "gtest",
        strip_prefix = "googletest-master",
        urls = ["https://github.com/google/googletest/archive/master.zip"],
    )

def ign_math_repositories():
    eigen3()

def ign_common_repositories():
    native.new_local_repository(
        name = "glib",
        path = "/usr/include/glib-2.0",
        build_file_content = """
package(default_visibility = ["//visibility:public"])
cc_library(
    name = "headers",
    hdrs = glob(["**/*.h"])
)
""",
    )
    native.new_local_repository(
        name = "glibconfig",
        path = "/usr/lib/x86_64-linux-gnu/glib-2.0/include",
        build_file_content = """
package(default_visibility = ["//visibility:public"])
cc_library(
    name = "headers",
    hdrs = glob(["**/*.h"])
)
""",
    )

def ign_msgs_repositories():
    _maybe(
        http_archive,
        name = "rules_proto",
        sha256 = "602e7161d9195e50246177e7c55b2f39950a9cf7366f74ed5f22fd45750cd208",
        strip_prefix = "rules_proto-97d8af4dc474595af3900dd85cb3a29ad28cc313",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/rules_proto/archive/97d8af4dc474595af3900dd85cb3a29ad28cc313.tar.gz",
            "https://github.com/bazelbuild/rules_proto/archive/97d8af4dc474595af3900dd85cb3a29ad28cc313.tar.gz",
        ],
    )

    tinyxml2()

def ign_physics_repositories():
    eigen3()

def ign_fuel_tools_repositories():
    native.new_local_repository(
        name = "json",
        path = "/usr/include/jsoncpp",
        build_file_content = """
package(default_visibility = ["//visibility:public"])
cc_library(
    name = "headers",
    hdrs = glob(["**/*.h"])
)
""",
    )

def ign_gui_repositories():
    native.new_local_repository(
        name = "qt",
        build_file = "//ign_bazel/third_party:qt.BUILD",
        path = "/usr/include/x86_64-linux-gnu/qt5/",
    )

def ignition_repositories():
    ogre_repositories()
    ign_bazel_repositories()
    ign_math_repositories()
    ign_common_repositories()
    ign_msgs_repositories()
    ign_physics_repositories()
    ign_fuel_tools_repositories()
    ign_gui_repositories()

def _maybe(repo_rule, name, **kwargs):
    if name not in native.existing_rules():
        repo_rule(name = name, **kwargs)
