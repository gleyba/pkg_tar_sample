_FILE_SIZE_SH = """
#!/usr/bin/env bash
stat -f%z 
""".strip()

def _file_size_impl(ctx):
    if ctx.attr.is_windows:
        fail("file_size is not supported on windows currently")

    out = ctx.actions.declare_file(ctx.attr.name)
    ctx.actions.write(
        output = out,
        content = "%s `readlink %s`" % (_FILE_SIZE_SH, ctx.file.file.short_path),
        is_executable = True
    )

    return DefaultInfo(
        executable = out,
        files = depset([out]),
        runfiles = ctx.runfiles(files = [
            out,
            ctx.file.file,
        ]),
    )

_file_size = rule(
    implementation = _file_size_impl,
    executable = True,
    attrs = {
        "file": attr.label(
            allow_single_file = True,
            mandatory = True,
            doc = "A file to report size of",
        ),
        "is_windows": attr.bool(mandatory = True),
    },
)

def file_size(**kwargs):
    _file_size(
        is_windows = select({
            "@bazel_tools//src/conditions:host_windows": True,
            "//conditions:default": False,
        }),
        **kwargs
    )
