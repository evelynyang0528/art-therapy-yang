import json
import os
from flask import Flask, jsonify, request
from flask_apscheduler import APScheduler
from audio_generator import generate_music, generate_prompt
from emotion_detector import get_emotion
from storage_bucket_manager import StorageBucket
from image_generator import generate_image, generate_journal_image, get_text


app = Flask(__name__)
scheduler = APScheduler()
scheduler.api_enabled = True
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
   image=generate_journal_image(SB=SB,journal=info)
   print(image)
   return jsonify({"image": image})

@app.route("/analyze_emotion_video",methods=["POST"])
def analyze_emotion():
    if "video" not in request.files:
      return jsonify({"error": "no videos found"})
    file=request.files["video"]
    file_name=file.filename
    local_path=f"{file_name}.mp4"
    file.save(local_path)
    # use the video to get emotion
    emotion=get_emotion(local_path)

    if os.path.exists(local_path):
        os.remove(local_path)

    # return emotion
    return jsonify({"emotion":emotion})



@app.route("/generate_audio",methods=["GET","POST"]) 
def generate_audio():
    request_data=request.json
    journal=request_data.get("journal")
    print(journal)
    audio_prompt="Smooth music" #generate_prompt(journal)
    duration = 15
    audiourl=generate_music(audio_prompt,duration,audio_prompt,SB=SB)
    return jsonify({"music_url": audiourl})


# for image
def schedule_image():
  generate_image(SB=SB)

if __name__ == "__main__":
    scheduler.add_job(
        id="schedule_daily_image",
        func=schedule_image,
        trigger="interval",
        hours = 24,
    )
    scheduler.init_app(app=app)
    scheduler.start()
    app.run(host="0.0.0.0", port=80)