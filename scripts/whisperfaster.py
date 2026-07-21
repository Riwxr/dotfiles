from faster_whisper import WhisperModel

model = WhisperModel("turbo", device="cpu", compute_type="int8")
segments, info = model.transcribe("audioforquery.wav")
for segment in segments:
    print(segment.text)
