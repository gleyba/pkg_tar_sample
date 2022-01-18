def _pkg_tar_impl(ctx):
    output = ctx.actions.declare_file("%s.tar" % ctx.attr.name)
    args = ctx.actions.args()
    args.add("--output", output.path)
    args.add("--directory", ctx.attr.package_dir)
    inputs = []
    for src in ctx.files.srcs:
        inputs.append(src)
        args.add("--file", "%s:%s" % (src.path, src.basename))

    ctx.actions.run(
        arguments = [ args ],
        inputs = inputs,
        outputs = [ output ],
        executable = ctx.executable._pkg_tar,
    )

    return DefaultInfo(files = depset([output]))

pkg_tar = rule(
    implementation = _pkg_tar_impl,
    attrs = {
        "srcs": attr.label_list(
            allow_files = True,
            mandatory = True,
            doc = "A list of files that should be included in the archive.",
        ),
        "package_dir":  attr.string(
            default = "/",
            doc = "The directory in which to expand the specified files, defaulting to '/'"
        ),
        "_pkg_tar": attr.label(
            default = "//cmd/pkg_tar:pkg_tar",
            executable = True,
            cfg = "exec",
        ),
    },
)