import Pkg
Pkg.activate(".")

using Weave

chapters_ = "chapters"

chapters_content = joinpath.(chapters_, readdir(chapters_))
filter!(isfile, chapters_content)
filter!(p -> endswith(p, ".Jmd"), chapters_content)

for chapter in chapters_content
    weave(chapter, out_path="dist", doctype="github")
end
