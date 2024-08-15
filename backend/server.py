import json
from flask import Flask, jsonify, request

from storage_bucket_manager import StorageBucket
from image_generator import generate_image, get_text


app = Flask(__name__)
SB = StorageBucket()

@app.route("/")
def hello_world():
    return "Hello World"

@app.route("/status")
def hi_world():
    return "Our server is running."

@app.route("/get_daily_image")
def get_daily_image():
    with open("daily_img.txt","r") as file:
        result=json.load(file)
    return jsonify(result)

@app.route("/get_image",methods=["GET","POST"])
def get_image():
   request_data=request.json
   info=request_data.get("info")
   


   return "get_image"
generate_image(SB=SB)

if __name__ == "__main__":
    id=1
    app.run(host="0.0.0.0", port=80)