import os
from huggingface_hub import InferenceClient
from google import genai
from google.genai import types
import dotenv

dotenv.load_dotenv()

# client = InferenceClient(
#     provider="hf-inference",
#     api_key="",
# )

# 1. Initialize the Client
# It will automatically look for the GEMINI_API_KEY environment variable
gemini_client =genai.Client(api_key=os.getenv("GEMINI_API_KEY", "YOUR_API_KEY"))

def gemini_content_flagger(text, modes):
    # Use the current stable model: 'gemini-2.5-flash'
    # 'gemini-1.5-flash' is legacy and may return 404 in newer SDK versions
    model_id = "gemini-2.5-flash"
    
    # Safety configuration:
    # Since you are building a detector, we set thresholds to 'BLOCK_NONE' 
    # so the API doesn't block the very text you are trying to analyze.
    config = types.GenerateContentConfig(
        safety_settings=[
            types.SafetySetting(category="HARM_CATEGORY_HATE_SPEECH", threshold="BLOCK_NONE"),
            types.SafetySetting(category="HARM_CATEGORY_HARASSMENT", threshold="BLOCK_NONE"),
            types.SafetySetting(category="HARM_CATEGORY_SEXUALLY_EXPLICIT", threshold="BLOCK_NONE"),
            types.SafetySetting(category="HARM_CATEGORY_DANGEROUS_CONTENT", threshold="BLOCK_NONE"),
        ],
        temperature=0.0  # Zero temperature ensures consistent flagging
    )

    sexual_clause = "Flag sexual content as hateful." if modes.get('sexualcontent') else ""
    
    prompt = (
        f"You are a non-bias AI Abuse text detector. Your work is to flag HATE texts. "
        f"Judge the following text as 'good', 'neutral', or 'hateful' only. "
        f"{sexual_clause} Reply with only the single word. "
        f"Text: {text}"
    )

    try:
        response = gemini_client.models.generate_content(
            model=model_id,
            contents=prompt,
            config=config
        )

        if response.text:
            return response.text.strip().lower()
        return "unknown"

    except Exception as e:
        print(f"Error during detection: {e}")
        return "error"

if __name__ == "__main__":
    while True:
        text = input("enter text to evaluate: ")
        result = gemini_content_flagger(text=text , modes= {'sexualcontent':True})
        # result = client.text_classification(
        #     "I like you. I love you",
        #     model="facebook/roberta-hate-speech-dynabench-r4-target",
        # )
        # print(result[1].label)
        print(result)