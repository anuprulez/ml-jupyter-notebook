import galaxy_ie_helpers
from time import sleep
from nbformat import read, NO_CONVERT
import bioblend
from bioblend.galaxy import GalaxyInstance
from bioblend.galaxy import histories
from bioblend.galaxy import jobs


JOBS_STATUS = ["new", "queued", "running", "waiting"]
EXTRACTED_CODE_FILE_NAME = "extracted_code.py"


def __check_job_status(job_client, job_id, curr_job_status, finish_message):
    while curr_job_status in JOBS_STATUS:
        curr_job_status = job_client.get_state(job_id)
        if curr_job_status not in JOBS_STATUS:
            print(finish_message)
        else:
            sleep(5)


def __find_replace_paths(script_file, updated_data_dict):
    for item in updated_data_dict:
        g_path = updated_data_dict[item]
        script_file = script_file.replace(item, g_path)
    return script_file


def __get_conn(server=None, key=None):
    gi = None
    if server is None or key is None:
        conn = galaxy_ie_helpers.get_galaxy_connection()
        gi = conn.gi
    else:
        gi = GalaxyInstance(server, key=key)
    return gi


def run_script_job(script_path, data_dict=[], server=None, key=None, new_history_name="ml_analysis", tool_name="run_jupyter_job"):
    file_upload_message = "Data file uploaded"
    upload_message = "Uploaded code"
    execute_message = "Executed code"
    gi = __get_conn(server, key)
    history = histories.HistoryClient(gi)
    job_client = jobs.JobsClient(gi)
    updated_data_dict = dict()
    new_history = None
    new_history = history.create_history(new_history_name)
    # collect all Galaxy specific URLs
    for item in data_dict:
        upload_job = gi.tools.upload_file(item, new_history["id"])
        upload_job_id = upload_job["jobs"][0]["id"]
        upload_job_status = job_client.get_state(upload_job_id)
        galaxy_url = "{}datasets/{}/display".format(server, upload_job['outputs'][0]["id"])
        updated_data_dict[item] = galaxy_url
        __check_job_status(job_client, upload_job_id, upload_job_status, file_upload_message)
    hist_id = new_history["id"]
    # get script
    from nbformat import read, NO_CONVERT
    with open(script_path) as fp:
        notebook = read(fp, NO_CONVERT)
    cells = notebook['cells']
    code_cells = [c for c in cells if c['cell_type'] == 'code']
    notebook_script = ""
    for cell in code_cells:
        notebook_script += cell.source + "\n\n"
    # replace URLs from jupyter notebook by Galaxy specific URLs 
    notebook_script = __find_replace_paths(notebook_script, updated_data_dict)

    with open(EXTRACTED_CODE_FILE_NAME, "w") as f_obj:
        f_obj.write(notebook_script)

    # upload script
    upload_job = gi.tools.upload_file(EXTRACTED_CODE_FILE_NAME, hist_id)
    upload_job_id = upload_job["jobs"][0]["id"]
    upload_job_status = job_client.get_state(upload_job_id)
    __check_job_status(job_client, upload_job_id, upload_job_status, upload_message)

    # run script
    upload_file_path = upload_job["outputs"][0]["id"]
    code_execute_job = gi.tools.run_tool(hist_id, tool_name, {"inputs": {"select_file": upload_file_path}})
    code_execute_id = code_execute_job["jobs"][0]["id"]
    code_execute_status = job_client.get_state(code_execute_id)
    __check_job_status(job_client, code_execute_id, code_execute_status, execute_message)
    return {
        "job_client": job_client, 
        "u_job": upload_job,
        "e_job": code_execute_job
    }
