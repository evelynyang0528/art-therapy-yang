from flask import Flask

from backend.image_generator import get_text


app = Flask(__name__)


@app.route("/")
def hello_world():
    return "Hello World"

@app.route("/status")
def hi_world():
    return "Our server is running."


@app.route("/get_image")
def get_image():
    get_text()


    return "get_image"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)