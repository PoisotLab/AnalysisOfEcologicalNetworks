import Pkg; Pkg.activate(".")

using Weave

chapters_ = "chapters"
notebooks_ = "notebooks"

ispath(joinpath("content", chapters_)) || mkdir(joinpath("content", chapters_))
ispath(joinpath("content", notebooks_)) || mkdir(joinpath("content", notebooks_))

chapters_content = joinpath.(chapters_, readdir(chapters_))
filter!(isfile, chapters_content)
filter!(p -> endswith(p, ".Jmd"), chapters_content)

for chapter in chapters_content
    root_name = first(split(last(split(chapter, "/")), ".Jmd"))
    weave(chapter, out_path=joinpath("content", chapters_), doctype="github")
    #convert_doc(chapter, joinpath("content", "notebooks", root_name*".ipynb"))
end