# app.py
import os
from __init__ import create_app
os.environ["TF_ENABLE_ONEDNN_OPTS"] = "0"
app = create_app()

if __name__ == '__main__':
    app.run(debug=True)