import Pkg
Pkg.activate(".")

using Weave

chapters_ = "chapters"
notebooks_ = "notebooks"

ispath(joinpath("dist", chapters_)) || mkdir(joinpath("dist", chapters_))
ispath(joinpath("dist", notebooks_)) || mkdir(joinpath("dist", notebooks_))

chapters_content = joinpath.(chapters_, readdir(chapters_))
filter!(isfile, chapters_content)
filter!(p -> endswith(p, ".Jmd"), chapters_content)

for chapter in chapters_content
    root_name = first(split(last(split(chapter, "/")), ".Jmd"))
    weave(chapter, out_path=joinpath("dist", chapters_), doctype="github")
    convert_doc(chapter, joinpath("dist", "notebooks", root_name*".ipynb"))
end

# Generate the index page
weave("README.md", informat="markdown", out_path=joinpath("dist", "index.md"), doctype="github")
