import os
import sys
sys.path.append('/opt/graphite/webapp')

try:
    from importlib import import_module
except ImportError:
    from django.utils.importlib import import_module

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'graphite.settings')  # noqa

from django.conf import settings
from django.core.wsgi import get_wsgi_application
from graphite.logger import log

application = get_wsgi_application()

# Initializing the search index can be very expensive. The import below
# ensures the index is preloaded before any requests are handed to the
# process.
log.info("graphite.wsgi - pid %d - reloading search index" % os.getpid())
import graphite.metrics.search  # noqa
