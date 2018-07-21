#!/bin/bash
#
# generate python files based on the designer ui files. pyuic4/5 and pyrcc4/5
# should be on the path.
#
# based on build_ui.sh by Damien Elmes

shopt -s nullglob

if [[ ! -d "designer" ]]; then
    echo "Please run this from the project root."
    exit
fi

if [[ -z "$(find designer -name '*.ui')" ]]; then
    echo "No designer files found."
    exit
fi

function build_for_qt_version () {
    version="$1"
    pyuic_exec="pyuic${version}"
    form_dir="cloze_overlapper/forms${version}"
    if ! type "$pyuic_exec" >/dev/null 2>&1; then
        echo "${pyuic_exec} not found. Skipping generation."
        return 0
    fi
    rm -rf "$form_dir"
    mkdir -p "${form_dir}"
    init_file="${form_dir}/__init__.py"
    echo "Writing init file for ${form_dir}..."
    echo "# This file was auto-generated by build_ui.sh. Don't edit." > "${init_file}"
    for i in designer/*.ui; do
        name="${i##*/}"
        base="${name%.*}"
        outfile="$form_dir/${base}.py"
        echo "Generating ${outfile}"
        "$pyuic_exec" "$i" -o "${outfile}"
    done
}


for version in 4 5; do
    build_for_qt_version "${version}"
done
