using Weave
using Latexify

chapters_ = "chapters"

ispath("content") || mkdir("content")

chapters_folders = joinpath.(chapters_, readdir(chapters_))

all_files = String[]

for chapter_folder in chapters_folders
    global all_files
    chapter_files = joinpath.(chapter_folder, readdir(chapter_folder))
    filter!(f -> endswith(f, "text.texw"), chapter_files)
    if length(chapter_files) == 1
        chapter_text = first(chapter_files)
        target = replace(chapter_text, ".texw"=>".tex")
        target_absent = !isfile(target)
        target_older = target_absent ? true : mtime(chapter_text) > mtime(target)
        if target_absent | target_older
            @info "Weaving $(chapter_folder)"
            weave(chapter_text; doctype="texminted")
        else
            @info "Skipping $(chapter_folder)"
        end
        push!(all_files, target)
    end
end

include_string = """
"""
for chapter_file in all_files
    global include_string
    include_string *= "\n\t\\input{../$(replace(chapter_file, "\\"=>"/"))}%"
end

open(joinpath("template", "chapters.tex"), "w") do f
    write(f, include_string)
end
