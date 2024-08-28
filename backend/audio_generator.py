
import urllib
import json
import os
import re
import subprocess
from openai import OpenAI

import replicate

from storage_bucket_manager import StorageBucket


with open("api_key.json") as f:
     API_KEY= json.load(f)

os.environ["REPLICATE_API_TOKEN"] = API_KEY["replicate_api_key"]
openai_key = API_KEY["openAI_api_key"]

api = replicate.Client(api_token=os.environ["REPLICATE_API_TOKEN"])
client = OpenAI(
    api_key=openai_key
)


 

def generate_prompt(text):
      prompt = f"Create a piece of music that reflects the emotions described in the journal entry/survey results:{text}" \
             f" and is designed to boost the person's mood. The music should be in the key of [Key] and should feel " \
             f"[Emotion]. Keep the description simple and concise, limited to about three sentences, " \
             f"focusing on the main instruments, mood, and how the music will uplift the listener's emotions." \
             f" Only description, no need title."
    
      chat_completion = client.chat.completions.create(
            messages=[{"role": "user", "content": prompt}],
            model="gpt-3.5-turbo",
      ) 
      print(chat_completion)
      return chat_completion.choices[0].message.content



def generate_music(audio_prompt,duration,prompt,SB):
     #  audio_url = replicate.run(
     #    "meta/musicgen:671ac645ce5e552cc63a54a2bbff63fcf798043055d2dac5fc9e36a837eedcfb",
     #    input={
     #        "top_k": 250,
     #        "top_p": 0,
     #        "prompt": audio_prompt,
     #        "duration": duration,
     #        "temperature": 1,
     #        "continuation": False,
     #        "model_version": "stereo-large",
     #        "output_format": "mp3",
     #        "continuation_start": 0,
     #        "multi_band_diffusion": False,
     #        "normalization_strategy": "peak",
     #        "classifier_free_guidance": 3
     #    }
     #   )
     #  print(audio_url)
     audio_url = "https://replicate.delivery/yhqm/HAfZraNP0pR9FSYhQ1WkQqLGeful9JZpGFZ0X02WhhSf0EbNB/out.mp3"
     downloaded_song = download_song(audio_url,prompt)
   
     music_url=upload_to_SB(downloaded_song,SB)
     
     delete_music(audio_path=downloaded_song)
     return music_url




def delete_music(audio_path):
     if os.path.exists(audio_path):
          os.remove(audio_path)

def upload_to_SB(downloaded_song, SB : StorageBucket):
     filename = os.path.basename(downloaded_song)
     audio_link=SB.uploadfile(filename,downloaded_song)
     return audio_link
     
     

def download_song(audiourl,description):
     description = re.sub(r'[^a-zA-Z]', '', description)[:15]
     local_file=f"{description}.mp3"
     urllib.request.urlretrieve(audiourl, local_file)
     return local_file
     