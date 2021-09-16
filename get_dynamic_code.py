import galaxy_ie_helpers
from time import sleep
from nbformat import read, NO_CONVERT


def run_dynamic_code(script_path, new_history_name="ml_analysis", tool_name="run_jupyter_job"):
    # connect to Galaxy
    conn = galaxy_ie_helpers.get_galaxy_connection()
    gi = conn.gi
    new_history = gi.histories.create_history(new_history_name)
    # get script
    notebook_script = ""
    target_file_name = "target-file.py"
    hist_id = new_history["id"]
    with open(script_path) as fp:
        notebook = read(fp, NO_CONVERT)
    cells = notebook['cells']
    code_cells = [c for c in cells if c['cell_type'] == 'code']
    for cell in code_cells:
        notebook_script += cell.source + "\n\n"
    with open(target_file_name, "w") as f_obj:
        f_obj.write(notebook_script)
    # upload script
    uploaded_dataset = gi.tools.upload_file(target_file_name, hist_id)
    sleep(20)
    uploaded_file_path = uploaded_dataset["outputs"][0]["id"]
    tool_run = gi.tools.run_tool(hist_id, tool_name, {"inputs": {"select_file": uploaded_file_path}})
    return tool_run
