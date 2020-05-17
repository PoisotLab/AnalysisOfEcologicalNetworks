using Weave

chapters_ = "chapters"

ispath("content") || mkdir("content")

chapters_folders = joinpath.(chapters_, readdir(chapters_))

all_files = String[]

for chapter_folder in chapters_folders
    global all_files
    chapter_files = joinpath.(chapter_folder, readdir(chapter_folder))
    filter!(f -> endswith(f, "text.texw"), chapter_files)
    if length(chapter_files) == 1
        @info "Weaving $(chapter_folder)"
        chapter_text = first(chapter_files)
        weave(chapter_text)
        push!(all_files, replace(chapter_text, ".texw"=>".tex"))
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
