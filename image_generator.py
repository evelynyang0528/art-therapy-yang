from openai import OpenAI




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




