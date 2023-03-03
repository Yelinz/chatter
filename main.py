import openai
import speech_recognition as sr
import os
from google.cloud import texttospeech
import pyaudio
import time

openai.api_key = os.getenv("OPENAI_API_KEY")

def main():
    recognizer = sr.Recognizer()

    with sr.Microphone() as source:
        audio = recognizer.listen(source)

    text = recognizer.recognize_whisper(audio)

    response = openai.ChatCompletion.create(
        model="gpt-3.5-turbo",
        messages=[
                {"role": "system", "content": "You are a helpful assistant."},
                {"role": "user", "content": text},
        ]
        temperature=1
        top_p=1
        n=1
        max_tokens=2000
        presence_penalty=0
        frequency_penalty=1
        user="test"
    )
    print(response)

    answer = response["choices"][0]["message"]["content"]

    client = texttospeech.TextToSpeechClient()
    synthesis_input = texttospeech.SynthesisInput(text=answer)
    voice = texttospeech.VoiceSelectionParams(
        language_code="en-US", ssml_gender=texttospeech.SsmlVoiceGender.NEUTRAL
    )
    # Select the type of audio file you want returned
    audio_config = texttospeech.AudioConfig(
        audio_encoding=texttospeech.AudioEncoding.MP3
    )

    # Perform the text-to-speech request on the text input with the selected
    # voice parameters and audio file type
    response = client.synthesize_speech(
        input=synthesis_input, voice=voice, audio_config=audio_config
    )

    # https://people.csail.mit.edu/hubert/pyaudio/
    with response.audio_content as content:
        # Write the response to the output file.
        # Define callback for playback (1)
        def callback(in_data, frame_count, time_info, status):
            data = content.readframes(frame_count)
            # If len(data) is less than requested frame_count, PyAudio automatically
            # assumes the stream is finished, and the stream stops.
            return (data, pyaudio.paContinue)

        audio = pyaudio.PyAudio()
        # Open stream using callback (3)
        stream = audio.open(format=audio.get_format_from_width(content.getsampwidth()),
                        channels=content.getnchannels(),
                        rate=content.getframerate(),
                        output=True,
                        stream_callback=callback)

        # Wait for stream to finish (4)
        while stream.is_active():
            time.sleep(0.1)

        # Close the stream (5)
        stream.close()

        # Release PortAudio system resources (6)
        audio.terminate()

if __name__ == "__main__":
    main()