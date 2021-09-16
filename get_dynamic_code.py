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
    job_client = jobs.JobsClient(gi)
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
    upload_job = gi.tools.upload_file(target_file_name, new_history["id"])
    upload_job_id = upload_job["jobs"][0]["id"]
    upload_job_status = job_client.get_state(upload_job_id)
    while upload_job_status in ["new", "queued", "running", "waiting"]:
        upload_job_status = job_client.get_state(upload_job_id)
        print(upload_job_status)
        sleep(5)
    hist_id = new_history["id"]
    upload_file_path = upload_job["outputs"][0]["id"]
    code_execute_job = gi.tools.run_tool(hist_id, tool_name, {"inputs": {"select_file": upload_file_path}})
    return job_client, upload_job, code_execute_job
