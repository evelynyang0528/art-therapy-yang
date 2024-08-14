from io import BytesIO
import json
from openai import OpenAI
import requests
from PIL import Image

from storage_bucket_manager import StorageBucket


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
    # response_image = client.images.generate(
    #     model="dall-e-3",
    #     prompt=prompt,
    #     size="1024x1024",
    #     quality="standard",
    #     n=1,
    # )
    # image_url=response_image.data[0].url
    # response=requests.get(image_url)
    # img = Image.open(BytesIO(response.content))
    local_image_path = "daily_img.jpg"
    # img.save(local_image_path, "JPEG")

   
    url=SB.uploadfile("images/daily_image.jpg",local_image_path)
    text=get_text()

    response={
        "image":url,
        "phrase":text
        }
    with open("daily_img.txt", "w") as file:
        file.write(json.dumps(response))