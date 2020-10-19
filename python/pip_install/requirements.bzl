"Rules to verify and update pip-compile locked requirements.txt"

load("//python:defs.bzl", "py_binary", "py_test")
load("//python/pip_install:repositories.bzl", "requirement")

def compile_pip_requirements(
        name = "requirements",
        extra_args = [],
        visibility = ["//visibility:private"],
        **kwargs):
    """
    Produce two targets for checking pip-compile:

    - validate with `bazel test <name>_test`
    - update with   `bazel run <name>.update`
    
    By default requirements in file is expected to be <name>.in and output
    requirements txt lock file is expected to be <name>.txt. These may be customized
    with `requirements_in` and `requirements_locked` params.

    Args:
        name: string
        extra_args: passed to pip-compile
        visibility: passed to both the _test and .update rules
        **kwargs: other bazel attributes passed to the "_test" rule
    """
    requirements_in = kwargs.pop("requirements_in", name + ".in")
    requirements_txt = kwargs.pop("requirements_locked", name + ".txt")

    data = kwargs.pop("data", []) + [requirements_in, requirements_txt]

    loc = "$(rootpath %s)"

    # Use the Label constructor so this is expanded in the context of the file
    # where it appears, which is to say, in @rules_python
    pip_compile = Label("//python/pip_install:pip_compile.py")

    args = [
        loc % requirements_in,
        loc % requirements_txt,
        name + ".update",
    ] + extra_args

    py_binary(
        name = name + ".update",
        srcs = [pip_compile],
        main = pip_compile,
        args = args,
        visibility = visibility,
        deps = [
            requirement("click"),
            requirement("pip"),
            requirement("pip_tools"),
        ],
        data = data,
    )

    py_test(
        name = name + "_test",
        srcs = [pip_compile],
        main = pip_compile,
        args = args,
        visibility = visibility,
        deps = [
            requirement("click"),
            requirement("pip"),
            requirement("pip_tools"),
        ],
        data = data,
        **kwargs
    )
