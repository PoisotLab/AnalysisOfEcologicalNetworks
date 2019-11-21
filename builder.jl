import Pkg
Pkg.activate(".")

using Weave

chapters_ = "chapters"

ispath(joinpath("dist", chapters_)) || mkdir(joinpath("dist", chapters_))
ispath(joinpath("dist", "notebooks")) || mkdir(joinpath("dist", "notebooks"))

chapters_content = joinpath.(chapters_, readdir(chapters_))
filter!(isfile, chapters_content)
filter!(p -> endswith(p, ".Jmd"), chapters_content)

for chapter in chapters_content
    weave(chapter, out_path=joinpath("dist", chapters_), doctype="github")
end
