load("@bazel_skylib//:bzl_library.bzl", "bzl_library")

exports_files(["pip_compile.py"])

filegroup(
    name = "distribution",
    srcs = glob(["*.bzl"]) + [
        "BUILD",
        "pip_compile.py",
        "//python/pip_install/extract_wheels:distribution",
    ],
    visibility = ["//:__pkg__"],
)

bzl_library(
    name = "bzl",
    srcs = [
        "pip_repository.bzl",
        "repositories.bzl",
    ],
    visibility = ["//docs:__pkg__"],
)
