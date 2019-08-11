import os
import crossbar

os.environ["AUTOBAHN_USE_UMSGPACK"] = "1"
crossbar.run(["version"])
