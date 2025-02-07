import os
import xml.etree.ElementTree as ET

# Define the TEI namespace
NS = {'tei': 'http://www.tei-c.org/ns/1.0'}

def update_graphic_urls(directory):
    for filename in os.listdir(directory):
        if filename.endswith(".xml"):  
            file_path = os.path.join(directory, filename)
            print(f"Processing: {file_path}")  # Debug print

            try:
                tree = ET.parse(file_path)
                root = tree.getroot()

                # Find <idno type="filename"> value
                idno_element = root.find(".//tei:idno[@type='filename']", NS)
                if idno_element is not None and idno_element.text:
                    new_url = idno_element.text.strip() + ".jpg"
                    print(f"Found IDNO: {new_url}")  # Debug print

                    changed = False  # Track changes
                    for graphic in root.findall(".//tei:graphic", NS):
                        # Check if "url" attribute exists but is empty or only whitespace
                        url_value = graphic.get("url", "").strip()
                        if not url_value:
                            graphic.set("url", new_url)
                            print(f"Updated <graphic> in {filename} → url='{new_url}'")  # Debug print
                            changed = True

                    if changed:
                        tree.write(file_path, encoding="utf-8", xml_declaration=True)
                        print(f"Saved changes to {filename}")  # Debug print
                    else:
                        print(f"No changes needed for {filename}")

                else:
                    print(f"No valid <idno type='filename'> found in {filename}")

            except Exception as e:
                print(f"Error processing {filename}: {e}")

# Run the script in the current directory
update_graphic_urls(".")