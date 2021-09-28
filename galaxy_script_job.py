import galaxy_ie_helpers
from time import sleep
from nbformat import read, NO_CONVERT
import bioblend
from bioblend.galaxy import GalaxyInstance
from bioblend.galaxy import histories
from bioblend.galaxy import jobs


JOBS_STATUS = ["new", "queued", "running", "waiting"]


def __check_job_status(job_client, job_id, curr_job_status, finish_message):
    while curr_job_status in JOBS_STATUS:
        curr_job_status = job_client.get_state(job_id)
        if curr_job_status not in JOBS_STATUS:
            print(finish_message)
        else:
            sleep(5)


def upload_script_datasets(data_dict, server, key, new_history_name="ml_analysis"):
    new_data_dict = dict()
    new_history = None
    upload_message = "Uploaded code"
    gi = GalaxyInstance(server, key=key)
    history = histories.HistoryClient(gi)
    job_client = jobs.JobsClient(gi)
    new_history = history.create_history(new_history_name)
    for item in data_dict:
        upload_job = gi.tools.upload_file(data_dict[item], new_history["id"])
        upload_job_id = upload_job["jobs"][0]["id"]
        upload_job_status = job_client.get_state(upload_job_id)
        galaxy_url = "{}datasets/{}/display".format(server, upload_job['outputs'][0]["id"])
        new_data_dict[item] = list()
        new_data_dict[item].append((data_dict[item], galaxy_url))
        __check_job_status(job_client, upload_job_id, upload_job_status, upload_message)
    return {
        "u_job": upload_job,
        "data_path": new_data_dict
    }


def __find_replace_paths(script_file, data_dict):
    for item in data_dict:
        paths = data_dict[item]
        script_file.replace(paths[0], paths[1])
    print(script_file)
    return script_file


def run_script_job(data_dict, script_path, server, key, new_history_name="ml_analysis", tool_name="run_jupyter_job"):
    #connect to Galaxy
    #conn = galaxy_ie_helpers.get_galaxy_connection()
    #gi = conn.gi
    #new_history = gi.histories.create_history(new_history_name)
    upload_message = "Uploaded code"
    execute_message = "Executed code"
    gi = GalaxyInstance(server, key=key)
    history = histories.HistoryClient(gi)
    job_client = jobs.JobsClient(gi)
    new_history = history.create_history(new_history_name)
    # Run script
    # get script
    from nbformat import read, NO_CONVERT
    with open(script_path) as fp:
        notebook = read(fp, NO_CONVERT)
    cells = notebook['cells']
    code_cells = [c for c in cells if c['cell_type'] == 'code']
    notebook_script = ""
    for cell in code_cells:
        notebook_script += cell.source + "\n\n"
    notebook_script = __find_replace_paths(notebook_script, data_dict)
    target_file_name = "target-file.py"
    with open(target_file_name, "w") as f_obj:
        f_obj.write(notebook_script)
    # upload script
    upload_job = gi.tools.upload_file(target_file_name, new_history["id"])
    upload_job_id = upload_job["jobs"][0]["id"]
    upload_job_status = job_client.get_state(upload_job_id)
    __check_job_status(job_client, upload_job_id, upload_job_status, upload_message)
    hist_id = new_history["id"]
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
