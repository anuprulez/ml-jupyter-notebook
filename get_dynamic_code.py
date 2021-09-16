import galaxy_ie_helpers
from time import sleep
from nbformat import read, NO_CONVERT
import bioblend
from bioblend.galaxy import GalaxyInstance
from bioblend.galaxy import histories


def run_dynamic_code(script_path, server, key, new_history_name="ml_analysis", tool_name="run_jupyter_job"):
    # connect to Galaxy
    #conn = galaxy_ie_helpers.get_galaxy_connection()
    #gi = conn.gi
    #new_history = gi.histories.create_history(new_history_name)
    gi = GalaxyInstance(server, key=key)
    history = histories.HistoryClient(gi)
    new_history = history.create_history(new_history_name)
    # get script
    from nbformat import read, NO_CONVERT
    with open(script_path) as fp:
        notebook = read(fp, NO_CONVERT)
    cells = notebook['cells']
    code_cells = [c for c in cells if c['cell_type'] == 'code']
    notebook_script = ""
    for cell in code_cells:
        notebook_script += cell.source + "\n\n"
    target_file_name = "target-file.py"
    with open(target_file_name, "w") as f_obj:
        f_obj.write(notebook_script)
    # upload script
    uploaded_dataset = gi.tools.upload_file(target_file_name, new_history["id"])
    sleep(40)
    hist_id = new_history["id"]
    uploaded_file_path = uploaded_dataset["outputs"][0]["id"]
    tool_run = gi.tools.run_tool(hist_id, tool_name, {"inputs": {"select_file": uploaded_file_path}})
    return tool_run
