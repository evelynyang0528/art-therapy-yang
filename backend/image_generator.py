from io import BytesIO
import json
import random
from openai import OpenAI
import requests
from PIL import Image
from audio_generator import get_client
from storage_bucket_manager import StorageBucket
client = get_client()

def get_text():
    chat_completion = client.chat.completions.create(
        messages=[
            {
                "role": "user",
                "content": f"Share a meaningful phrase or quote from a notable figure in the field of art therapy."
                f" Include the author's name. This could be from a psychologist, therapist, artist, or any "
                f"influential person whose words inspire emotional well-being and creativity. Your chosen "
                f"phrase should reflect the power of art therapy to enhance emotions and promote healing.",
            }
        ],
        model="gpt-3.5-turbo",
    )
    print(chat_completion)
    return chat_completion.choices[0].message.content

def generate_image(SB):

    prompt = (
        "Create an image designed to visually convey and enhance mental health awareness and serve as a "
        "therapeutic tool"
    )
    response_image = client.images.generate(
        model="dall-e-3",
        prompt=prompt,
        size="1024x1024",
        quality="standard",
        n=1,
    )
    image_url=response_image.data[0].url
    response=requests.get(image_url)
    img = Image.open(BytesIO(response.content))
    local_image_path = "daily_img.jpg"
    img.save(local_image_path, "JPEG")
   
    url=SB.uploadfile("images/daily_image.jpg",local_image_path)
    text=get_text()

    response={
        "image":url,
        "phrase":text
        }
  
    with open("daily_img.txt", "w") as file:
        file.write(json.dumps(response))

def generate_journal_image(SB,journal):
    prompt = (
        f"Create an image based on the following information from a journal entry or survey response: {journal}. "
        f"The image should visually convey and enhance mental health awareness by incorporating elements that"
        f" symbolize healing, support, and resilience. Use calming colors, soothing shapes, and appropriate "
        f"symbols to create a therapeutic tool that helps in relaxation and self-reflection. The design should "
        f"aim to evoke positive emotions and provide comfort, making it a valuable resource for mental health"
        f" awareness and support."
    )
    response_image = client.images.generate(
        model="dall-e-3",
        prompt=prompt,
        size="1024x1024",
        quality="standard",
        n=1,
    )
    image_url=response_image.data[0].url
    image_response=requests.get(image_url)
    image=Image.open(BytesIO(image_response.content))
    id=random.randint(1, 100)

    local_image_path=f"images/image{id}.jpg"
    image.save(local_image_path, "JPEG")
    url=SB.uploadfile(f"journal_images/img{id}.jpg",local_image_path)
    result =  url
    print(result)
    return result


if __name__ == "__main__":
    SB = StorageBucket(

    )
    generate_image(SB=SB)




