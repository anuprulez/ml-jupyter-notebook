# See http://ipython.org/ipython-doc/1/interactive/public_server.html for more information.
# Configuration file for ipython-notebook.
import os
import psutil

c = get_config()
c.ServerApp.token = ''
c.ServerApp.password = ''
c.ServerApp.ip = '0.0.0.0'
c.ServerApp.port = 8888
c.ServerApp.open_browser = True
#c.ServerApp.profile = u'default'
c.IPKernelApp.matplotlib = 'inline'

CORS_ORIGIN = ''
CORS_ORIGIN_HOSTNAME = ''

if os.environ['CORS_ORIGIN'] != 'none':
    CORS_ORIGIN = os.environ.get('CORS_ORIGIN', '')
    CORS_ORIGIN_HOSTNAME = CORS_ORIGIN.split('://')[1]

headers = {
    'X-Frame-Options': 'ALLOWALL',
    'Content-Security-Policy':
        "; ".join([
            f"default-src 'self' https: {CORS_ORIGIN}",
            f"img-src 'self' data: {CORS_ORIGIN} https: {CORS_ORIGIN}",
            f"connect-src 'self' ws://{CORS_ORIGIN_HOSTNAME}",
            f"style-src 'unsafe-inline' 'self' {CORS_ORIGIN}",
            f"script-src https: 'unsafe-inline' 'unsafe-eval' 'self' {CORS_ORIGIN}"
        ])
}


c.ServerApp.allow_origin = '*'
c.ServerApp.allow_credentials = True

c.ServerApp.base_url = '%s/ipython/' % os.environ.get('PROXY_PREFIX', '')
c.ServerApp.tornado_settings = {
    'static_url_prefix': '%s/ipython/static/' % os.environ.get('PROXY_PREFIX', '')
}

if os.environ.get('NOTEBOOK_PASSWORD', 'none') != 'none':
    c.ServerApp.password = os.environ['NOTEBOOK_PASSWORD']
    del os.environ['NOTEBOOK_PASSWORD']

if CORS_ORIGIN:
    c.ServerApp.allow_origin = CORS_ORIGIN

# monitor resource usage
c.ResourceUseDisplay.mem_limit = psutil.virtual_memory().total
c.ResourceUseDisplay.track_cpu_percent = True
c.ResourceUseDisplay.cpu_limit = os.cpu_count()

c.ServerApp.contents_manager_class = "jupytext.TextFileContentsManager"
c.ServerApp.tornado_settings['headers'] = headers
