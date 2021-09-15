import os
import galaxy_ie_helpers
from galaxy_ie_helpers import get
from galaxy_ie_helpers import put
from galaxy_ie_helpers import get_galaxy_connection
from get_dynamic_code import run_dynamic_code
HISTORY_ID = os.environ.get('HISTORY_ID', None)
