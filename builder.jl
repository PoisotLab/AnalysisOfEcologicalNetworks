using Weave

chapters_ = "chapters"
notebooks_ = "notebooks"
pdf_ = "pdf"

ispath("content") || mkdir("content")
for output in [chapters_, notebooks_, pdf_]
    ispath(joinpath("content", output)) || mkdir(joinpath("content", output))
end

chapters_content = joinpath.(chapters_, readdir(chapters_))
filter!(isfile, chapters_content)
filter!(p -> endswith(p, ".Jmd"), chapters_content)

for chapter in chapters_content
    root_name = first(split(last(split(chapter, "/")), ".Jmd"))
    @info "Weaving $(root_name)"
    weave(chapter, out_path=joinpath("content", chapters_))
end
