load("@bazel_gazelle//:deps.bzl", "go_repository")

def go_repositories():
    go_repository(
        name = "com_github_jessevdk_go_flags",
        importpath = "github.com/jessevdk/go-flags",
        sum = "h1:1jKYvbxEjfUl0fmqTCOfonvskHHXMjBySTLW4y9LFvc=",
        version = "v1.5.0",
    )
    go_repository(
        name = "org_golang_x_sys",
        importpath = "golang.org/x/sys",
        sum = "h1:EZ2mChiOa8udjfp6rRmswTbtZN/QzUQp4ptM4rnjHvc=",
        version = "v0.0.0-20210320140829-1e4c9ba3b0c4",
    )
