import os
import re

def replace_xml_headers(directory):
    old_header = (
        '<?xml version="1.0" encoding="UTF-8"?>\n'
        '<?xml-model href="http://www.stoa.org/epidoc/schema/latest/tei-epidoc.rng" schematypens="http://relaxng.org/ns/structure/1.0"?>\n'
        '<?xml-model href="http://www.stoa.org/epidoc/schema/latest/tei-epidoc.rng" schematypens="http://purl.oclc.org/dsdl/schematron"?>'
    )
    
    new_header = (
        '<?xml version="1.0" encoding="UTF-8"?>\n'
        '<?xml-model href="https://epidoc.stoa.org/schema/latest/tei-epidoc.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"?>\n'
        '<?xml-model href="https://epidoc.stoa.org/schema/latest/tei-epidoc.rng" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"?>'
    )
    
    for filename in os.listdir(directory):
        if filename.endswith(".xml"):  # Process only XML files
            file_path = os.path.join(directory, filename)
            with open(file_path, "r", encoding="utf-8") as file:
                content = file.read()
            
            updated_content = content.replace(old_header, new_header)
            
            if content != updated_content:  # Write only if changes were made
                with open(file_path, "w", encoding="utf-8") as file:
                    file.write(updated_content)
                print(f"Updated: {filename}")
            else:
                print(f"No changes needed: {filename}")

# Esegui la funzione sulla cartella desiderata
replace_xml_headers(".")