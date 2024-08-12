from openai import OpenAI


client = OpenAI(api_key="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")

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




